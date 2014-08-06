{Robot, User, TextMessage} = require 'hubot'
assert = require 'power-assert'
path = require 'path'
sinon = require 'sinon'

describe 'hello', ->
  beforeEach (done) ->
    @sinon = sinon.sandbox.create()
    # for warning: possible EventEmitter memory leak detected.
    # process.on 'uncaughtException'
    @sinon.stub process, 'on', -> null
    @robot = new Robot(path.resolve(__dirname, '..'), 'shell', false, 'hubot')
    @robot.adapter.on 'connected', =>
      @robot.load path.resolve(__dirname, '../../src/scripts')
      done()
    @robot.run()

  afterEach (done) ->
    @robot.brain.on 'close', =>
      @sinon.restore()
      done()
    @robot.shutdown()

  describe 'listeners[0].regex', ->
    beforeEach ->
      @callback = @sinon.spy()
      @robot.listeners[0].callback = @callback

    describe 'receive "@hubot hello"', ->
      beforeEach ->
        @sender = new User 'bouzuya', room: 'hitoridokusho'
        message = '@hubot hello'
        @robot.adapter.receive new TextMessage(@sender, message)

      it 'calls *hello* with "@hubot hello"', ->
        assert @callback.callCount is 1
        assert @callback.firstCall.args[0].match.length is 1
        assert @callback.firstCall.args[0].match[0] is '@hubot hello'

  describe 'listeners[0].callback', ->
    beforeEach ->
      @hello = @robot.listeners[0].callback

    describe 'receive "@hubot hello"', ->
      beforeEach ->
        @send = @sinon.spy()
        @hello
          match: ["@hubot hello"]
          send: @send

      it 'send "hello!"', ->
        assert @send.callCount is 1
        assert @send.firstCall.args[0] is 'hello!'

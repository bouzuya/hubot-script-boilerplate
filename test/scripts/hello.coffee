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
      setTimeout done, 10 # wait for parseHelp()
    @robot.run()

  afterEach (done) ->
    @robot.brain.on 'close', =>
      @sinon.restore()
      done()
    @robot.shutdown()

  describe 'listeners[0].regex', ->
    beforeEach ->
      @sender = new User 'bouzuya', room: 'hitoridokusho'
      @callback = @sinon.spy()
      @robot.listeners[0].callback = @callback

    describe 'receive "@hubot hello"', ->
      beforeEach ->
        message = '@hubot hello'
        @robot.adapter.receive new TextMessage(@sender, message)

      it 'matches', ->
        assert @callback.callCount is 1
        match = @callback.firstCall.args[0].match
        assert match.length is 1
        assert match[0] is '@hubot hello'

  describe 'listeners[0].callback', ->
    beforeEach ->
      @hello = @robot.listeners[0].callback

    describe 'receive "@hubot hello"', ->
      beforeEach ->
        @send = @sinon.spy()
        @hello
          match: ['@hubot hello']
          send: @send

      it 'send "hello!"', ->
        assert @send.callCount is 1
        assert @send.firstCall.args[0] is 'hello!'

    describe 'receive "@hubot hello"', ->
      beforeEach ->
        responseBody = greeting: 'hello'
        httpGetResponse = @sinon.stub()
        httpGetResponse
          .onFirstCall()
          .callsArgWith 0, null, null, JSON.stringify(responseBody)
        httpGet = @sinon.stub()
        httpGet.onFirstCall().returns httpGetResponse
        http = @sinon.stub()
        http.onFirstCall().returns get: httpGet
        @send = @sinon.spy()
        @hello
          match: ['@hubot hello']
          send: @send
          http: http

      it 'send "hello!"', ->
        assert @send.callCount is 1
        assert @send.firstCall.args[0] is 'hello!'

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
    describe 'valid patterns', ->
      beforeEach ->
        @tests = [
          message: '@hubot hello'
          matches: ['@hubot hello']
        ,
          message: '@hubot hi'
          matches: ['@hubot hi']
        ]

      it 'should match', ->
        @tests.forEach ({ message, matches }) =>
          callback = @sinon.spy()
          @robot.listeners[0].callback = callback
          sender = new User 'bouzuya', room: 'hitoridokusho'
          @robot.adapter.receive new TextMessage(sender, message)
          actualMatches = callback.firstCall.args[0].match.map((i) -> i)
          assert callback.callCount is 1
          assert.deepEqual actualMatches, matches

    describe 'invalid patterns', ->
      beforeEach ->
        @messages = [
          '@hubot hoge'
        ]

      it 'should not match', ->
        @messages.forEach (message) =>
          callback = @sinon.spy()
          @robot.listeners[0].callback = callback
          sender = new User 'bouzuya', room: 'hitoridokusho'
          @robot.adapter.receive new TextMessage(sender, message)
          assert callback.callCount is 0

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

  describe 'robot.helpCommands()', ->
    it 'should be ["hubot XXX [<args>] - DESCRIPTION"]', ->
      assert.deepEqual @robot.helpCommands(), [
        "hubot XXX [<args>] - DESCRIPTION"
      ]

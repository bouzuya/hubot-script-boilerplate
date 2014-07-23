require '../helper'

describe 'xxx', ->
  beforeEach (done) ->
    @kakashi.scripts = [require '../../src/scripts/xxx']
    @kakashi.users = [{ id: 'bouzuya', room: 'hitoridokusho' }]
    @kakashi.start().then done, done

  afterEach (done) ->
    @kakashi.stop().then done, done

  describe 'receive "@hubot XXX"', ->
    it 'send "XXX!"', (done) ->
      sender = id: 'bouzuya', room: 'hitoridokusho'
      message = '@hubot XXX'
      @kakashi
        .receive sender, message
        .then =>
          expect(@kakashi.send).to.have.callCount(1)
          expect(@kakashi.send.firstCall.args[1]).to.equal('XXX!')
        .then (-> done()), done

global.expect = require('chai').use(require('sinon-chai')).expect
{Kakashi} = require 'kakashi'

beforeEach ->
  @kakashi = new Kakashi(httpd: false)

afterEach (done) ->
  @kakashi.stop().then(done, done)

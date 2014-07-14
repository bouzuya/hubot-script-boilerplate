global.expect = require('chai').use(require('sinon-chai')).expect
sinon = require 'sinon'
{Kakashi} = require 'kakashi'

beforeEach ->
  @kakashi = new Kakashi(httpd: false)
  @sinon = sinon.sandbox.create()

afterEach (done) ->
  @sinon.restore()
  @kakashi.stop().then(done, done)

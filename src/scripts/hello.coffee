# Description
#   A Hubot script that XXX
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot XXX [<args>] - XXX
#
# Author:
#   bouzuya <m@bouzuya.net>
#
module.exports = (robot) ->
  robot.respond /hello$/i, (res) ->
    res.send 'hello!'

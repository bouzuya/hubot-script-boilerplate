# Description
#   A Hubot script that DESCRIPTION
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot XXX [<args>] - DESCRIPTION
#
# Author:
#   bouzuya <m@bouzuya.net>
#
module.exports = (robot) ->
  robot.respond /h(?:ello|i)$/i, (res) ->
    res.send 'hello!'

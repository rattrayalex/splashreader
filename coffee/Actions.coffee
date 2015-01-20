Bacon = require 'baconjs'

Actions =
  ###
  @param [String] url
  ###
  requestUrl: new Bacon.Bus()

  ###
  @param [String] url
  ###
  changePage: new Bacon.Bus()

module.exports = Actions
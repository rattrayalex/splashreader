Bacon = require 'baconjs'

constants = require('./constants')


Actions =
  ###
  @param [String] url
  ###
  requestUrl: new Bacon.Bus()

  ###
  @param [String] url
  ###
  changePage: new Bacon.Bus()

  ###
  @param [String] raw_html
  @param [String] title
  @param [String] author
  @param [String] url
  @param [String] domain
  @param [String] date
  ###
  processArticle: new Bacon.Bus()

  ###
  @param [String] raw_html
  ###
  postProcessArticle: new Bacon.Bus()

  play: new Bacon.Bus()
  pause: new Bacon.Bus()
  togglePlayPause: new Bacon.Bus()
  paraChange: new Bacon.Bus()
  # paraResume: new Bacon.Bus()

  ###
  @param [Number] wpm
  ###
  setWpm: new Bacon.Bus()
  ###
  @param [Number] amount
  ###
  increaseWpm: new Bacon.Bus()
  ###
  @param [Number] amount
  ###
  decreaseWpm: new Bacon.Bus()

  toggleSideMenu: new Bacon.Bus()



Actions.Derived = {}
Actions.Derived.paraResume = Actions
  .paraChange.delay(constants.PARA_CHANGE_TIME)

module.exports = Actions
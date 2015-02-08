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
  pageChange: new Bacon.Bus()

  ###
  @param [Object] payload:
    [String] raw_html
    [String] title
    [String] author
    [String] url
    [String] domain
    [String] date
  ###
  processArticle: new Bacon.Bus()
  ###
  @param [Immutable.List[Int]] words
  ###
  wordlistComplete: new Bacon.Bus()

  ###
  @param [String] raw_html
  ###
  postProcessArticle: new Bacon.Bus()

  ###
  @param [String] source
  ###
  play: new Bacon.Bus()
  ###
  @param [String] source
  ###
  pause: new Bacon.Bus()
  ###
  @param [String] source
  ###
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

  ###
  @param [Int] idx
  @param [String] source
  ###
  wordChange: new Bacon.Bus()


Actions.Derived = {}

Actions.Derived.play2 = Bacon.merge Actions.play,
  Actions.togglePlayPause.filter ->
    !window.store.getIn(['store', 'playing'])

Actions.Derived.pause2 = Bacon.merge Actions.pause,
  Actions.togglePlayPause.filter ->
    window.store.getIn(['store', 'playing'])

Actions.Derived.paraResume = Actions.paraChange
  .delay(constants.PARA_CHANGE_TIME)

module.exports = Actions
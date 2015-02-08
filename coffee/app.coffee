window.React = React = require('react')  # for ReactDevTools
Immutable = require('immutable')
Backbone = require('backbone')
window.$ = $ = Backbone.$ = require('jquery')  # so Backbone.Router doesnt die
window._ = require('lodash')  # for convenience

RootStore = require('./stores/RootStore')
Actions = require('./Actions')
Body = React.createFactory require('./components/Body')

computed = require('./stores/computed')


main = ->

  RootStore.onValue (updatedStore) ->
    start = new Date()

    window.store = updatedStore
    updatedStore.current = computed.getCurrentWord(updatedStore.get('words'))
    React.render(
      Body(updatedStore)
      document.body
    )

    # perf debugging
    console.log 'full render took',
      new Date() - start
      "on word "
      current?.toString()


  # install global event listeners
  $(window).keydown (e) ->
    if e.which is 32  # space
      Actions.togglePlayPause.push('space')
      false
  $(window).blur ->
    Actions.pause.push('window-blur')

  # in chrome ext, no url; instead, use ext-planted vars.
  if window.location.origin is "null"
    console.log 'in Ext, going to go to ', window.SplashReaderExt.url
    Actions.pageChange.push window.SplashReaderExt.url
  else
    Backbone.history.start
      pushState: false


main()

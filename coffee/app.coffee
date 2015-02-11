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

  RootStore.skipDuplicates().debounce(10).onValue (updatedStore) ->
    start = new Date()

    # window.store = updatedStore
    React.render(
      Body
        article: updatedStore.get('article')
        words: updatedStore.get('words')
        page: updatedStore.get('page')
        status: updatedStore.get('status')
        current: computed.getCurrentWord(updatedStore.get('words'))
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
      Actions.togglePlayPause.push
        source: 'space'
      false
  $(window).blur ->
    Actions.pause.push
      source: 'window-blur'

  # in chrome ext, no url; instead, use ext-planted vars.
  if window.location.origin is "null"
    console.log 'in Ext, going to go to ', window.SplashReaderExt.url
    Actions.pageChange.push
      url: window.SplashReaderExt.url
  else
    Backbone.history.start
      pushState: false


main()

window.React = React = require('react')  # for ReactDevTools
Immutable = require('immutable')
Backbone = require('backbone')
$ = Backbone.$ = require('jquery')  # so Backbone.Router doesnt die
Hammer = require('hammerjs')

store = require('./stores/store')

ArticleStore = require('./stores/ArticleStore')
WordStore = require('./stores/WordStore')
CurrentWordStore = require('./stores/CurrentWordStore')
CurrentPageStore = require('./stores/CurrentPageStore')
RsvpStatusStore = require('./stores/RsvpStatusStore')

Body = require('./components/Body')

dispatcher = require('./dispatcher')


main = ->

  # initial data
  store.cursor().update ->
    Immutable.fromJS
      article: {}
      words: []
      current:
        idx: 0
      page:
        url: window.location.hash.split('#')[1]
      status:
        playing: false
        para_change: false
        wpm: 500
        menuShown: false

  new ArticleStore(store)
  new WordStore(store)
  new CurrentWordStore(store)
  new CurrentPageStore(store)
  new RsvpStatusStore(store)

  RenderedBodyComponent = React.renderComponent(
    Body
      article: store.get('article')
      words: store.get('words')
      current: store.get('current')
      page: store.get('page')
      status: store.get('status')
    document.body
  )
  store.on "update", (updatedStore) ->
    RenderedBodyComponent.setProps
      article: updatedStore.get('article')
      words: updatedStore.get('words')
      current: updatedStore.get('current')
      page: updatedStore.get('page')
      status: updatedStore.get('status')


  # install global event listeners
  $(window).keydown (e) ->
    if e.which is 32  # space
      dispatcher.dispatch
        actionType: 'play-pause'
        source: 'space'
      false
  hammer = new Hammer(document.body)
  hammer.on 'tap', ->
    dispatcher.dispatch
      actionType: 'pause'
      source: 'tap'
  $(window).blur ->
    dispatcher.dispatch
      actionType: 'pause'
      source: 'window-blur'


  # in chrome ext, no url; instead, use ext-planted vars.
  if window.location.origin is "null"
    console.log 'in Ext, going to go to ', window.SplashReaderExt.url
    dispatcher.dispatch
      actionType: 'page-change'
      url: window.SplashReaderExt.url
  else
    Backbone.history.start
      pushState: false


main()

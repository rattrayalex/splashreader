React = require('react')
Immutable = require('immutable')
Backbone = require('backbone')
Backbone.$ = require('jquery')  # so Backbone.Router doesnt die



store = require('./stores/store')

Body = require('./components/Body')

dispatcher = require('./dispatcher')



main = ->

  # initial data
  store.cursor().update ->
    Immutable.fromJS
      article: {}
      words: []
      page:
        url: window.location.hash.split('#')[1]
      status:
        playing: false
        wpm: 500
        menuShown: false

  ArticleStore = require('./stores/ArticleStore')
  WordStore = require('./stores/WordStore')
  CurrentWordStore = require('./stores/CurrentWordStore')
  CurrentPageStore = require('./stores/CurrentPageStore')
  RsvpStatusStore = require('./stores/RsvpStatusStore')

  new ArticleStore(store)
  new CurrentPageStore(store)
  # new RsvpStatusStore(store)

  RenderedBodyComponent = React.renderComponent(
    Body
      article: store.current.get('article')
      words: WordStore
      current: CurrentWordStore
      page: store.current.get('page')
      status: store.current.get('status')
    document.body
  )
  store.on "update", (updatedStore) ->
    RenderedBodyComponent.setProps
      article: updatedStore.get('article')
      page: updatedStore.get('page')
      status: updatedStore.get('status')


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

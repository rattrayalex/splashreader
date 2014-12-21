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
      status:
        playing: false
        wpm: 500
        menuShown: false

  ArticleStore = require('./stores/ArticleStore')
  WordStore = require('./stores/WordStore')
  CurrentWordStore = require('./stores/CurrentWordStore')
  CurrentPageStore = require('./stores/CurrentPageStore')
  RsvpStatusStore = require('./stores/RsvpStatusStore')

  RenderedBodyComponent = React.renderComponent(
    Body
      article: ArticleStore
      words: WordStore
      current: CurrentWordStore
      page: CurrentPageStore
      status: store.current.get('status')
    document.body
  )
  store.on "update", (updatedStore) ->
    RenderedBodyComponent.setProps
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

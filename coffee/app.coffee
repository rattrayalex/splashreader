React = require('react')
store = require('./stores/store')
Backbone = require('backbone')
Backbone.$ = require('jquery')  # so Backbone.Router doesnt die

ArticleStore = require('./stores/ArticleStore')
WordStore = require('./stores/WordStore')
CurrentWordStore = require('./stores/CurrentWordStore')
CurrentPageStore = require('./stores/CurrentPageStore')
RsvpStatusStore = require('./stores/RsvpStatusStore')

Body = require('./components/Body')

dispatcher = require('./dispatcher')



main = ->

  # initial data
  store.add 'status',
    playing: false
    wpm: 500
    menuShown: false

  RenderedBodyComponent = React.renderComponent(
    Body
      article: ArticleStore
      words: WordStore
      current: CurrentWordStore
      page: CurrentPageStore
      status: store.status
    document.body
  )
  store.on "update", (updatedStore) ->
    RenderedBodyComponent.setProps({status: updatedStore.status})

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

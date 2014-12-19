React = require('react')
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
  React.renderComponent(
    Body
      article: ArticleStore
      words: WordStore
      current: CurrentWordStore
      page: CurrentPageStore
      status: RsvpStatusStore
    document.body
  )

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

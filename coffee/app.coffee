React = require('react')
Backbone = require('backbone')
$ = require('jquery')  # so Backbone.Router doesnt die
Backbone.$ = $
key = require('keymaster')

ArticleStore = require('./stores/ArticleStore')
WordStore = require('./stores/WordStore')
CurrentWordStore = require('./stores/CurrentWordStore')
CurrentPageStore = require('./stores/CurrentPageStore')
RsvpStatusStore = require('./stores/RsvpStatusStore')

{ArticleViewDisplay} = require('./components/ArticleView')
RsvpDisplay = require('./components/RsvpDisplay')
Topbar = require('./components/Topbar')

dispatcher = require('./dispatcher')

example_data = require("./example_data")

main = ->
  url = "https://medium.com/@rattrayalex/daily-ten-965db68ef86f"

  dispatcher.dispatch
    actionType: 'process-article'
    raw_html: example_data

  React.renderComponent(
    Topbar {
      status: RsvpStatusStore
    }
    document.querySelector('.topbar')
  )
  React.renderComponent(
    ArticleViewDisplay {
      article: ArticleStore
      current: CurrentWordStore
      status: RsvpStatusStore
    }
    document.querySelector('.article-main')
  )
  React.renderComponent(
    RsvpDisplay {
      current: CurrentWordStore
      key: 'current-word'
      status: RsvpStatusStore
    }
    document.querySelector('.rsvp-main')
  )

  key 'space', ->
    dispatcher.dispatch
      actionType: 'play-pause'
      source: 'space'
    false

  window.onblur = ->
    dispatcher.dispatch
      actionType: 'pause'
      source: 'window-blur'

  Backbone.history.start
    pushState: false


main()

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

main = ->

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

  $(window).keydown (e) ->
    if e.which is 32  # space
      dispatcher.dispatch
        actionType: 'play'
        source: 'space'
      false
  $(window).keyup (e) ->
    if e.which is 32  # space
      dispatcher.dispatch
        actionType: 'pause'
        source: 'space'
      false

  window.onblur = ->
    dispatcher.dispatch
      actionType: 'pause'
      source: 'window-blur'

  Backbone.history.start
    pushState: false


main()

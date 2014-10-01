React = require('react')
Backbone = require('backbone')
$ = require('jquery')
Backbone.$ = $  # so Backbone.Router doesnt die
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
      words: WordStore
      current: CurrentWordStore
    }
    document.querySelector('.topbar')
  )
  React.renderComponent(
    ArticleViewDisplay {
      article: ArticleStore
      current: CurrentWordStore
      status: RsvpStatusStore
      words: WordStore
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

  Backbone.history.start
    pushState: false


main()

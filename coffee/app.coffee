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
SideMenu = require('./components/SideMenu')
BottomBar = require('./components/BottomBar')

dispatcher = require('./dispatcher')

main = ->

  React.renderComponent(
    Topbar
      status: RsvpStatusStore
      words: WordStore
      current: CurrentWordStore
      article: ArticleStore
    document.querySelector('.topbar-here')
  )
  React.renderComponent(
    SideMenu
      status: RsvpStatusStore
    document.querySelector('.side-menu-here')
  )
  React.renderComponent(
    BottomBar
      status: RsvpStatusStore
      current: CurrentWordStore
      words: WordStore
      article: ArticleStore
    document.querySelector('.bottombar-here')
  )
  React.renderComponent(
    ArticleViewDisplay
      article: ArticleStore
      current: CurrentWordStore
      status: RsvpStatusStore
      words: WordStore
      page: CurrentPageStore
    document.querySelector('.article-main-here')
  )
  React.renderComponent(
    RsvpDisplay
      current: CurrentWordStore
      key: 'current-word'
      status: RsvpStatusStore
    document.querySelector('.rsvp-main-here')
  )

  Backbone.history.start
    pushState: false


main()

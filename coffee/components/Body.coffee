React = require('react')

{ArticleViewDisplay} = require('./ArticleView')
RsvpDisplay = require('./RsvpDisplay')
Topbar = require('./Topbar')
SideMenu = require('./SideMenu')
BottomBar = require('./BottomBar')

{div} = React.DOM


Body = React.createClass
  render: ->
    div
      id: 'react-body'
      ,
      div
        className: "rsvp-outer-wrapper"
        ,
        div
          className: "row"
          ,
          div
            className: "
              col-sm-9 col-sm-offset-1
              col-md-8 col-md-offset-2
              col-lg-6 col-lg-offset-3"
            ,
            RsvpDisplay
              current: @props.current
              key: 'current-word'
              status: @props.status
      div
        className: "container-fluid"
        ,
        div
          className: "row"
          ,
          div
            className: "
              col-sm-9 col-sm-offset-1
              col-md-8 col-md-offset-2
              col-lg-6 col-lg-offset-3"
            ,
            ArticleViewDisplay
              article: @props.article
              current: @props.current
              status: @props.status
              words: @props.words
              page: @props.page
      Topbar
        status: @props.status
        words: @props.words
        current: @props.current
        article: @props.article
      SideMenu
        status: @props.status
      BottomBar
        status: @props.status
        current: @props.current
        words: @props.words
        article: @props.article

module.exports = Body

React = require('react')
$ = require 'jQuery'

Actions = require('../Actions')

ArticleView = React.createFactory require('./ArticleView')
HomePage    = React.createFactory require('./HomePage')
RsvpDisplay = React.createFactory require('./RsvpDisplay')
LoadingIcon = React.createFactory require('./LoadingIcon')
Topbar      = React.createFactory require('./Topbar')
SideMenu    = React.createFactory require('./SideMenu')
BottomBar   = React.createFactory require('./BottomBar')

{div} = React.DOM


Body = React.createClass
  displayName: 'Body'

  _handleRsvpClick: (e) ->
    console.log 'rsvp-display clicked!'
    e.preventDefault()
    e.stopPropagation()
    Actions.pause.push
      source: 'rsvp-display'


  getLoadingState: ->
    if @props.page.get('url') and not @props.article.get('elem')
      true
    else if @props.page.get('url') is not @props.article.get('url')
      true
    else
      false

  getPadding: ->
    if typeof window isnt 'undefined'
      window.innerHeight * .4 - 40
    else
      200

  componentDidMount: ->
    $(window).on 'resize', ( => @forceUpdate() )

  render: ->
    loading = @getLoadingState()

    div
      id: 'react-body'
      ,
      div
        className: "rsvp-outer-wrapper"
        onClick: @_handleRsvpClick
        ,
        div
          className: "row"
          ,
          div
            className: "
              col-sm-10 col-sm-offset-1
              col-md-8 col-md-offset-2
              col-lg-6 col-lg-offset-3"
            ,
            RsvpDisplay
              current: @props.current
              status: @props.status
              words: @props.words
              key: 'current-word'

      div
        className: "container-fluid"
        ,
        div
          className: "row"
          ,
          div
            className: "
              col-sm-10 col-sm-offset-1
              col-md-8 col-md-offset-2
              col-lg-6 col-lg-offset-3"
            ,
            div
              className: "article-main #{ if loading then 'loading' else '' }"
              style:
                paddingTop: @getPadding()
                paddingBottom: @getPadding()
              ,
              if loading
                LoadingIcon {}
              if not @props.article.get('title')
                HomePage
                  url: @props.article.get('url') or @props.page.get('url')
              else
                ArticleView
                  current: @props.current
                  article: @props.article
                  status: @props.status
                  words: @props.words
                  page: @props.page
      Topbar
        status: @props.status
        words: @props.words
        article: @props.article
      SideMenu
        status: @props.status
      BottomBar
        current: @props.current
        status: @props.status
        words: @props.words

module.exports = Body

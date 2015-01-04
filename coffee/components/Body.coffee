React = require('react')
$ = require 'jQuery'

ArticleView = React.createFactory require('./ArticleView')
HomePage    = React.createFactory require('./HomePage')
RsvpDisplay = React.createFactory require('./RsvpDisplay')
LoadingIcon = React.createFactory require('./LoadingIcon')
Topbar      = React.createFactory require('./Topbar')
SideMenu    = React.createFactory require('./SideMenu')
BottomBar   = React.createFactory require('./BottomBar')

{div} = React.DOM


Body = React.createClass

  getLoadingState: ->
    if @props.page.get('url') and not @props.article.get('elem')
      true
    else if @props.page.get('url') is not @props.article.get('url')
      true
    else
      false

  getPadding: ->
    window.innerHeight * .4 - 40

  componentDidMount: ->
    $(window).on 'resize', ( => @forceUpdate() )

  render: ->
    loading = @getLoadingState()

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
              col-sm-9 col-sm-offset-1
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

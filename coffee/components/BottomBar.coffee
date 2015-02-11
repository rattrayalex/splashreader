React = require('react/addons')

WpmWidget = React.createFactory require('./WpmWidget')

Actions = require('../Actions')
{getPercentDone, getTimeLeft} = require('../stores/computed')

{h1, div, li, p, a, span, button, form, em} = React.DOM


BottomBar = React.createClass
  displayName: 'BottomBar'

  mixins: [
    React.addons.PureRenderMixin
  ]

  handleToggleMenuClick: ->
    Actions.toggleSideMenu.push()

  render: ->

    if not @props.words.size
      return div {}

    percent_done = getPercentDone(@props.words, @props.current) * 100
    time_left = Math.round getTimeLeft(
      @props.words, @props.status, @props.current)

    div
      className: 'navbar-fluid navbar-default navbar-fixed-bottom'
      ,
      div
        className: 'container-fluid'
        ,
        div
          className: 'nav navbar-left'
          ,
          div
            className: 'navbar-form'
            ,
            div
              className: 'btn-group'
              ,
              button
                type: 'button'
                onClick: @handleToggleMenuClick
                className: 'btn btn-warning'
                style:
                  padding: '9px 10px'
                ,
                span className: 'icon-bar'
                span className: 'icon-bar'
                span className: 'icon-bar'
            WpmWidget
              status: @props.status
              className: 'hidden-xs'
              style:
                display: 'inline-block'
                margin: '0px 10px'

        p
          className: 'navbar-text navbar-right text-muted'
          style:
            marginRight: 75
          ,
          em
            className: 'text-muted'
            ,
            if @props.words.size and !isNaN(time_left)
              pluralize = unless time_left is 1 then "s" else ""
              "#{ time_left } minute#{ pluralize } left"
            else
              ""
        div
          className: 'progress'
          style:
            position: 'absolute'
            top: 0  # 51 if on top
            # bottom: 0
            left: 0
            width: "100%"
            height: 3
            borderRadius: 0
            marginBottom: 0
            boxShadow: 'none'
            background: 'transparent'
          ,
          div
            className: 'progress-bar progress-bar-warning'
            role: 'progressbar'
            style:
              width: "#{percent_done}%"
      if @props.words.size
        PlayPauseButton
          status: @props.status
          words: @props.words



PlayPauseButton = React.createFactory React.createClass
  displayName: 'PlayPauseButton'

  mixins: [
    React.addons.PureRenderMixin
  ]

  handlePlayPauseClick: (e) ->
    e.preventDefault()
    e.stopPropagation()
    Actions.togglePlayPause.push
      source: 'button-click'

  render: ->

    play_pause_button_class = React.addons.classSet
      'btn': true
      'btn-info': true
      'glyphicon': true
      'glyphicon-play': not @props.status.get('playing')
      'glyphicon-pause': @props.status.get('playing')
      'active': @props.status.get('playing')
      'disabled': not @props.words.size

    div
      style:
        position: 'fixed'
        bottom: 25
        right: 25
        top: 'initial'  # to override glyphicon
        borderRadius: '50%'
        boxShadow: '0 3px 6px rgba(0,0,0,.2)'
      ,
      button
        type: 'submit'
        className: play_pause_button_class
        onClick: @handlePlayPauseClick
        style:
          outline: 'none'
          borderRadius: '50%'
          height: 50
          width: 50
          top: 'initial'


module.exports = BottomBar

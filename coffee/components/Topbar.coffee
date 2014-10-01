React = require('react/addons')
{Navbar, Nav, NavItem} = require('react-bootstrap')

dispatcher = require('../dispatcher')

{h1, div, li, p, a, span, button, form} = React.DOM


Topbar = React.createClass

  handleIncreaseWpmClick: ->
    dispatcher.dispatch
      actionType: 'increase-wpm'
      amount: 50

  handleDecreaseWpmClick: ->
    dispatcher.dispatch
      actionType: 'decrease-wpm'
      amount: 50

  handlePlayPauseClick: ->
    dispatcher.dispatch
      actionType: 'play-pause'

  componentDidMount: ->
    @props.status.on 'change', =>
      @forceUpdate()
    , @
    @props.words.on 'add remove reset', =>
      @forceUpdate()
    , @
    @props.current.on 'change', =>
      @forceUpdate()
    , @
  componentWillUnmount: ->
    @props.status.off null, null, @
    @props.words.off null, null, @
    @props.current.off null, null, @

  render: ->
    percent_done = @props.current.getPercentDone() * 100
    time_left = Math.round @props.current.getTimeLeft()
    play_pause_button_class = React.addons.classSet
      'btn': true
      'btn-default': true
      'glyphicon': true
      'glyphicon-play': not @props.status.get('playing')
      'glyphicon-pause': @props.status.get('playing')
      'active': @props.status.get('playing')
      'disabled': not @props.words.length

    Navbar {
      className: 'navbar-fixed-bottom'
    },
      p {
        className: "navbar-center navbar-text navbar-brand"
      },
        "SplashReader"

      Nav {
        className: 'navbar-left'
      },
        form {
          className: 'navbar-form'
        },
          button {
            type: 'submit'
            className: play_pause_button_class
            onClick: @handlePlayPauseClick
            style:
              outline: 'none'
          }
      p {
        className: 'navbar-text'
      },
        if @props.words?.length
          pluralize = unless time_left is 1 then "s" else ""
          "#{ time_left } minute#{ pluralize } left"
        else
          ""

      Nav {
        className: 'navbar-right'
      },
        div {
          className: 'navbar-form'
        },
          div {
            className: 'btn-group'
          },
            button {
              type: 'button'
              className: 'btn btn-default'
              onClick: @handleDecreaseWpmClick
            },
              span {
                className: 'glyphicon glyphicon-chevron-down'
              }
            span {
              className: 'btn btn-default disabled'
            },
              "#{ @props.status.get('wpm') } wpm"
            button {
              type: 'button'
              className: 'btn btn-default'
              onClick: @handleIncreaseWpmClick
            },
              span {
                className: 'glyphicon glyphicon-chevron-up'
              }
      div {
        className: 'progress'
        style:
          position: 'absolute'
          top: 0  # 51 if on top
          left: 0
          width: "100%"
          height: 3
          borderRadius: 0
          boxShadow: 'none'
          background: 'transparent'
      },
        div {
          className: 'progress-bar progress-bar-warning'
          role: 'progressbar'
          style:
            width: "#{percent_done}%"
        }


module.exports = Topbar

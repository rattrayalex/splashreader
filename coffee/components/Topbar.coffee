React = require('react/addons')
{Navbar, Nav, NavItem} = require('react-bootstrap')

dispatcher = require('../dispatcher')
FluxBone = require('./FluxBone')

{h1, div, li, p, a, span, button, form} = React.DOM


Topbar = React.createClass

  mixins: [
    FluxBone.ModelMixin('status', 'change')
    FluxBone.ModelMixin('current', 'change')
    FluxBone.CollectionMixin('words', 'add remove reset')
    React.addons.PureRenderMixin
  ]

  handleIncreaseWpmClick: ->
    dispatcher.dispatch
      actionType: 'increase-wpm'
      amount: 50

  handleDecreaseWpmClick: ->
    dispatcher.dispatch
      actionType: 'decrease-wpm'
      amount: 50

  handlePlayPauseClick: (e) ->
    e.preventDefault()
    e.stopPropagation()

    dispatcher.dispatch
      actionType: 'play-pause'

    false

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

    div {
      className: 'navbar-fluid navbar-default navbar-fixed-bottom'
    },
      div {
        className: 'container-fluid'
      },
        p {
          className: "navbar-center navbar-text navbar-brand hidden-xs"
        },
          "SplashReader"


        Nav {
          className: 'navbar-left'
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
        Nav {
          className: 'navbar-right'
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
          className: 'navbar-text navbar-right'
        },
          if @props.words.length and time_left
            pluralize = unless time_left is 1 then "s" else ""
            "#{ time_left } minute#{ pluralize } left"
          else
            ""
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

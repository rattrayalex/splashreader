React = require('react/addons')
{Navbar, Nav, NavItem} = require('react-bootstrap')

dispatcher = require('../dispatcher')
FluxBone = require('./FluxBone')
deferUpdateMixin = require('./deferUpdateMixin')

{h1, div, li, p, a, span, button, form, em} = React.DOM


WpmWidget = React.createClass

  mixins: [
    FluxBone.ModelMixin('status', 'change')
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

  render: ->
    div {
      className: 'navbar-form'
    },
      div {
        className: 'btn-group'
      },
        button {
          type: 'button'
          className: 'btn btn-info'
          onClick: @handleDecreaseWpmClick
        },
          span {
            className: 'glyphicon glyphicon-chevron-down'
          }
        span {
          className: 'btn btn-default disabled'
        },
          "#{ @props.status.get('wpm') }"
          span {
            className: 'hidden-xs'
          }, " wpm"
        button {
          type: 'button'
          className: 'btn btn-info'
          onClick: @handleIncreaseWpmClick
        },
          span {
            className: 'glyphicon glyphicon-chevron-up'
          }


BottomBar = React.createClass

  mixins: [
    deferUpdateMixin
    FluxBone.ModelMixin('status', 'change')
    FluxBone.ModelMixin('current', 'change')
    FluxBone.CollectionMixin('words', 'add remove reset', 'deferUpdate')
    React.addons.PureRenderMixin
  ]

  render: ->

    if not @props.words.length
      return div {}

    percent_done = @props.current.getPercentDone() * 100
    time_left = Math.round @props.current.getTimeLeft()


    div {
      className: 'navbar-fluid navbar-default navbar-fixed-bottom'
    },
      div {
        className: 'container-fluid'
      },

        Nav {
          className: 'navbar-left'
        },
          WpmWidget {
            status: @props.status
          }

        p {
          className: 'navbar-text navbar-right text-muted'
          style:
            marginRight: 75
        },
          em {
            className: 'text-muted'
          },
            if @props.words.length and !isNaN(time_left)
              pluralize = unless time_left is 1 then "s" else ""
              "#{ time_left } minute#{ pluralize } left"
            else
              ""
        div {
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
        },
          div {
            className: 'progress-bar progress-bar-warning'
            role: 'progressbar'
            style:
              width: "#{percent_done}%"
          }
      if @props.words.length
        PlayPauseButton {
          status: @props.status
          words: @props.words
        }


PlayPauseButton = React.createClass

  mixins: [
    FluxBone.ModelMixin('status', 'change')
    FluxBone.CollectionMixin('words', 'add remove reset')
    React.addons.PureRenderMixin
  ]

  handlePlayPauseClick: (e) ->
    e.preventDefault()
    e.stopPropagation()

    dispatcher.dispatch
      actionType: 'play-pause'

    false

  render: ->

    play_pause_button_class = React.addons.classSet
      'btn': true
      'btn-info': true
      'glyphicon': true
      'glyphicon-play': not @props.status.get('playing')
      'glyphicon-pause': @props.status.get('playing')
      'active': @props.status.get('playing')
      'disabled': not @props.words.length

    div {
      style:
        position: 'fixed'
        bottom: 25
        right: 25
        top: 'initial'  # to override glyphicon
        borderRadius: '50%'
        boxShadow: '0 3px 6px rgba(0,0,0,.2)'
    },
      button {
        type: 'submit'
        className: play_pause_button_class
        onClick: @handlePlayPauseClick
        style:
          outline: 'none'
          borderRadius: '50%'
          height: 50
          width: 50
          top: 'initial'
      }


module.exports = BottomBar

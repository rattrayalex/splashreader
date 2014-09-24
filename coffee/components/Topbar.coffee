React = require('react')
{Navbar, Nav, NavItem} = require('react-bootstrap')

dispatcher = require('../dispatcher')

{h1, div, li, p, a, span} = React.DOM


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
  componentWillUnmount: ->
    @props.status.off null, null, @

  render: ->
    Navbar {
      className: 'navbar-fixed-top'
    },
      p {
        className: "navbar-center navbar-text navbar-brand"
      },
        "SplashReader"

      Nav {
        className: 'navbar-left'
      },
        li {},
          a {
            onClick: @handlePlayPauseClick
          },
            if @props.status.get('playing')
              span {className: 'glyphicon glyphicon-pause'}
            else
              span {className: 'glyphicon glyphicon-play'}

      Nav {
        className: 'navbar-right'
      },
        li {},
          a {
            onClick: @handleDecreaseWpmClick
          },
            span {
              className: 'glyphicon glyphicon-chevron-down'
            }
        p {
          className: 'navbar-text'
        },
          @props.status.get('wpm')
        li {},
          a {
            onClick: @handleIncreaseWpmClick
          },
            span {
              className: 'glyphicon glyphicon-chevron-up'
            }



module.exports = Topbar

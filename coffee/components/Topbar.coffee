React = require('react')
{Navbar, Nav, NavItem} = require('react-bootstrap')

dispatcher = require('../dispatcher')

{h1, div, li, p, a, span} = React.DOM


Topbar = React.createClass

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
          a {},
            span {
              className: 'glyphicon glyphicon-chevron-down'
            }
        p {
          className: 'navbar-text'
        },
          "600 WPM"
        li {},
          a {},
            span {
              className: 'glyphicon glyphicon-chevron-up'
            }



module.exports = Topbar

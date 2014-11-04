React = require('react/addons')
{Navbar, Nav, NavItem} = require('react-bootstrap')

dispatcher = require('../dispatcher')
FluxBone = require('./FluxBone')

{h1, div, li, p, a, span, button, form, em, img} = React.DOM


Topbar = React.createClass

  mixins: [
    FluxBone.ModelMixin('article', 'change:title')
    FluxBone.ModelMixin('status', 'change')
    FluxBone.ModelMixin('current', 'change')
    FluxBone.CollectionMixin('words', 'add remove reset')
    React.addons.PureRenderMixin
  ]

  render: ->

    div {
      className: 'navbar-fluid navbar-default navbar-fixed-top'
    },
      div {
        className: 'container-fluid'
      },
        div {
          className: 'row'
        },
          div {
            className: 'col-xs-1'
          },
            p {
              className: 'navbar-text'
              style:
                marginTop: 10
                marginBottom: 10
            },
              a {
                href: '#'
              },
                img {
                  src: '/images/icon32.png'
                }
          div {
            className: 'col-xs-10'
          },
            p {
              className: "navbar-center navbar-text navbar-brand hidden-xs"
            },
              if @props.article.get('title')
                @props.article.get('title')
              else
                "SplashReader"


module.exports = Topbar

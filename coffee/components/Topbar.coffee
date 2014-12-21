React = require('react/addons')
{Navbar, Nav, NavItem} = require('react-bootstrap')

dispatcher = require('../dispatcher')
FluxBone = require('./FluxBone')

{h1, div, li, p, a, span, button, form, em, img} = React.DOM


Topbar = React.createClass

  mixins: [
    FluxBone.ModelMixin('current', 'change')
    React.addons.PureRenderMixin
  ]

  render: ->
    if not (@props.article.get('elem') or @props.article.get('title'))
      return div {}

    div
      className: 'navbar-fluid navbar-default navbar-fixed-top hidden-xs'
      ,
      div
        className: 'container-fluid'
        ,
        div
          className: 'row'
          ,
          # div
          #   className: 'col-xs-1'
          #   ,
          #   p
          #     className: 'navbar-text'
          #     style:
          #       marginTop: 10
          #       marginBottom: 10
          #     ,
          #     a
          #       href: '#'
          #       ,
          #       img
          #         src: '/images/icon32.png'

          div
            className: 'col-xs-12'
            ,
            p
              className: "navbar-center navbar-text navbar-brand"
              ,
              if @props.article.get('title')
                @props.article.get('title')
              else
                "SplashReader"


module.exports = Topbar

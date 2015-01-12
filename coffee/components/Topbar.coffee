React = require('react/addons')

dispatcher = require('../dispatcher')

{h1, div, li, p, a, span, button, form, em, img} = React.DOM


Topbar = React.createClass
  displayName: 'Topbar'

  mixins: [
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

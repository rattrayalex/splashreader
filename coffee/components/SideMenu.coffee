React = require 'react/addons'

WpmWidget = React.createFactory require('./WpmWidget')

dispatcher = require('../dispatcher')

{h1, div, span, form, input, button, p, a, em, small, hr} = React.DOM


SideMenu = React.createClass
  displayName: 'SideMenu'

  mixins: [
    React.addons.PureRenderMixin
  ]

  getInitialState: ->
    menuEverShown: false

  handleUrlSubmitted: (e) ->
    e.preventDefault()
    url = @refs.url.getDOMNode().value
    dispatcher.dispatch
      actionType: 'url-requested'
      url: url
    false

  detectMenuEverShown: ->
    if @props.status.get('menuShown')
      @setState
        menuEverShown: true

  render: ->
    if not @state.menuEverShown
      # async b/c can't setState w/in render.
      # TODO: think of a better way to trigger this.
      setTimeout =>
        @detectMenuEverShown()
      , 0

    anim = if @props.status.get('menuShown') then 'fadeInLeft' else 'fadeOutLeft'

    div
      className: 'animated side-menu ' + anim
      style:
        display: 'none' unless @state.menuEverShown
        # left: if @props.status.get('menuShown') then 0 else -350
      ,
      div
        className: 'list-group'
        ,
        form
          className: 'list-group-item'
          onSubmit: @handleUrlSubmitted
          ,
          div
            className: 'form-group'
            style:
              marginBottom: 0
            ,
            div
              className: 'input-group'
              ,
              input
                className: 'form-control'
                type: 'text'
                placeholder: 'Splash a new Article'
                ref: 'url'
              span
                className: 'input-group-btn'
                ,
                button
                  type: 'submit'
                  className: 'btn btn-warning'
                  onSubmit: @handleUrlSubmitted
                  ,
                  span
                    className: 'glyphicon glyphicon-forward'

        div
          className: 'list-group-item'
          ,
          WpmWidget
            status: @props.status

        a
          className: 'list-group-item'
          href: '#'
          ,
          "SplashReader Home"
        div
          className: 'list-group-item'
          ,
          'Created by '
          a
            href: 'http://alexrattray.com'
            ,
            'Alex Rattray'


module.exports = SideMenu

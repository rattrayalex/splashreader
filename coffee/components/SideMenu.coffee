React = require 'react/addons'

dispatcher = require('../dispatcher')
FluxBone = require('./FluxBone')

WpmWidget = require('./WpmWidget')

{h1, div, span, form, input, button, p, a, em, small, hr} = React.DOM


SideMenu = React.createClass
  mixins: [
    # FluxBone.ModelMixin('status', 'change')
    # FluxBone.ModelMixin('status', 'change', 'detectMenuEverShown')
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
    if @props.status.menuShown.getValue()
      @setState
        menuEverShown: true

  render: ->
    anim = if @props.status.menuShown.getValue() then 'fadeInLeft' else 'fadeOutLeft'
    div
      className: 'animated side-menu ' + anim
      style:
        display: 'none' unless @state.menuEverShown
        # left: if @props.status.menuShown.getValue() then 0 else -350
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

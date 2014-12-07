React = require 'react/addons'

dispatcher = require('../dispatcher')
FluxBone = require('./FluxBone')

WpmWidget = require('./WpmWidget')

{h1, div, span, form, input, button, p, a, em, small, hr} = React.DOM


SideMenu = React.createClass
  mixins: [
    FluxBone.ModelMixin('status', 'change')
    FluxBone.ModelMixin('status', 'change', 'detectMenuEverShown')
  ]

  getInitialState: ->
    menuEverShown: false

  detectMenuEverShown: ->
    if @props.status.get('menuShown')
      @setState
        menuEverShown: true

  render: ->
    anim = if @props.status.get('menuShown') then 'fadeInLeft' else 'fadeOutLeft'
    div {
      className: 'animated side-menu ' + anim
      style:
        display: 'none' unless @state.menuEverShown
        # left: if @props.status.get('menuShown') then 0 else -350
    },
      div {
        className: 'list-group'
      },
        div {
          className: 'list-group-item'
        },
          div {
            className: 'form-group'
            style:
              marginBottom: 0
          },
            div {
              className: 'input-group'
            },
              input {
                className: 'form-control'
                type: 'text'
                placeholder: 'Splash a new Article'
              },
              span {
                className: 'input-group-btn'
              },
                button {
                  type: 'submit'
                  className: 'btn btn-warning'
                },
                  span {
                    className: 'glyphicon glyphicon-forward'
                  }
        div {
          className: 'list-group-item'
        },
          WpmWidget {
            status: @props.status
          }
        a {
          className: 'list-group-item'
        },
          "Hello World!"


module.exports = SideMenu

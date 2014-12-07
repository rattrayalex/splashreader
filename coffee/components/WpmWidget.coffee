React = require('react/addons')
dispatcher = require('../dispatcher')
FluxBone = require('./FluxBone')

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
          className: 'btn btn-warning'
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
          className: 'btn btn-warning'
          onClick: @handleIncreaseWpmClick
        },
          span {
            className: 'glyphicon glyphicon-chevron-up'
          }

module.exports = WpmWidget

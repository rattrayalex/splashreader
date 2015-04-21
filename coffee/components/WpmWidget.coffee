React = require('react/addons')
Actions = require('../Actions')

{h1, div, li, p, a, span, button, form, em} = React.DOM


WpmWidget = React.createClass
  displayName: 'WpmWidget'

  mixins: [
    React.addons.PureRenderMixin
  ]

  handleIncreaseWpmClick: ->
    Actions.increaseWpm.push
      amount: 50

  handleDecreaseWpmClick: ->
    Actions.decreaseWpm.push
      amount: 50

  render: ->
    div
      className: 'navbar-form ' + @props.className or ''
      style: @props.style or {}
      ,
      div
        className: 'btn-group'
        ,
        button
          type: 'button'
          className: 'btn btn-warning'
          onClick: @handleDecreaseWpmClick
          ,
          span
            className: 'glyphicon glyphicon-chevron-down'
        span
          className: 'btn btn-default disabled'
          ,
          "#{ @props.status.get('wpm') }"
          span
            className: 'hidden-xs'
            ,
            " wpm"
        button
          type: 'button'
          className: 'btn btn-warning'
          onClick: @handleIncreaseWpmClick
          ,
          span
            className: 'glyphicon glyphicon-chevron-up'


module.exports = WpmWidget

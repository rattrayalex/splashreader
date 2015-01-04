React = require 'react'

{div, span} = React.DOM

LoadingIcon = React.createClass
  shouldComponentUpdate: -> false

  render: ->
    div
      style:
        position: 'absolute'
        top: 0
        left: 0
        right: 0
        bottom: 0
        margin: 'auto'
        zIndex: 100
        # background: 'rgba(0,0,0,.1)'
      ,
      div
        style:
          display: 'table'
          textAlign: 'center'
          width: '100%'
          height: '100%'
        ,
        span
          className: "glyphicon glyphicon-repeat fa-spin"
          style:
            fontSize: '500%'
            opacity: .5
            display: 'table-cell'
            verticalAlign: 'middle'


module.exports = LoadingIcon

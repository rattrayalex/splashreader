React = require 'react'

{div} = React.DOM

RsvpDisplay = React.createClass

  componentDidMount: ->
    @props.word.on 'reset', ( => @forceUpdate() ), @
  componentWillUnmount: ->
    @props.word.off null, null, @

  render: ->
    div {
      className: 'well lead text-center'
    },
      if @props.word.at(0)
        @props.word.at(0).get('word') or ' '
      else
        ' '


module.exports = RsvpDisplay

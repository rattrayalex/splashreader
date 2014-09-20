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
      @props.word.at(0).get('word')


module.exports = RsvpDisplay

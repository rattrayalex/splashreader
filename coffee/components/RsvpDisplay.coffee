React = require 'react'
{div, span} = React.DOM

OrpWord = require './OrpWord'

RsvpDisplay = React.createClass

  componentDidMount: ->
    @props.current.on 'change:word', =>
      @forceUpdate()
    , @
    @props.status.on 'change', =>
      @forceUpdate()
    , @
  componentWillUnmount: ->
    @props.current.off null, null, @
    @props.status.off null, null, @

  render: ->
    word = @props.current.get('word').get('word') or " "

    div {
      className: 'rsvp-wrapper'
      style:
        display: if @props.status.get('playing') then 'block' else 'none'
    },
      OrpWord {word}



module.exports = RsvpDisplay

React = require 'react'

{getWordMiddle} = require '../rsvp_utils'

{div, span} = React.DOM
eleven_dots = Array(11).join('.')


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
    word = word.trim()
    word = word or " "

    # append a space before 1-letter words... uhh, it fixes bugs...
    if word.length is 1
      word = ' ' + word
      length = 2
    middle = getWordMiddle word.length

    word_p1 = word[0 .. (middle - 2)]
    word_p2 = word[middle - 1]
    word_p3 = word[middle..] or ' '

    div {
      className: 'rsvp-wrapper'
      style:
        display: if @props.status.get('playing') then 'block' else 'none'
    },
      span {className: 'rsvp-before-word'},
        # why 11, you ask? I have no idea!
        # https://github.com/Miserlou/Glance/blob/master/spritz.js#L221
        eleven_dots[0 .. (11 - 1 - middle)]
      span {className: 'rsvp-before-middle'},
        word_p1
      span {className: 'rsvp-middle'},
        word_p2
      span {className: 'rsvp-after-middle'},
        word_p3
      span {className: 'rsvp-after-word'},
        eleven_dots[0 .. (11 - 1 - (word.length - middle))]


module.exports = RsvpDisplay

React = require 'react/addons'

FluxBone = require('./FluxBone')
{getWordMiddle, getTextWidth} = require '../rsvp_utils'

{div, span} = React.DOM
eleven_dots = Array(11).join('.')
eleven_ems = Array(11).join('m')


RsvpDisplay = React.createClass

  mixins: [
    FluxBone.ModelMixin('current', 'change:word')
    FluxBone.ModelMixin('status', 'change')
    React.addons.PureRenderMixin
  ]

  componentDidMount: ->
    @font = '32pt Libre Baskerville'
    @ORP_center = getTextWidth(eleven_ems, @font) / 3

  render: ->
    if not @props.current.get('word')?.get('word')?
      return div {}

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

    width_p1 = getTextWidth(word_p1, @font)
    width_p2 = getTextWidth(word_p2, @font)
    center_point = width_p1 + (width_p2 / 2)
    offset = @ORP_center - center_point

    div {
      className: 'rsvp-wrapper'
      style:
        font: @font
        display: if @props.status.get('playing') then 'block' else 'none'
        marginLeft: offset or 0
    },
      span {className: 'rsvp-before-middle'},
        word_p1
      span {className: 'rsvp-middle'},
        word_p2
      span {className: 'rsvp-after-middle'},
        word_p3


module.exports = RsvpDisplay

React = require 'react/addons'

{getWordMiddle, getTextWidth} = require '../rsvp_utils'
{getCurrentWord, isPlaying} = require '../stores/computed'

{div, span} = React.DOM
eleven_dots = Array(11).join('.')
eleven_ems = Array(11).join('m')


RsvpDisplay = React.createClass

  mixins: [
    # React.addons.PureRenderMixin
  ]

  isShown: ->
    isPlaying(@props.status)

  componentDidMount: ->
    @font = '32pt libre_baskervilleregular, Georgia'
    # @font = "600 32pt 'Open Sans'"
    full_width = Math.min window.innerWidth, getTextWidth(eleven_ems, @font)
    @ORP_center = full_width / 3

  render: ->
    currentWord = getCurrentWord @props.words
    if not currentWord
      return div {}

    word = currentWord.get('word') or " "
    word = word.trim()
    word = word or " "

    # append a space before 1-letter words... uhh, it fixes bugs...
    if word.length is 1
      word = ' ' + word

    if currentWord.get('after') is '-'
      word += '-'

    middle = getWordMiddle word.length

    word_p1 = word[0 .. (middle - 2)]
    word_p2 = word[middle - 1]
    word_p3 = word[middle..] or ' '

    width_p1 = getTextWidth(word_p1, @font)
    width_p2 = getTextWidth(word_p2, @font)
    center_point = width_p1 + (width_p2 / 2)
    offset = @ORP_center - center_point

    div
      className: 'rsvp-wrapper'
      style:
        display: if @isShown() then 'block' else 'none'
      ,
      div
        className: 'rsvp-notch-top'
        style:
          marginLeft: @ORP_center + getTextWidth('m', @font)/2
      div
        className: 'rsvp-notch-bottom'
        style:
          marginLeft: @ORP_center + getTextWidth('m', @font)/2
      div
        className: 'rsvp-wrapper-inner'
        style:
          font: @font
          marginLeft: offset or 0
        ,
        span
          className: 'rsvp-before-middle'
          ,
          word_p1
        span
          className: 'rsvp-middle'
          ,
          word_p2
        span
          className: 'rsvp-after-middle'
          ,
          word_p3


module.exports = RsvpDisplay

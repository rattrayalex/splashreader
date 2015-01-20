_ = require('lodash')


getDisplayMultiplier = (word) ->
  word = word.trim()
  display = 1

  if not word
    return display

  if word.length > 8
    display += 1

  # Double up on words with numbers, symbols, or punctuation!
  if word.match /[^a-zA-Z]/  # anything but a letter
    display += 1

  # Triple up on words that have a number.
  if word.match /[0-9]/
    display += 2

  # triple up on words that end with one of: . ! ? : ) ]
  if _.last(word).match /\.|\!|\?|:|\)|\]/
    display += 2

  return display


getWordMiddle = (length) ->
  # gets the "middle" of the word, where the red letter goes
  # from https://github.com/Miserlou/Glance/blob/master/spritz.js#L190
  #
  # ... this may need refining, returns different results from eg; squirt.io

  if length is 1
    1
  else if length in [2..5]
    2
  else if length in [6..9]
    3
  else if length in [10..13]
    4
  else
    5


###*
Uses canvas.measureText to compute and return the width
of the given text of given font in pixels.

@param {String} text
  The text to be rendered.
@param {String} font
  The css font descriptor that text is to be rendered with
  (e.g. "bold 14px verdana").

@see http://stackoverflow.com/a/21015393/1048433
###
getTextWidth = (text, font) ->
  # re-use canvas object for better performance
  canvas = getTextWidth.canvas or (
    getTextWidth.canvas = document.createElement("canvas"))
  context = canvas.getContext("2d")
  context.font = font
  metrics = context.measureText(text)
  return metrics.width


module.exports = {getDisplayMultiplier, getWordMiddle, getTextWidth}

_ = require('underscore')

shortenLongWord = (word) ->
  max_length = 15

  if word.length < max_length
    return word

  hyphen = word.match /-/
  if hyphen
    first_half = word.slice(0, hyphen.index + 1)
    second_half = word.slice(hyphen.index + 1)
  else
    middle = Math.floor(word.length / 2)
    middle = Math.min(middle, max_length - 2)

    first_half = word.slice(0, middle) +
      '-'
    second_half = word.slice(middle)

  words = [shortenLongWord(first_half), shortenLongWord(second_half)]
  return words


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

  # triple up on words that end with period.
  if _.last(word).match /\.|\!|\?|:|;|\)/
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


module.exports = {getDisplayMultiplier, getWordMiddle}

Bacon = require 'baconjs'
Immutable = require 'immutable'
Backbone = require 'backbone'
RsvpStatusStore = require './RsvpStatusStore'

Actions = require '../Actions'
defaults = require './defaults'
{msPerWord, isPlaying, getCurrentWord} = require './computed'


_timeout = 0
###
This sets a timeout to display the next word,
as well as paraChange and end-of-article pause.

@param [Immutable.List] words the `store` variable in the Bacon.update here...
@param [Integer] idx the index of the current word.
###
_enqueueWordAfter = (words, idx) ->
  if not isPlaying(window.store.get('status'))
    return

  word = words.get(idx)
  next_word = words.get(idx + 1)
  para_change = next_word?.get('parent') isnt word.get('parent')
  time_to_display = word.get('display') *
    msPerWord window.store.getIn(['status', 'wpm'])

  if not next_word
    # end of article, just pause.
    return setTimeout ->
      Actions.pause.push('end-of-article')
    , time_to_display

  # HACK: janky prevention of rare double-display bug.
  clearTimeout _timeout

  # display the next word in a bit
  _timeout = setTimeout ->
    # change para before next updateWord so it pauses.
    if para_change
      Actions.paraChange.push()

    Actions.wordChange.push next_word.get('idx'), 'WordStore._enqueueWordAfter'
  , time_to_display


WordStore = Bacon.update defaults.words,

  Actions.wordlistComplete, (store, words) ->
    console.log 'wordlist-complete'
    if not words.length
      console.log 'no words in this homepage'
      setTimeout ->
        window.location = '#'
      , 1000
      return store

    # TODO: check if this is needed here.
    _enqueueWordAfter store, 0

    # set first word to be the current word
    words[0] = words[0].set 'current', true
    store.update ->
      Immutable.List words

  Actions.wordChange, (store, idx, source) ->
    # ignore `pre`, `td`, etc...
    if store.getIn([idx, 'display']) is 0
      console.log 'changing to display0 word!'
      if source is 'click'
        return store
      else
        setTimeout ->
          Actions.wordChange.push idx + 1, 'display0'
        return store

    _enqueueWordAfter(store, idx)
    store.update (words) ->
      words.map (word) ->
        if word.get('idx') is idx
          word.set('current', true)
        else if word.get('current')
          word.set('current', false)
        else
          word

  Actions.paraResume, (store) ->
    _enqueueWordAfter store, getCurrentWord(store).get('idx')
    store

  Actions.play2, (store) ->
    _enqueueWordAfter store, getCurrentWord(store).get('idx') or 0
    store

  Actions.pause2, (store) ->
    clearTimeout _timeout if _timeout?
    store

  Actions.processArticle, (store) ->
    store.clear()

  Actions.pageChange, (store, url) ->
    if not url
      store.clear()
    else
      store


module.exports = WordStore

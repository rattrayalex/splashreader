Immutable = require 'immutable'
Backbone = require 'backbone'
{WordModel} = require './ArticleModels'
RsvpStatusStore = require './RsvpStatusStore'

dispatcher = require '../dispatcher'


class WordStore
  constructor: (@store) ->
    dispatcher.tokens.WordStore = dispatcher.register @dispatcherCallback

  cursor: (path...) ->
    @store.cursor('words').cursor(path)

  numWords: ->
    @cursor().valueOf().count()

  getWord: (idx) ->
    @cursor().valueOf().get(idx)

  indexOfWord: (word) ->
    @cursor().valueOf().indexOf(word)

  getTimeSince: (idx) ->
    # http://facebook.github.io/immutable-js/docs/#/List/skip
    remaining_words = @cursor().valueOf().skip(idx).toJS()

    time_left = 0
    for w in remaining_words
      time_left += w.get('display')

    seconds_left = time_left * RsvpStatusStore.msPerWord() / 1000
    minutes_left = seconds_left / 60

    return minutes_left

  getTotalTime: ->
    @getTimeSince 0

  dispatcherCallback: (payload) =>
    switch payload.actionType

      when 'wordlist-complete'
        console.log 'wordlist-complete'
        @cursor().update ->
          Immutable.List payload.words

      when 'process-article'
        @cursor().clear()

      when 'page-change'
        dispatcher.waitFor [dispatcher.tokens.CurrentPageStore]
        if not payload.url
          @cursor().clear()

module.exports = new WordStore(require('./store'))

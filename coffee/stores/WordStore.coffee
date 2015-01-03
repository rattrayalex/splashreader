Immutable = require 'immutable'
Backbone = require 'backbone'
RsvpStatusStore = require './RsvpStatusStore'

dispatcher = require '../dispatcher'



class WordStore
  constructor: (@store) ->
    dispatcher.tokens.WordStore = dispatcher.register @dispatcherCallback

  cursor: (path...) ->
    @store.cursor('words').cursor(path)

  dispatcherCallback: (payload) =>
    switch payload.actionType

      when 'wordlist-complete'
        console.log 'wordlist-complete'
        # set first word to be the current word
        payload.words[0] = payload.words[0].set 'current', true
        @cursor().update ->
          Immutable.List payload.words
        # console.log 'wordlist processing done', @cursor(0).toString()

      when 'process-article'
        @cursor().clear()

      when 'page-change'
        dispatcher.waitFor [dispatcher.tokens.CurrentPageStore]
        if not payload.url
          @cursor().clear()

      when 'change-word'
        oldIdx = @store.get('current').get('idx')
        @cursor(oldIdx).set('current', false)
        @cursor(payload.idx).set('current', true)

module.exports = WordStore



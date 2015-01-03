Backbone = require 'backbone'
# Backbone.LocalStorage = require("backbone.localstorage")
_ = require('underscore')

{msPerWord, getCurrentWord} = require('./computed')
RsvpStatusStore = require './RsvpStatusStore'

dispatcher = require '../dispatcher'



class CurrentWordStore
  constructor: (@store) ->
    dispatcher.tokens.CurrentWordStore = dispatcher.register @dispatchCallback
    # # when there's a new word,
    # @on 'change:idx', (model, idx) =>

  cursor: (path...) ->
    @store.cursor('current').cursor(path)

  onChange: (model, idx) ->
    # tell old/new they've changed
    prev = @store.get('words').get @previous('idx')
    word = @store.get('words').get(idx)
    prev?.trigger('change')
    word?.trigger('change')

    # paragraph change!
    if prev?.get('parent') isnt word?.get('parent')

      if @store.current.get('status').get('playing')

        # pause on para change
        # TODO: set paraChange instead of playing,
        #   read from that too in display
        @store.cursor('status').cursor('playing').update -> false

        # start playing after para change
        setTimeout ->
          dispatcher.dispatch
            actionType: 'play'
            source: 'para-change'
        , 1000

      # scroll to first word
      getCurrentWord @store.get('words'), @store.get('current')
        .trigger 'scroll'

  updateWord: (idx) ->

    # # code blocks (in `pre`) aren't in WordStore, don't go to them.
    # if WordStore.indexOfWord(word) < 0
    #   console.log 'word not in WordStore, ignore', word
    #   return

    # idx = WordStore.indexOfWord(word)
    word = @store.get('words').get(idx)
    @cursor('idx').update -> idx

    # trigger the next word to update.
    if @store.get('status').get('playing') is true
      next_word = @store.get('words').get(idx + 1)
      time_to_display = msPerWord(@store.getIn(['status', 'wpm'])) * word.get('display')

      if next_word
        # janky prevention of rare double-display bug.
        # TODO: prevent that from happening in the first place.
        clearTimeout @timeout if @timeout?

        @timeout = setTimeout ->
          dispatcher.dispatch
            actionType: 'change-word'
            idx: next_word.get('idx')
            source: 'updateWord'
        , time_to_display

      # end of article, just pause.
      else
        setTimeout ->
          dispatcher.dispatch
            actionType: 'pause'
            source: 'article-end'
        , time_to_display

  dispatchCallback: (payload) =>
    switch payload.actionType

      when 'page-change'
        dispatcher.waitFor [dispatcher.tokens.CurrentPageStore]
        if not payload.url
          @cursor().clear()

      when 'change-word'
        dispatcher.waitFor([dispatcher.tokens.WordStore])
        @updateWord(payload.idx)

      when 'wordlist-complete'
        dispatcher.waitFor [dispatcher.tokens.WordStore]
        console.log 'starting at the top'
        @updateWord 0

      when 'play-pause', 'play', 'pause'
        dispatcher.waitFor [dispatcher.tokens.RsvpStatusStore]

        if @store.get('status').get('playing')
          @updateWord @cursor().get('idx') or 0
        else
          clearTimeout @timeout if @timeout?


module.exports = CurrentWordStore

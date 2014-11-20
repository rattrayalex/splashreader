Backbone = require 'backbone'
# Backbone.LocalStorage = require("backbone.localstorage")
_ = require('underscore')

OfflineBackbone = require './OfflineBackbone'

{WordModel, ElementModel} = require './ArticleModels'
ArticleStore = require './ArticleStore'
WordStore = require './WordStore'
RsvpStatusStore = require './RsvpStatusStore'
CurrentPageStore = require './CurrentPageStore'

dispatcher = require '../dispatcher'


class CurrentWordModel extends Backbone.Model

  getWord: (idx=null) ->
    if idx is null
      idx = @get('idx')
    WordStore.at(idx)

  getParent: (idx=null) ->
    word = @getWord(idx)
    word.get('parent')

  updateWord: (word) ->

    # code blocks (in `pre`) aren't in WordStore, don't go to them.
    if WordStore.indexOf(word) < 0
      console.log 'word not in WordStore, ignore'
      return

    idx = WordStore.indexOf(word)
    @set {idx}

    # trigger the next word to update.
    if RsvpStatusStore.get('playing') is true
      next_word = WordStore.at(idx + 1)
      time_to_display = RsvpStatusStore.msPerWord() * word.get('display')

      if next_word
        # janky prevention of rare double-display bug.
        # TODO: prevent that from happening in the first place.
        clearTimeout @timeout if @timeout?

        @timeout = setTimeout ->
          dispatcher.dispatch
            actionType: 'change-word'
            word: next_word
            source: 'updateWord'
        , time_to_display

      # end of article, just pause.
      else
        setTimeout ->
          dispatcher.dispatch
            actionType: 'pause'
            source: 'article-end'
        , time_to_display

  getPercentDone: ->
    @get('idx') / WordStore.length

  getTimeLeft: ->
    WordStore.getTimeSince @get('idx')

  initialize: ->
    # offline stuff... not working rn.
    # _.extend @, OfflineBackbone.Model
    # @localLoad()
    # @on 'change', (model, options) =>
    #   console.log 'options, model', options, model
    #   @localSave(model)

    # when there's a new word,
    @on 'change:idx', (model, idx) =>
      # tell old/new they've changed
      prev = @getWord @previous('idx')
      word = @getWord(idx)
      prev?.trigger('change')
      word?.trigger 'change'

      # paragraph change!
      if prev?.get('parent') isnt word?.get('parent')
        # tell old/new they've changed
        prev.get('parent')?.trigger('change')
        word.get('parent')?.trigger('change')

        if RsvpStatusStore.get('playing')

          # pause on para change
          RsvpStatusStore.set
            playing: false

          # start playing after para change
          setTimeout ->
            dispatcher.dispatch
              actionType: 'play'
              source: 'para-change'
          , 1000

        # scroll to first word
        @getWord().trigger 'scroll'


    # get data from localStorage
    # @fetch
    #   success: =>
    #     console.log 'success', @get 'word'
    @dispatchToken = dispatcher.register @dispatchCallback

  dispatchCallback: (payload) =>
    switch payload.actionType

      when 'page-change'
        dispatcher.waitFor [CurrentPageStore.dispatchToken]
        if not payload.url
          @clear()

      when 'change-word'
        @updateWord(payload.word)
        if payload.source is 'click'
          payload.word.trigger 'scroll'

      when 'process-article'
        dispatcher.waitFor [ArticleStore.dispatchToken]
        if not @get 'idx'
          console.log 'no word, starting at tthe top'
          @updateWord WordStore.at(0)

      when 'play-pause', 'play', 'pause'
        dispatcher.waitFor [RsvpStatusStore.dispatchToken]

        if RsvpStatusStore.get('playing')
          @updateWord @getWord() or WordStore.at(0)
        else
          clearTimeout @timeout if @timeout?

        if payload.actionType is 'pause'
          @getWord()?.trigger 'scroll'


CurrentWordStore = new CurrentWordModel()
module.exports = CurrentWordStore

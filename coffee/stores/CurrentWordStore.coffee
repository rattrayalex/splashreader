Backbone = require 'backbone'
{WordModel} = require './ArticleModels'
ArticleStore = require './ArticleStore'
WordStore = require './WordStore'
RsvpStatusStore = require './RsvpStatusStore'

dispatcher = require '../dispatcher'


class CurrentWordModel extends Backbone.Model

  updateWord: (word) ->
    parent = word.get('parent')
    @set {word, parent}

    # trigger the next word to update.
    if RsvpStatusStore.get('playing') is true
      next_word = WordStore.at(WordStore.indexOf(word) + 1)
      time_to_display = RsvpStatusStore.msPerWord() * word.get('display')

      if next_word
        @timeout = setTimeout ->
          dispatcher.dispatch
            'actionType': 'change-word'
            'word': next_word
        , time_to_display

      # end of article, just pause.
      else
        setTimeout ->
          dispatcher.dispatch
            actionType: 'pause'
        , time_to_display

  getPercentDone: ->
    WordStore.indexOf(@get('word')) / WordStore.length

  getTimeLeft: ->
    WordStore.getTimeSince @get('word')

  initialize: ->
    # when there's a new parent,
    @on 'change:parent', (model, parent) =>
      # tell old/new they've changed
      @previous('parent')?.trigger('change')
      parent.trigger 'change'

      # pause on para change
      RsvpStatusStore.set
        playing: false
      # start playing after para change
      setTimeout ->
        dispatcher.dispatch
          actionType: 'play'
          source: 'para-change'
      , 1000

    # when there's a new word,
    @on 'change:word', (model, word) =>
      # tell old/new they've changed
      @previous('word')?.trigger('change')
      word.trigger 'change'

    @dispatchToken = dispatcher.register @dispatchCallback

  dispatchCallback: (payload) =>
    switch payload.actionType

      when 'change-word'
        @updateWord(payload.word)

      when 'process-article'
        dispatcher.waitFor [ArticleStore.dispatchToken]
        @updateWord WordStore.at(0)

      when 'play-pause', 'play', 'pause'
        dispatcher.waitFor [RsvpStatusStore.dispatchToken]

        if RsvpStatusStore.get('playing')
          if payload.changed
            @updateWord @get('word') or WordStore.at(0)
        else
          clearTimeout @timeout if @timeout?


CurrentWordStore = new CurrentWordModel()
module.exports = CurrentWordStore

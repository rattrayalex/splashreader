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
      time_to_display = 100 * word.get('display')

      @timeout = setTimeout ->
        dispatcher.dispatch
          'actionType': 'change-word'
          'word': next_word
      , time_to_display

  initialize: ->
    # when there's a new parent, tell old/new they've changed
    @on 'change:parent', (model, parent) =>
      @previous('parent')?.trigger('change')
      parent.trigger 'change'

    # when there's a new word, tell old/new they've changed
    @on 'change:word', (model, word) =>
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

      when 'play-pause'
        dispatcher.waitFor [RsvpStatusStore.dispatchToken]

        if RsvpStatusStore.get('playing')
          @updateWord @get('word') or WordStore.at(0)
        else
          clearTimeout @timeout if @timeout?

      when 'pause'
        dispatcher.waitFor [RsvpStatusStore.dispatchToken]

        clearTimeout @timeout if @timeout?


CurrentWordStore = new CurrentWordModel()
module.exports = CurrentWordStore

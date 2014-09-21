Backbone = require 'backbone'
{WordModel} = require './ArticleModels'
ArticleStore = require './ArticleStore'
WordStore = require './WordStore'
RsvpStatusStore = require './RsvpStatusStore'

dispatcher = require '../dispatcher'

class CurrentWordCollection extends Backbone.Collection
  model: WordModel

  updateWord: (word) ->
    @reset word

    if RsvpStatusStore.get('playing') is true

      next_word = WordStore.at(WordStore.indexOf(@at(0)) + 1)
      time_to_display = 100 * @at(0).get('display')

      @timeout = setTimeout ->
        dispatcher.dispatch
          actionType: 'change-word'
          word: next_word
      , time_to_display

  initialize: ->
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
          @updateWord @at(0) or WordStore.at(0)
        else
          clearTimeout @timeout if @timeout?

      when 'pause'
        dispatcher.waitFor [RsvpStatusStore.dispatchToken]

        clearTimeout @timeout if @timeout?



module.exports = new CurrentWordCollection()
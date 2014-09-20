Backbone = require 'backbone'
{WordModel} = require './ArticleModels'
ArticleStore = require './ArticleStore'
WordStore = require './WordStore'

dispatcher = require '../dispatcher'

class CurrentWordCollection extends Backbone.Collection
  model: WordModel

  updateWord: (word) ->
    @reset word

    next_word = WordStore.at(WordStore.indexOf(@at(0)) + 1)
    time_to_display = 200 * @at(0).get('display')

    setTimeout ->
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

module.exports = new CurrentWordCollection()
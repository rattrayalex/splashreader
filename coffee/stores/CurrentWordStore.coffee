Backbone = require 'backbone'
{WordModel} = require './ArticleModels'
ArticleStore = require './ArticleStore'
WordStore = require './WordStore'

dispatcher = require '../dispatcher'

class CurrentWordCollection extends Backbone.Collection
  model: WordModel

  initialize: ->
    @dispatchToken = dispatcher.register @dispatchCallback

  dispatchCallback: (payload) =>
    switch payload.actionType
      when 'change-word'
        @reset payload.word
      when 'process-article'
        dispatcher.waitFor [ArticleStore.dispatchToken]
        @reset WordStore.at(0)

        console.log @at(0)

module.exports = new CurrentWordCollection()
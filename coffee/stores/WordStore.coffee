Backbone = require 'backbone'
{WordModel} = require './ArticleModels'
RsvpStatusStore = require './RsvpStatusStore'
CurrentPageStore = require './CurrentPageStore'

dispatcher = require '../dispatcher'


class WordCollection extends Backbone.Collection
  model: WordModel

  getTimeSince: (word) ->
    remaining_words = @rest @indexOf(word)

    time_left = 0
    for w in remaining_words
      time_left += w.get('display')

    seconds_left = time_left * RsvpStatusStore.msPerWord() / 1000
    minutes_left = seconds_left / 60

    return minutes_left

  getTotalTime: ->
    @getTimeSince @at(0)

  initialize: ->
    @dispatchToken = dispatcher.register @dispatcherCallback

  dispatcherCallback: (payload) =>
    switch payload.actionType
      when 'page-change'
        dispatcher.waitFor [CurrentPageStore.dispatchToken]
        if not payload.url
          @reset()

module.exports = new WordCollection()

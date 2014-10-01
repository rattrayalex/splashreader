Backbone = require 'backbone'
{WordModel} = require './ArticleModels'
RsvpStatusStore = require './RsvpStatusStore'

class WordCollection extends Backbone.Collection
  model: WordModel

  getTimeSince: (word) ->
    remaining_words = @rest @indexOf(word)

    time_left = 0
    for word in remaining_words
      time_left += word.get('display')

    seconds_left = time_left * RsvpStatusStore.msPerWord() / 1000
    minutes_left = seconds_left / 60

    return minutes_left

  getTotalTime: ->
    @getTimeSince @at(0)

module.exports = new WordCollection()

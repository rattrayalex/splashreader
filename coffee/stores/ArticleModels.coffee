Backbone = require 'backbone'

dispatcher = require '../dispatcher'
{getDisplayMultiplier} = require '../rsvp_utils'



class ElementModel extends Backbone.Model


class WordModel extends ElementModel
  initialize: ->
    @once 'change', =>
      @set
        display: getDisplayMultiplier @get('word')

    @dispatchToken = dispatcher.register @dispatcherCallback

  dispatcherCallback: (payload) =>
    switch payload.actionType
      when 'click-word'
        if payload.word is @
          @set
            clicked: true


class ChildrenCollection extends Backbone.Collection
  model: ElementModel


class WordCollection extends Backbone.Collection
  model: WordModel

  initialize: ->
    @dispatchToken = dispatcher.register @dispatcherCallback

  dispatcherCallback: (payload) =>
    switch payload.actionType
      when 'process-article'
        console.log @


module.exports = {ElementModel, ChildrenCollection, WordModel, WordCollection}

Backbone = require 'backbone'

dispatcher = require '../dispatcher'


class ElementModel extends Backbone.Model
  initialize: ->
    @dispatchToken = dispatcher.register @dispatcherCallback

  dispatcherCallback: (payload) =>
    switch payload.actionType
      when 'click-word'
        if payload.word is @
          @set
            clicked: true


class ChildrenCollection extends Backbone.Collection
  model: ElementModel


module.exports = {ElementModel, ChildrenCollection}

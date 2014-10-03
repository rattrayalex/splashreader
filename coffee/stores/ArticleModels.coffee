Backbone = require 'backbone'

dispatcher = require '../dispatcher'
{getDisplayMultiplier} = require '../rsvp_utils'


class ElementModel extends Backbone.Model


class ChildrenCollection extends Backbone.Collection
  model: ElementModel


class WordModel extends ElementModel
  initialize: ->
    setTimeout =>
      @set
        display: getDisplayMultiplier @get('word')
    , 0


module.exports = {
  ElementModel,
  ChildrenCollection,
  WordModel,
}

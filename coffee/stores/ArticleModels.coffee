Backbone = require 'backbone'
NestedBackbone = require './NestedBackbone'
_ = require 'underscore'

dispatcher = require '../dispatcher'
{getDisplayMultiplier} = require '../rsvp_utils'


class ChildrenCollection extends Backbone.Collection


class ElementModel extends NestedBackbone.Model
  nested:
    children: ChildrenCollection


# class ChildrenCollection extends Backbone.Collection
#   model: ElementModel


class WordModel extends NestedBackbone.Model
  nested:
    _exclude: [
      'parent'
    ]
    parent: ElementModel

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

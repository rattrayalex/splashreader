Backbone = require 'backbone'

dispatcher = require '../dispatcher'
{getDisplayMultiplier} = require '../rsvp_utils'


class ElementModel extends Backbone.Model


class ChildrenCollection extends Backbone.Collection
  model: ElementModel


class WordModel extends ElementModel
  initialize: ->
    # when the word is added, calculate its display time
    @once 'change', =>
      @set
        display: getDisplayMultiplier @get('word')


class WordCollection extends Backbone.Collection
  model: WordModel


module.exports = {
  ElementModel,
  ChildrenCollection,
  WordModel,
  WordCollection,
}

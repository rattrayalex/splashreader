Backbone = require 'backbone'
_ = require 'underscore'

class Model extends Backbone.Model
  # usage:
  # this.nested = {
  #   "childModelName": ModelClass,
  #   "childCollectionName": CollectionClass
  #   "_exclude": [
  #     "excludedChildName",
  #   ]
  # }
  parse: (data, options) ->
    if not @nested?
      throw new Error(
        'You must define nested attribute on a NestedBackbone.Model instance')

    for name, value of data
      if name in @_exclude?
        delete data[name]
        continue

      if value and name of @nested
        data[name] = new @nested[name](value, {parse: true})
    data

  toJSON: ->
    if not @nested?
      throw new Error(
        'You must define nested attribute on a NestedBackbone.Model instance')

    @_isSerializing = true
    json = _.clone @attributes
    for name, value of json
      if name in @_exclude?
        delete data[name]
        continue

      if value and name of @nested
        # self-referential?
        if value._isSerializing
          json[name] = value.id or value.cid
        else
          json[name] = value.toJSON()
    @_isSerializing = false
    json

class Collection extends Backbone.Model
  # usage:
  # this.nested = {
  #   "childModelName": ModelClass,
  #   "childCollectionName": CollectionClass
  # }
  parse: (data, options) ->
    if not @nested?
      throw new Error(
        'You must define nested attribute on a NestedBackbone.Collection')

    for name, value of data
      if name in @_exclude?
        delete data[name]
        continue

      if value and name of @nested
        data[name] = new @nested[name](value, {parse: true})
    data

  toJSON: ->
    if not @nested?
      throw new Error(
        'You must define nested attribute on a NestedBackbone.Collection')

    @_isSerializing = true
    json = _.clone @models
    for name, value of json
      if name in @_exclude?
        delete data[name]
        continue

      if value and name of @nested
        # self-referential?
        if value._isSerializing
          json[name] = value.id or value.cid
        else
          json[name] = value.toJSON()
    @_isSerializing = false
    json


module.exports = {Model, Collection}

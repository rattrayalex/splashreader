Backbone = require('backbone')
_ = require('underscore')
Immutable = require('immutable')
Cursor = require('immutable/contrib/cursor')


class Store
  constructor: (data) ->
    @current = Immutable.fromJS(data or {})
    # TODO: replace with eventemitter3
    _.extend(this, Backbone.Events)

  get: (key) ->
    @current.get(key)

  getIn: (keys) ->
    @current.getIn(keys)

  cursor: (path...) ->
    Cursor.from(@current, path, @_updateCursor)

  _updateCursor: (newRoot, oldRoot, path) =>
    @current = newRoot
    @trigger('update', @current)
    @current


store = new Store()


module.exports = new Store({})

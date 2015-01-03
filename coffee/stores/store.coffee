Backbone = require('backbone')
_ = require('underscore')
Immutable = require('immutable')
Cursor = require('immutable/contrib/cursor')


class Store
  constructor: (data) ->
    @_root = Immutable.fromJS(data or {})
    # TODO: replace with eventemitter3
    _.extend(this, Backbone.Events)

  get: (key) ->
    @_root.get(key)

  getIn: (keys) ->
    @_root.getIn(keys)

  cursor: (path...) ->
    Cursor.from(@_root, path, @_updateCursor)

  _updateCursor: (newRoot, oldRoot, path) =>
    if oldRoot != @_root
      throw new Error('oldRoot != @_root! '
        'need to implement store._updateCursor better')
    @_root = newRoot
    @trigger('update', @_root)
    @_root


module.exports = new Store({})

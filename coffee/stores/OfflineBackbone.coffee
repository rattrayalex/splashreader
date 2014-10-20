Backbone = require 'backbone'



# for "multiple inheritance":
# https://github.com/jashkenas/coffeescript/issues/452#issuecomment-17012372
#
# mixOf = (base, mixins...) ->
#   class Mixed extends base
#   for mixin in mixins by -1
#     for name, method of mixin::
#       Mixed::[name] = method
#   Mixed
#
#  class MyModel extends mixOf NestedBackbone.Model, OfflineBackbone.Model
#

Model =
  # example usage:
  # @initialize: ->
  #   _.extend @, OfflineBackbone.Model
  #   @localLoad()
  #   @on 'change', (model, options) =>
  #     @localSave()


  localLoad: (parse_options, set_options) ->
    try
      ls_items = localStorage.getItem @constructor.name
    catch e
      return null

    items = JSON.parse ls_items
    if items
      parsed = @parse(items, parse_options)
    if parsed
      console.log 'we have stuff loading!', parsed
      @set(parsed, set_options)

  localSave: (model) ->
    localStorage.setItem @constructor.name, JSON.stringify @toJSON()


class Collection extends Backbone.Collection


module.exports = {Model, Collection}

Backbone = require 'backbone'

dispatcher = require('../dispatcher')

class RsvpStatusModel extends Backbone.Model
  defaults:
    playing: false

  initialize: ->
    @dispatchToken = dispatcher.register @dispatchCallback

  dispatchCallback: (payload) =>
    switch payload.actionType
      when 'play-pause'
        @set
          playing: !@get('playing')

      when 'pause'
        @set
          playing: false

RsvpStatusStore = new RsvpStatusModel()
module.exports = RsvpStatusStore

Backbone = require 'backbone'

dispatcher = require('../dispatcher')

class RsvpStatusModel extends Backbone.Model
  defaults:
    playing: false
    wpm: 400

  msPerWord: ->
    60000 / @get('wpm')

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

      when 'set-wpm'
        @set
          wpm: payload.wpm

      when 'increase-wpm'
        @set
          wpm: @get('wpm') + payload.amount

      when 'decrease-wpm'
        @set
          wpm: @get('wpm') - payload.amount

RsvpStatusStore = new RsvpStatusModel()
module.exports = RsvpStatusStore

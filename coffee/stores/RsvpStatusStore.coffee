Backbone = require 'backbone'

dispatcher = require('../dispatcher')

class RsvpStatusModel extends Backbone.Model
  defaults:
    playing: false
    wpm: 500

  msPerWord: ->
    60000 / @get('wpm')

  initialize: ->
    @dispatchToken = dispatcher.register @dispatchCallback

  dispatchCallback: (payload) =>
    switch payload.actionType
      when 'play-pause'
        @set
          playing: !@get('playing')
        payload.changed = @changedAttributes()

      when 'pause'
        @set
          playing: false
        payload.changed = @changedAttributes()

      when 'play'
        @set
          playing: true
        payload.changed = @changedAttributes()

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

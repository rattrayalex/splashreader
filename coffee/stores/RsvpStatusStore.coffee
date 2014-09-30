Backbone = require 'backbone'
$ = require('jquery')

dispatcher = require('../dispatcher')

class RsvpStatusModel extends Backbone.Model
  defaults:
    playing: false
    wpm: 500

  msPerWord: ->
    60000 / @get('wpm')

  initialize: ->
    @dispatchToken = dispatcher.register @dispatchCallback

    @space_is_down = false
    $(window).keydown (e) =>
      if e.which is 32  # space
        if not @space_is_down
          @space_is_down = true
          dispatcher.dispatch
            actionType: 'play'
            source: 'space'
        false

    $(window).keyup (e) =>
      if e.which is 32  # space
        @space_is_down = false
        dispatcher.dispatch
          actionType: 'pause'
          source: 'space'
        false

    $(window).blur = ->
      dispatcher.dispatch
        actionType: 'pause'
        source: 'window-blur'

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
        if not ( payload.source is 'para-change' and not @space_is_down )
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

Backbone = require 'backbone'
$ = require('jquery')
_ = require('underscore')
key = require('keymaster')

OfflineBackbone = require('./OfflineBackbone')

dispatcher = require('../dispatcher')

class RsvpStatusStore
  constructor: (@store) ->
    # @cursor = @store.cursor('status').cursor

    dispatcher.tokens.RsvpStatusStore = dispatcher.register(@dispatchCallback)

    $(window).keydown (e) =>
      if e.which is 32  # space
        dispatcher.dispatch
          actionType: 'play-pause'
          source: 'space'
        false
    $(window).on 'touchend', (e) =>
      if @get('playing')
        dispatcher.dispatch
          actionType: 'pause'
          source: 'tap'
        false
    $(window).blur ->
      dispatcher.dispatch
        actionType: 'pause'
        source: 'window-blur'

  cursor: (path...) ->
    @store.cursor('status').cursor(path)

  msPerWord: ->
    60000 / @cursor().get('wpm')

  dispatchCallback: (payload) =>
    switch payload.actionType
      when 'play-pause'
        @cursor('playing').update (x) -> !x
        @cursor('menuShown').update -> false

      when 'pause'
        @cursor('playing').update -> false

      when 'play'
        # # don't play if the trigger was a paragraph change
        # # but the user has lifted the spacebar in the interim.
        # unless payload.source is 'para-change' and not @space_is_down
        @cursor('playing').update -> true
        @cursor('menuShown').update -> false

      when 'set-wpm'
        @cursor('wpm').update -> payload.wpm

      when 'increase-wpm'
        @cursor('wpm').update (x) ->
          x + payload.amount

      when 'decrease-wpm'
        @cursor('wpm').update (x) ->
          x - payload.amount

      when 'toggle-side-menu'
        @cursor('menuShown').update (x) -> !x
        @cursor('playing').update -> false

      when 'page-change'
        @cursor('playing').update -> false
        @cursor('menuShown').update -> false


# TODO: move instantiation into app.coffee
module.exports = new RsvpStatusStore(require('./store'))

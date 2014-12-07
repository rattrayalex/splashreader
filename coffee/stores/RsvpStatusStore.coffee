Backbone = require 'backbone'
$ = require('jquery')
_ = require('underscore')
key = require('keymaster')

OfflineBackbone = require('./OfflineBackbone')

dispatcher = require('../dispatcher')

class RsvpStatusModel extends Backbone.Model
  defaults:
    playing: false
    wpm: 500
    menuShown: false

  msPerWord: ->
    60000 / @get('wpm')

  initialize: ->
    @dispatchToken = dispatcher.register @dispatchCallback

    # save/load WPM between sessions.
    _.extend @, OfflineBackbone.Model
    @localLoad()
    @on 'change', (model, options) =>
      @localSave()

    # hide menu when play is resumed
    @on 'change:playing', (model, options) =>
      if model.get('playing')
        @set
          menuShown: false

    # key 'space', =>
    #   dispatcher.dispatch
    #     actionType: 'play-pause'
    #     source: 'space'
    #   false
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


    # @space_is_down = false
    # $(window).keydown (e) =>
    #   if e.which is 32  # space
    #     if not @space_is_down
    #       @space_is_down = true
    #       dispatcher.dispatch
    #         actionType: 'play'
    #         source: 'space'
    #     false

    # $(window).keyup (e) =>
    #   if e.which is 32  # space
    #     @space_is_down = false
    #     dispatcher.dispatch
    #       actionType: 'pause'
    #       source: 'space'
    #     false

    $(window).blur ->
      dispatcher.dispatch
        actionType: 'pause'
        source: 'window-blur'

  dispatchCallback: (payload) =>
    switch payload.actionType
      when 'play-pause'
        @set
          playing: !@get('playing')

      when 'pause'
        @set
          playing: false

      when 'play'
        # don't play if the trigger was a paragraph change
        # but the user has lifted the spacebar in the interim.
        # unless payload.source is 'para-change' and not @space_is_down
          @set
            playing: true

      when 'set-wpm'
        @set
          wpm: payload.wpm

      when 'increase-wpm'
        @set
          wpm: @get('wpm') + payload.amount

      when 'decrease-wpm'
        @set
          wpm: @get('wpm') - payload.amount

      when 'toggle-side-menu'
        @set
          menuShown: !@get('menuShown')
          playing: false

      when 'page-change'
        @set
          playing: false
          menuShown: false


RsvpStatusStore = new RsvpStatusModel()
module.exports = RsvpStatusStore

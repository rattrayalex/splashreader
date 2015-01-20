Backbone = require 'backbone'
$ = require('jquery')
_ = require('lodash')
key = require('keymaster')

dispatcher = require('../dispatcher')
constants = require('../constants')


class RsvpStatusStore
  constructor: (@store) ->
    dispatcher.tokens.RsvpStatusStore = dispatcher.register(@dispatchCallback)

  cursor: (path...) ->
    @store.cursor('status').cursor(path)

  dispatchCallback: (payload) =>
    switch payload.actionType
      when 'play-pause'
        @cursor('playing').update (x) -> !x
        @cursor('menuShown').update -> false

      when 'pause'
        @cursor('playing').update -> false

      when 'play'
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

      when 'para-change'
        @cursor('para_change').update -> true
        setTimeout ->
          dispatcher.dispatch
            actionType: 'para-resume'
        , constants.PARA_CHANGE_TIME

      when 'para-resume'
        @cursor('para_change').update -> false


module.exports = RsvpStatusStore

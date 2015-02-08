Backbone = require 'backbone'
Bacon = require 'baconjs'
$ = require('jquery')
_ = require('lodash')
key = require('keymaster')

Actions = require('../Actions')
constants = require('../constants')
defaults = require('./defaults')


RsvpStatusStore = Bacon.update defaults.status,

  Actions.pageChange, (store, url) ->
    store = store.set 'playing', false
    store.set 'menuShown', false

  Actions.pause2, (store) ->
    store.set 'playing', false

  Actions.play2, (store) ->
    store = store.set 'playing', true
    store.set 'menuShown', false

  Actions.setWpm, (store, wpm) ->
    store.set 'wpm', payload.wpm

  Actions.increaseWpm, (store, wpm) ->
    store.updateIn ['wpm'], (x) ->
      x + payload.amount

  Actions.decreaseWpm, (store, wpm) ->
    store.updateIn ['wpm'], (x) ->
      x - payload.amount

  Actions.toggleSideMenu, (store) ->
    store = store.updateIn ['menuShown'], (x) -> !x
    store.set 'playing', false

  Actions.paraChange, (store) ->
    store.set 'para_change', true

  Actions.Derived.paraResume, (store) ->
    store.set 'para_change', false


module.exports = RsvpStatusStore

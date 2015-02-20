Bacon = require 'baconjs'

Actions = require('../Actions')
constants = require('../constants')
defaults = require('./defaults')


RsvpStatusStore = Bacon.update defaults.get('status'),

  Actions.pageChange, (store, {url}) ->
    store = store.set 'playing', false
    store.set 'menuShown', false

  Actions.pause, (store) ->
    store.set 'playing', false

  Actions.play, (store) ->
    store = store.set 'playing', true
    store.set 'menuShown', false

  # HACK: this should be done with stream composition or w/e
  Actions.togglePlayPause, (store, {source}) ->
    if store.get('playing')
      Actions.pause.push
        source: source
    else
      Actions.play.push
        source: source
    store

  Actions.setWpm, (store, {wpm}) ->
    store.set 'wpm', wpm

  Actions.increaseWpm, (store, {amount}) ->
    store.updateIn ['wpm'], (x) ->
      x + amount

  Actions.decreaseWpm, (store, {amount}) ->
    store.updateIn ['wpm'], (x) ->
      x - amount

  Actions.toggleSideMenu, (store) ->
    store = store.updateIn ['menuShown'], (x) -> !x
    store.set 'playing', false

  Actions.paraChange, (store) ->
    store.set 'para_change', true

  Actions.Derived.paraResume, (store) ->
    store.set 'para_change', false


module.exports = RsvpStatusStore

/* @flow */
import { createStore, applyMiddleware } from 'redux'
import createLogger from 'redux-logger'
import { handleActions } from 'redux-actions'
import * as Immutable from 'immutable'

import { saveWpm } from '../lib/chrome'

const DEBUG = false


// TODO: nesting.
const initialState = Immutable.fromJS({
  buttonShown: true,
  isPlaying: false,
  changingPara: false,

  currentWord: '',
  readingEdge: {
    left: 0,
  },

  wpm: 300,
  font: '32pt Georgia',

})


const actionHandlers = {

  playPause(state) {
    return state.update('isPlaying', (isPlaying) => !isPlaying)
  },
  pause(state) {
    return state.set('isPlaying', false)
  },
  play(state) {
    return state.set('isPlaying', true)
  },

  paraChange(state) {
    return state.set('changingPara', true)
  },
  paraResume(state) {
    return state.set('changingPara', false)
  },

  textHighlighted(state) {
    return state.set('buttonShown', true)
  },
  nothingHighlighted(state) {
    return state.set('buttonShown', false)
  },

  changeWord(state, { word }) {
    return state.set('currentWord', word)
  },
  setReadingEdge(state, { left }) {
    return state.setIn(['readingEdge', 'left'], left)
  },

  setWpm(state, { wpm }) {
    return state.set('wpm', saveWpm(wpm))
  },
  increaseWpm(state, { amount }) {
    return state.update('wpm', (wpm) => saveWpm(Math.min(3000, wpm + amount)))
  },
  decreaseWpm(state, { amount }) {
    return state.update('wpm', (wpm) => saveWpm(Math.max(50, wpm - amount)))
  },
}

function createSimpleAction(type) {
  return (payload) => Object.assign((payload || {}), { type })
}

// TODO: be less magical.
/**
 * automagically create simple actions
 * based on those defined in `handleActions`
 * (mutates the actions object)
 *
 * Usage:
 * store.actions.someAction({ payloadItem: val, })
 * results in:
 * store.dispatch({ type: 'someAction', payload: { payloadItem: val } })
 */
export function createActionsFromHandlers(ignoreKeys: Array<string> = []): Object {
  const actions = {}
  Object.keys(actionHandlers).forEach((key) => {
    if (ignoreKeys.includes(key)) return
    actions[key] = createSimpleAction(key)
  })
  return actions
}

const reducer = handleActions(actionHandlers, initialState)

const store = (() => {
  if (DEBUG) {
    const logger = createLogger({
      // print immutable as json
      transformer: (x) => (x.toJSON ? x.toJSON() : x),
    })
    const createStoreWithMiddleware = applyMiddleware(logger)(createStore)
    return createStoreWithMiddleware(reducer)
  }

  return createStore(reducer)
})()


export default store

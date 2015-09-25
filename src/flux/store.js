/* @flow */
import { createStore, applyMiddleware } from 'redux'
import createLogger from 'redux-logger'
import { createAction, handleActions } from 'redux-actions'
import Immutable from 'immutable'

import { saveWpm } from '../utils/chrome'


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


type State = Immutable.Map

const actionHandlers = {

  playPause: (state, {  }) =>
    state.update('isPlaying', (isPlaying) => !isPlaying )
  ,
  pause: (state, {  }) =>
    state.set('isPlaying', false)
  ,
  play: (state, {  }) =>
    state.set('isPlaying', true)
  ,

  paraChange: (state, {  }) =>
    state.set('changingPara', true)
  ,
  paraResume: (state, {  }) =>
    state.set('changingPara', false)
  ,

  textHighlighted: (state, {  }) =>
    state.set('buttonShown', true)
  ,
  nothingHighlighted: (state, {  }) =>
    state.set('buttonShown', false)
  ,

  changeWord: (state, { word }) =>
    state.set('currentWord', word)
  ,
  setReadingEdge: (state, { left }) =>
    state.setIn(['readingEdge', 'left'], left)
  ,

  setWpm: (state, { wpm }) =>
    state.set('wpm', saveWpm(wpm))
  ,
  increaseWpm: (state, { amount }) =>
    state.update('wpm', (wpm) => saveWpm(Math.min(3000, wpm + amount)))
  ,
  decreaseWpm: (state, { amount }) =>
    state.update('wpm', (wpm) => saveWpm(Math.max(50, wpm - amount)))
  ,
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
export function createActions(ignoreKeys: Array<string> = []): Object {
  let actions = {}
  Object.keys(actionHandlers).forEach( (key) => {
    if ( ignoreKeys.includes(key) ) { return }
    const action = createSimpleAction(key)
    actions[key] = (payload) =>
      store.dispatch(action(payload))
  })
  return actions
}

const reducer = handleActions(actionHandlers, initialState)

const logger = createLogger({
  // print immutable as json
  transformer: (x) => ( x.toJSON ? x.toJSON() : x )
})
const createStoreWithMiddleware = applyMiddleware(logger)(createStore)
// const store = createStoreWithMiddleware(reducer)
const store = createStore(reducer)

store.actions = createActions()

export default store

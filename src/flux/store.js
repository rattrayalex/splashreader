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

const actionHandlers = {

  playPause: (state, { payload }) =>
    state.update('isPlaying', (isPlaying) => !isPlaying )
  ,
  pause: (state, { payload }) =>
    state.set('isPlaying', false)
  ,
  play: (state, { payload }) =>
    state.set('isPlaying', true)
  ,

  paraChange: (state, { payload }) =>
    state.set('changingPara', true)
  ,
  paraResume: (state, { payload }) =>
    state.set('changingPara', false)
  ,

  textHighlighted: (state, { payload }) =>
    state.set('buttonShown', true)
  ,
  nothingHighlighted: (state, { payload }) =>
    state.set('buttonShown', false)
  ,

  changeWord: (state, { payload }) =>
    state.set('currentWord', payload.word)
  ,
  setReadingEdge: (state, { payload }) =>
    state.set('readingEdge', Immutable.fromJS(payload))
  ,

  setWpm: (state, { payload }) =>
    state.set('wpm', saveWpm(payload.wpm))
  ,
  increaseWpm: (state, { payload }) =>
    state.update('wpm', (wpm) => saveWpm(Math.min(3000, wpm + payload.amount)))
  ,
  decreaseWpm: (state, { payload }) =>
    state.update('wpm', (wpm) => saveWpm(Math.max(50, wpm - payload.amount)))
  ,
}

const reducer = handleActions(actionHandlers, initialState)

const logger = createLogger({
  // print immutable as json
  transformer: (x) => ( x.toJSON ? x.toJSON() : x )
})
const createStoreWithMiddleware = applyMiddleware(logger)(createStore)
// const store = createStoreWithMiddleware(reducer)
const store = createStore(reducer)


// be automagic about creating actions
// b/c they're all so simple...
// TODO: be less magical.
//
// Usage:
// store.actions.someAction({ payloadItem: val, })
// results in:
// store.dispatch({ type: 'someAction', payload: { payloadItem: val } })
store.actions = {}
Object.keys(actionHandlers).forEach( (key) => {
  const action = createAction(key)
  store.actions[key] = (payload) =>
    store.dispatch(action(payload))
})

export default store

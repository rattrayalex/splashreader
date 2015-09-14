import { createStore } from 'redux'
import { createAction, handleActions } from 'redux-actions'
import Immutable from 'immutable'


const initialState = Immutable.fromJS({
  buttonShown: true,
  isPlaying: false,
  currentWord: '',
  wpm: 300,
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
  wordSelected: (state, { payload }) =>
    state.set('buttonShown', true)
  ,
  wordDeselected: (state, { payload }) =>
    state.set('buttonShown', false)
  ,
  changeWord: (state, { payload }) =>
    state.set('currentWord', payload.word)
  ,
  setWpm: (state, { payload }) =>
    state.set('wpm', payload.wpm)
  ,
  increaseWpm: (state, { payload }) =>
    state.update('wpm', (wpm) => Math.min(3000, wpm + payload.amount))
  ,
  decreaseWpm: (state, { payload }) =>
    state.update('wpm', (wpm) => Math.max(0, wpm - payload.amount))
  ,
}

const reducer = handleActions(actionHandlers, initialState)

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

import { createStore } from 'redux'
import { createAction, handleActions } from 'redux-actions'
import Immutable from 'immutable'


const initialState = Immutable.Map({
  buttonShown: true,
  isPlaying: false,
})

const actionHandlers = {

  playPause: (state, { payload }) =>
    state.update('isPlaying', (isPlaying) => !isPlaying )
  ,
  wordSelected: (state, { payload }) =>
    state.set('buttonShown', true)
  ,
  wordDeselected: (state, { payload }) =>
    state.set('buttonShown', false)
  ,

}

const reducer = handleActions(actionHandlers, initialState)

const store = createStore(reducer)


// be automagic about creating actions
// b/c they're all so simple...
// TODO: be less magical.
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

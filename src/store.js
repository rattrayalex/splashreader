import { createStore } from 'redux'
import Immutable from 'immutable'

import actions from './actions'

const initialState = Immutable.Map({
  buttonShown: true,
  isPlaying: false,
})


const store = createStore( (state=initialState, action) => {
  switch (action.type) {

    case actions.WORD_SELECTED:
      return state.set('buttonShown', true)
    case actions.WORD_DESELECTED:
      return state.set('buttonShown', false)

    case actions.PLAY_PAUSE:
      return state.update('isPlaying', (isPlaying) => !isPlaying )

    default:
      return state
  }
  return state
})

export default store

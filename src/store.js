import { createStore } from 'redux'
import Immutable from 'immutable-js'

const initialState = Immutable.Map({
  paraSelected: false,
})

const store = createStore( (state=initialState, action) => {
  switch (action.type) {
    case 'PARA_SELECTED':
      return state.set('paraSelected', true)
    case 'PARA_DESELECTED':
      return state.set('paraSelected', false)
    default:
      return state
  }
  return state
})

export default store

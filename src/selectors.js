import { createSelector } from 'reselect'

// overcomplicated for sake of practice
export const paraSelected = createSelector(
  [state => state.get('buttonShown')],
  (buttonShown) => ( { buttonShown } )
)

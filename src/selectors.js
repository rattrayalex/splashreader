import { createSelector } from 'reselect'

export const currentWordSelector = createSelector(
  [state => state.get('currentWord')],
  (currentWord) => currentWord
)

export const isPlayingSelector = createSelector(
  [state => state.get('isPlaying')],
  (isPlaying) => isPlaying
)

export const buttonShownSelector = createSelector(
  [state => state.get('buttonShown')],
  (buttonShown) => buttonShown
)

// overcomplicated for sake of practice
export const allSelector = createSelector(
  [
    buttonShownSelector,
    isPlayingSelector,
    currentWordSelector,
  ],
  (buttonShown, isPlaying, currentWord) =>
    ( { buttonShown, isPlaying, currentWord } )
)

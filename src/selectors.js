import { createSelector } from 'reselect'


export const buttonShownSelector = state => state.get('buttonShown')
export const isPlayingSelector = state => state.get('isPlaying')
export const currentWordSelector = state => state.get('currentWord')
export const wpmSelector = state => state.get('wpm')

export const allSelector = createSelector(
  [
    buttonShownSelector,
    isPlayingSelector,
    currentWordSelector,
    wpmSelector,
  ],
  (buttonShown, isPlaying, currentWord, wpm) =>
    ( { buttonShown, isPlaying, currentWord, wpm } )
)

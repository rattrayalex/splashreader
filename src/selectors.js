import { createSelector } from 'reselect'


export const buttonShownSelector = state => state.get('buttonShown')
export const isPlayingSelector = state => state.get('isPlaying')
export const changingParaSelector = state => state.get('changingPara')
export const currentWordSelector = state => state.get('currentWord')
export const wpmSelector = state => state.get('wpm')

export const rsvpPlayingSelector = createSelector(
  [
    isPlayingSelector,
    changingParaSelector,
  ],
  (isPlaying, changingPara) => (
    isPlaying && !changingPara
  )
)

export const allSelector = createSelector(
  [
    buttonShownSelector,
    isPlayingSelector,
    currentWordSelector,
    wpmSelector,
    rsvpPlayingSelector,
  ],
  (buttonShown, isPlaying, currentWord, wpm, rsvpPlaying) =>
    ( { buttonShown, isPlaying, currentWord, wpm, rsvpPlaying} )
)

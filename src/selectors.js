import { createSelector } from 'reselect'

import { getTextWidth } from './rsvp_utils'

// TODO: cleanup / nest / break up

export const buttonShownSelector = state => state.get('buttonShown')
export const isPlayingSelector = state => state.get('isPlaying')
export const changingParaSelector = state => state.get('changingPara')

export const currentWordSelector = state => state.get('currentWord')
export const readingEdgeLeftSelector = state =>
  state.get('readingEdge').get('left')

export const wpmSelector = state => state.get('wpm')
export const fontSelector = state => state.get('font')

export const rsvpPlayingSelector = createSelector(
  [
    isPlayingSelector,
    changingParaSelector,
  ],
  (isPlaying, changingPara) => (
    isPlaying && !changingPara
  )
)

export const orpCenterSelector = createSelector(
  [
    readingEdgeLeftSelector,
    fontSelector,
  ],
  (left, font) =>
    Math.max(
      // five em's wide b/c that's how big
      // the left+middle parts of a word
      // in the RSVP display can be. (m is typically widest letter)
      getTextWidth('mmmmm', font),
      left
    )
)

export const allSelector = createSelector(
  [
    buttonShownSelector,
    isPlayingSelector,
    currentWordSelector,
    orpCenterSelector,
    wpmSelector,
    fontSelector,
    rsvpPlayingSelector,
  ],
  (buttonShown, isPlaying, currentWord, orpCenter, wpm, font, rsvpPlaying) =>
    ( { buttonShown, isPlaying, currentWord, orpCenter, wpm, font, rsvpPlaying, } )
)

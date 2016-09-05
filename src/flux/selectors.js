/* @flow */
import * as Immutable from 'immutable'
import { createSelector } from 'reselect'

import { getTextWidth } from '../lib/rsvp'


// TODO: real definition
type State = Immutable.Map<string, any>


// TODO: cleanup / nest / break up
export const buttonShownSelector = (state: State): boolean =>
  state.get('buttonShown')
export const isPlayingSelector = (state: State): boolean =>
  state.get('isPlaying')
export const changingParaSelector = (state: State): boolean =>
  state.get('changingPara')

export const currentWordSelector = (state: State): ?string =>
  state.get('currentWord')
export const readingEdgeLeftSelector = (state: State): number =>
  state.get('readingEdge').get('left')

export const wpmSelector = (state: State): number =>
  state.get('wpm')
export const fontSelector = (state: State): string =>
  state.get('font')

export const rsvpPlayingSelector = createSelector(
  [isPlayingSelector, changingParaSelector],
  (isPlaying, changingPara) => (isPlaying && !changingPara)
)

export const orpCenterSelector = createSelector(
  [readingEdgeLeftSelector, fontSelector],
  (left, font) =>
    Math.max(
      // five em's wide b/c that's how big
      // the left+middle parts of a word
      // in the RSVP display can be. (m is typically widest letter)
      getTextWidth('mmmmm', font),
      left
    )
)

// TODO cleanup
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
    ({ buttonShown,
      isPlaying,
      currentWord,
      orpCenter,
      wpm,
      font,
      rsvpPlaying,
    })
)

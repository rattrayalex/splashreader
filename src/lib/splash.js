import rangy from 'rangy/lib/rangy-textrange'

import store from '../flux/store'
import actions from '../flux/actions'
import {
  isPlayingSelector,
  wpmSelector,
  changingParaSelector,
} from '../flux/selectors'
import * as rsvp from './rsvp'
import * as dom from './dom'
import * as chrome from './chrome'
import * as ranges from './ranges'
import { wordOptions } from '../constants'


export const loadWpmFromChrome = async () => {
  const wpm = await chrome.loadWpm()
  if (wpm && wpm > 0) {
    store.dispatch(actions.setWpm({ wpm }))
  }
}

function getRangeIfSelected() {
  const sel = rangy.getSelection()
  if (sel.rangeCount < 1) return null

  const range = sel.getRangeAt(0)

  if (!range) return null
  if (!ranges.isTextHighlighted(sel)) return null

  return range
}

export const setReadingPointAt = async (range) => {
  await dom.scrollToElementOnce(range.nativeRange)
  const left = dom.getLeftEdge(range.endContainer.parentNode)
  store.dispatch(actions.setReadingEdge({ left }))
}

// TODO: clean up
let playTimeout: ?number = null
const splash = async (rangeArg = null) => {
  if (!isPlayingSelector(store.getState())) return
  // prevent double-play.
  window.clearTimeout(playTimeout)

  const range = rangeArg || getRangeIfSelected()

  // bail if nothing is selected
  if (!range) {
    // TODO: consider trying to find and select the first word in the doc
    store.dispatch(actions.pause())
    return
  }

  // resume RSVP if in a new (non-header) paragrah.
  // Otherwise, move to next word.
  // (results, intentionally, in first-words-of-paragraph
  // being dispayed twice: first without RSVP, and then with RSVP)
  const isChangingPara = changingParaSelector(store.getState())
  const isInHeading = dom.looksLikeAHeading(range.endContainer.parentElement)
  const justPressedPlay = !rangeArg
  let isNewPara = false
  if (isChangingPara && !isInHeading) {
    store.dispatch(actions.paraResume())
  } else {
    if (justPressedPlay) {
      range.move('word', -1, wordOptions)
    }
    isNewPara = ranges.moveToNextWord(range)
  }

  // highlight it
  range.select()

  // send it to React
  const word = range.text()
  store.dispatch(actions.changeWord({ word }))

  // scroll if we're not there yet.
  if (justPressedPlay || isChangingPara) {
    await setReadingPointAt(range)
  }

  // move to the next word in a sec
  const wpm = wpmSelector(store.getState())
  let timeToDisplay = rsvp.getTimeToDisplay(word, wpm)

  // pause RSVP at paragraph change
  if (isNewPara) {
    store.dispatch(actions.paraChange())
    if (!justPressedPlay) {
      timeToDisplay = 1000
      await setReadingPointAt(range)
    }
  }

  playTimeout = setTimeout(
    splash.bind(null, range),
    timeToDisplay
  )
}
export default splash

export const listenForPlay = () => {
  let isPlaying = false
  let wasPlaying = false

  store.subscribe(async () => {
    // TODO: clean up / document better...
    wasPlaying = isPlaying
    isPlaying = isPlayingSelector(store.getState())

    if (isPlaying && !wasPlaying) {
      await splash()
    } else if (wasPlaying && !isPlaying) {
      // scroll on pause
      ranges.scrollToHighlightedText()
    }
  })
}

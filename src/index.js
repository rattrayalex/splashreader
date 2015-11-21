/* @flow */
import 'babel-core/polyfill' // for Object.assign, etc... used throughout.

import React from 'react'
import { Provider } from 'react-redux'
import rangy from 'rangy/lib/rangy-textrange'

import store from './flux/store'
import actions from './flux/actions'
import {
  isPlayingSelector,
  wpmSelector,
  changingParaSelector,
} from './flux/selectors'
import SplashApp from './components/SplashApp'
import * as rsvp from './utils/rsvp'
import * as dom from './utils/dom'
import * as chrome from './utils/chrome'
import * as ranges from './utils/ranges'
import * as events from './utils/events'
import { word_options } from './constants'

window.rangy = rangy


async function loadWpmFromChrome() {
  let wpm = await chrome.loadWpm()
  if ( wpm && wpm > 0 ) {
    store.dispatch(actions.setWpm({ wpm }))
  }
}

function listenForPlay() {
  let is_playing = false
  let was_playing = false

  store.subscribe(() => {
    // TODO: clean up / document better...
    was_playing = is_playing
    is_playing = isPlayingSelector(store.getState())

    if ( is_playing && !was_playing ) {
      splash()
    } else if ( was_playing && !is_playing ) {
      // scroll on pause
      ranges.scrollToHighlightedText()
    }

  })
}

async function setReadingPointAt(range) {
  await dom.scrollToElementOnce(range.nativeRange)
  const left = dom.getLeftEdge(range.endContainer.parentNode)
  store.dispatch(actions.setReadingEdge({ left }))
}

// TODO: clean up
let play_timeout: ?number = null
async function splash(range=null) {
  if ( !isPlayingSelector(store.getState()) ) {
    return
  }
  // prevent double-play.
  window.clearTimeout(play_timeout)

  const just_pressed_play = ( range ? false : true )

  // initialize
  if ( range === null ) {
    let sel = rangy.getSelection()
    range = sel.getRangeAt(0)

    // bail if nothing is selected
    if ( range === null || !ranges.isTextHighlighted(sel) ) {
      return store.dispatch(actions.pause())
    }
  }

  // resume RSVP if in a new (non-header) paragrah.
  // Otherwise, move to next word.
  // (results, intentionally, in first-words-of-paragraph
  // being dispayed twice: first without RSVP, and then with RSVP)
  const is_changing_para = changingParaSelector(store.getState())
  const is_in_heading = rsvp.looksLikeAHeading(range.endContainer.parentElement)
  let is_new_para = false
  if ( is_changing_para && !is_in_heading ) {
    store.dispatch(actions.paraResume())
  } else {
    if ( just_pressed_play ) {
      range.move('word', -1, word_options)
    }
    is_new_para = ranges.moveToNextWord(range)
  }

  // highlight it
  range.select()

  // send it to React
  const word = range.text()
  store.dispatch(actions.changeWord({ word }))

  // scroll if we're not there yet.
  if ( just_pressed_play || is_changing_para ) {
    await setReadingPointAt(range)
  }

  // move to the next word in a sec
  const wpm = wpmSelector(store.getState())
  let time_to_display = rsvp.getTimeToDisplay(word, wpm)

  // pause RSVP at paragraph change
  if ( is_new_para ) {
    store.dispatch(actions.paraChange())
    if ( !just_pressed_play ) {
      time_to_display = 1000
      await setReadingPointAt(range)
    }
  }

  play_timeout = setTimeout(
    splash.bind(null, range),
    time_to_display
  )
}

/** annoyingly, rangy doesn't work for a bit sometimes... */
async function waitForRangy() {
  return await new Promise((resolve) => {
    let checker = () => {
      if (typeof rangy.getSelection === 'function') {
        resolve()
      } else {
        setTimeout(checker, 100)
      }
    }
    checker()
  })
}


async function init() {
  await waitForRangy()

  let wrapper = dom.insertWrapper()

  loadWpmFromChrome()
  listenForPlay()
  events.listenForSpace()

  React.render(
    <Provider store={store}>
      {() => <SplashApp />}
    </Provider>,
    wrapper
  )
}

init()

import 'babel-core/polyfill' // for Object.assign
import key from 'keymaster'
import React from 'react'
import { Provider } from 'react-redux'
import rangy from 'rangy/lib/rangy-textrange'

window.rangy = rangy

import store from './store'
import {
  isPlayingSelector,
  wpmSelector,
  changingParaSelector
} from './selectors'
import SplashApp from './SplashApp'
import { getTimeToDisplay, looksLikeAHeading } from './rsvp_utils'
import {
  scrollToElementOnce,
  getReadingEdgeLeft,
  isTextHighlighted,
  isEditableFocused,
} from './dom_utils'
import { loadWpm } from './chromeSync'

// TODO: move elsewhere...
const word_options = {
  wordOptions: {
    wordRegex: /[^–—\s]+/gi
  }
}

function _containsNewline(range) {
  return !!range.text().match(/[\n\r]/)
}

class SplashReader {
  constructor() {
    // local vars for ::listenForPlay...
    // TODO: reconsider
    this.is_playing = false
    this.was_playing = false

    this.play_timeout = null

    this.wrapper = this.insertWrapper()

    this.loadWpmFromChrome()
    this.listenForPlay()
    this.listenForWordHighlight()
    this.listenForEsc()

    React.render(
      <Provider store={store}>
        {() => <SplashApp />}
      </Provider>,
      this.wrapper
    )
    return this
  }

  insertWrapper() {
    const wrapper = document.createElement('div')
    wrapper.setAttribute('id', 'splashreader-wrapper')
    document.body.appendChild(wrapper)
    return wrapper
  }

  loadWpmFromChrome() {
    loadWpm( ({ wpm }) => {
      wpm = parseInt(wpm)
      if ( wpm ) {
        store.actions.setWpm({ wpm })
      }
    })
  }

  listenForWordHighlight() {
    this.unListenForWordHighlight()
    document.addEventListener(
      'selectionchange',
      this.listenForSpace.bind(this)
    )
  }
  unListenForWordHighlight() {
    document.removeEventListener(
      'selectionchange',
      this.listenForSpace.bind(this)
    )
  }
  listenForSpace() {
    this.unListenForSpace()
    if ( isTextHighlighted() && !isEditableFocused() ) {
      store.actions.textHighlighted()
      key('space', (e) => {
        e.preventDefault()
        store.actions.playPause()
      })
    } else {
      store.actions.nothingHighlighted()
    }
  }
  unListenForSpace() {
    key.unbind('space')
  }
  listenForEsc() {
    this.unListenForEsc()
    key('esc', (e) => {
      store.actions.pause()
    })
  }
  unListenForEsc() {
    key.unbind('esc')
  }

  listenForPlay() {
    store.subscribe(() => {
      // TODO: clean up / document better...
      this.was_playing = this.is_playing
      this.is_playing = isPlayingSelector(store.getState())

      if ( this.is_playing && !this.was_playing ) {
        this.splash()
      }

    })
  }

  setReadingPointAt(range) {
    scrollToElementOnce(range.endContainer.parentNode)
    const left = getReadingEdgeLeft(range.endContainer.parentNode)
    store.actions.setReadingEdge({ left })
  }

  // TODO: move elsewhere
  // TODO: clean up
  splash(range=null) {
    if ( !isPlayingSelector(store.getState()) ) {
      return
    }
    // prevent double-play.
    window.clearTimeout(this.play_timeout)

    let sel = rangy.getSelection()
    const just_pressed_play = ( range ? false : true )

    // initialize
    if ( !range ) {
      range = sel.getRangeAt(0)
      range.move('word', -1, word_options)
    }

    // resume RSVP if in a new (non-header) paragrah.
    // Otherwise, move to next word.
    // (results, intentionally, in first-words-of-paragraph
    // being dispayed twice: first without RSVP, and then with RSVP)
    const is_changing_para = changingParaSelector(store.getState())
    const is_in_heading = looksLikeAHeading(range.endContainer.parentElement)
    let is_new_para = false
    if ( is_changing_para && !is_in_heading ) {
      store.actions.paraResume()
    } else {
      // set range to next word
      range.moveStart('word', 1, word_options)
      range.moveEnd('word', 1, word_options)
      is_new_para = _containsNewline(range) ? true : false
      range.expand('word', Object.assign(word_options, {
        trim: true  // removes whitespace, newlines, etc.
      }))
    }

    // scroll if we're not there yet.
    if ( just_pressed_play ) {
      this.setReadingPointAt(range)
    }

    // highlight it
    sel.setSingleRange(range)

    // send it to React
    const word = range.text()
    store.actions.changeWord({ word })

    // move to the next word in a sec
    const wpm = wpmSelector(store.getState())
    let time_to_display = getTimeToDisplay(word, wpm)

    // pause RSVP at paragraph change
    if ( is_new_para ) {
      if ( !just_pressed_play ) {
        time_to_display = 1000
        this.setReadingPointAt(range)
      }
      store.actions.paraChange()
    }

    this.play_timeout = setTimeout(
      this.splash.bind(this, range),
      time_to_display
    )
  }
}


const Reader = new SplashReader()

import "babel-core/polyfill" // for Object.assign
import key from 'keymaster'
import React from 'react'
import { Provider } from 'react-redux'

import rangy from 'rangy/lib/rangy-textrange'

import store from './store'
import { isPlayingSelector, wpmSelector } from './selectors'
import SplashApp from './SplashApp'
import { getTimeToDisplay } from './rsvp_utils'

// TODO: move elsewhere...
const word_options = {
  wordOptions: {
    wordRegex: /[^–—\s]+/gi
  }
}


class SplashReader {
  constructor() {
    // local vars for ::listenForPlay...
    // TODO: reconsider
    this.is_playing = false
    this.was_playing = false

    this.wrapper = this.insertWrapper()

    this.listenForSpace()
    this.listenForPlay()

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
  listenForSpace() {
    key('space', (e) => {
      e.preventDefault()
      store.actions.playPause()
      return false
    })
    key('esc', (e) => {
      e.preventDefault()
      store.actions.pause()
      return false
    })
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
  // TODO: move elsewhere
  splash(range=null) {
    if ( !isPlayingSelector(store.getState()) ) {
      return
    }

    let sel = rangy.getSelection()

    // initialize
    if ( !range ) {
      range = sel.getRangeAt(0)
      range.move("word", -1, word_options)
    }

    // set range to next word
    range.moveStart("word", 1, word_options)
    range.moveEnd("word", 1, word_options)
    range.expand('word', Object.assign(word_options, {
      trim: true
    }))

    // highlight it
    sel.setSingleRange(range)

    // send it to React
    const word = range.text()
    store.actions.changeWord({ word })

    // move to the next word in a sec
    const wpm = wpmSelector(store.getState())
    setTimeout(
      this.splash.bind(this, range),
      getTimeToDisplay(word, wpm)
    )
  }
}


const Reader = new SplashReader()

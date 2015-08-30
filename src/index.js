import "babel-core/polyfill" // for Object.assign
import key from 'keymaster'
import React from 'react'
import { Provider } from 'react-redux'

import rangy from 'rangy/lib/rangy-textrange'

import store from './store'
import SplashButton from './SplashButton'

// TODO: move elsewhere...
// const word_regex = /[a-z0-9]+('[a-z0-9]+)*/gi
const word_options = {
  wordOptions: {
    wordRegex: /[^–—\s]+/gi
    // this is really a phrase...
    // TODO: investigate this idea...
    // wordRegex: /.+(?:\s+['"“\[(]|[.,!?'"”:;\])]\s+|–|—|\r|\n)/gi
  }
}


class SplashReader {
  constructor() {
    this.wrapper = this.insertWrapper()

    this.listenForSpace()
    this.listenForPlay()

    React.render(
      <Provider store={store}>
        {() => <SplashButton />}
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
  }
  listenForPlay() {
    store.subscribe(this.splash.bind(this, null))
  }
  // TODO: move elsewhere
  splash(range=null) {
    if ( !store.getState().get('isPlaying') ) {
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

    setTimeout(this.splash.bind(this, range), 500)
  }
}


const Reader = new SplashReader()

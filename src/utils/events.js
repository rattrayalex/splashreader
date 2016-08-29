/* @flow */
import key from 'keymaster'

import store from '../flux/store'
import actions from '../flux/actions'
import * as dom from './dom'
import * as ranges from './ranges'


export function readingHighlighted(): boolean {
  return (ranges.isTextHighlighted() && !dom.isNonSplashEditableFocused())
}

export function listenForSpace() {
  unListenForSpace()
  key('space', (e) => {
    e.preventDefault()
    store.dispatch(actions.playPause())
    return false
  })
}

export function unListenForSpace() {
  key.unbind('space')
}

export function listenForEsc() {
  unListenForEsc()
  key('esc', () => {
    store.dispatch(actions.pause())
  })
}

export function unListenForEsc() {
  key.unbind('esc')
}

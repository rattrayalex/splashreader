import key from 'keymaster'

import store from '../flux/store'
import * as dom from './dom'
import * as ranges from './ranges'

export function listenForWordHighlight() {
  unListenForWordHighlight()
  document.addEventListener(
    'selectionchange',
    listenForSpace
  )
}

export function unListenForWordHighlight() {
  document.removeEventListener(
    'selectionchange',
    listenForSpace
  )
}

export function listenForSpace() {
  unListenForSpace()
  if ( ranges.isTextHighlighted() && !dom.isEditableFocused() ) {
    store.actions.textHighlighted()
    key('space', (e) => {
      e.preventDefault()
      store.actions.playPause()
      return false
    })
  } else {
    store.actions.nothingHighlighted()
  }
}

export function unListenForSpace() {
  key.unbind('space')
}

export function listenForEsc() {
  unListenForEsc()
  key('esc', (e) => {
    store.actions.pause()
  })
}

export function unListenForEsc() {
  key.unbind('esc')
}
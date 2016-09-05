/* @flow */

import rangy from 'rangy/lib/rangy-textrange'
import { wordOptions } from '../constants'
import { scrollToElementOnce } from './dom'

// TODO: get types for real
type RangyRange = any
type RangyWrappedSelection = {
  rangeCount: number,
  getRangeAt: (i: number) => RangyRange,
}


/* annoyingly, rangy doesn't work for a bit sometimes... */
export async function waitForRangy() {
  return await new Promise((resolve) => {
    const checker = () => {
      if (typeof rangy.getSelection === 'function') {
        resolve()
      } else {
        setTimeout(checker, 100)
      }
    }
    checker()
  })
}


export function scrollToHighlightedText(): void {
  const sel = rangy.getSelection()
  if (isTextHighlighted(sel)) {
    const range = sel.getRangeAt(0)
    scrollToElementOnce(range.nativeRange)
  }
}


/**
 * Whether the user has highlighted text.
 */
export function isTextHighlighted(selArg: ?RangyWrappedSelection = null): boolean {
  const sel = selArg || rangy.getSelection()
  if (!sel) return false
  if (sel.rangeCount !== 1) return false

  return (sel.getRangeAt(0).text().trim().length > 0)
}


/**
 * Moves the range to the next word,
 * without including intervening block elements,
 * and returns whether a new paragraph has been entered.
 */
export function moveToNextWord(range: RangyRange): boolean {
  // set range to next word
  range.moveStart('word', 1, wordOptions)
  range.moveEnd('word', 1, wordOptions)

  const isNewPara = containsNewline(range)

  // removes whitespace, newlines, etc.
  range.collapse(false)  // collapse to end of word
  range.moveStart('word', -1, wordOptions)
  range.expand('word', Object.assign({}, wordOptions, { trim: true }))

  return isNewPara
}


/**
 * currently unused.
 */
export function isSingleWordHighlighted(): boolean {
  const sel = rangy.getSelection()

  if (sel.rangeCount < 1) {
    return false
  }

  const range = sel.getRangeAt(0)
  const text = range.text()

  // TODO: improve accuracy... this is simple/dumb
  if (!text.match(/\s/)) {
    return true
  }

  return false
}


function containsNewline(range) {
  return !!range.text().match(/[\n\r]/)
}

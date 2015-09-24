import rangy from 'rangy/lib/rangy-textrange'
import { word_options } from '../constants'

/**
 * Whether the user has highlighted text.
 * @return {Boolean}
 */
export function isTextHighlighted() {
  return (
    rangy.getSelection().rangeCount === 1
    &&
    rangy.getSelection().getRangeAt(0).text().trim().length
  )
}

/**
 * Moves the range to the next word,
 * without including intervening block elements,
 * and returns whether a new paragraph has been entered.
 *
 * @param  {Rangy Range} range
 * @return {Boolean}
 *         whether the next word is in a new paragraph
 */
export function moveToNextWord(range) {

  // set range to next word
  range.moveStart('word', 1, word_options)
  range.moveEnd('word', 1, word_options)

  let is_new_para = _containsNewline(range)

  // removes whitespace, newlines, etc.
  range.collapse(false)  // collapse to end of word
  range.moveStart('word', -1, word_options)
  range.expand('word', Object.assign(word_options, { trim: true }))

  return is_new_para
}

/**
 * currently unused.
 * @return {Boolean}
 */
export function isSingleWordHighlighted() {
  const sel = rangy.getSelection()

  if ( sel.rangeCount < 1 ) {
    return false
  }

  let range = sel.getRangeAt(0)
  let text = range.text()

  // TODO: improve accuracy... this is simple/dumb
  if ( !text.match(/\s/) ) {
    return true
  }

  return false
}

function _containsNewline(range) {
  return !!range.text().match(/[\n\r]/)
}
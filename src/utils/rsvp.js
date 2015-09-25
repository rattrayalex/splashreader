/* @flow */

/**
 * modifies the length of time a word should be displayed
 * on the basis of how hard to read it is.
 * TODO: refine this model!
 *
 * @param  {string} word
 * @return {int}      how much longer than normal to display the word
 */
export function getDisplayMultiplier(word: string): number {
  word = word.trim()
  let display = 1

  if ( !word ) {
    return display
  }

  if ( word.length > 8 ) {
    display *= 1.4
  }

  // Double up on words with numbers, symbols, or punctuation!
  if ( word.match(/[^a-zA-Z]/) ) {
    display *= 1.4
  }

  // Triple up on words that have a number.
  if ( word.match(/[0-9]/) ) {
    display *= 1.8
  }

  // triple up on words that end with one of: . ! ? : ) ]
  if ( word.slice(-1).match(/\.|\!|\?|:|\)|\]/) ) {
    display *= 1.8
  }

  return display
}

export function msPerWord(wpm: number): number {
  return ( 60000 / wpm )
}

/**
 * given a target word-per-minute,
 * tells you how long to display a given word,
 * adjusted for how complicated the word is.
 *
 * @param  {string} word
 * @param  {int} wpm
 * @return {int}
 *         milliseconds to display word
 */
export function getTimeToDisplay(word: string, wpm: number): number {
  return ( msPerWord(wpm) * getDisplayMultiplier(word) )
}


/**
 *  gets the "middle" of the word, where the red letter goes
 *  from https://github.com/Miserlou/Glance/blob/master/spritz.js#L190
 *  ... this may need refining, returns different results from eg; squirt.io

 * @param  {int} length
 *         the length of the word
 * @return {int}
 *         the index of the "middle" of the word
 */
export function getWordMiddle(length: number): number {
  // TODO: figure out how to make JavaScript a less gross language.
  if ( length === 1 ) {
    return 1
  }
  if ( length < 5 ) {
    return 2
  }
  if ( length < 9 ) {
    return 3
  }
  if ( length < 13 ) {
    return 4
  }
  return 5
}

type SplitWord = {
  word_p1: string,
  word_p2: string,
  word_p3: string,
}

export function splitWord(word: string): SplitWord {

  word = word.trim() || ' '

  let middle = getWordMiddle(word.length)

  let word_p1 = word.slice(0, (middle - 1))
  let word_p2 = word.slice(middle - 1, middle)
  let word_p3 = word.slice(middle) || ' '

  return { word_p1, word_p2, word_p3 }
}

/**
  Uses canvas.measureText to compute and return the width
  of the given text of given font in pixels.

  @param {String} text
    The text to be rendered.
  @param {String} font
    The css font descriptor that text is to be rendered with
    (e.g. "bold 14px verdana").
  @see http://stackoverflow.com/a/21015393/1048433
*/
// re-use canvas object for better performance
const _canvas = document.createElement("canvas")
export function getTextWidth(text: string, font: string): number {

  if ( !(_canvas instanceof HTMLCanvasElement) ) { return 0 } // for flow
  const context = _canvas.getContext("2d")
  context.font = font

  const metrics = context.measureText(text)

  return metrics.width
}

/**
 * crawls up the DOM tree
 * to find the nearest `display: block` element
 * (including the passed-in element)
 *
 * @param  {Element} elem
 * @return {element}
 */
export function getClosestBlockElement(elem: Element): Element {
  if ( window.getComputedStyle(elem).display === 'block' ) {
    return elem
  }
  if ( !elem.parentElement ) {
    // if it's spans all the way up for some reason, just return the top one.
    return elem
  }
  return getClosestBlockElement(elem.parentElement)
}

/**
 * tries to detect whether the given element
 * is inside a block element
 * that is only a single line of text high.
 * Doesn't always work.
 * TODO: improve accuracy
 *
 * @param  {Element}  elem
 * @return {Boolean}
 */
export function isSingleLine(elem: Element): boolean {
  const elem_height: number = elem.clientHeight
  const line_height = parseInt(window.getComputedStyle(elem).lineHeight)
  // direct comparison didn't work,
  // so just check if it's at least smaller than two lines tall...
  return ( elem_height < ( line_height * 2) )
}

/**
 * Does an okay (not perfect) job
 * of telling you whether an element is bold or italic
 *
 * @param  {Element}  elem
 * @return {Boolean}
 */
export function isBoldOrItalic(elem: Element): boolean {
  let { fontWeight, fontStyle } = window.getComputedStyle(elem)
  return (
    fontWeight === 'bold'
    ||
    fontWeight === 'bolder'
    ||
    fontStyle === 'italic'
    ||
    fontStyle === 'oblique'
  )
}


/**
 * @param  {Element} elem
 * @return {Boolean}
 */
export function elementContainsASingleWord(elem: Element): boolean {
  if ( !elem.innerText ) {
    return false
  }
  return ( elem.innerText.split(/\s/).length === 1 )
}


const heading_elems = [
  'H1', 'H2', 'H3', 'H4', 'H5', 'H6',
  'DT',
]
/**
 * tries to guess at whether an element
 * is a heading...
 *
 * @param  {Element} elem
 * @return {Boolean}
 */
export function looksLikeAHeading(elem: Element): boolean {
  elem = getClosestBlockElement(elem)

  if ( elementContainsASingleWord(elem) ) {
    return true
  }

  return (
    (
      heading_elems.includes(elem.nodeName)
      ||
      isBoldOrItalic(elem)
    )
    &&
    isSingleLine(elem)
  )
}

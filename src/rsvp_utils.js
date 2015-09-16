
/**
 * modifies the length of time a word should be displayed
 * on the basis of how hard to read it is.
 * TODO: refine this model!
 *
 * @param  {string} word
 * @return {int}      how much longer than normal to display the word
 */
export function getDisplayMultiplier(word) {
  word = word.trim()
  let display = 1

  if ( !word ) {
    return display
  }

  if ( word.length > 8 ) {
    display *= 1.2
  }

  // Double up on words with numbers, symbols, or punctuation!
  if ( word.match(/[^a-zA-Z]/) ) { // anything but a letter
    display *= 1.2
  }

  // Triple up on words that have a number.
  if ( word.match(/[0-9]/) ) {
    display *= 1.4
  }

  // triple up on words that end with one of: . ! ? : ) ]
  if ( word.slice(-1).match(/\.|\!|\?|:|\)|\]/) ) {
    display *= 1.4
  }

  return display
}

export function msPerWord(wpm) {
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
export function getTimeToDisplay(word, wpm) {
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
export function getWordMiddle(length) {
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


export function splitWord(word) {

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
export function getTextWidth(text, font) {

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
 * @param  {DOM Element} elem
 * @return {element}
 */
export function getClosestBlockElement(elem) {
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
 * @param  {DOM Element}  elem
 * @return {Boolean}
 */
export function isSingleLine(elem) {
  try {
    const elem_height = parseInt(elem.clientHeight)
    const line_height = parseInt(window.getComputedStyle(elem).lineHeight)
    // direct comparison didn't work,
    // so just check if it's at least smaller than two lines tall...
    return ( elem_height < ( line_height * 2) )

  } catch (e) {
    console.error('could not calculate isSingleLine', e)
    return false
  }
}

/**
 * Does an okay (not perfect) job
 * of telling you whether an element is bold or italic
 *
 * @param  {DOM Element}  elem
 * @return {Boolean}
 */
export function isBoldOrItalic(elem) {
  const { fontWeight, fontStyle } = window.getComputedStyle(elem)
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
 * @param  {DOM Element} elem
 * @return {Boolean}
 */
export function elementContainsASingleWord(elem) {
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
 * @param  {DOM Element} elem
 * @return {Boolean}
 */
export function looksLikeAHeading(elem) {
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

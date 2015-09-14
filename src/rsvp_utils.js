
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

/* @flow */


/**
 * modifies the length of time a word should be displayed
 * on the basis of how hard to read it is.
 *
 * TODO: refine this model!
 */
export function getDisplayMultiplier(wordArg: string): number {
  const word = wordArg.trim()
  let display = 1
  if (!word) return display

  if (word.length > 8) {
    display *= 1.4
  }

  // Double up on words with numbers, symbols, or punctuation!
  if (word.match(/[^a-zA-Z]/)) {
    display *= 1.4
  }

  // Triple up on words that have a number.
  if (word.match(/[0-9]/)) {
    display *= 1.8
  }

  // triple up on words that end with one of: . ! ? : ) ]
  if (word.slice(-1).match(/\.|!|\?|:|\)|\]/)) {
    display *= 1.8
  }

  return display
}

export function msPerWord(wpm: number): number {
  return (60000 / wpm)
}

/**
 * given a target word-per-minute,
 * tells you how long to display a given word,
 * adjusted for how complicated the word is.
 */
export function getTimeToDisplay(word: string, wpm: number): number {
  return (msPerWord(wpm) * getDisplayMultiplier(word))
}


/**
 *  gets the "middle" of the word, where the red letter goes
 *  from https://github.com/Miserlou/Glance/blob/master/spritz.js#L190
 *  ... this may need refining, returns different results from eg; squirt.io
 */
export function getWordMiddle(length: number): number {
  /* eslint-disable no-multi-spaces */
  // TODO: figure out how to make JavaScript a less gross language.
  if (length ===  1) return 1
  if (length  <   5) return 2
  if (length  <   9) return 3
  if (length  <  13) return 4
  return 5
} /* eslint-enable no-multi-spaces */


type SplitWord = {
  wordPart1: string,
  wordPart2: string,
  wordPart3: string,
}
export function splitWord(wordArg: string): SplitWord {
  const word = wordArg.trim() || ' '

  const middle = getWordMiddle(word.length)

  const wordPart1 = word.slice(0, (middle - 1))
  const wordPart2 = word.slice(middle - 1, middle)
  const wordPart3 = word.slice(middle) || ' '

  return { wordPart1, wordPart2, wordPart3 }
}


// re-use canvas object for better performance
const canvas: HTMLCanvasElement = document.createElement('canvas')
/**
 * Uses canvas.measureText to compute and return the width
 * of the given text of given font in pixels.
 *
 * @see http://stackoverflow.com/a/21015393/1048433
 */
export function getTextWidth(text: string, font: string): number {
  if (!(canvas instanceof HTMLCanvasElement)) return 0 // for flow

  const context = canvas.getContext('2d')
  if (!context) return 0

  context.font = font
  const metrics = context.measureText(text)

  return metrics.width
}

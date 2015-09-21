import rangy from 'rangy/lib/rangy-textrange'
import { word_options } from '../constants'

export function isElementEditable(elem) {
  return (
    elem.getAttribute('contenteditable') === 'true'
    ||
    elem.nodeName === 'INPUT'
  )
}

function _containsNewline(range) {
  return !!range.text().match(/[\n\r]/)
}

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

export function isEditableFocused() {
  let activeElement = document.activeElement
  return isElementEditable(activeElement)
}

export function isTextHighlighted() {
  return (
    rangy.getSelection().rangeCount === 1
    &&
    rangy.getSelection().getRangeAt(0).text().trim().length
    &&
    ( 1 || console.log('isTextHighlighted', rangy.getSelection().getRangeAt(0).text()) )
  )
}

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


export function getReadingEdgeLeft(elem) {
  return elem.getBoundingClientRect().left + window.scrollX
}


export function getReadingHeight() {
  return ( window.innerHeight * .32 )
}

// TODO: scroll w/in scrolly-divs on the page.
export function scrollToElementOnce (elem) {
  let elem_top = elem.getBoundingClientRect().top + window.scrollY
  let offset = getReadingHeight()
  let target = elem_top - offset
  scrollToOnce(document.body, target, 500)
}


/**
 * Scrolls screen to an element with animation.
 *
 * @see http://stackoverflow.com/a/16136789/1048433
 *
 * @param  {DOM Element} element
 * @param  {int} to       padding from top
 * @param  {int} duration milliseconds
 * @return {void}
 */
let isAnimating = false
function scrollToOnce(element, to, duration) {
  if ( isAnimating ) {
    return
  }

  const start = element.scrollTop
  const change = to - start
  const increment = 20

  if ( change === 0 ) {
    console.log('not animating, change is 0', {start, to, change})
    return
  }
  isAnimating = true

  const animateScroll = (elapsedTime) => {
    elapsedTime += increment
    const position = easeInOut(elapsedTime, start, change, duration)
    element.scrollTop = position
    if ( elapsedTime < duration ) {
      setTimeout(
        animateScroll.bind(null, elapsedTime),
        increment
      )
    } else {
      isAnimating = false
    }
  }

  animateScroll(0)
}

/** see http://stackoverflow.com/a/16136789/1048433 */
function easeInOut(currentTime, start, change, duration) {
  currentTime /= ( duration / 2 )
  if ( currentTime < 1 ) {
    return change / 2 * currentTime * currentTime + start
  }
  currentTime -= 1
  return -change / 2 * (currentTime * (currentTime - 2) - 1) + start
}

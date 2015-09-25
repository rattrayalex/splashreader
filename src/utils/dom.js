/* @flow */

/**
 * Whether the document's active element is editable.
 * @return {Boolean}
 */
export function isEditableFocused(): boolean {
  let activeElement = document.activeElement
  return _isElementEditable(activeElement)
}

/**
 * Returns true if `elem` can be edited by user
 *
 * @param  {HTMLElement}  elem
 * @return {Boolean}
 */
function _isElementEditable(elem: HTMLElement): boolean {
  return (
    elem.getAttribute('contenteditable') === 'true'
    ||
    elem.nodeName === 'INPUT'
  )
}

/**
 * Gets the elem's distance from left edge of screen.
 *
 * @param  {HTMLElement}  elem
 * @return {number}      distance from left edge of screen
 */
export function getLeftEdge(elem: HTMLElement): number {
  return elem.getBoundingClientRect().left + window.scrollX
}

/**
 * Finds the point 1/3 of the way down the viewport.
 * @return {number} target distance from top edge of screen
 */
export function getReadingHeight(): number {
  return ( window.innerHeight * .32 )
}

/**
 * smooth-scroll's the viewport to target element.
 *
 * @param  {HTMLElement} elem
 * @return {void}
 */
export async function scrollToElementOnce(elem: HTMLElement): Promise<void> {
  // TODO: scroll w/in scrolly-divs on the page.
  let elem_top = elem.getBoundingClientRect().top + window.scrollY
  let offset = getReadingHeight()
  let target = elem_top - offset
  await _scrollToOnce(document.body, target, 500)
}
// </void> (for syntax highlighting...)

/**
 * Scrolls screen to an element with animation.
 *
 * @see http://stackoverflow.com/a/16136789/1048433
 *
 * @param  {HTMLElement} element
 * @param  {int} to       padding from top
 * @param  {int} duration milliseconds
 * @return {void}
 */
let isAnimating = false
async function _scrollToOnce(element, to, duration) {
  if ( isAnimating ) {
    return
  }

  const start = element.scrollTop
  const change = to - start
  const increment = 20

  // don't bother if it's close
  if ( Math.abs(change) < 5 ) {
    return
  }

  return await new Promise( (resolve, reject) => {
    isAnimating = true
    const animateScroll = (elapsedTime) => {
      elapsedTime += increment
      const position = _easeInOut(elapsedTime, start, change, duration)
      element.scrollTop = position
      if ( elapsedTime < duration ) {
        setTimeout(
          animateScroll.bind(null, elapsedTime),
          increment
        )
      } else {
        isAnimating = false
        resolve()
      }
    }
    animateScroll(0)
  }
  )
}

/** see http://stackoverflow.com/a/16136789/1048433 */
function _easeInOut(currentTime, start, change, duration) {
  currentTime /= ( duration / 2 )
  if ( currentTime < 1 ) {
    return change / 2 * currentTime * currentTime + start
  }
  currentTime -= 1
  return -change / 2 * (currentTime * (currentTime - 2) - 1) + start
}

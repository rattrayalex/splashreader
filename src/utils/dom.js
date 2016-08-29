/* @flow */
import { splashreaderContainerId } from '../constants'

export function insertWrapper(): HTMLElement {
  const wrapper = document.createElement('div')
  wrapper.setAttribute('id', splashreaderContainerId)
  document.body.appendChild(wrapper)
  return wrapper
}

export function isNonSplashEditableFocused(): boolean {
  const activeElement = document.activeElement

  // return false if it's a child of the splash container
  const splashContainer = document.getElementById(splashreaderContainerId)
  if (splashContainer.contains(activeElement)) {
    return false
  }

  return isElementEditable(activeElement)
}

function isElementEditable(elem: HTMLElement): boolean {
  return (
    elem.nodeName === 'INPUT'
    || elem.getAttribute('contenteditable') === 'true'
  )
}

/**
 * Gets the elem's distance from left edge of screen.
 */
export function getLeftEdge(elem: HTMLElement): number {
  return elem.getBoundingClientRect().left + window.scrollX
}

/**
 * Finds the point 1/3 of the way down the viewport.
 */
export function getReadingHeight(): number {
  return (window.innerHeight * 0.32)
}

export async function scrollToElementOnce(elem: Range | HTMLElement): Promise<void> {
  // TODO: scroll w/in scrolly-divs on the page.
  const elemTop = elem.getBoundingClientRect().top + window.scrollY
  const offset = getReadingHeight()
  const target = elemTop - offset
  await scrollToOnce(document.body, target, 500)
}

/**
 * Scrolls screen to an element with animation.
 * @see http://stackoverflow.com/a/16136789/1048433
 */
let isAnimating = false
async function scrollToOnce(element, paddingFromTop, duration) {
  if (isAnimating) return Promise.resolve()

  const start = element.scrollTop
  const change = paddingFromTop - start
  const increment = 20

  // don't bother if it's close
  if (Math.abs(change) < 5) return Promise.resolve()

  return await new Promise((resolve) => {
    isAnimating = true
    const animateScroll = (elapsedTime) => {
      /* eslint-disable no-param-reassign */
      elapsedTime += increment
      const position = easeInOut(elapsedTime, start, change, duration)
      element.scrollTop = position
      if (elapsedTime < duration) {
        setTimeout(animateScroll.bind(null, elapsedTime), increment)
      } else {
        isAnimating = false
        resolve()
      }
    }
    animateScroll(0)
  })
}

/** see http://stackoverflow.com/a/16136789/1048433 */
function easeInOut(currentTime, start, change, duration) {
  /* eslint-disable */
  currentTime /= (duration / 2)
  if (currentTime < 1) {
    return change / 2 * currentTime * currentTime + start
  }
  currentTime -= 1
  return -change / 2 * (currentTime * (currentTime - 2) - 1) + start
}

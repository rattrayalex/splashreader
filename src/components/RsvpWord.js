/* @flow */
import React from 'react'
import { props as tprops } from 'tcomb-react'
import { splitWord, getTextWidth } from '../lib/rsvp'
// $FlowIgnore
import styles from './Rsvp.css'

type RsvpWordProps = {
  font: string,
  orpCenter: number,
  currentWord: string,
}

@tprops(RsvpWordProps) /* eslint-disable react/prop-types */
export default class RsvpWord extends React.Component {
  getWordOffset(wordPart1: string, wordPart2: string): number {
    const { font, orpCenter } = this.props

    const widthPart1 = getTextWidth(wordPart1, font)
    const widthPart2 = getTextWidth(wordPart2, font)
    const centerPoint = widthPart1 + (widthPart2 / 2)

    const wordOffset = (orpCenter - centerPoint) || 0

    return wordOffset
  }

  render() {
    const { currentWord, font } = this.props

    const { wordPart1, wordPart2, wordPart3 } = splitWord(currentWord)
    const wordOffset = this.getWordOffset(wordPart1, wordPart2)

    return (
      <div
        className={styles.rsvpWrapperInner}
        style={{ font, marginLeft: wordOffset }}
      >
        <span className={styles.rsvpBeforeMiddle}>
          {wordPart1}
        </span>
        <span className={styles.rsvpMiddle}>
          {wordPart2}
        </span>
        <span className={styles.rsvpAfterMiddle}>
          {wordPart3}
        </span>
      </div>
    )
  }
} /* eslint-enable react/prop-types */

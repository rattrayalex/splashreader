import React from 'react'

import { splitWord, getTextWidth } from '../utils/rsvp'
import styles from './Rsvp.css'


export default class RsvpWord extends React.Component {
  static propTypes = {
    font: React.PropTypes.string.isRequired,
    orpCenter: React.PropTypes.number.isRequired,
  }

  _getWordOffset(word_p1, word_p2) {
    const { font, orpCenter } = this.props

    let width_p1 = getTextWidth(word_p1, font)
    let width_p2 = getTextWidth(word_p2, font)
    let center_point = width_p1 + (width_p2 / 2)

    let word_offset = ( orpCenter - center_point ) || 0

    return word_offset
  }

  render() {
    const { currentWord, font } = this.props

    const { word_p1, word_p2, word_p3 } = splitWord(currentWord)

    const word_offset = this._getWordOffset(word_p1, word_p2)

    return (
      <div className={styles.rsvpWrapperInner}
        style={{ font, marginLeft: word_offset, }}
        >
        <span className={styles.rsvpBeforeMiddle}>
          {word_p1}
        </span>
        <span className={styles.rsvpMiddle}>
          {word_p2}
        </span>
        <span className={styles.rsvpAfterMiddle}>
          {word_p3}
        </span>
      </div>
    )
  }
}

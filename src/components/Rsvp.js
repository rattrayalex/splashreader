/* @flow */
import React from 'react'

import { getTextWidth } from '../utils/rsvp'
import { getReadingHeight } from '../utils/dom'
import SplashButton from './SplashButton'
import RsvpWord from './RsvpWord'
// $FlowIgnore
import styles from './Rsvp.css'


export default class Rsvp extends React.Component {
  render(): ?React.Element {
    let { rsvpPlaying, currentWord, orpCenter, font } = this.props

    if ( !rsvpPlaying ) {
      return null
    }
    if ( !currentWord.trim().length ) {
      return null
    }

    // the lil notch goes in the middle of a letter (hence half an 'm')
    let notch_offset = ( orpCenter + getTextWidth('m', font) / 2 )

    return (
      <div className={styles.Rsvp}>

        <div className={styles.rsvpWrapper}
          style={{
            top: (getReadingHeight() - 40),  // TODO: remove hardcoding
          }}
          >
          <div className={styles.rsvpNotchTop}
            style={{ marginLeft: notch_offset }}
          />

          <RsvpWord
            currentWord={currentWord}
            orpCenter={orpCenter}
            font={font}
          />

          <div className={styles.rsvpNotchBottom}
            style={{ marginLeft: notch_offset }}
          />
        </div>

        <SplashButton {...this.props} />

      </div>
    )
  }
}

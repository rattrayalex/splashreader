import React from 'react'

import { getTextWidth } from './rsvp_utils'
import { getReadingHeight } from './dom_utils'
import SplashButton from './SplashButton'
import RsvpWord from './RsvpWord'
import {} from './Rsvp.css'


export default class Rsvp extends React.Component {
  render() {
    const { rsvpPlaying, currentWord, orpCenter, font } = this.props

    if ( !rsvpPlaying ) {
      return null
    }

    // the lil notch goes in the middle of a letter (hence half an 'm')
    const notch_offset = ( orpCenter + getTextWidth('m', font) / 2 )

    return (
      <div className='Rsvp'>

        <div className='rsvp-wrapper'
          style={{
            top: getReadingHeight() - 40 // TODO: remove hardcoding
          }}
          >
          <div className='rsvp-notch-top'
            style={{ marginLeft: notch_offset }}
          />

          <RsvpWord
            currentWord={currentWord}
            orpCenter={orpCenter}
            font={font}
          />

          <div className='rsvp-notch-bottom'
            style={{ marginLeft: notch_offset }}
          />
        </div>

        <SplashButton {...this.props} />

      </div>
    )
  }
}

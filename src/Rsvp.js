import React from 'react'

import { getTextWidth } from './rsvp_utils'
import RsvpWord from './RsvpWord'
import {} from './Rsvp.css'

const eleven_ems = Array(11).join('m')


export default class Rsvp extends React.Component {
  constructor() {
    super()
    this.state = {
      // TODO: '32pt libre_baskervilleregular, Georgia'
      // TODO: let user set the font
      font: '32pt Georgia',
      ORP_center: null,
    }
  }
  componentDidMount() {
    this._setOrpCenter()
    window.addEventListener('resize', this._setOrpCenter.bind(this), true)
  }
  componentWillUnmount() {
    window.removeEventListener('resize', this._setOrpCenter)
  }

  _setOrpCenter() {
    const { font } = this.state

    const full_width = Math.min(
      window.innerWidth,
      getTextWidth(eleven_ems, font)
    )
    const ORP_center = ( full_width / 3 )
    const notch_offset = ( ORP_center + getTextWidth('m', font) / 2 )

    this.setState({
      ORP_center,
      notch_offset,
    })
  }

  render() {
    const { isPlaying, currentWord } = this.props
    const { font, notch_offset, ORP_center } = this.state

    if ( !isPlaying ) {
      return null
    }

    return (
      <div className='Rsvp'>
        <div className='rsvp-wrapper'>
          <div className='rsvp-notch-top'
            style={{ marginLeft: notch_offset }}
          />
          <div className='rsvp-notch-bottom'
            style={{ marginLeft: notch_offset }}
          />

          <RsvpWord
            currentWord={currentWord}
            ORP_center={ORP_center}
            font={font}
          />

        </div>
      </div>
    )
  }
}
import React from 'react'

import {} from './Rsvp.css'

export default class Rsvp extends React.Component {
  render() {
    const { isPlaying, currentWord } = this.props

    if ( !isPlaying ) {
      return null
    }

    return (
      <div className='Rsvp'>
        <div className='word'>
          {currentWord}
        </div>
      </div>
    )
  }
}
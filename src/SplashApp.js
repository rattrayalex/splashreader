import React, { PropTypes } from 'react'
import { connect } from 'react-redux'

import SplashButton from './SplashButton'
import Rsvp from './Rsvp'

import { allSelector } from './selectors'


class SplashApp extends React.Component {
  render() {
    const { isPlaying } = this.props
    if ( isPlaying ) {
      return <Rsvp {...this.props} />
    }
    return <SplashButton {...this.props} />
  }
}

SplashApp.propTypes = {
  currentWord: PropTypes.string.isRequired,
  buttonShown: PropTypes.bool.isRequired,
  isPlaying: PropTypes.bool.isRequired,
  wpm: PropTypes.number.isRequired,
}

// TODO: use as decorator in ES7
export default connect(allSelector)(SplashApp)

import React, { PropTypes } from 'react'
import { connect } from 'react-redux'

import SplashButton from './SplashButton'
import Rsvp from './Rsvp'

import { allSelector } from './selectors'


class SplashApp extends React.Component {
  render() {
    return (
      <div>
        <SplashButton {...this.props} />
        <Rsvp {...this.props} />
      </div>
    )
  }
}

SplashApp.propTypes = {
  currentWord: PropTypes.string.isRequired,
  buttonShown: PropTypes.bool.isRequired,
  isPlaying: PropTypes.bool.isRequired,
}

// TODO: use as decorator in ES7
export default connect(allSelector)(SplashApp)

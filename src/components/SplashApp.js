import React, { PropTypes } from 'react'
import { connect } from 'react-redux'

import SplashButton from './SplashButton'
import Rsvp from './Rsvp'
import { allSelector } from '../flux/selectors'


@connect(allSelector)
export default class SplashApp extends React.Component {
  static propTypes = {
    currentWord: PropTypes.string.isRequired,
    buttonShown: PropTypes.bool.isRequired,
    rsvpPlaying: PropTypes.bool.isRequired,
    wpm: PropTypes.number.isRequired,
  }

  render() {
    const { rsvpPlaying } = this.props
    if ( rsvpPlaying ) {
      return <Rsvp {...this.props} />
    }
    return <SplashButton {...this.props} />
  }
}

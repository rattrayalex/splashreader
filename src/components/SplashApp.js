/* @flow */
import React, { PropTypes } from 'react'
import { connect } from 'react-redux'

import SplashButton from './SplashButton'
import Rsvp from './Rsvp'
import { allSelector } from '../flux/selectors'
import actions from '../flux/actions'


// see https://github.com/facebook/flow/issues/606
/*::`*/@connect(allSelector)/*::`;*/
export default class SplashApp extends React.Component {
  // $FlowIssue https://github.com/facebook/flow/issues/850
  static propTypes = {
    currentWord: PropTypes.string.isRequired,
    buttonShown: PropTypes.bool.isRequired,
    rsvpPlaying: PropTypes.bool.isRequired,
    wpm: PropTypes.number.isRequired,
  };

  render() {
    let { rsvpPlaying, dispatch } = this.props
    if ( rsvpPlaying ) {
      return <Rsvp {...this.props} />
    }
    return <SplashButton {...this.props} />
  }
}

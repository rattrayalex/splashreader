/* @flow */
import React from 'react'
import { connect } from 'react-redux'

import SplashButton from './SplashButton'
import Rsvp from './Rsvp'
import { allSelector } from '../flux/selectors'
// $FlowIgnore
import styles from './Rsvp.css'


type SplashAppProps = {
  dispatch: () => void,
  currentWord: string,
  buttonShown: bool,
  rsvpPlaying: bool,
  isPlaying: bool,
  wpm: number,
  font: string,
  orpCenter: number,
}
const SplashApp = connect(allSelector)((props: SplashAppProps) => (
  <div className={props.rsvpPlaying ? styles.Rsvp : ''} >
    <Rsvp {...props} />
    <SplashButton
      dispatch={props.dispatch}
      buttonShown={props.buttonShown}
      isPlaying={props.isPlaying}
      wpm={props.wpm}
    />
  </div>
))
export default SplashApp

/* @flow */
import React, { PropTypes } from 'react'
import classNames from 'classnames'

import actions from '../flux/actions'
import FloatingHoverButtons from './FloatingHoverButtons'
import WpmButtons from './WpmButtons'
// $FlowIgnore
import styles from './SplashButton.css'


export default class SplashButton extends React.Component {
  // $FlowIssue https://github.com/facebook/flow/issues/850
  static propTypes = {
    dispatch: PropTypes.func.isRequired,
    buttonShown: PropTypes.bool.isRequired,
    isPlaying: PropTypes.bool.isRequired,
    wpm: PropTypes.number.isRequired,
  };

  _handleClick() {
    let { dispatch } = this.props
    dispatch(actions.playPause())
  }

  render() {
    let { buttonShown, isPlaying, wpm, dispatch } = this.props

    if ( !buttonShown ) {
      return null
    }

    let play_pause_class = classNames({
      // $FlowIssue https://github.com/facebook/flow/issues/252
      [styles.SplashButton]: true,
      // $FlowIssue https://github.com/facebook/flow/issues/252
      [styles.active]: isPlaying,
    })
    let play_pause_button = (
      <button className={play_pause_class}
        onClick={this._handleClick.bind(this)}
        title='SplashRead (spacebar)'
        >
        { ( !isPlaying )
          ? <span className={styles.playButton}></span>
          : <span className={styles.pauseButton}></span>
        }
      </button>
    )

    return (
      <FloatingHoverButtons
        shown={isPlaying}
        primary={play_pause_button}
        >
        <WpmButtons wpm={wpm}
          dispatch={dispatch}
        />
      </FloatingHoverButtons>
    )
  }
}

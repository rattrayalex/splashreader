import React, { PropTypes } from 'react'
import classNames from 'classnames'

import store from '../flux/store'
import FloatingHoverButtons from './FloatingHoverButtons'
import WpmButtons from './WpmButtons'
import styles from './SplashButton.css'


export default class SplashButton extends React.Component {
  static propTypes = {
    buttonShown: PropTypes.bool.isRequired,
    isPlaying: PropTypes.bool.isRequired,
    wpm: PropTypes.number.isRequired,
  }

  _handleClick(e) {
    store.actions.playPause()
  }

  render() {
    let { buttonShown, isPlaying, wpm } = this.props

    if ( !buttonShown ) {
      return null
    }

    let play_pause_class = classNames({
      [styles.SplashButton]: true,
      [styles.active]: isPlaying,
    })
    let play_pause_button = (
      <button className={play_pause_class}
        onClick={this._handleClick}
        title='SplashRead (spacebar)'
        >
        { ( !isPlaying )
          ? <span className={styles.playButton}></span>
          : <span className={styles.pauseButton}></span>
        }
      </button>
    )

    return (
      <FloatingHoverButtons shown={isPlaying}
        primary={play_pause_button}
        >
        <WpmButtons wpm={wpm} />
      </FloatingHoverButtons>
    )
  }
}

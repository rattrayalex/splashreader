import React, { PropTypes } from 'react'
import classNames from 'classnames'

import store from './store'
import FloatingHoverButtons from './FloatingHoverButtons'
import WpmButtons from './WpmButtons'
import {} from './SplashButton.css'



class SplashButton extends React.Component {

  _handleClick(e) {
    store.actions.playPause()
  }


  render() {
    let { buttonShown, isPlaying, wpm } = this.props

    if ( !buttonShown ) {
      return null
    }

    let play_pause_class = classNames({
      'SplashButton': true,
      'active': isPlaying,
    })
    let play_pause_button = (
      <button className={play_pause_class}
        onClick={this._handleClick}
        title='SplashRead (spacebar)'
        >
        { ( !isPlaying )
          ? <span className="play-button">▶</span>
          : <span className='pause-button'>▌▌</span>
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

SplashButton.propTypes = {
  buttonShown: PropTypes.bool.isRequired,
  isPlaying: PropTypes.bool.isRequired,
  wpm: PropTypes.number.isRequired,
}


export default SplashButton


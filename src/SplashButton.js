import React, { PropTypes } from 'react'
import classNames from 'classnames'

import store from './store'
import {} from './SplashButton.css'

const DEFAULT_WPM_STEP = 50


class FloatingHoverButtons extends React.Component {
  constructor() {
    super()
    this.state = {
      hovered: false
    }
  }
  _handleMouseEnter(e) {
    this.setState({ hovered: true })
  }
  _handleMouseLeave(e) {
    this.setState({ hovered: false })
  }
  render() {
    let { primary, children, shown } = this.props
    let { hovered } = this.state

    return (
      <div className='floating-hover-buttons-container'
        onMouseEnter={this._handleMouseEnter.bind(this)}
        onMouseLeave={this._handleMouseLeave.bind(this)}
        >
        { ( hovered || shown )
          ? {children}
          : null
        }
        {primary}
      </div>
    )
  }

}
FloatingHoverButtons.propTypes = {
  children: PropTypes.array.isRequired,
  primary: PropTypes.element.isRequired,
  shown: PropTypes.bool,
}

class SplashButton extends React.Component {


  _handleHover(e) {
    this.setState({ hovered: true })
  }
  _handleClick(e) {
    store.actions.playPause()
  }
  _decreaseWpm(e) {
    store.actions.decreaseWpm({ amount: DEFAULT_WPM_STEP })
  }
  _increaseWpm(e) {
    store.actions.increaseWpm({ amount: DEFAULT_WPM_STEP })
  }

  render() {
    let { buttonShown, isPlaying, wpm } = this.props
    if ( !buttonShown )
      return null

    return (
      <FloatingHoverButtons shown={isPlaying}
        primary={
          <button className={classNames('SplashButton', {
              'active': isPlaying,
            })}
            onClick={this._handleClick}
            title='SplashRead (spacebar)'
            >
            <span className="play-button">▶</span>
          </button>
        }
      >
        <button className='smaller-hover-button'
          onClick={this._increaseWpm}
          title='Increase Reading Speed'
          style={{ marginBottom: 10 }}
          key='increase-button'
          >
          <span>▲</span>
        </button>
        <small style={{ marginBottom: 10 }} key='wpm'>{wpm} wpm</small>
        <button className='smaller-hover-button'
          onClick={this._decreaseWpm}
          title='Decrease Reading Speed'
          style={{ marginBottom: 20 }}
          key='decrease-button'
          >
          <span>▼</span>
        </button>
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


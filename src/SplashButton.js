import React, { PropTypes } from 'react'
import classNames from 'classnames'

import {} from './SplashButton.css'


class SplashButton extends React.Component {
  _handleClick(e) {
    console.log('TODO: implement')
  }

  render() {
    let { buttonShown, isPlaying } = this.props
    if ( !buttonShown )
      return null

    return (
      <button className={classNames('SplashButton', {
          'active': isPlaying,
        })}
        onClick={this._handleClick}
        >
        <img src={require('../images/icon16.png')} />
        &nbsp;
        SplashRead (space)
      </button>
    )
  }
}

SplashButton.propTypes = {
  buttonShown: PropTypes.bool.isRequired,
  isPlaying: PropTypes.bool.isRequired,
}


export default SplashButton


import React, { PropTypes } from 'react'

import { connect } from 'react-redux'

import { paraSelected } from './selectors'
import {} from './splashable.css'


// TODO: use ES7
// @connect(paraSelected)
class SplashButton extends React.Component {
  _handleClick(e) {
    console.log('TODO: implement')
  }

  render() {
    let { buttonShown } = this.props
    if ( !buttonShown )
      return null

    return (
      <button className='SplashButton'
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
}

// TODO: use as decorator in ES7
export default connect(paraSelected)(SplashButton)


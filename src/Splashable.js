import React, { PropTypes } from 'react'

import { connect } from 'react-redux'

import { paraSelected } from './selectors'
import {} from './splashable.css'


// TODO: use ES7
// @connect(paraSelected)
class Splashable extends React.Component {
  _handleClick(e) {
    console.log('TODO: implement')
  }

  render() {
    let { paraSelected } = this.props
    if ( !paraSelected )
      return null

    return (
      <button className='splashreader--splashable'
        onClick={this._handleClick}
        >
        <img src={require('../images/icon16.png')} />
        &nbsp;
        SplashRead (space)
      </button>
    )
  }
}

Splashable.propTypes = {
  paraSelected: PropTypes.bool.isRequired,
}

// TODO: use as decorator in ES7
export default connect(paraSelected)(Splashable)


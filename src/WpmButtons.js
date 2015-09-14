import React from 'react'

import store from './store'


const DEFAULT_WPM_STEP = 50

export default class WpmButtons extends React.Component {
  _decreaseWpm(e) {
    store.actions.decreaseWpm({ amount: DEFAULT_WPM_STEP })
  }
  _increaseWpm(e) {
    store.actions.increaseWpm({ amount: DEFAULT_WPM_STEP })
  }
  render() {
    let { wpm } = this.props

    return (
      <center>
        <button className='smaller-hover-button'
          onClick={this._increaseWpm}
          title='Increase Reading Speed'
          >
          <span>▲</span>
        </button>

        <div style={{ marginBottom: 10, marginTop: -10 }}>
          <small>{wpm} wpm</small>
        </div>

        <button className='smaller-hover-button'
          onClick={this._decreaseWpm}
          title='Decrease Reading Speed'
          >
          <span>▼</span>
        </button>
      </center>
    )
  }
}

WpmButtons.propTypes = {
  wpm: React.PropTypes.number.isRequired,
}
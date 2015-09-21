import React from 'react'
import classNames from 'classnames'

import store from '../flux/store'
import styles from './SplashButton.css'

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
        <button
          className={classNames(styles.upArrow, styles.smallerHoverButton)}
          onClick={this._increaseWpm}
          title='Increase Reading Speed'
        />

        <div className={styles.wpmLabel}>
          {wpm} wpm
        </div>

        <button
          className={classNames(styles.downArrow, styles.smallerHoverButton)}
          onClick={this._decreaseWpm}
          title='Decrease Reading Speed'
        />
      </center>
    )
  }
}

WpmButtons.propTypes = {
  wpm: React.PropTypes.number.isRequired,
}

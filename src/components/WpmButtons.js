/* @flow */
import React from 'react'
import classNames from 'classnames'

import store from '../flux/store'
// $FlowIgnore
import styles from './SplashButton.css'

const DEFAULT_WPM_STEP = 50


export default class WpmButtons extends React.Component {
  // $FlowIssue https://github.com/facebook/flow/issues/850
  static propTypes = {
    wpm: React.PropTypes.number.isRequired,
  };

  _decreaseWpm() {
    store.actions.decreaseWpm({ amount: DEFAULT_WPM_STEP })
  }
  _increaseWpm() {
    store.actions.increaseWpm({ amount: DEFAULT_WPM_STEP })
  }

  render(): React.Element {
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

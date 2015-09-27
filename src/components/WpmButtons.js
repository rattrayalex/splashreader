/* @flow */
import React from 'react'
import classNames from 'classnames'

import actions from '../flux/actions'
// $FlowIgnore
import styles from './SplashButton.css'

const DEFAULT_WPM_STEP = 50


export default class WpmButtons extends React.Component {
  // $FlowIssue https://github.com/facebook/flow/issues/850
  static propTypes = {
    dispatch: React.PropTypes.func.isRequired,
    wpm: React.PropTypes.number.isRequired,
  };

  _decreaseWpm() {
    let { dispatch } = this.props
    dispatch(actions.decreaseWpm({ amount: DEFAULT_WPM_STEP }))
  }
  _increaseWpm() {
    let { dispatch } = this.props
    dispatch(actions.increaseWpm({ amount: DEFAULT_WPM_STEP }))
  }
  _handleSet(e: React.SyntheticEvent) {
    let { dispatch } = this.props
    let wpm = parseInt(e.target.value)
    dispatch(actions.setWpm({ wpm }))
  }

  render(): React.Element {
    let { wpm } = this.props

    return (
      <center title='Words Per Minute (WPM)'>
        <button
          className={classNames(styles.upArrow, styles.smallerHoverButton)}
          onClick={this._increaseWpm.bind(this)}
          title='Increase Reading Speed'
        />

        <input className={styles.wpmInput}
          type='number'
          value={wpm}
          onChange={this._handleSet.bind(this)}
          min={50}
          step={10}
          title='Words Per Minute (WPM)'
        />

        <button
          className={classNames(styles.downArrow, styles.smallerHoverButton)}
          onClick={this._decreaseWpm.bind(this)}
          title='Decrease Reading Speed'
        />
      </center>
    )
  }
}

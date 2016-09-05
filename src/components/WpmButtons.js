/* @flow */
import React from 'react'
import classNames from 'classnames'
import autobind from 'react-autobind'

import actions from '../flux/actions'
// $FlowIgnore
import styles from './SplashButton.css'

const DEFAULT_WPM_STEP = 50

type WpmButtonsProps = {
  dispatch: () => void,
  wpm: number,
}
export default class WpmButtons extends React.Component {
  constructor(props: WpmButtonsProps) {
    super(props)
    autobind(this)
  }
  props: WpmButtonsProps

  decreaseWpm() {
    const { dispatch } = this.props
    dispatch(actions.decreaseWpm({ amount: DEFAULT_WPM_STEP }))
  }
  increaseWpm() {
    const { dispatch } = this.props
    dispatch(actions.increaseWpm({ amount: DEFAULT_WPM_STEP }))
  }
  handleSet({ target }: SyntheticInputEvent) {
    // flow is being persnickety, event.target might not have a value
    if (!(target instanceof HTMLInputElement)) return

    const { dispatch } = this.props

    const wpm = parseInt(target.value, 10)
    dispatch(actions.setWpm({ wpm }))
  }

  render() {
    const { wpm } = this.props

    return (
      <center title="Words Per Minute (WPM)">
        <button
          className={styles.smallerHoverButton}
          onClick={this.increaseWpm}
          title="Increase Reading Speed"
        >
          <div className={styles.upArrow} />
        </button>

        <input
          className={styles.wpmInput}
          type="number"
          value={wpm}
          onChange={this.handleSet}
          min={50}
          step={10}
          title="Words Per Minute (WPM)"
        />

        <button
          className={styles.smallerHoverButton}
          onClick={this.decreaseWpm}
          title="Decrease Reading Speed"
        >
          <div className={styles.downArrow} />
        </button>
      </center>
    )
  }
}

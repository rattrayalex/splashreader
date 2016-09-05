/* @flow */
import React from 'react'
import cx from 'classnames'
import autobind from 'react-autobind'
import { props as tprops } from 'tcomb-react'

import actions from '../flux/actions'
import FloatingHoverButtons from './FloatingHoverButtons'
import WpmButtons from './WpmButtons'
// $FlowIgnore
import styles from './SplashButton.css'

type PlayPauseButtonProps = {
  isPlaying: bool,
  handleClick: () => void,
}
const PlayPauseButton = ({ isPlaying, handleClick }: PlayPauseButtonProps) => (
  <button
    className={cx(styles.SplashButton, {
      [styles.active]: isPlaying,
    })}
    onClick={handleClick}
    title="SplashRead (spacebar)"
  >
    {(!isPlaying)
      ? <span className={styles.playButton} />
      : <span className={styles.pauseButton} />
    }
  </button>
)

type SplashButtonProps = {
  dispatch: () => void,
  buttonShown: bool,
  isPlaying: bool,
  wpm: number,
}
@tprops(SplashButtonProps) /* eslint-disable react/prop-types */
export default class SplashButton extends React.Component {
  constructor(props: SplashButtonProps) {
    super(props)
    autobind(this)
  }

  handleClick() {
    const { dispatch } = this.props
    dispatch(actions.playPause())
  }

  render() {
    const { buttonShown, isPlaying, wpm, dispatch } = this.props
    if (!buttonShown) return null

    const playPauseButton = (
      <PlayPauseButton
        isPlaying={isPlaying}
        handleClick={this.handleClick}
      />
    )

    return (
      <FloatingHoverButtons shown={true} primary={playPauseButton}>
        <WpmButtons wpm={wpm} dispatch={dispatch} />
      </FloatingHoverButtons>
    )
  }
} /* eslint-enable react/prop-types */

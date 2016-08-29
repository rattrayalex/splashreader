/* @flow */
import React, { PropTypes } from 'react'
import cx from 'classnames'
import { props as tprops } from 'tcomb-react'

import { getTextWidth } from '../utils/rsvp'
import { getReadingHeight } from '../utils/dom'
import RsvpWord from './RsvpWord'
// $FlowIgnore
import styles from './Rsvp.css'

const RsvpWrapper = ({ children }) => {
  // TODO: remove hardcoding
  const top = getReadingHeight() - 40
  return (
    <div className={styles.rsvpWrapper} style={{ top }}>
      {children}
    </div>
  )
}
RsvpWrapper.propTypes = {
  children: PropTypes.array.isRequired,
}

const Notch = ({ offset, position }) => (
  <div
    className={cx({
      [styles.rsvpNotchTop]: (position === 'top'),
      [styles.rsvpNotchBottom]: (position === 'bottom'),
    })}
    style={{ marginLeft: offset }}
  />
)
Notch.propTypes = {
  position: PropTypes.oneOf(['top', 'bottom']).isRequired,
  offset: PropTypes.number.isRequired,
}

type RsvpProps = {
  rsvpPlaying: bool,
  currentWord: string,
  orpCenter: number,
  font: string,
}
const Rsvp = (props: RsvpProps) => {
  const { rsvpPlaying, currentWord, orpCenter, font } = props
  if (!rsvpPlaying) return null
  if (!currentWord.trim().length) return null

  // the lil notch goes in the middle of a letter (hence half an 'm')
  const notchOffset = (orpCenter + (getTextWidth('m', font) / 2))

  return (
    <RsvpWrapper>
      <Notch position="top" offset={notchOffset} />
      <RsvpWord
        currentWord={currentWord}
        orpCenter={orpCenter}
        font={font}
      />
      <Notch position="bottom" offset={notchOffset} />
    </RsvpWrapper>
  )
}
export default Rsvp

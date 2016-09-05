/* @flow */
import React from 'react'
import cx from 'classnames'
import { ReactChildren, propTypes } from 'tcomb-react'

import { getTextWidth } from '../lib/rsvp'
import { getReadingHeight } from '../lib/dom'
import RsvpWord from './RsvpWord'
// $FlowIgnore
import styles from './Rsvp.css'

type RsvpWrapperProps = {
  children: ReactChildren,
}
const RsvpWrapper = ({ children }) => {
  // TODO: remove hardcoding
  const top = getReadingHeight() - 40
  return (
    <div className={styles.rsvpWrapper} style={{ top }}>
      {children}
    </div>
  )
}
// $FlowIgnore
RsvpWrapper.propTypes = propTypes(RsvpWrapperProps)


type NotchProps = {
  position: 'top' | 'bottom',
  offset: number,
}
const Notch = ({ offset, position }: NotchProps) => (
  <div
    className={cx({
      [styles.rsvpNotchTop]: (position === 'top'),
      [styles.rsvpNotchBottom]: (position === 'bottom'),
    })}
    style={{ marginLeft: offset }}
  />
)
// $FlowIgnore
Notch.propTypes = propTypes(NotchProps)

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

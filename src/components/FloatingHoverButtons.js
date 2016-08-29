/* @flow */
import React from 'react'
import autobind from 'react-autobind'
import { props as tprops } from 'tcomb-react'

// $FlowIgnore
import styles from './SplashButton.css'

type FloatingHoverButtonsProps = {
  children: any,
  primary: any,
  shown: bool,
}

@tprops(FloatingHoverButtonsProps)  /* eslint-disable react/prop-types */
export default class FloatingHoverButtons extends React.Component {
  constructor(props: FloatingHoverButtonsProps) {
    super(props)
    autobind(this)
  }
  state = {
    hovered: false,
  }

  handleMouseEnter() {
    this.setState({ hovered: true })
  }
  handleMouseLeave() {
    this.setState({ hovered: false })
  }

  render() {
    const { primary, children, shown } = this.props
    const { hovered } = this.state

    return (
      <div
        className={styles.floatingHoverButtonsContainer}
        onMouseEnter={this.handleMouseEnter}
        onMouseLeave={this.handleMouseLeave}
      >
        {(hovered || shown) ?
          <div>{children}</div>
        : null}
        {primary}
      </div>
    )
  }
}

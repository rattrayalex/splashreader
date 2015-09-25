/* @flow */
import React, { PropTypes } from 'react'
// $FlowIgnore
import styles from './SplashButton.css'


export default class FloatingHoverButtons extends React.Component {
  // $FlowIssue https://github.com/facebook/flow/issues/850
  static propTypes = {
    children: PropTypes.oneOfType([
      PropTypes.array,
      PropTypes.object
    ]).isRequired,
    primary: PropTypes.element.isRequired,
    shown: PropTypes.bool,
  };

  // $FlowIssue https://github.com/facebook/flow/issues/850
  state = {
    hovered: false
  };

  _handleMouseEnter() {
    this.setState({ hovered: true })
  }
  _handleMouseLeave() {
    this.setState({ hovered: false })
  }

  render(): React.Element {
    let { primary, children, shown } = this.props
    let { hovered } = this.state

    return (
      <div className={styles.floatingHoverButtonsContainer}
        onMouseEnter={this._handleMouseEnter.bind(this)}
        onMouseLeave={this._handleMouseLeave.bind(this)}
        >
        { ( hovered || shown )
          ? {children}
          : null
        }
        {primary}
      </div>
    )
  }
}

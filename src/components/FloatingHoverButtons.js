import React, { PropTypes } from 'react'
import styles from './SplashButton.css'


export default class FloatingHoverButtons extends React.Component {
  static propTypes = {
    children: PropTypes.oneOfType([
      PropTypes.array,
      PropTypes.object
    ]).isRequired,
    primary: PropTypes.element.isRequired,
    shown: PropTypes.bool,
  }

  state = {
    hovered: false
  }

  _handleMouseEnter(e) {
    this.setState({ hovered: true })
  }
  _handleMouseLeave(e) {
    this.setState({ hovered: false })
  }

  render() {
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

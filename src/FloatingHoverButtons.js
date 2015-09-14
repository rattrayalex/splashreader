import React, { PropTypes } from 'react'


class FloatingHoverButtons extends React.Component {
  constructor() {
    super()
    this.state = {
      hovered: false
    }
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
      <div className='floating-hover-buttons-container'
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
FloatingHoverButtons.propTypes = {
  children: PropTypes.array.isRequired,
  primary: PropTypes.element.isRequired,
  shown: PropTypes.bool,
}

export default FloatingHoverButtons

React = require 'react'

dispatcher = require('../dispatcher')


getElemOrWord = (elem) ->
  if elem.get('word')?
    Word({elem})
  else
    Elem({elem})


Word = React.createClass
  handleClick: ->
    dispatcher.dispatch
      actionType: 'click-word'
      word: @props.elem

  componentDidMount: ->
    @props.elem.on 'change', ( => @forceUpdate() ), @

  componentWillUnmount: ->
    @props.elem.off null, null, @

  render: ->
    React.DOM.span {
      onClick: @handleClick
      style:
        color: if @props.elem.get('clicked') then 'red'
    },
      @props.elem.get('word')

Elem = React.createClass
  render: ->
    children = @props.elem.get('children').models

    React.DOM[@props.elem.get('node_name')](
      @props.elem.get('attrs'),
      [getElemOrWord(elem) for elem in children]
    )

module.exports = {Elem}

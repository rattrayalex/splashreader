React = require 'react'
_ = require 'underscore'

dispatcher = require('../dispatcher')

{div, span} = React.DOM


getElemOrWord = (elem, current) ->
  if elem.get('word')?
    Word({elem, current})
  else
    Elem({elem, current})


Word = React.createClass

  handleClick: ->
    dispatcher.dispatch
      actionType: 'change-word'
      word: @props.elem

  componentDidMount: ->
    @props.elem.on 'change', ( => @forceUpdate() ), @
    @props.elem.set
      react_elem: @

  componentWillUnmount: ->
    @props.elem.off null, null, @

  render: ->
    span {
      onClick: @handleClick
      style:
        textDecoration: if @props.current.get('word') is @props.elem then 'underline'
    },
      @props.elem.get('word')

Elem = React.createClass

  isCurrentPara: ->
    @props.current.get('parent') is @props.elem

  componentDidMount: ->
    # bind react elem to model
    @props.elem.set
      react_elem: @

    @props.elem.on 'change', =>
      @forceUpdate()
    , @

  componentWillUnmount: ->
    @props.elem.off null, null, @

  render: ->
    ReactElem = React.DOM[@props.elem.get('node_name')]

    attrs = _.extend @props.elem.get('attrs'),
      style:
        color: if @isCurrentPara() then 'orange'

    children = [
      getElemOrWord(elem, @props.current) \
      for elem in @props.elem.get('children').models
    ]

    ReactElem(attrs, children)


ArticleViewDisplay = React.createClass

  componentDidMount: ->
    @props.current.on 'change:parent', =>
      elem = @props.current.get('parent').get('react_elem').getDOMNode()
      @scrollToElem elem

  scrollToElem: (elem) ->
    node = @getDOMNode()
    node.scrollTop = elem.offsetTop - node.offsetTop - 75

  render: ->
    div {
      className: ' scroll-box'
      style:
        paddingTop: 40
        overflowY: 'scroll'
        height: 400
    },
      Elem {
        elem: @props.elem
        current: @props.current
      }


module.exports = {Elem, ArticleViewDisplay}

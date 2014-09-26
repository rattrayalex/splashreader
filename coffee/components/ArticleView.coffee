React = require 'react'
$ = require 'jQuery'
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

  isCurrentWord: ->
    @props.current.get('word') is @props.elem

  componentDidMount: ->
    @props.elem.on 'change', ( => @forceUpdate() ), @
    @props.elem.set
      react_elem: @

  componentWillUnmount: ->
    @props.elem.off null, null, @

  render: ->
    span {
      onClick: @handleClick
      className: 'current-word' if @isCurrentWord()
    },
      @props.elem.get('word')

Elem = React.createClass

  isCurrentPara: ->
    @props.current.get('parent') is @props.elem

  scrollToMe: ->
    offset = (window.innerHeight * .4) - 40
    # document.body.scrollTop = @getDOMNode().offsetTop - offset
    $('body').animate
      scrollTop: @getDOMNode().offsetTop - offset
    , 500

  componentDidMount: ->
    # bind react elem to model
    @props.elem.set
      react_elem: @

    @props.elem.on 'change', =>
      @forceUpdate()
      @scrollToMe() if @isCurrentPara()
    , @

  componentWillUnmount: ->
    @props.elem.off null, null, @

  render: ->
    ReactElem = React.DOM[@props.elem.get('node_name')]

    attrs = _.extend @props.elem.get('attrs'),
      className: if @isCurrentPara() then 'current-para'

    children = [
      getElemOrWord(elem, @props.current) \
      for elem in @props.elem.get('children').models
    ]

    ReactElem(attrs, children)


ArticleViewDisplay = React.createClass

  componentDidMount: ->
    @props.status.on 'change', ( => @forceUpdate() ), @

  componentWillUnmount: ->
    @props.status.off null, null, @

  render: ->
    div {
      className: 'scroll-box'
      style:
        paddingTop: window.innerHeight * .4
        paddingBottom: window.innerHeight * .4
        # visibility instead of display b/c it retains the scroll position
        visibility: if @props.status.get('playing') then 'hidden' else 'visible'
    },
      Elem {
        elem: @props.elem
        current: @props.current
      }


module.exports = {Elem, ArticleViewDisplay}

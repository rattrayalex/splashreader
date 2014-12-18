React = require 'react/addons'
_ = require 'underscore'

FluxBone = require('./FluxBone')
dispatcher = require('../dispatcher')
{scrollToNode} = require('../article_utils.coffee')

{span} = React.DOM

ElemOrWord = React.createClass
  mixins: [
    React.addons.PureRenderMixin
  ]

  render: ->
    if @props.elem.get('word')?
      Word
        elem: @props.elem
        current: @props.current
    else
      Elem
        elem: @props.elem
        current: @props.current


Word = React.createClass

  mixins: [
    FluxBone.ModelMixin('elem', 'change')
    React.addons.PureRenderMixin
  ]

  handleClick: ->
    dispatcher.dispatch
      actionType: 'change-word'
      word: @props.elem
      source: 'click'

  scrollToMe: ->
    scrollToNode @getDOMNode()

  isCurrentWord: ->
    @props.current.getWord() is @props.elem

  componentDidMount: ->
    @props.elem.on 'scroll', =>
      @scrollToMe()
    , @

  componentWillUnmount: ->
    @props.elem.off 'scroll', null, @

  render: ->
    space = if @props.elem.get('after') is ' ' then ' ' else ''
    span
      onClick: @handleClick
      className: 'current-word' if @isCurrentWord()
      ,
      @props.elem.get('word') + space


Elem = React.createClass

  mixins: [
    FluxBone.ModelMixin('elem', 'change')
    React.addons.PureRenderMixin
  ]

  isCurrentPara: ->
    @props.current.getWord()?.get('parent') is @props.elem

  render: ->
    ReactElem = React.DOM[@props.elem.get('node_name')]

    attrs = _.extend @props.elem.get('attrs'),
      # NOTE: this will override any existing className.
      # (which currently doesn't matter since `sanitize` cleans them out)
      # TODO: fix that.
      className: if @isCurrentPara() then 'current-para'

    children = [
      ElemOrWord({elem: elem, current: @props.current}) \
      for elem in @props.elem.get('children').models
    ]

    ReactElem(attrs, children)


module.exports = ElemOrWord
React = require 'react/addons'
_ = require 'underscore'

FluxBone = require('./FluxBone')
dispatcher = require('../dispatcher')
{scrollToNode} = require('../article_utils.coffee')
{getCurrentWord} = require('../stores/computed')

{span} = React.DOM


ElemOrWord = React.createClass
  mixins: [
    React.addons.PureRenderMixin
  ]

  render: ->
    if typeof @props.elem is "number"
      # console.log 'we have a word?', @props
      Word
        word: @props.words.get(@props.elem)
        # current: @props.current
    else
      Elem
        elem: @props.elem
        words: @props.words
        current: @props.current


Word = React.createClass

  mixins: [
    React.addons.PureRenderMixin
  ]

  # shouldComponentUpdate: (nextProps) ->
  #   @props.word isnt nextProps.word

  handleClick: ->
    dispatcher.dispatch
      actionType: 'change-word'
      idx: @props.word.get('idx')
      source: 'click'

  scrollToMe: ->
    scrollToNode @getDOMNode()

  isCurrentWord: ->
    @props.word.get('current')
    # @props.current.get('idx') is @props.word.get('idx')

  # componentDidMount: ->
  #   @props.word.on 'scroll', =>
  #     @scrollToMe()
  #   , @

  # componentWillUnmount: ->
  #   @props.word.off 'scroll', null, @

  render: ->
    space = if @props.word.get('after') is ' ' then ' ' else ''
    span
      onClick: @handleClick
      className: 'current-word' if @isCurrentWord()
      ,
      @props.word.get('word') + space


Elem = React.createClass

  mixins: [
    React.addons.PureRenderMixin
  ]
  # shouldComponentUpdate: (nextProps) ->
  #   @isCurrentPara() or (nextProps.elem.get('cid') is
  #     getCurrentWord(nextProps.words, nextProps.current).get('parent'))

  isCurrentPara: ->
    getCurrentWord(@props.words, @props.current).get('parent') is
      @props.elem.get('cid')

  render: ->
    ReactElem = React.DOM[@props.elem.get('node_name')]

    attrs = _.extend @props.elem.get('attrs'),
      # NOTE: this will override any existing className.
      # (which currently doesn't matter since `sanitize` cleans them out)
      # TODO: fix that.
      className: if @isCurrentPara() then 'current-para'

    current = @props.current
    words = @props.words
    children = [
      ElemOrWord({elem, current, words}) \
      for elem in @props.elem.get('children').toArray()
    ]

    ReactElem(attrs, children)


module.exports = ElemOrWord
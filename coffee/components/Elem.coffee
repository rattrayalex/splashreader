React = require 'react/addons'
_ = require 'underscore'

dispatcher = require('../dispatcher')
{scrollToNode} = require('../article_utils.coffee')
{isPlaying} = require('../stores/computed')

{span} = React.DOM

# func instead of React b/c too much overhead!
getElemOrWord = (props) ->
  if typeof props.elem is "number"
    WordFactory
      word: props.words.get(props.elem)
      status: props.status
  else if props.elem?
    ElemFactory
      elem: props.elem
      words: props.words
      status: props.status
      current: props.current
  else
    span {}


Word = React.createClass

  handleClick: ->
    dispatcher.dispatch
      actionType: 'change-word'
      idx: @props.word.get('idx')
      source: 'click'

  scrollToMe: ->
    scrollToNode @getDOMNode()

  isCurrentWord: ->
    @props.word.get('current')

  shouldComponentUpdate: (nextProps) ->
    changed = (@props.word isnt nextProps.word)
    paused_here = (nextProps.word.get('current') and
      not isPlaying(nextProps.status))
    return changed or paused_here

  render: ->
    if @isCurrentWord() and not isPlaying(@props.status)
      @scrollToMe() if @isMounted()

    space = if @props.word.get('after') is ' ' then ' ' else ''
    span
      onClick: @handleClick
      className: 'current-word' if @isCurrentWord()
      ,
      @props.word.get('word') + space


Elem = React.createClass

  isCurrentPara: ->
    @props.current.get('parent') is @props.elem.get('cid')

  shouldComponentUpdate: (nextProps) ->
    this_para = (
      @props.elem.get('start_word') <=
      @props.current.get('idx') <=
      @props.elem.get('end_word')
    )
    next_para = (
      nextProps.elem.get('start_word') <=
      nextProps.current.get('idx') <=
      nextProps.elem.get('end_word')
    )
    paused = (isPlaying(@props.status) and not isPlaying(nextProps.status))
    return this_para or next_para or paused

  render: ->
    ReactElem = React.DOM[@props.elem.get('node_name')]

    attrs = _.extend @props.elem.get('attrs'),
      # NOTE: this will override any existing className.
      # (which currently doesn't matter since `sanitize` cleans them out)
      # TODO: fix that.
      className: if @isCurrentPara() then 'current-para'

    words = @props.words
    status = @props.status
    current = @props.current
    children = [
      getElemOrWord({elem, words, status, current}) \
      for elem in @props.elem.get('children').toArray()
    ]

    ReactElem(attrs, children)


WordFactory = React.createFactory Word
ElemFactory = React.createFactory Elem


module.exports = Elem

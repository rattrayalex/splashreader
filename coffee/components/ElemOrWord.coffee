React = require 'react/addons'
_ = require 'underscore'

FluxBone = require('./FluxBone')
dispatcher = require('../dispatcher')
{scrollToNode} = require('../article_utils.coffee')
{getCurrentWord} = require('../stores/computed')

{span} = React.DOM


ElemOrWord = React.createClass

  render: ->
    if typeof @props.elem is "number"
      Word
        word: @props.words.get(@props.elem)
        playing: @props.playing
    else
      Elem
        elem: @props.elem
        words: @props.words
        current: @props.current
        playing: @props.playing


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
    paused_here = (nextProps.word.get('current') and not nextProps.playing)
    return changed or paused_here

  render: ->
    if @isCurrentWord() and not @props.playing
      @scrollToMe() if @isMounted()

    space = if @props.word.get('after') is ' ' then ' ' else ''
    span
      onClick: @handleClick
      className: 'current-word' if @isCurrentWord()
      ,
      @props.word.get('word') + space


Elem = React.createClass

  isCurrentPara: ->
    getCurrentWord(@props.words, @props.current).get('parent') is
      @props.elem.get('cid')

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
    paused = (@props.playing and not nextProps.playing)
    return this_para or next_para or paused

  render: ->
    ReactElem = React.DOM[@props.elem.get('node_name')]

    attrs = _.extend @props.elem.get('attrs'),
      # NOTE: this will override any existing className.
      # (which currently doesn't matter since `sanitize` cleans them out)
      # TODO: fix that.
      className: if @isCurrentPara() then 'current-para'

    current = @props.current
    words = @props.words
    playing = @props.playing
    children = [
      ElemOrWord({elem, current, words, playing}) \
      for elem in @props.elem.get('children').toArray()
    ]

    ReactElem(attrs, children)


module.exports = ElemOrWord

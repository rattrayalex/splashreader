React = require 'react/addons'
_ = require 'lodash'

Actions = require('../Actions')
{scrollToNodeOnce} = require('../article_utils.coffee')
{isPlaying} = require('../stores/computed')

{span} = React.DOM

# func instead of React b/c too much overhead!
getElemOrWord = (props) ->
  if typeof props.elem is "number"
    WordFactory
      word: props.words.get(props.elem)
      status: props.status
      parent: props.parent
  else if props.elem?
    ElemFactory
      elem: props.elem
      words: props.words
      status: props.status
      current: props.current
  else
    span {}


Word = React.createClass
  displayName: 'Word'

  handleClick: ->
    Actions.wordChange.push
      idx: @props.word.get('idx')
      source: 'click'

  maybeScrollToMe: ->
    if not @props.status.get('rsvp_mode')
      return @scrollToMe() if @isCurrentWord()

    if @isCurrentWord() and not isPlaying(@props.status)
      unless @props.status.get('para_change') and @isLastWordInPara()
        @scrollToMe()

  scrollToMe: ->
    if @isMounted()
      scrollToNodeOnce @getDOMNode()

  isCurrentWord: ->
    @props.word.get('current')

  isLastWordInPara: ->
    @props.parent.get('end_word') is @props.word.get('idx')

  shouldComponentUpdate: (nextProps) ->
    changed = (@props.word isnt nextProps.word)
    paused_here = (
      nextProps.word.get('current') and
      isPlaying(@props.status) and
      not isPlaying(nextProps.status)
    )
    return changed or paused_here

  render: ->
    if not @props.word?
      return span {}

    @maybeScrollToMe()

    className = React.addons.classSet
      'current-word': @isCurrentWord()
      'bounceIn': @isCurrentWord() and @props.status.get('rsvp_mode')

    space = if @props.word.get('after') is ' ' then ' ' else ''
    span
      onClick: @handleClick
      className: className
      ,
      @props.word.get('word') + space


Elem = React.createClass
  displayName: 'Elem'

  isCurrentPara: ->
    @props.current.get('parent') is @props.elem.get('cid')

  shouldComponentUpdate: (nextProps) ->
    if nextProps.status.get('rsvp_mode')
      if isPlaying(nextProps.status)
        return false

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
    just_paused = (isPlaying(@props.status) and not isPlaying(nextProps.status))
    return this_para or next_para or just_paused

  render: ->
    ReactElem = React.DOM[@props.elem.get('node_name')]

    attrs = @props.elem.get('attrs').toJS()
    if @isCurrentPara()
      attrs.className ?= ''
      attrs.className += ' current-para'

    words = @props.words
    status = @props.status
    current = @props.current
    parent = @props.elem
    children = [
      getElemOrWord({elem, words, status, current, parent}) \
      for elem in @props.elem.get('children').toArray()
    ]

    ReactElem(attrs, children)


WordFactory = React.createFactory Word
ElemFactory = React.createFactory Elem


module.exports = Elem

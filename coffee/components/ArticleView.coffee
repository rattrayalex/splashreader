React = require 'react'
validator = require 'validator'
$ = require 'jQuery'
_ = require 'underscore'

router = require('../router')
dispatcher = require('../dispatcher')
deferUpdateMixin = require('./deferUpdateMixin')

{h1, div, span, form, input, button, p, a, em, small, hr} = React.DOM


getElemOrWord = (elem, current) ->
  if elem.get('word')?
    Word({elem, current})
  else
    Elem({elem, current})


scrollToNode = (node) ->
  offset = (window.innerHeight * .32) + 40
  # document.body.scrollTop = @getDOMNode().offsetTop - offset
  $('html,body').animate
    scrollTop: node.offsetTop - offset
  , 500


Word = React.createClass

  handleClick: ->

    dispatcher.dispatch
      actionType: 'change-word'
      word: @props.elem
      source: 'click'

  scrollToMe: ->
    scrollToNode @getDOMNode()

  isCurrentWord: ->
    @props.current.get('word') is @props.elem

  componentDidMount: ->
    @props.elem.on 'change', ( => @forceUpdate() ), @
    # @props.elem.set
    #   react_elem: @
    @props.elem.on 'scroll', =>
      @scrollToMe()
    , @

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
    scrollToNode @getDOMNode()

  componentDidMount: ->
    # # bind react elem to model
    # @props.elem.set
    #   react_elem: @

    @props.elem.on 'change', =>
      @forceUpdate()
      # @scrollToMe() if @isCurrentPara()
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


CollectURL = React.createClass

  handleSubmit: (e) ->
    e.preventDefault()
    url = @refs.url.getDOMNode().value
    if not _.contains ['http://', 'https://'], url[0..6]
      url = 'http:// ' + url

    if not validator.isURL(url)
      console.log 'isnt url'
      @setState
        error: 'not-url'
    else
      url = '/' + url
      router.navigate url,
        trigger: true
    false

  render: ->
    div {},
      div {
        className: 'text-center'
      },
        h1 {}, "SplashReader"
        p {}, "A speed reader you'll actually want to use."
        form {
          className: 'form'
          style:
            marginTop: 30
          onSubmit: @handleSubmit
        },
          div {
            className: 'form-group'
          },
            div {
              className: 'input-group'
            },
              div {
                className: 'input-group-addon'
              }, "http://"
              input {
                className: 'form-control'
                type: 'text'
                placeholder: 'Enter an article URL'
                ref: 'url'
              }
              span {
                className: 'input-group-btn'
              },
                button {
                  type: 'submit'
                  className: 'btn btn-warning'
                },
                  "Speed Read "
                  span {
                    className: 'glyphicon glyphicon-forward'
                  }

Masthead = React.createClass

  getMarginBottom: ->
    target = (@props.padding - @getDOMNode().clientHeight * 2)
    min = 20
    Math.max target, min

  render: ->
    if @props.article.get('title')
      date = new Date @props.article.get('date')

      div {
        className: 'masthead'
        style:
          paddingBottom: 60
      },
        h1 {}, @props.article.get('title')
        hr {}
        div {className: 'row'},
          div {className: 'col-sm-6'},
            small {className: 'text-muted'},
              "By " if @props.article.get('author')
            small {},
              @props.article.get('author')
            div {},
              small {className: 'text-muted'},
                "on " if date
              small {},
                date.toDateString()

          div {className: 'col-sm-6'},
            small {},
              a {
                className: 'pull-right text-muted'
                href: @props.article.get('url')
                target: '_blank'
              },
                "from #{ @props.article.get('domain') } "
                span {
                  className: 'glyphicon glyphicon-share-alt'
                }
    else
      div {}


ArticleFooter = React.createClass

  mixins: [deferUpdateMixin]

  componentDidMount: ->
    @props.words.on 'add remove reset', ( => @deferUpdate() ), @

  componentWillUnmount: ->
    @props.words.off null, null, @

  render: ->
    if @props.words.length < 2
      div {}
    else
      total_time = @props.words.getTotalTime().toFixed(1)
      pluralize = unless total_time is 1 then "s" else ""

      div {},
        hr {}
        small {
          className: 'text-muted pull-right'
        },
          em {},
            "You just read #{ @props.words.length } words
             in #{ total_time } minute#{ pluralize }."


ArticleViewDisplay = React.createClass

  mixin: [deferUpdateMixin]

  getPadding: ->
    window.innerHeight * .4

  getPaddingTop: ->
    if @refs.masthead
      @getPadding() - @refs.masthead.getDOMNode().clientHeight
    else
      @getPadding()

  componentDidMount: ->
    @props.status.on 'change', ( => @deferUpdate() ), @
    @props.article.on 'change', ( => @deferUpdate() ), @
    $(window).on 'resize', ( => @deferUpdate() )

  componentWillUnmount: ->
    @props.status.off null, null, @
    @props.article.off null, null, @

  render: ->
    div {
      className: 'scroll-box'
      style:
        paddingTop: @getPaddingTop()
        paddingBottom: @getPadding()
        # visibility instead of display b/c it retains the scroll position
        visibility: if @props.status.get('playing') then 'hidden' else 'visible'
    },
      Masthead {
        article: @props.article
        padding: @getPadding()
        ref: 'masthead'
      }
      if @props.article.get('elem')
        Elem {
          elem: @props.article.get('elem')
          current: @props.current
        }
      else
        CollectURL {}
      ArticleFooter {
        words: @props.words
      }

module.exports = {Elem, ArticleViewDisplay}

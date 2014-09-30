React = require 'react'
validator = require 'validator'
$ = require 'jQuery'
_ = require 'underscore'

router = require('../router')
dispatcher = require('../dispatcher')

{h1, div, span, form, input, button, p, a, hr} = React.DOM


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
    offset = (window.innerHeight * .32) + 40
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
  render: ->
    if @props.article.get('title')
      date = new Date @props.article.get('date')

      div {
        className: 'masthead'
      },
        h1 {}, @props.article.get('title')
        hr {}
        div {className: 'row'},
          div {className: 'col-sm-6'},
            span {className: 'text-muted'},
              "By " if @props.article.get('author')
            span {},
              @props.article.get('author')
            span {className: 'text-muted'},
              ", " if @props.article.get('author') and date
              "on " if date
            span {},
              date.toDateString()

          div {className: 'col-sm-6'},
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



ArticleViewDisplay = React.createClass

  componentDidMount: ->
    @props.status.on 'change', ( => @forceUpdate() ), @
    @props.article.on 'change', ( => @forceUpdate() ), @

  componentWillUnmount: ->
    @props.status.off null, null, @
    @props.article.off null, null, @

  render: ->
    div {
      className: 'scroll-box'
      style:
        paddingTop: window.innerHeight * .4
        paddingBottom: window.innerHeight * .4
        # visibility instead of display b/c it retains the scroll position
        visibility: if @props.status.get('playing') then 'hidden' else 'visible'
    },
      Masthead {
        article: @props.article
      }
      if @props.article.get('elem')
        Elem {
          elem: @props.article.get('elem')
          current: @props.current
        }
      else
        CollectURL {}

module.exports = {Elem, ArticleViewDisplay}

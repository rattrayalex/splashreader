React = require 'react/addons'
validator = require 'validator'
$ = require 'jQuery'
_ = require 'underscore'

router = require('../router')
dispatcher = require('../dispatcher')
FluxBone = require('./FluxBone')
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
      getElemOrWord(elem, @props.current) \
      for elem in @props.elem.get('children').models
    ]

    ReactElem(attrs, children)


CollectURL = React.createClass

  handleSubmit: (e) ->
    e.preventDefault()
    url = @refs.url.getDOMNode().value
    if not _.contains ['http://', 'https:/'], url[0..6]
      console.log 'prepending http://'
      url = 'http://' + url

    if not validator.isURL(url)
      console.log 'isnt url', url
      @setState
        error: 'not-url'
    else
      url = '/' + url
      router.navigate url,
        trigger: true
    false

  render: ->
    div {}
      ,
      div
        className: 'text-center'
        ,
        h1 {}
          ,
          "SplashReader"
        p {}
          ,
          "A speed reader that lets you come up for air."
        form
          className: 'form'
          style:
            marginTop: 30
          onSubmit: @handleSubmit
          ,
          div
            className: 'form-group'
            ,
            div
              className: 'input-group'
              ,
              div
                className: 'input-group-addon'
                ,
                "http://"
              input
                className: 'form-control'
                type: 'text'
                placeholder: 'Enter an article URL'
                defaultValue: @props.url
                ref: 'url'

              span
                className: 'input-group-btn'
                ,
                button
                  type: 'submit'
                  className: 'btn btn-warning'
                  ,
                  span
                    className: "hidden-xs"
                    ,
                    "Splash "
                  span
                    className: 'glyphicon glyphicon-forward'


Masthead = React.createClass

  getMarginBottom: ->
    target = (@props.padding - @getDOMNode().clientHeight * 2)
    min = 20
    Math.max target, min

  render: ->
    if not  @props.article.get('title')
      return div {}

    date = @props.article.get('date')

    div
      className: 'masthead'
      style:
        paddingBottom: 60
      ,
      h1 {}
        ,
        @props.article.get('title')
      hr {}
      div
        className: 'row'
        ,
        div
          className: 'col-sm-6'
          ,
          small
            className: 'text-muted'
            ,
            "By " if @props.article.get('author')
          small {}
            ,
            @props.article.get('author')
          div {}
            ,
            small
              className: 'text-muted'
              ,
              "on " if date
            small {}
              ,
              new Date(date).toDateString() if date

        div
          className: 'col-sm-6'
          ,
          small {}
            ,
            a
              className: 'pull-right text-muted'
              href: @props.article.get('url')
              target: '_blank'
              ,
              "from #{ @props.article.get('domain') } "
              span
                className: 'glyphicon glyphicon-share-alt'


ArticleFooter = React.createClass

  mixins: [
    deferUpdateMixin
    FluxBone.CollectionMixin('words', 'add remove reset', 'deferUpdate')
  ]

  render: ->
    total_time = @props.words.getTotalTime().toFixed(1)
    if @props.words.length < 2 or isNaN(total_time)
      div {}
    else
      pluralize = unless total_time is 1 then "s" else ""

      div {}
        ,
        hr {}
        small
          className: 'text-muted pull-right'
          ,
          em {}
            ,
            "You just read #{ @props.words.length } words
             in #{ total_time } minute#{ pluralize }."


LoadingIcon = React.createClass
  render: ->
    div
      style:
        position: 'absolute'
        top: 0
        left: 0
        right: 0
        bottom: 0
        margin: 'auto'
        zIndex: 100
        # background: 'rgba(0,0,0,.1)'
      ,
      div
        style:
          display: 'table'
          textAlign: 'center'
          width: '100%'
          height: '100%'
        ,
        span
          className: "glyphicon glyphicon-repeat fa-spin"
          style:
            fontSize: '500%'
            opacity: .5
            display: 'table-cell'
            verticalAlign: 'middle'


ArticleViewDisplay = React.createClass

  mixins: [
    FluxBone.ModelMixin('status', 'change:playing')
    FluxBone.ModelMixin('article', 'change')
    FluxBone.ModelMixin('page', 'change')
  ]

  getLoadingState: ->
    if @props.page.get('url') and not @props.article.get('elem')
      true
    else if @props.page.get('url') is not @props.article.get('url')
      true
    else
      false

  getPadding: ->
    window.innerHeight * .4 - 40

  componentDidMount: ->
    $(window).on 'resize', ( => @forceUpdate() )

  render: ->
    loading = @getLoadingState()

    div
      className: if loading then 'loading' else ''
      style:
        paddingTop: @getPadding()
        paddingBottom: @getPadding()
        # visibility instead of display b/c it retains the scroll position
        visibility: if @props.status.get('playing') then 'hidden' else 'visible'
      ,
      if loading
        LoadingIcon {}
      Masthead
        article: @props.article
        padding: @getPadding()
        ref: 'masthead'
      if @props.article.has('elem')
        Elem
          elem: @props.article.get('elem')
          current: @props.current
      else
        CollectURL
          url: @props.article.get('url') or @props.page.get('url')
      ArticleFooter
        words: @props.words


module.exports = {Elem, ArticleViewDisplay}

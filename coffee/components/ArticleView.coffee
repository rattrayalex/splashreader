React = require 'react/addons'
$ = require 'jQuery'

FluxBone = require('./FluxBone')
deferUpdateMixin = require('./deferUpdateMixin')

ElemOrWord = require('./ElemOrWord')
{HomePage} = require('./HomePage')

{h1, div, span, form, input, button, p, a, em, small, hr} = React.DOM


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
    # FluxBone.ModelMixin('status', 'change:playing')
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
      className: "article-main #{ if loading then 'loading' else '' }"
      style:
        paddingTop: @getPadding()
        paddingBottom: @getPadding()
        # visibility instead of display b/c it retains the scroll position
        visibility: if @props.status.playing.getValue() then 'hidden' else 'visible'
      ,
      if loading
        LoadingIcon {}
      Masthead
        article: @props.article
        padding: @getPadding()
        ref: 'masthead'
      if @props.article.has('elem')
        ElemOrWord
          elem: @props.article.get('elem')
          current: @props.current
      else
        HomePage
          url: @props.article.get('url') or @props.page.get('url')
      ArticleFooter
        words: @props.words


module.exports = {ArticleViewDisplay}

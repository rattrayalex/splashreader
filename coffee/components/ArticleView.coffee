React = require 'react/addons'

FluxBone = require('./FluxBone')
deferUpdateMixin = require('./deferUpdateMixin')

ElemOrWord = require('./ElemOrWord')

computed = require('../stores/computed')

{h1, div, span, form, input, button, p, a, em, small, hr} = React.DOM


Masthead = React.createClass

  render: ->
    if not  @props.article.has('title')
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
  ]

  render: ->
    total_time = computed.getTotalTime(@props.words, @props.status).toFixed(1)
    if @props.words.size < 2 or isNaN(total_time)
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
            "You just read #{ @props.words.size } words
             in #{ total_time } minute#{ pluralize }."


ArticleViewDisplay = React.createClass

  mixins: [
    React.addons.PureRenderMixin
  ]

  render: ->
    div {},
      Masthead
        article: @props.article
      if @props.article.get('elem') and @props.words.size
        ElemOrWord
          elem: @props.article.get('elem')
          words: @props.words
          current: @props.current
      ArticleFooter
        words: @props.words
        status: @props.status


module.exports = {ArticleViewDisplay}

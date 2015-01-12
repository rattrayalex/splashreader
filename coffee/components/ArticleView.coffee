React = require 'react/addons'
Elem = React.createFactory require('./Elem')

computed = require('../stores/computed')

{h1, div, span, form, input, button, p, a, em, small, hr} = React.DOM


Masthead = React.createFactory React.createClass
  displayName: 'Masthead'

  render: ->
    if not  @props.article.has('title')
      return div {}

    date = @props.article.get('date')

    div
      className: 'masthead'
      style:
        paddingBottom: 60
      ,
      h1 {},
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
          small {},
            @props.article.get('author')
          div {},
            small
              className: 'text-muted'
              ,
              "on " if date
            small {},
              new Date(date).toDateString() if date

        div
          className: 'col-sm-6'
          ,
          if @props.article.get('url') and @props.article.get('domain')
            small {},
              a
                className: 'pull-right text-muted'
                href: @props.article.get('url')
                target: '_blank'
                ,
                "from #{ @props.article.get('domain') } "
                span
                  className: 'glyphicon glyphicon-share-alt'


ArticleFooter = React.createFactory React.createClass
  displayName: 'ArticleFooter'

  render: ->
    total_time = computed.getTotalTime(@props.words, @props.status).toFixed(1)
    if @props.words.size < 2 or isNaN(total_time)
      div {}
    else
      pluralize = unless total_time is 1 then "s" else ""

      div {},
        hr {}
        small
          className: 'text-muted pull-right'
          ,
          em {},
            "You just read #{ @props.words.size } words
             in #{ total_time } minute#{ pluralize }."


ArticleView = React.createClass
  displayName: 'ArticleView'

  mixins: [
    React.addons.PureRenderMixin
  ]

  isShown: ->
    not computed.isPlaying(@props.status)

  render: ->
    div
      style:
        # visibility instead of display b/c it retains the scroll position
        visibility: if @isShown() then 'visible' else 'hidden'
      ,
      Masthead
        article: @props.article
      if @props.article.get('elem') and @props.words.size
        Elem
          elem: @props.article.get('elem')
          words: @props.words
          status: @props.status
          current: @props.current
      ArticleFooter
        words: @props.words
        status: @props.status


module.exports = ArticleView

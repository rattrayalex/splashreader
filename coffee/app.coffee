React = require('react')

ArticleStore = require('./stores/ArticleStore')
{Elem} = require('./components/ArticleView')
dispatcher = require('./dispatcher')

example_data = require("./example_data")


MainComponent = React.createClass
  componentDidMount: ->
    @props.article.on 'change', ( => @forceUpdate() ), @
  componentWillUnmount: ->
    @props.article.off null, null, @

  render: ->
    if @props.article.get('elem')
      Elem {
        elem: @props.article.get('elem')
      }
    else
      React.DOM.div {},
        'No info yet...'

main = ->
  url = "https://medium.com/@rattrayalex/daily-ten-965db68ef86f"

  React.renderComponent(
    MainComponent {
      article: ArticleStore
    }
    document.querySelector('.main')
  )

  dispatcher.dispatch
    actionType: 'process-article'
    raw_html: example_data



main()





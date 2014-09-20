React = require('react')

ArticleStore = require('./stores/ArticleStore')
WordStore = require('./stores/WordStore')
CurrentWordStore = require('./stores/CurrentWordStore')
{Elem} = require('./components/ArticleView')
RsvpDisplay = require('./components/RsvpDisplay')
dispatcher = require('./dispatcher')

example_data = require("./example_data")


MainComponent = React.createClass
  componentDidMount: ->
    @props.article.on 'change', ( => @forceUpdate() ), @
    @props.words.once 'add', =>
      @forceUpdate()
    , @

  componentWillUnmount: ->
    @props.article.off null, null, @

  render: ->

    if @props.article.get('elem') and @props.words.length

      # if @props.current.isEmpty()
      #   dispatcher.dispatch
      #     actionType: 'change-word'
      #     word: @props.words.at(0)

      React.DOM.div {},
        RsvpDisplay {
          word: @props.current
          key: 'current-word'
        }
        Elem {
          elem: @props.article.get('elem')
        }
    else
      React.DOM.div {},
        'No info yet...'

main = ->
  url = "https://medium.com/@rattrayalex/daily-ten-965db68ef86f"

  dispatcher.dispatch
    actionType: 'process-article'
    raw_html: example_data

  React.renderComponent(
    MainComponent {
      article: ArticleStore
      words: WordStore
      current: CurrentWordStore
    }
    document.querySelector('.main')
  )

  setInterval ->
    dispatcher.dispatch
      actionType: 'change-word'
      word: WordStore.at(WordStore.indexOf(CurrentWordStore.at(0)) + 1)
  , 1000



main()





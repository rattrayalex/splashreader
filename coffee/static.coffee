React = require('react')

Body = require('./components/Body')

main = ->
  React.renderToString(
    Body
      current: null
      article: null
      words: null
      page: null
      status: null
  )

module.exports = main
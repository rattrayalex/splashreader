React = require('react')

Body = require('./components/Body')

main = ->
  React.renderComponentToString(
    Body
      article: null
      words: null
      page: null
      status: null
  )

module.exports = main
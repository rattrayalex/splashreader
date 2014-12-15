$ = require 'jQuery'

scrollToNode = (node) ->
  offset = (window.innerHeight * .32) + 40
  # document.body.scrollTop = @getDOMNode().offsetTop - offset
  $('html,body').animate
    scrollTop: node.offsetTop - offset
  , 500

module.exports = {
  scrollToNode
}
$ = require 'jQuery'

isAnimating = false
scrollToNode = (node) ->
  if isAnimating
    return
  isAnimating = true

  offset = (window.innerHeight * .32) + 40
  # document.body.scrollTop = @getDOMNode().offsetTop - offset
  $('html,body').animate
    scrollTop: node.offsetTop - offset
  , 500, -> isAnimating = false

module.exports = {
  scrollToNode
}
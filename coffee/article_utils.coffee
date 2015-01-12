$ = require 'jQuery'

# this one prevents double-scroll, though I've decided to retire it for now.
isAnimating = false
scrollToNodeOnce = (node) ->
  if isAnimating
    return
  isAnimating = true

  offset = (window.innerHeight * .32) + 40
  # document.body.scrollTop = @getDOMNode().offsetTop - offset
  $('html,body').animate
    scrollTop: node.offsetTop - offset
  , 500, -> isAnimating = false

scrollToNode = (node) ->
  offset = (window.innerHeight * .32) + 40
  # document.body.scrollTop = @getDOMNode().offsetTop - offset
  $('html,body').animate
    scrollTop: node.offsetTop - offset
  , 500

module.exports = {
  scrollToNode
}
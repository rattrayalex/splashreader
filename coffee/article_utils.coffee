$ = require 'jQuery'

# this one prevents double-scroll, though I've decided to retire it for now.
isAnimating = false
scrollToNodeOnce = (node) ->
  if isAnimating
    return

  offset = (window.innerHeight * .32) + 40
  target = Math.round(node.offsetTop - offset)
  current = $('body').scrollTop() or $('html').scrollTop()  # x-browser

  unless target is current
    console.log "target isnt current", target, current
    isAnimating = true
    $('html,body').animate
      scrollTop: target
    , 500, -> isAnimating = false

scrollToNode = (node) ->
  offset = (window.innerHeight * .32) + 40
  target = node.offsetTop - offset
  current = $('body').scrollTop() or $('html').scrollTop()  # x-browser

  unless target is current
    $('html,body').animate
      scrollTop: target
    , 500

module.exports = {
  scrollToNode,
  scrollToNodeOnce
}
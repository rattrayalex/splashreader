Backbone = require 'backbone'
Actions = require './Actions'

class SplashRouter extends Backbone.Router

  initialize: ->
    @route "", "home"
    @route /(.+)/, "url"

  home: ->
    Actions.changePage.push null

  url: (url) ->
    Actions.changePage.push url


module.exports = new SplashRouter()

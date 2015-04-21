Backbone = require 'backbone'
Actions = require './Actions'

class SplashRouter extends Backbone.Router

  initialize: ->
    @route "", "home"
    @route /(.+)/, "url"

  home: ->
    Actions.pageChange.push
      url: null

  url: (url) ->
    Actions.pageChange.push
      url: url


module.exports = new SplashRouter()

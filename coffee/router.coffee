Backbone = require 'backbone'
dispatcher = require './dispatcher'

class SplashRouter extends Backbone.Router


  initialize: ->
    @route "", "home"
    @route /(.+)/, "url"

  home: ->
    dispatcher.dispatch
      actionType: 'page-change'
      url: null

  url: (url) ->
    dispatcher.dispatch
      actionType: 'page-change'
      url: url


module.exports = new SplashRouter()

Backbone = require 'backbone'
dispatcher = require './dispatcher'

class SplashRouter extends Backbone.Router


  initialize: ->
    console.log 'SplashRouter init'
    @route "", "home"
    @route /(.+)/, "url"

  home: ->
    console.log 'home!'
    dispatcher.dispatch
      actionType: 'page-change'
      url: null

  url: (url) ->
    console.log 'url!'
    dispatcher.dispatch
      actionType: 'page-change'
      url: url


module.exports = new SplashRouter()

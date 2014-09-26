Backbone = require 'backbone'

SplashRouter = require '../router'
dispatcher = require '../dispatcher'


class CurrentPageModel extends Backbone.Model
  initialize: ->
    @dispatchToken = dispatcher.register @dispatcherCallback

  dispatcherCallback: (payload) =>
    switch payload.actionType
      when 'page-change'
        @set
          url: payload.url
        console.log 'url changed to ', payload.url

CurrentPageStore = new CurrentPageModel()
module.exports = CurrentPageStore

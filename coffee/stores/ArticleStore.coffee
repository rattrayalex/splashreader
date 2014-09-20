Backbone = require 'backbone'

dispatcher = require '../dispatcher'
htmlToArticle = require '../htmlToArticle'


class ArticleModel extends Backbone.Model
  initialize: ->
    @dispatchToken = dispatcher.register @dispatcherCallback

  dispatcherCallback: (payload) =>
    switch payload.actionType
      when 'process-article'
        elem = htmlToArticle(payload.raw_html)
        @set {elem}


ArticleStore = new ArticleModel()

module.exports = ArticleStore

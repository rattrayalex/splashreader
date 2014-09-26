Backbone = require 'backbone'
validator = require 'validator'
$ = require 'jQuery'

CurrentPageStore = require './CurrentPageStore'
WordStore = require './WordStore'

dispatcher = require '../dispatcher'
constants = require '../constants'
htmlToArticle = require '../htmlToArticle'


class ArticleModel extends Backbone.Model
  initialize: ->
    @dispatchToken = dispatcher.register @dispatcherCallback

  dispatcherCallback: (payload) =>
    switch payload.actionType
      when 'process-article'
        WordStore.reset()
        elem = htmlToArticle(payload.raw_html)
        @set {elem}

      when 'page-change'
        dispatcher.waitFor [CurrentPageStore.dispatchToken]

        if not validator.isURL(payload.url)
          return

        req_url = "https://readability.com/api/content/v1/parser" +
          '?token=' + constants.READABILITY_TOKEN +
          '&url=' + payload.url +
          '&callback=?' # for JSONP, which allows cross-domain ajax.

        $.getJSON req_url
          .then (data, status, jqXHR) ->
            console.log 'got response', data
            dispatcher.dispatch
              actionType: 'process-article'
              raw_html: data.content

          .fail (err) ->
            throw err


ArticleStore = new ArticleModel()
module.exports = ArticleStore

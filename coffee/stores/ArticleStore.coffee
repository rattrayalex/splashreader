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

        {title, author, url, date, domain} = payload
        @set {title, author, url, date, domain}

        elem = htmlToArticle(payload.raw_html)
        @set {elem}

      when 'page-change'
        dispatcher.waitFor [CurrentPageStore.dispatchToken]

        if not validator.isURL(payload.url)
          if not payload.url
            console.log 'back to home page'
            @clear()
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
              title: data.title
              author: data.author
              url: data.url
              domain: data.domain
              date: data.date_published

          .fail (err) ->
            # throw err

            data = require('../example_data')

            console.log 'REQ FAILED USING TEST DATA', data
            setTimeout ->
              dispatcher.dispatch
                actionType: 'process-article'
                raw_html: data.content
                title: data.title
                author: data.author
                url: data.url
                domain: data.domain
                date: data.date_published
            , 0

ArticleStore = new ArticleModel()
module.exports = ArticleStore

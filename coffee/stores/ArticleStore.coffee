Backbone = require 'backbone'
validator = require 'validator'
$ = require 'jQuery'
_ = require 'underscore'

read = require 'node-readability'

NestedBackbone = require './NestedBackbone'
OfflineBackbone = require './OfflineBackbone'

CurrentPageStore = require './CurrentPageStore'
WordStore = require './WordStore'
{ElementModel} = require './ArticleModels'

dispatcher = require '../dispatcher'
constants = require '../constants'
htmlToArticle = require '../htmlToArticle'


getUrlDomain = (url) ->
  # from stackoverflow.com/a/8498668
  a = document.createElement('a')
  a.href = url
  a.hostname


class ArticleModel extends NestedBackbone.Model

  nested:
    'elem': ElementModel

  initialize: ->
    # _.extend @, OfflineBackbone.Model
    # @localLoad()
    # @on 'change', (model, options) =>
    #   console.log 'options, model', options, model
    #   @localSave(model)

    @dispatchToken = dispatcher.register @dispatcherCallback

  dispatcherCallback: (payload) =>
    switch payload.actionType
      when 'process-article'
        WordStore.reset()

        {title, author, url, date, domain} = payload
        @set {title, author, url, date, domain}

        elem = htmlToArticle(payload.raw_html)
        @set {elem}

        console.log "article json", @toJSON()

      when 'page-change'
        dispatcher.waitFor [CurrentPageStore.dispatchToken]

        if not validator.isURL(payload.url)
          if not payload.url
            console.log 'back to home page'
            @clear()
          return

        # read payload.url, {withCredentials: false}, (error, article, data) ->
        #   console.log 'got readability', error, article, data
        #   dispatcher.dispatch
        #     actionType: 'process-article'
        #     raw_html: article.content
        #     title: article.title
        #     author: null
        #     url: payload.url
        #     domain: data.domain or getUrlDomain(payload.url)
        #     date: null

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

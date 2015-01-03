Immutable = require 'immutable'
validator = require 'validator'
$ = require 'jQuery'

read = require 'node-readability'

dispatcher = require '../dispatcher'
constants = require '../constants'
htmlToArticle = require '../htmlToArticle'


getUrlDomain = (url) ->
  # from stackoverflow.com/a/8498668
  a = document.createElement('a')
  a.href = url
  a.hostname


class ArticleStore

  constructor: (@store) ->
    dispatcher.tokens.ArticleStore = dispatcher.register @dispatcherCallback

  cursor: (path...) ->
    @store.cursor('article').cursor(path)

  dispatcherCallback: (payload) =>
    switch payload.actionType
      when 'process-article'
        dispatcher.waitFor([dispatcher.tokens.WordStore])

        {title, author, url, date, domain, raw_html} = payload
        @cursor().update ->
          Immutable.fromJS {title, author, url, date, domain, raw_html}

        elem = htmlToArticle(raw_html)
        @cursor('elem').update -> elem

      when 'page-change'
        dispatcher.waitFor [dispatcher.tokens.CurrentPageStore]

        url = payload.url

        # going back to the home page, or ignoring if invalid URL.
        if not validator.isURL(url)
          if not url
            console.log 'back to home page'
            @cursor().clear()
          return

        # remove hashtag and thereafter, can't have two titles
        url = url.split('#')[0]

        # when you change from one page directly to another
        if @cursor().get('url') isnt url
          console.log 'going to clear Article'
          @cursor().clear()
          @cursor('url').update -> url

        req_url = "https://readability.com/api/content/v1/parser" +
          '?token=' + constants.READABILITY_TOKEN +
          '&url=' + url +
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
            console.log 'Readability failed, will try read lib:'

            read url, {withCredentials: false}, (error, article, data) ->
              console.log 'got readability', error, article, data

              if error
                console.log 'READ FAILED USING TEST DATA', data
                data = article = require('../example_data')

              dispatcher.dispatch
                actionType: 'process-article'
                raw_html: article.content
                title: article.title
                author: null
                url: url
                domain: data.domain or getUrlDomain(url)
                date: null

module.exports = ArticleStore

Immutable = require 'immutable'
Bacon = require 'baconjs'
validator = require 'validator'
$ = require 'jQuery'

read = require 'node-readability'

Actions = require '../Actions'
constants = require '../constants'
htmlToArticle = require '../htmlToArticle'
defaults = require('./defaults')


getUrlDomain = (url) ->
  # from stackoverflow.com/a/8498668
  a = document.createElement('a')
  a.href = url
  a.hostname

_sendReadabilityRequests = (url) ->
  req_url = "https://readability.com/api/content/v1/parser" +
    '?token=' + constants.READABILITY_TOKEN +
    '&url=' + url +
    '&callback=?' # for JSONP, which allows cross-domain ajax.

  $.getJSON req_url
    .then (data, status, jqXHR) ->
      console.log 'got response', data
      Actions.processArticle.push
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

        Actions.processArticle.push
          raw_html: article.content
          title: article.title
          author: null
          url: url
          domain: data.domain or getUrlDomain(url)
          date: null


ArticleStore = Bacon.update defaults.get('article'),

  Actions.processArticle, (store, payload) ->
    {title, author, url, date, domain, raw_html} = payload
    res = Immutable.fromJS {title, author, url, date, domain, raw_html}
    Actions.postProcessArticle.push(raw_html)
    return res

  Actions.pageChange, (store, url) ->
    # going back to the home page, or ignoring if invalid URL.
    if not validator.isURL(url)
      if not url
        console.log 'back to home page'
        return Immutable.Map()

      else if url is "selection"
        console.log "url is selection, html is", window.SplashReaderExt.html
        Actions.processArticle.push
          raw_html: window.SplashReaderExt.html
          title: "[Selected Text]"
          author: null
          url: null
          domain: null
          date: null

      return store

    # remove hashtag and thereafter, can't have two titles
    url = url.split('#')[0]

    # when you change from one page directly to another
    if store.get('url') isnt url
      console.log 'going to clear Article'
      res = store.update -> Immutable.Map()
      res = res.set 'url', url

      _sendReadabilityRequests(url)

    return res

  Actions.postProcessArticle, (store, raw_html) ->
    elem = htmlToArticle(raw_html)
    store.updateIn ['elem'], -> elem


module.exports = ArticleStore

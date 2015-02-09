Bacon = require 'baconjs'
_ = require 'lodash'
validator = require 'validator'

router = require '../router'
Actions = require '../Actions'
defaults = require('./defaults')


CurrentPageStore = Bacon.update defaults.get('page'),

  Actions.requestUrl, (store, url) ->
    if not _.contains ['http://', 'https:/'], url[0..6]
      console.log 'prepending http://'
      url = 'http://' + url
    if not validator.isURL(url)
      console.log 'isnt url', url
      return store.set 'error', 'Invalid URL'
    else
      url = '/' + url
      router.navigate url,
        trigger: true
      return store

  Actions.pageChange, (store, url) ->
    console.log 'page changing to', url
    store.set 'url', url


module.exports = CurrentPageStore

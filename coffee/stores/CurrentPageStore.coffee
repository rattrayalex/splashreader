Backbone = require 'backbone'
_ = require 'underscore'
validator = require 'validator'

router = require '../router'
dispatcher = require '../dispatcher'


class CurrentPageStore
  constructor: (@store) ->
    dispatcher.tokens.CurrentPageStore = dispatcher.register @dispatcherCallback

  cursor: (path...) ->
    @store.cursor('page').cursor(path)

  dispatcherCallback: (payload) =>
    switch payload.actionType
      when 'url-requested'
        url = payload.url
        if not _.contains ['http://', 'https:/'], url[0..6]
          console.log 'prepending http://'
          url = 'http://' + url
        if not validator.isURL(url)
          console.log 'isnt url', url
          @cursor('error').update ->
            'Invalid URL'
        else
          url = '/' + url
          # perform asyncronously b/c dispatch w/in dispatch
          setTimeout ->
            router.navigate url,
              trigger: true
          , 0

      when 'page-change'
        @cursor('url').update -> payload.url
        console.log 'url changed to ', payload.url

# CurrentPageStore = new CurrentPageModel()
module.exports = CurrentPageStore

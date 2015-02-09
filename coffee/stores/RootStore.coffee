Bacon = require('baconjs')
Actions = require('../Actions')
defaults = require('./defaults')

ArticleStore = require('./ArticleStore')
CurrentPageStore = require('./CurrentPageStore')
RsvpStatusStore = require('./RsvpStatusStore')
WordStore = require('./WordStore')


RootStore = Bacon.update defaults,

  ArticleStore.changes(), (store, article) ->
    store.set 'article', article

  CurrentPageStore.changes(), (store, page) ->
    store.set 'page', page

  RsvpStatusStore.changes(), (store, status) ->
    store.set 'status', status

  WordStore.changes(), (store, words) ->
    store.set 'words', words


module.exports = RootStore

Bacon = require('baconjs')
Actions = require('./Actions')
defaults = require('./defaults')

RootStore = Bacon.update defaults,
  require('./ArticleStore').skipDuplicates(), (store, article) ->
    store.set 'article', article
  require('./CurrentPageStore').skipDuplicates(), (store, current) ->
    store.set 'current', current
  require('./RsvpStatusStore').skipDuplicates(), (store, status) ->
    store.set 'status', status
  require('./WordStore').skipDuplicates(), (store, wordStore) ->
    store.set 'words', words

module.exports = RootStore
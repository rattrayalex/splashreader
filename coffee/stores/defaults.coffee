Imm = require 'immutable'

module.exports = Imm.fromJS
  page:
    url: window.location.hash.split('#')[1]
  article: {}
  words: []
  status:
    playing: false
    para_change: false
    wpm: 500
    menuShown: false

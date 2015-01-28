Imm = require 'immutable'

module.exports =
  page: Imm.fromJS
    url: window.location.hash.split('#')[1]
  article: Imm.Map()
  status: Imm.fromJS
    playing: false
    para_change: false
    wpm: 500
    menuShown: false

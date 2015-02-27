Imm = require 'immutable'

module.exports = Imm.fromJS
  page:
    url: null
  article:
    raw_html: null
    title: null
    author: null
    url: null
    domain: null
    date: null
  words: []
  status:
    playing: false
    para_change: false
    wpm: 500
    menuShown: false
    rsvp_mode: false

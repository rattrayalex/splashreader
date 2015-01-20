Imm = require 'immutable'

module.exports =
  page: Imm.fromJS
    url: window.location.hash.split('#')[1]
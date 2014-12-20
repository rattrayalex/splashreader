# Cortex = require('../../node_modules/cortexjs/src/cortext')  # TODO; file issue
Cortex = require('cortexjs')  # TODO; file issue

# RsvpStatusStore = require('./RsvpStatusStore')

store = new Cortex({})

# new RsvpStatusStore(store)

module.exports = store

Dispatcher = require('flux').Dispatcher

dispatcher = new Dispatcher()
dispatcher.tokens = {}
window.dispatcher = dispatcher

module.exports = dispatcher
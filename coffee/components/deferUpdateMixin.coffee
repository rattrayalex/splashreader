
module.exports =
  deferUpdate: ->
    setTimeout =>
      @forceUpdate()
    , 0

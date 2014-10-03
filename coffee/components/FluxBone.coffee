
module.exports =

  ModelMixin: (model_name, event_name="all") ->

    eventCallbackName = "_eventCallbacks_#{ model_name }_#{ event_name }"

    mixin =

      componentDidMount: ->
        @props[model_name].on event_name,
          @[eventCallbackName]
          @

      componentWillUnmount: ->
        @props[model_name].off event_name,
          @[eventCallbackName]
          @

    mixin[eventCallbackName] = () ->
      setTimeout =>
        @forceUpdate()
      , 0

    return mixin


  CollectionMixin: (collection_name, event_name="all") ->

    eventCallbackName = "_eventCallbacks_#{ collection_name }_#{ event_name }"

    mixin =

      componentDidMount: ->
        @props[collection_name].on event_name,
          @[eventCallbackName]
          @

      componentWillUnmount: ->
        @props[collection_name].off event_name,
          @[eventCallbackName]
          @

    mixin[eventCallbackName] = () ->
      setTimeout =>
        @forceUpdate()
      , 0

    return mixin


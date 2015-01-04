React = require 'react/addons'

dispatcher = require('../dispatcher')

{div, span, h1, p, form, input, button} = React.DOM


CollectURL = React.createClass
  displayName: 'CollectURL'

  handleSubmit: (e) ->
    e.preventDefault()
    url = @refs.url.getDOMNode().value
    dispatcher.dispatch
      actionType: 'url-requested'
      url: url
    false

  render: ->
    form
      className: 'form'
      style:
        marginTop: 30
      onSubmit: @handleSubmit
      ,
      div
        className: 'form-group'
        ,
        div
          className: 'input-group'
          ,
          div
            className: 'input-group-addon'
            ,
            "http://"
          input
            className: 'form-control'
            type: 'text'
            placeholder: 'Enter an article URL'
            defaultValue: @props.url
            ref: 'url'

          span
            className: 'input-group-btn'
            ,
            button
              type: 'submit'
              className: 'btn btn-warning'
              ,
              span
                className: "hidden-xs"
                ,
                "Splash "
              span
                className: 'glyphicon glyphicon-forward'


module.exports = CollectURL

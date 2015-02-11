React = require 'react/addons'

Actions = require('../Actions')

{div, span, h1, p, form, input, button} = React.DOM


CollectURL = React.createClass
  displayName: 'CollectURL'

  handleSubmit: (e) ->
    e.preventDefault()
    url = @refs.url.getDOMNode().value
    Actions.requestUrl.push
      url: url

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

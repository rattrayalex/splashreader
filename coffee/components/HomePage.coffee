React = require 'react/addons'

CollectURL = React.createFactory require('./CollectURL')

{div, h1, p} = React.DOM


HomePage = React.createClass
  displayName: 'HomePage'

  render: ->
    div
      className: 'text-center'
      ,
      h1 {},
        "SplashReader"
      p {},
        "A speed reader that lets you come up for air."
      CollectURL
        url: @props.url


module.exports = HomePage

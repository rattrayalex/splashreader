example_data = require("./example_data")
sanitize = require('sanitize-html')

rawHtmlToReact = (raw_html) ->
  # console.log raw_html
  sanitized = sanitize(raw_html)
  # console.log sanitized
  document.body.querySelector('.main').innerHTML = sanitized

main = ->
  console.log "hello world"
  url = "https://medium.com/@rattrayalex/daily-ten-965db68ef86f"
  rawHtmlToReact(example_data)

main()





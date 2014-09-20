React = require('react')
sanitize = require('sanitize-html')

constants = require('./constants')
example_data = require("./example_data")


textToSpans = (textNode) ->
  text = textNode.nodeValue
  ' hi there '
  ' hi there'
  words = text.split /\s+/
  # spans = [React.DOM.span({}, word+' ') for word in words]
  spans = []
  for word, i in words
    if i < (words.length - 1)
      spans.push React.DOM.span({}, word+' ')
    else
      spans.push React.DOM.span({}, word)

  return spans

domAttrsToReact = (attributes) ->
  # TODO: this... at all correctly (camelCase etc)
  if not attributes?
    return {}
  if attributes.length is 0
    return {}

  # console.log attributes
  react_attrs = {}
  for i in [0 .. attributes.length - 1]
    # console.log attributes[i]
    name = attributes[i].name
    val = attributes[i].value

    if name is 'class'
      name = 'className'

    # TODO: handle style (needs to be )
    if name not in ['style'] and name in constants.ALLOWED_REACT_ATTRIBUTES
      react_attrs[name] = val

  return react_attrs

cleanedHtmlToReact = (elem) ->
  # recursively turn elems to React objs.

  # if its text, return the text.
  if typeof elem is String then return textToSpans(elem)
  if elem.nodeName is "#text" then return textToSpans(elem)

  # console.log elem.nodeName, elem
  node_name = elem.nodeName.toLowerCase()
  attrs = domAttrsToReact(elem.attributes)
  children = [cleanedHtmlToReact(child) for child in elem.childNodes]

  return React.DOM[node_name](attrs, children)


rawHtmlToReact = (raw_html) ->
  # console.log raw_html
  sanitized = sanitize(raw_html)
  # console.log sanitized
  document.body.querySelector('.plain').innerHTML = sanitized

  # string -> html by creating fake wrapper
  # stackoverflow.com/a/494348
  wrapper_elem = document.createElement('div')
  wrapper_elem.innerHTML = sanitized

  cleanedHtmlToReact(wrapper_elem)


main = ->
  # console.log "hello world"
  url = "https://medium.com/@rattrayalex/daily-ten-965db68ef86f"
  react_code = rawHtmlToReact(example_data)

  React.renderComponent(
    react_code,
    document.querySelector('.main')
  )

main()






sanitize = require('sanitize-html')
_ = require('underscore')

dispatcher = require('./dispatcher')
constants = require('./constants')
WordStore = require './stores/WordStore'
{
  ChildrenCollection,
  WordModel,
  ElementModel
} = require('./stores/ArticleModels')


isBlock = (node_name) ->
  if node_name in constants.INLINE_ELEMENTS
    false
  else
    true


textToWords = (textNode, parent) ->
  text = textNode.nodeValue
  words = text.split /\s+/

  # remove blanks
  if not text.trim()
    return null

  # turns the words into an array of Elements
  word_models = []
  for word, i in words
    # add trailing space to all words but the last one
    if i < (words.length - 1)
      word += ' '
    word_model = new WordModel()
    word_model.set {word, parent}
    word_models.push word_model

    # also add it to list of words
    WordStore.add(word_model)

  return word_models


domAttrsToDict = (attributes) ->
  # TODO: this... at all correctly (camelCase etc)
  if not attributes?
    return {}
  if attributes.length is 0
    return {}

  react_attrs = {}
  for i in [0 .. attributes.length - 1]
    name = attributes[i].name
    val = attributes[i].value

    if name is 'class'
      name = 'className'

    # TODO: handle style (needs to be )
    if name not in ['style'] and name in constants.ALLOWED_REACT_ATTRIBUTES
      react_attrs[name] = val

  return react_attrs


cleanedHtmlToElem = (node, parent) ->
  # recursively turn nodes to React objs.

  # if its text, return the text as list of WordModels.
  if node.nodeName is "#text" or typeof node is String
    return textToWords(node, parent)

  if not node.innerText.trim()
    console.log 'got an empty guy', node
    return null

  node_name = node.nodeName.toLowerCase()
  attrs = domAttrsToDict(node.attributes)

  elem = new ElementModel()
  elem.set {node_name, attrs}

  # `parent` is stored on Words, representing their nearest Block parent.
  if isBlock(node_name)
    parent = elem

  children_list = _.compact _.flatten [  # unpacks text words, removes nulls
    cleanedHtmlToElem(child, parent) for child in node.childNodes
  ]
  children = new ChildrenCollection()
  children.add(children_list)

  elem.set {children}
  return elem


rawHtmlToArticle = (raw_html) ->
  sanitized = sanitize raw_html,
    # remove empty elements.
    exclusiveFilter: (frame) -> !frame.text.trim()
    allowedTags: [
      'h1', 'h2', 'h3', 'h4', 'h5', 'h6', 'blockquote', 'p', 'a',
      'ul', 'ol', 'nl', 'li',
      'b', 'i', 'strong', 'em', 'strike', 'code', 'pre'
      'hr', 'br',
      'div',
      'table', 'thead', 'caption', 'tbody', 'tr', 'th', 'td',
    ]


  # string -> html by creating fake wrapper
  # stackoverflow.com/a/494348
  wrapper_elem = document.createElement('div')
  wrapper_elem.innerHTML = sanitized

  elem = cleanedHtmlToElem(wrapper_elem)
  return elem


module.exports = rawHtmlToArticle

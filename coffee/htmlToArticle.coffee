
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



textToSpans = (textNode) ->
  text = textNode.nodeValue
  words = text.split /\s+/

  # turns the words into an array of Elements
  spans = []
  for word, i in words
    # add trailing space to all words but the last one
    if i < (words.length - 1)
      word += ' '
    word_model = new WordModel()
    word_model.set {word}
    spans.push word_model

    # also add it to list of words
    WordStore.add(word_model)

  return spans


domAttrsToArticle = (attributes) ->
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


cleanedHtmlToArticle = (elem) ->
  # recursively turn elems to React objs.

  # if its text, return the text.
  if typeof elem is String then return textToSpans(elem)
  if elem.nodeName is "#text" then return textToSpans(elem)

  node_name = elem.nodeName.toLowerCase()
  attrs = domAttrsToArticle(elem.attributes)

  children_list = [cleanedHtmlToArticle(child) for child in elem.childNodes]
  children_list = _.flatten(children_list)  # unpacks text words
  children = new ChildrenCollection()
  children.add(children_list)

  elem = new ElementModel()
  elem.set {node_name, attrs, children}
  return elem


rawHtmlToArticle = (raw_html) ->
  sanitized = sanitize(raw_html)

  # string -> html by creating fake wrapper
  # stackoverflow.com/a/494348
  wrapper_elem = document.createElement('div')
  wrapper_elem.innerHTML = sanitized

  cleanedHtmlToArticle(wrapper_elem)


module.exports = rawHtmlToArticle

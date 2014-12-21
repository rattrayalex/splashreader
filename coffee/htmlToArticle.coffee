
sanitize = require('sanitize-html')
_ = require('underscore')

dispatcher = require('./dispatcher')
constants = require('./constants')
{
  ChildrenCollection,
  WordModel,
  ElementModel
} = require('./stores/ArticleModels')


# evil global.
# TODO: rethink this
WordList = {
  words: []
}

isBlock = (node_name) ->
  node_name not in constants.INLINE_ELEMENTS


handlePre = (text, parent) ->
  # handle `pre` elements, aka blocks of code.
  # put multiple words, no trimming, into "word"
  word = text
  after = ''
  word_model = new WordModel {word, parent, after}

  # don't add it to WordStore,
  # dont want to speedread this shit
  return word_model


# pretty meh algo to split words longer than 14 chars,
# preferring to split on - and otherwise being super naive.
shortenLongWord = (word) ->
  if word.length < 14
    after = ' '
    return [{word, after}]

  # first, try to split on hyphens...
  parts = word.split(/(?=-)/).filter (part) ->
    # getting rid of blanks...
      part.length > 0
    # then split greedily on strings longer than 13 chars if needed.
    .map (part) ->
      part.split(/(.{1,13})/).filter (subpart) ->
        subpart.length > 0

  _.flatten(parts).map (part, i, parts) ->
    if i < (parts.length - 1)
      word: part
      after: '-'
    else
      word: part
      after: ' '


textToWords = (textNode, parent) ->
  text = textNode.nodeValue
  words = text.replace(/(–|—)/g, ' $1 ').split /\s+/

  # remove blanks
  if not text.trim()
    return null

  # code blocks get special treatment
  if parent.get('node_name') in ['pre', 'td', 'th']
    return handlePre(text, parent)

  # split_words = splitHyphens(words)

  # turns the words into an array of Elements
  word_models = []
  for full_word, i in words
    parts = shortenLongWord(full_word)
    for {word, after}, j in parts
      # last word in textNode doesn't get space after.
      if j == (parts.length - 1) and i == (words.length - 1)
        after = ''

      word_model = new WordModel {word, parent, after}
      word_models.push word_model

      # also add it to list of words
      WordList.words.push(word_model)

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

  node_name = node.nodeName.toLowerCase()
  attrs = domAttrsToDict(node.attributes)

  elem = new ElementModel {node_name, attrs}

  # `parent` is stored on Words, representing their nearest Block parent.
  if isBlock(node_name)
    # `pre` elems should always be the parent, they're special.
    unless parent?.get('node_name') is 'pre'
      parent = elem

  children_list = _.compact _.flatten [  # unpacks text words, removes nulls
    cleanedHtmlToElem(child, parent) for child in node.childNodes
  ]
  children = new ChildrenCollection children_list

  elem.set {children}, {silent: true}
  return elem


saveWordListToWordStore = () ->
  setTimeout =>
    dispatcher.dispatch
      actionType: 'wordlist-complete'
      words: WordList.words
    # I know, I know... evil globals...
    WordList.words = []
  , 0




rawHtmlToArticle = (raw_html) ->
  start = new Date()

  sanitized = sanitize raw_html,
    # remove empty elements.
    # exclusiveFilter: (frame) -> !frame.text.trim()
    allowedTags: constants.ALLOWED_REACT_NODES
  post_sanitize = new Date()
  console.log 'sanitize took', post_sanitize - start

  # string -> html by creating fake wrapper
  # stackoverflow.com/a/494348
  wrapper_elem = document.createElement('div')
  wrapper_elem.innerHTML = sanitized
  post_wrapper_elem = new Date()
  console.log 'setting wrapper_elem took', post_wrapper_elem - post_sanitize

  elem = cleanedHtmlToElem(wrapper_elem)
  post_elem = new Date()
  console.log 'cleanedHtmlToElem took', post_elem - post_wrapper_elem

  saveWordListToWordStore()
  post_wordlist = new Date()
  console.log 'saveWordListToWordStore took', post_wordlist - post_elem

  return elem


module.exports = rawHtmlToArticle

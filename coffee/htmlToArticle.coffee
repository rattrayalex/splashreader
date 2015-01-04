Immutable = require('immutable')
sanitize = require('sanitize-html')
_ = require('underscore')

dispatcher = require('./dispatcher')
constants = require('./constants')
{getDisplayMultiplier} = require './rsvp_utils'

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
  parent = parent.get('cid')
  after = ''
  display = 0
  return [saveWord(word, parent, after, display)]


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


saveWord = (word, parent, after, display=null) ->
  display ?= getDisplayMultiplier(word)
  cid = _.uniqueId('w')
  current = false
  idx = WordList.words.length

  word_model = Immutable.Map {word, parent, after, display, cid, current, idx}
  WordList.words.push(word_model)

  return idx


textToWords = (textNode, parent) ->
  text = textNode.nodeValue
  words = text.replace(/(–|—)/g, ' $1 ').split /\s+/

  # remove blanks
  if not text.trim()
    return null

  # code blocks get special treatment
  if parent.get('node_name') in ['pre', 'td', 'th']
    return handlePre(text, parent)

  # turns the words into an array of Elements
  parent = parent.get('cid')
  word_idxs = []
  for full_word, i in words
    parts = shortenLongWord(full_word)
    for {word, after}, j in parts
      # last word in textNode doesn't get space after.
      if j == (parts.length - 1) and i == (words.length - 1)
        after = ''

      idx = saveWord(word, parent, after)
      word_idxs.push idx

  return word_idxs


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


getStartWord = (children) ->
  for child in children.toArray()
    if typeof child is 'number'
      return child
    else if child?
      subWord = getStartWord(child.get('children'))
      if subWord?
        return subWord
  return null


getEndWord = (children) ->
  for child in children.toArray().reverse()
    if typeof child is 'number'
      return child
    else if child?
      subWord = getEndWord(child.get('children'))
      if subWord?
        return subWord
  return null


cleanedHtmlToElem = (node, parent) ->
  # recursively turn nodes to React objs.

  # if its text, return the text as list of WordModels.
  if node.nodeName is "#text" or typeof node is String
    return textToWords(node, parent)

  node_name = node.nodeName.toLowerCase()
  attrs = domAttrsToDict(node.attributes)
  cid = _.uniqueId('p')

  elem = Immutable.fromJS {node_name, attrs, cid}

  # `parent` is stored on Words, representing their nearest Block parent.
  if isBlock(node_name)
    # `pre` elems should always be the parent, they're special.
    unless parent?.get('node_name') is 'pre'
      parent = elem

  children_list = _.without _.flatten [  # unpacks text words, removes nulls
    cleanedHtmlToElem(child, parent) for child in node.childNodes
  ], null
  children = Immutable.List children_list
  start_word = getStartWord(children)
  end_word = getEndWord(children)

  elem = elem.merge {children, start_word, end_word}
  return elem


saveWordListToWordStore = () ->
  setTimeout =>
    dispatcher.dispatch
      actionType: 'wordlist-complete'
      words: WordList.words
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

  return elem


module.exports = rawHtmlToArticle

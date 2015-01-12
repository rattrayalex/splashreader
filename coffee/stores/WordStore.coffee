Immutable = require 'immutable'
Backbone = require 'backbone'
RsvpStatusStore = require './RsvpStatusStore'

dispatcher = require '../dispatcher'
{msPerWord, isPlaying, getCurrentWord} = require './computed'



class WordStore
  constructor: (@store) ->
    dispatcher.tokens.WordStore = dispatcher.register @dispatcherCallback

  cursor: (path...) ->
    @store.cursor('words').cursor(path)

  updateWord: (idx) ->

    # # code blocks (in `pre`) aren't in WordStore, don't go to them.
    # if WordStore.indexOfWord(word) < 0
    #   console.log 'word not in WordStore, ignore', word
    #   return

    word = @store.get('words').get(idx)

    # trigger the next word to update.
    if isPlaying(@store.get('status'))
      next_word = @store.get('words').get(idx + 1)
      para_change = next_word?.get('parent') isnt word.get('parent')
      time_to_display = word.get('display') *
        msPerWord @store.getIn(['status', 'wpm'])

      if not next_word
        # end of article, just pause.
        return setTimeout ->
          dispatcher.dispatch
            actionType: 'pause'
            source: 'article-end'
        , time_to_display

      # janky prevention of rare double-display bug.
      # TODO: prevent that from happening in the first place.
      clearTimeout @timeout if @timeout?

      # display the next word in a bit
      @timeout = setTimeout ->
        # change para before next updateWord so it pauses.
        if para_change
          dispatcher.dispatch
            actionType: 'para-change'

        dispatcher.dispatch
          actionType: 'change-word'
          idx: next_word.get('idx')
          source: 'updateWord'

      , time_to_display

  dispatcherCallback: (payload) =>
    switch payload.actionType

      when 'wordlist-complete'
        console.log 'wordlist-complete'
        if not payload.words.length
          console.log 'no words in this homepage'
          return setTimeout ->
            window.location = '#'
          , 1000


        # set first word to be the current word
        payload.words[0] = payload.words[0].set 'current', true
        @cursor().update ->
          Immutable.List payload.words
        @updateWord 0

      when 'process-article'
        @cursor().clear()

      when 'page-change'
        dispatcher.waitFor [dispatcher.tokens.CurrentPageStore]
        if not payload.url
          @cursor().clear()

      when 'change-word'
        # ignore `pre`, `td`, etc...
        if @store.getIn(['words', payload.idx, 'display']) is 0
          console.log 'changing to display0 word!'
          if payload.source is 'click'
            return
          else
            return setTimeout ->
              dispatcher.dispatch
                actionType: 'change-word'
                idx: payload.idx + 1
                source: 'display0'

        @cursor().update (words) ->
          words.map (word) ->
            if word.get('idx') is payload.idx
              word.set('current', true)
            else if word.get('current')
              word.set('current', false)
            else
              word
        @updateWord(payload.idx)

      when 'para-resume'
        dispatcher.waitFor [dispatcher.tokens.RsvpStatusStore]
        @updateWord getCurrentWord(@store.get('words')).get('idx')

      when 'play-pause', 'play', 'pause'
        dispatcher.waitFor [dispatcher.tokens.RsvpStatusStore]

        if @store.get('status').get('playing')
          @updateWord getCurrentWord(@store.get('words')).get('idx') or 0
        else
          clearTimeout @timeout if @timeout?



module.exports = WordStore



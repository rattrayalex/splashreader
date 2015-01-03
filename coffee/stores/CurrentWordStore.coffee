dispatcher = require '../dispatcher'
constants = require '../constants'

{msPerWord, getCurrentWord, isPlaying} = require('./computed')


class CurrentWordStore
  constructor: (@store) ->
    dispatcher.tokens.CurrentWordStore = dispatcher.register @dispatchCallback

  cursor: (path...) ->
    @store.cursor('current').cursor(path)

  updateWord: (idx) ->

    # # code blocks (in `pre`) aren't in WordStore, don't go to them.
    # if WordStore.indexOfWord(word) < 0
    #   console.log 'word not in WordStore, ignore', word
    #   return

    word = @store.get('words').get(idx)
    @cursor('idx').update -> idx

    # trigger the next word to update.
    if isPlaying(@store.get('status'))
      next_word = @store.get('words').get(idx + 1)
      para_change = next_word.get('parent') isnt word.get('parent')
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

  dispatchCallback: (payload) =>
    switch payload.actionType

      when 'page-change'
        dispatcher.waitFor [dispatcher.tokens.CurrentPageStore]
        if not payload.url
          @cursor().clear()

      when 'change-word'
        dispatcher.waitFor [dispatcher.tokens.WordStore]
        @updateWord(payload.idx)

      when 'para-resume'
        dispatcher.waitFor [dispatcher.tokens.RsvpStatusStore]
        @updateWord @cursor().get('idx')

      when 'wordlist-complete'
        dispatcher.waitFor [dispatcher.tokens.WordStore]
        console.log 'starting at the top'
        @updateWord 0

      when 'play-pause', 'play', 'pause'
        dispatcher.waitFor [dispatcher.tokens.RsvpStatusStore]

        if @store.get('status').get('playing')
          @updateWord @cursor().get('idx') or 0
        else
          clearTimeout @timeout if @timeout?


module.exports = CurrentWordStore

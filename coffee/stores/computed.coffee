
msPerWord = (wpm) ->
  60000 / wpm


getTimeSince = (words, status, idx) ->
  # http://facebook.github.io/immutable-js/docs/#/List/skip
  remaining_words = words.skip(idx).toArray()

  time_left = 0
  for w in remaining_words
    time_left += w.get('display')

  seconds_left = time_left * msPerWord(status.get('wpm')) / 1000
  minutes_left = seconds_left / 60

  return minutes_left


getTotalTime = (words, status) ->
  getTimeSince words, status, 0


getPercentDone = (words, current) ->
  current.get('idx') / words.size


getTimeLeft = (words, status, current) ->
  getTimeSince words, status, current.get('idx')


getCurrentWord = (words) ->
  start = new Date()
  res = words.find (word) -> word.get('current')
  console.log 'getCurrentWord took', new Date() - start
  res


isPlaying = (status) ->
  status.get('playing') and not status.get('para_change')


module.exports = {
  msPerWord
  getTimeSince
  getTotalTime
  getPercentDone
  getTimeLeft
  getCurrentWord
  isPlaying
}



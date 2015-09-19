
export function saveWpm(wpm) {
  try {
    chrome.storage.sync.set({'wpm': wpm})
  } catch (e) {
    console.error('Could not save WPM to chrome', e)
  }
  return wpm
}

export function loadWpm(cb) {
  try {
    return chrome.storage.sync.get('wpm', cb)
  } catch (e) {
    console.error('Could not load WPM from chrome', e)
  }
}

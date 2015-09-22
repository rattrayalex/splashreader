
export function saveWpm(wpm) {
  try {
    chrome.storage.sync.set({'wpm': wpm})
  } catch (e) {
    console.error('Could not save WPM to chrome', e)
  }
  return wpm
}

export async function loadWpm() {
  try {
    return await new Promise( (resolve, reject) =>
      chrome.storage.sync.get('wpm', ({ wpm }) =>
        resolve(wpm)
      )
    )
  } catch (e) {
    console.error('Could not load WPM from chrome', e)
  }
}

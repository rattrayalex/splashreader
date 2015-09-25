/* @flow */

declare var chrome: any

export function saveWpm(wpm: number): number {
  try {
    chrome.storage.sync.set({'wpm': wpm})
  } catch (e) {
    console.error('Could not save WPM to chrome', e)
  }
  return wpm
}

export async function loadWpm(): Promise<?number> {
  try {
    return await new Promise( (resolve) =>
      chrome.storage.sync.get('wpm', ({ wpm }) =>
        resolve(parseInt(wpm))
      )
    )
  } catch (e) {
    console.error('Could not load WPM from chrome', e)
  }
  return null
}

/* @flow */
declare var chrome: any


export function saveWpm(wpm: number): number {
  try {
    chrome.storage.sync.set({ wpm })
  } catch (e) {
    console.error('Could not save WPM to chrome', e) // eslint-disable-line no-console
  }
  return wpm
}

export async function loadWpm(): Promise<?number> {
  try {
    return await new Promise((resolve) =>
      chrome.storage.sync.get('wpm', ({ wpm }) =>
        resolve(parseInt(wpm, 10))
      )
    )
  } catch (e) {
    console.error('Could not load WPM from chrome', e) // eslint-disable-line no-console
  }
  return null
}

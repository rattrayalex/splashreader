chrome.browserAction.onClicked.addListener ->
  chrome.tabs.executeScript
    file: 'js/chrome.js'
  , ->
    alert 'finished running the thing!'
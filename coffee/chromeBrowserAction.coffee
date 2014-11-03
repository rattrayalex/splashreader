chrome.browserAction.onClicked.addListener ->
  chrome.tabs.insertCSS
    file: 'css/chrome.css'
  , ->
    chrome.tabs.executeScript
      file: 'js/chrome.js'

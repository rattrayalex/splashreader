insertSplash = ->
  chrome.tabs.insertCSS
    file: 'css/chrome.css'
  , ->
    chrome.tabs.executeScript
      file: 'js/chrome.js'

# currently unused
listenForSignal = ->
  # check for ctrl+alt+s
  document.addEventListener "keydown", (evt) ->
    e = window.event or evt
    key = e.which or e.keyCode
    if e.ctrlKey and e.altKey
      alert "ctrl and alt are down! #{key}"
      if key is 's'
        insertSplash()
    return
  , false


chromeContextMenuid = chrome.contextMenus.create
  title: "Splash this page"
  id: "splashPage"
  contexts: ["page"]
  onclick: insertSplash

chrome.browserAction.onClicked.addListener insertSplash

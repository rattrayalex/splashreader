PAGE_MENU_ID = "splashPageMenu"
SELECTION_MENU_ID = "splashSelectionMenu"

insertSplash = (cb) ->
  chrome.tabs.insertCSS
    file: 'css/chrome.css'
    , ->
      chrome.tabs.executeScript
        file: 'js/chrome.js'
        , ->
          cb() if cb?



chrome.runtime.onInstalled.addListener ->

  chrome.contextMenus.create
    title: "Splash this page"
    id: PAGE_MENU_ID
    contexts: ["page"]
    , ->
      error = chrome.extension.lastError
      if error
        console.log "error Inserting Page ContextMenu!", error
      else
        console.log 'page contextmenu created successfully'

  chrome.contextMenus.create
    title: "Splash Selection: '%s'"
    id: SELECTION_MENU_ID
    contexts: ["selection"]
    , ->
      error = chrome.extension.lastError
      if error
        console.log "error Inserting Page ContextMenu!", error
      else
        console.log 'selection contextmenu created successfully'

  chrome.contextMenus.onClicked.addListener (info, tab) ->
    switch info.menuItemId
      when PAGE_MENU_ID
        insertSplash ->
          chrome.tabs.sendMessage tab.id,
            actionType: "page"
      when SELECTION_MENU_ID
        console.log "about to insertSplash..."
        insertSplash ->
          chrome.tabs.sendMessage tab.id,
            actionType: "selection"
            selection: info.selectionText
            , (response) ->
              console.log "received response in chrome event page: ", response


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


chrome.browserAction.onClicked.addListener ->
  console.log "browserAction clicked"
  chrome.tabs.query
    active: true
    , (tabs) ->
      console.log "got tabs", tabs, tabs[0], tabs[0].id
      insertSplash ->
        chrome.tabs.sendMessage tabs[0].id,
          actionType: "page"
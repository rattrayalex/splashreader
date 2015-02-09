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
        insertSplash ->
          chrome.tabs.sendMessage tab.id,
            actionType: "selection"
            selection: info.selectionText

  chrome.browserAction.onClicked.addListener (tab) ->
    console.log "browserAction clicked on ", tab
    insertSplash ->
      chrome.tabs.sendMessage tab.id,
        actionType: "page"

  chrome.commands.onCommand.addListener (command) ->
    console.log "command received", command
    chrome.tabs.query {active: true, currentWindow: true}, (tabs) ->
      tab = tabs[0]
      console.log "using tab", tab, " of tabs", tabs

      switch command

        when "splash_page"
          console.log "splash_page command"
          insertSplash ->
            chrome.tabs.sendMessage tab.id,
              actionType: "page"

        when "splash_selection"
          console.log "splash_selection command"
          insertSplash ->
            chrome.tabs.sendMessage tab.id,
              actionType: "selection"
              selection: "unknown..."


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

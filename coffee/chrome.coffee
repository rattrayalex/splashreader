fs = require('fs')

# inlined by brfs: https://github.com/substack/brfs
APP_CSS = fs.readFileSync(__dirname + '/../css/style.css', 'utf8')
APP_JS = fs.readFileSync(__dirname + '/../js/app.js', 'utf8')


getCurrentUrl = () ->
  document.URL


getPageHtml = () ->
  document.body.innerHTML


getSelectionHtml = () ->
  # http://stackoverflow.com/a/6668159/1048433
  html = ""
  unless typeof window.getSelection is "undefined"
    sel = window.getSelection()
    if sel.rangeCount
      container = document.createElement("div")
      i = 0
      len = sel.rangeCount
      while i < len
        container.appendChild sel.getRangeAt(i).cloneContents()
        ++i
      html = container.innerHTML
  else
    unless typeof document.selection is "undefined"
      if document.selection.type is "Text"
        html = document.selection.createRange().htmlText
  html


insertCSS = (iframe, css) ->
  style = iframe.contentWindow.document.createElement('style')
  style.innerHTML = css
  iframe.contentWindow.document.head.appendChild(style)
  style


insertScript = (iframe, js) ->
  script = iframe.contentWindow.document.createElement('script')
  script.innerHTML = js
  iframe.contentWindow.document.head.appendChild(script)
  script


insertIframe = (url, html) ->
  iframe = document.createElement('iframe')

  iframe.style.position = 'fixed'
  iframe.style.top = 0
  iframe.style.left = 0
  iframe.style.right = 0
  iframe.style.bottom = 0
  iframe.style.width = '100%'
  iframe.style.height = '100%'
  iframe.style.border = 'none'
  iframe.style.margin = 0
  iframe.style.padding = 0
  iframe.style.overflow = 'hidden'
  iframe.style.zIndex = 999999

  iframe.className = ''
  iframe.style.transition = "all .5s"
  iframe.setAttribute 'id', 'splashreader'

  iframe.onload = () ->
    console.log 'iframe loaded just fiiine'
    listenForEsc(iframe.contentWindow)
  iframe.onerror = () ->
    console.log 'iframe had an error!'

  try
    document.body.appendChild(iframe)
    console.log 'inserted the iframe, no problem...'
  catch e
    console.log 'oh noes, cannot insert iframe!', e

  insertCSS iframe, APP_CSS

  insertScript iframe, "
    window.SplashReaderExt = {};
    window.SplashReaderExt.url = decodeURIComponent(
      \"#{ encodeURIComponent(url) }\"
    );
    window.SplashReaderExt.html = decodeURIComponent(
      \"#{ encodeURIComponent(html) }\"
    );
    "
  insertScript iframe, APP_JS

  iframe.focus()

  return iframe


toggleIframe = (iframe) ->
  if iframe.className is 'splashreader-out'
    iframe.className = ''
  else
    iframe.className = 'splashreader-out'


listenForEsc = (env) ->
  env.document.onkeyup = (e) ->
    e = e or window.event
    if e.keyCode is 27
      toggleIframe(window.SplashReader.iframe)


main = (url, html) ->
  window.SplashReader ?=
    iframe: null

  if not window.SplashReader.iframe
    window.SplashReader.iframe = insertIframe(url, html)
    toggleIframe(window.SplashReader.iframe)
    listenForEsc(window)

  toggleIframe(window.SplashReader.iframe)


chrome.runtime.onMessage.addListener (request, sender, sendResponse) ->
  console.log "content script received request", request, sender
  switch request.actionType
    when "page"
      main getCurrentUrl(), getPageHtml()
    when "selection"
      main "selection", getSelectionHtml()

  sendResponse reply: "thanks!"



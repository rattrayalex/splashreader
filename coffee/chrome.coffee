fs = require('fs')

# inlined by brfs: https://github.com/substack/brfs
APP_CSS = fs.readFileSync(__dirname + '/../css/style.css', 'utf8')
APP_JS = fs.readFileSync(__dirname + '/../js/app.js', 'utf8')

getCurrentUrl = () ->
  document.URL


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


insertIframe = (url) ->
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

  # target_url = 'http://www.splashreaderapp.com/?view=chrome#' + url
  # target_url = '#' + url
  # iframe.setAttribute 'src', target_url

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
      \"#{ encodeURIComponent(window.location.href) }\"
    );
    window.SplashReaderExt.html = decodeURIComponent(
      \"#{ encodeURIComponent(document.body.innerHTML) }\"
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


main = ->
  window.SplashReader ?=
    iframe: null

  if not window.SplashReader.iframe
    url = getCurrentUrl()
    window.SplashReader.iframe = insertIframe(url)
    toggleIframe(window.SplashReader.iframe)
    listenForEsc(window)

  toggleIframe(window.SplashReader.iframe)

main()



getCurrentUrl = () ->
  document.URL


insertIframe = (url)->
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

  iframe.setAttribute 'src', 'http://www.splashreaderapp.com/?view=chrome#' + url
  iframe.onload = () ->
    listenForEsc(iframe.contentWindow)

  document.body.appendChild(iframe)

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

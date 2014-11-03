

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

  iframe.setAttribute 'src', 'http://www.splashreaderapp.com/#' + url

  # iframe.style.display = 'none'
  document.body.appendChild(iframe)

  return iframe


toggleIframe = (iframe) ->
  console.log 'toggling...'
  if iframe.className is 'splashreader-out'
    iframe.className = ''
  else
    iframe.className = 'splashreader-out'


main = ->
  window.SplashReader ?=
    iframe: null

  if not window.SplashReader.iframe
    url = getCurrentUrl()
    window.SplashReader.iframe = insertIframe(url)
    toggleIframe(window.SplashReader.iframe)

  toggleIframe(window.SplashReader.iframe)

main()

alert 'hello world'

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

  iframe.style.display = 'none'

  iframe.setAttribute 'src', 'http://www.splashreaderapp.com/#' + url

  document.body.appendChild(iframe)

  return iframe


toggleIframe = (iframe) ->
  if iframe.style.display is 'none'
    iframe.style.display = 'block'
  else
    iframe.style.display = 'none'


main = ->
  window.SplashReader ?=
    iframe: null

  if not window.SplashReader.iframe
    url = getCurrentUrl()
    alert 'url is' + url
    window.SplashReader.iframe = insertIframe(url)

  toggleIframe(window.SplashReader.iframe)

main()

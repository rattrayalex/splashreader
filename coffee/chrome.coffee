

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

  target_url = 'http://www.splashreaderapp.com/?view=chrome#' + url
  iframe.setAttribute 'src', target_url

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

  setTimeout ->
    doc = iframe.contentWindow.document
    actual_url = doc.URL
    if actual_url != target_url
      console.log 'oh noes, iframe failed!', actual_url
      h1 = doc.createElement('h1')
      h1.innerText = 'Redirecting...'
      h1.style.top = 0
      h1.style.bottom = 0
      h1.style.width = '100%'
      h1.style.height = '100%'
      h1.style.background = 'white'
      h1.style.fontFamily = 'Georgia'
      h1.style.textAlign = 'center'
      h1.style.fontStyle = 'italic'
      h1.style.color = '#888'
      h1.style.lineHeight = '10em'

      doc.querySelector('body').appendChild(h1)
      document.location = 'http://www.splashreaderapp.com/#' + url
  , 1000

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

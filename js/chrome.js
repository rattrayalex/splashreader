(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);var f=new Error("Cannot find module '"+o+"'");throw f.code="MODULE_NOT_FOUND",f}var l=n[o]={exports:{}};t[o][0].call(l.exports,function(e){var n=t[o][1][e];return s(n?n:e)},l,l.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({"./coffee/chrome.coffee":[function(require,module,exports){
var getCurrentUrl, insertIframe, listenForEsc, main, toggleIframe;

getCurrentUrl = function() {
  return document.URL;
};

insertIframe = function(url) {
  var e, iframe, target_url;
  iframe = document.createElement('iframe');
  iframe.style.position = 'fixed';
  iframe.style.top = 0;
  iframe.style.left = 0;
  iframe.style.right = 0;
  iframe.style.bottom = 0;
  iframe.style.width = '100%';
  iframe.style.height = '100%';
  iframe.style.border = 'none';
  iframe.style.margin = 0;
  iframe.style.padding = 0;
  iframe.style.overflow = 'hidden';
  iframe.style.zIndex = 999999;
  iframe.className = '';
  iframe.style.transition = "all .5s";
  iframe.setAttribute('id', 'splashreader');
  target_url = 'http://www.splashreaderapp.com/?view=chrome#' + url;
  iframe.setAttribute('src', target_url);
  iframe.onload = function() {
    console.log('iframe loaded just fiiine');
    return listenForEsc(iframe.contentWindow);
  };
  iframe.onerror = function() {
    return console.log('iframe had an error!');
  };
  try {
    document.body.appendChild(iframe);
    console.log('inserted the iframe, no problem...');
  } catch (_error) {
    e = _error;
    console.log('oh noes, cannot insert iframe!', e);
  }
  setTimeout(function() {
    var actual_url, doc, h1;
    doc = iframe.contentWindow.document;
    actual_url = doc.URL;
    if (actual_url !== target_url) {
      console.log('oh noes, iframe failed!', actual_url);
      h1 = doc.createElement('h1');
      h1.innerText = 'Redirecting...';
      h1.style.top = 0;
      h1.style.bottom = 0;
      h1.style.width = '100%';
      h1.style.height = '100%';
      h1.style.background = 'white';
      h1.style.fontFamily = 'Georgia';
      h1.style.textAlign = 'center';
      h1.style.fontStyle = 'italic';
      h1.style.color = '#888';
      h1.style.lineHeight = '10em';
      doc.querySelector('body').appendChild(h1);
      return document.location = 'http://www.splashreaderapp.com/#' + url;
    }
  }, 1000);
  return iframe;
};

toggleIframe = function(iframe) {
  if (iframe.className === 'splashreader-out') {
    return iframe.className = '';
  } else {
    return iframe.className = 'splashreader-out';
  }
};

listenForEsc = function(env) {
  return env.document.onkeyup = function(e) {
    e = e || window.event;
    if (e.keyCode === 27) {
      return toggleIframe(window.SplashReader.iframe);
    }
  };
};

main = function() {
  var url;
  if (window.SplashReader == null) {
    window.SplashReader = {
      iframe: null
    };
  }
  if (!window.SplashReader.iframe) {
    url = getCurrentUrl();
    window.SplashReader.iframe = insertIframe(url);
    toggleIframe(window.SplashReader.iframe);
    listenForEsc(window);
  }
  return toggleIframe(window.SplashReader.iframe);
};

main();



},{}]},{},["./coffee/chrome.coffee"]);

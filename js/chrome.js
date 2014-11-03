(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);var f=new Error("Cannot find module '"+o+"'");throw f.code="MODULE_NOT_FOUND",f}var l=n[o]={exports:{}};t[o][0].call(l.exports,function(e){var n=t[o][1][e];return s(n?n:e)},l,l.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({"./coffee/chrome.coffee":[function(require,module,exports){
var getCurrentUrl, insertIframe, main, toggleIframe;

getCurrentUrl = function() {
  return document.URL;
};

insertIframe = function(url) {
  var iframe;
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
  iframe.setAttribute('src', 'http://www.splashreaderapp.com/#' + url);
  document.body.appendChild(iframe);
  return iframe;
};

toggleIframe = function(iframe) {
  console.log('toggling...');
  if (iframe.className === 'splashreader-out') {
    return iframe.className = '';
  } else {
    return iframe.className = 'splashreader-out';
  }
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
  }
  return toggleIframe(window.SplashReader.iframe);
};

main();



},{}]},{},["./coffee/chrome.coffee"]);

(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);var f=new Error("Cannot find module '"+o+"'");throw f.code="MODULE_NOT_FOUND",f}var l=n[o]={exports:{}};t[o][0].call(l.exports,function(e){var n=t[o][1][e];return s(n?n:e)},l,l.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({"./coffee/chrome.coffee":[function(require,module,exports){
},getPageHtml=function(){return document.body.innerHTML},getSelectionHtml=function(){var e,t,r,n,o;if(t="","undefined"!=typeof window.getSelection){if(o=window.getSelection(),o.rangeCount){for(e=document.createElement("div"),r=0,n=o.rangeCount;n>r;)e.appendChild(o.getRangeAt(r).cloneContents()),++r;t=e.innerHTML}}else"undefined"!=typeof document.selection&&"Text"===document.selection.type&&(t=document.selection.createRange().htmlText);return t},insertCSS=function(e,t){var r;return r=e.contentWindow.document.createElement("style"),r.innerHTML=t,e.contentWindow.document.head.appendChild(r),r},insertScript=function(e,t){var r;return r=e.contentWindow.document.createElement("script"),r.innerHTML=t,e.contentWindow.document.head.appendChild(r),r},insertIframe=function(e,t){var r,n;n=document.createElement("iframe"),n.style.position="fixed",n.style.top=0,n.style.left=0,n.style.right=0,n.style.bottom=0,n.style.width="100%",n.style.height="100%",n.style.border="none",n.style.margin=0,n.style.padding=0,n.style.overflow="hidden",n.style.zIndex=999999,n.className="",n.style.transition="all .5s",n.setAttribute("id","splashreader"),n.onload=function(){return console.log("iframe loaded just fiiine"),listenForEsc(n.contentWindow)},n.onerror=function(){return console.log("iframe had an error!")};try{document.body.appendChild(n),console.log("inserted the iframe, no problem...")}catch(o){r=o,console.log("oh noes, cannot insert iframe!",r)}return insertCSS(n,APP_CSS),insertScript(n,'window.SplashReaderExt = {}; window.SplashReaderExt.url = decodeURIComponent( "'+encodeURIComponent(e)+'" ); window.SplashReaderExt.html = decodeURIComponent( "'+encodeURIComponent(t)+'" );'),insertScript(n,APP_JS),n.focus(),n},toggleIframe=function(e){return"splashreader-out"===e.className?(e.className="",e.focus()):(e.className="splashreader-out",window.focus())},listenForEsc=function(e){return e.document.onkeyup=function(e){return e=e||window.event,27===e.keyCode?toggleIframe(window.SplashReader.iframe):void 0}},main=function(e,t){return null==window.SplashReader&&(window.SplashReader={iframe:null}),window.SplashReader.iframe||(window.SplashReader.iframe=insertIframe(e,t),toggleIframe(window.SplashReader.iframe),listenForEsc(window)),toggleIframe(window.SplashReader.iframe)},chrome.runtime.onMessage.addListener(function(e,t,r){switch(console.log("content script received request",e,t),e.actionType){case"page":main(getCurrentUrl(),getPageHtml());break;case"selection":main("selection",getSelectionHtml())}return r({reply:"thanks!"})});
},{}]},{},["./coffee/chrome.coffee"]);
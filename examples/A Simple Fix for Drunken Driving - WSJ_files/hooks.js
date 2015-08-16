/*! realtime-hooks-js, Generated 2015-05-20 DO NOT EDIT BY HAND */
window.hooks = window.hooks || {};
window.hooks.baseUrl = "http://insights.dowjones.net";
window.hooks.commandUrl = "http://djibeacon.dowjoneson.com";

 
String.prototype.hexEncode = function(){var r='';var i=0;var h;var ascii = this.replace(/^[\u0080-\uffff]/g, ''); while(i<ascii.length){h=ascii.charCodeAt(i++).toString(16);h = (h.length<2) ?"0"+ h: h;r+=h;}return r;};
String.prototype.hexDecode = function(){var r='';for(var i=0;i<this.length;i+=2){r+=unescape('%'+this.substr(i,2));}return r;};

  


var JSON;JSON||(JSON={});
(function(){function k(a){return a<10?"0"+a:a}function o(a){p.lastIndex=0;return p.test(a)?'"'+a.replace(p,function(a){var c=r[a];return typeof c==="string"?c:"\\u"+("0000"+a.charCodeAt(0).toString(16)).slice(-4)})+'"':'"'+a+'"'}function l(a,j){var c,d,h,m,g=e,f,b=j[a];b&&typeof b==="object"&&typeof b.toJSON==="function"&&(b=b.toJSON(a));typeof i==="function"&&(b=i.call(j,a,b));switch(typeof b){case "string":return o(b);case "number":return isFinite(b)?String(b):"null";case "boolean":case "null":return String(b);case "object":if(!b)return"null";
e+=n;f=[];if(Object.prototype.toString.apply(b)==="[object Array]"){m=b.length;for(c=0;c<m;c+=1)f[c]=l(c,b)||"null";h=f.length===0?"[]":e?"[\n"+e+f.join(",\n"+e)+"\n"+g+"]":"["+f.join(",")+"]";e=g;return h}if(i&&typeof i==="object"){m=i.length;for(c=0;c<m;c+=1)typeof i[c]==="string"&&(d=i[c],(h=l(d,b))&&f.push(o(d)+(e?": ":":")+h))}else for(d in b)Object.prototype.hasOwnProperty.call(b,d)&&(h=l(d,b))&&f.push(o(d)+(e?": ":":")+h);h=f.length===0?"{}":e?"{\n"+e+f.join(",\n"+e)+"\n"+g+"}":"{"+f.join(",")+
"}";e=g;return h}}if(typeof Date.prototype.toJSON!=="function")Date.prototype.toJSON=function(){return isFinite(this.valueOf())?this.getUTCFullYear()+"-"+k(this.getUTCMonth()+1)+"-"+k(this.getUTCDate())+"T"+k(this.getUTCHours())+":"+k(this.getUTCMinutes())+":"+k(this.getUTCSeconds())+"Z":null},String.prototype.toJSON=Number.prototype.toJSON=Boolean.prototype.toJSON=function(){return this.valueOf()};var q=/[\u0000\u00ad\u0600-\u0604\u070f\u17b4\u17b5\u200c-\u200f\u2028-\u202f\u2060-\u206f\ufeff\ufff0-\uffff]/g,
p=/[\\\"\x00-\x1f\x7f-\x9f\u00ad\u0600-\u0604\u070f\u17b4\u17b5\u200c-\u200f\u2028-\u202f\u2060-\u206f\ufeff\ufff0-\uffff]/g,e,n,r={"\u0008":"\\b","\t":"\\t","\n":"\\n","\u000c":"\\f","\r":"\\r",'"':'\\"',"\\":"\\\\"},i;if(typeof JSON.stringify!=="function")JSON.stringify=function(a,j,c){var d;n=e="";if(typeof c==="number")for(d=0;d<c;d+=1)n+=" ";else typeof c==="string"&&(n=c);if((i=j)&&typeof j!=="function"&&(typeof j!=="object"||typeof j.length!=="number"))throw Error("JSON.stringify");return l("",
{"":a})};if(typeof JSON.parse!=="function")JSON.parse=function(a,e){function c(a,d){var g,f,b=a[d];if(b&&typeof b==="object")for(g in b)Object.prototype.hasOwnProperty.call(b,g)&&(f=c(b,g),f!==void 0?b[g]=f:delete b[g]);return e.call(a,d,b)}var d,a=String(a);q.lastIndex=0;q.test(a)&&(a=a.replace(q,function(a){return"\\u"+("0000"+a.charCodeAt(0).toString(16)).slice(-4)}));if(/^[\],:{}\s]*$/.test(a.replace(/\\(?:["\\\/bfnrt]|u[0-9a-fA-F]{4})/g,"@").replace(/"[^"\\\n\r]*"|true|false|null|-?\d+(?:\.\d*)?(?:[eE][+\-]?\d+)?/g,
"]").replace(/(?:^|:|,)(?:\s*\[)+/g,"")))return d=eval("("+a+")"),typeof e==="function"?c({"":d},""):d;throw new SyntaxError("JSON.parse");}})();

(function(){var a=typeof window!="undefined"?window:exports,b="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=",c=function(){try{document.createElement("$")}catch(a){return a}}();a.btoa||(a.btoa=function(a){for(var d,e,f=0,g=b,h="";a.charAt(f|0)||(g="=",f%1);h+=g.charAt(63&d>>8-f%1*8)){e=a.charCodeAt(f+=.75);if(e>255)throw c;d=d<<8|e}return h}),a.atob||(a.atob=function(a){a=a.replace(/=+$/,"");if(a.length%4==1)throw c;for(var d=0,e,f,g=0,h="";f=a.charAt(g++);~f&&(e=d%4?e*64+f:f,d++%4)?h+=String.fromCharCode(255&e>>(-2*d&6)):0)f=b.indexOf(f);return h})})();
if(!Array.prototype.filter){Array.prototype.filter=function(e){"use strict";if(this===void 0||this===null)throw new TypeError;var t=Object(this);var n=t.length>>>0;if(typeof e!=="function")throw new TypeError;var r=[];var i=arguments.length>=2?arguments[1]:void 0;for(var s=0;s<n;s++){if(s in t){var o=t[s];if(e.call(i,o,s,t))r.push(o)}}return r}}

if("function"!==typeof Array.prototype.reduce){Array.prototype.reduce=function(e){"use strict";if(null===this||"undefined"===typeof this){throw new TypeError("Array.prototype.reduce called on null or undefined")}if("function"!==typeof e){throw new TypeError(e+" is not a function")}var t=Object(this),n=t.length>>>0,r=0,i;if(arguments.length>=2){i=arguments[1]}else{while(r<n&&!r in t)r++;if(r>=n)throw new TypeError("Reduce of empty array with no initial value");i=t[r++]}for(;r<n;r++){if(r in t){i=e(i,t[r],r,t)}}return i}}


(function(window, undefined){
    var _sf_async_config = window._sf_async_config || {};
    var pingMilliseconds = 30000;
    var totalEngagedSeconds = 0;
    var hooksVersion = 20141010;
    if (!Array.prototype.indexOf) {
        Array.prototype.indexOf = function(obj, start) {
             for (var i = (start || 0), j = this.length; i < j; i++) {
                 if (this[i] === obj) { return i; }
             }
             return -1;
        };
    }

    var trim = function(s){
        return s.replace(/^\s\s*/, '').replace(/\s\s*$/, '');
    };

    var hooks = {};

    // writing getter so it can be mocked out in jasmine
    hooks.getLocation = function(){
        return window.location;
    };

    hooks.getTitle = function(){
        return window.document.title;
    };

    window.hooks.start = new Date().getTime();

    var merge = function(src, addl) {
        // for every additional prop in addl, add it to src
        // doesn't mutate inputs
        // warning: this is a shallow merge

        var o = {};
        src = src || {};
        addl = addl || {};

        for(var s in src){ o[s] = src[s]; }
        for(var a in addl){o[a] = addl[a];}

        return o;
    };

    var serializeMetaTag = function(node){
        // turn xml thing into jsobj thing
        // <meta name="n" content="c" />
        // {"name": "n", "content": "c"}
        var o = {};
        for(var i = 0; i < node.attributes.length; i++){
            var n = node.attributes[i].name;
            var v = node.attributes[i].value;
            o[n] = v;
        }
        return o;
    };

    var transformMetaObject = function(meta){
        // simplifies a meta object down to a regular key/value obj
        // {"name": "n", "content": "c"} or
        // {"property": "n", "content": "c"} or
        // {"itemprop": "n", "content": "c"} or
        // all turn into
        // {"n": "c"}
        var k, v;
        // if another idenfitier attr is on the same object, just overwrite it
        if(meta.itemprop)
            k = meta.itemprop;
        if(meta.property)
            k = meta.property;
        if(meta.name)
            k = meta.name;
        // someone used 'value' instead of 'content'
        if(meta.value)
            v = meta.value;
        // content wins, though
        if(meta.content)
            v = meta.content;
        var o = {};
        o[k] = v;
        return o;
    };

    hooks.parseMetatags = function(nodeList){
        var a = [{}];
        for(var i = 0; i < nodeList.length; i++){
            a.push(transformMetaObject(serializeMetaTag(nodeList[i])));
        }
        return a.reduce(merge);
    };

    hooks.getQueryObject = function(){
        // parses the querystring into an object
        // not implementing array behavior, last duplicate
        // key is the winner
        var querystring = window.hooks.getLocation().href.split("?")[1];
        if(!querystring){
            return {};
        }
        var parts = querystring.split("&");
        var key_values = [];
        for(var i = 0; i < parts.length; i++){
            key_values.push(parts[i].split("="));
        }

        // build up the return object, parsing the kv pairs
        var obj = {};
        for(i = 0; i < key_values.length; i++){
            var k = key_values[i][0];
            var v = key_values[i][1];
            obj[k] = v;
        }

        return obj;
    };

    var getCookieVal = function(name){
        var cookies = document.cookie.split(";");
        var r = new RegExp(name, "i");
        var found = cookies.filter(function(e){ return r.test(e); });
        if(found.length > 0){
            found = trim(found[0]);
            return found.split("=")[1];
        }
        else{
            return undefined;
        }
    };

    hooks.getUser = function(){
        return getCookieVal("remote_user");
    };

     hooks.getSVI = function(){
        return getCookieVal("s_vi");
    };

    hooks.getCke = function(){
        return getCookieVal("cke");
    };

    var guid = function(){
        // http://stackoverflow.com/a/2117523/656833
        return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
                var r = Math.random()*16|0, v = c == 'x' ? r : (r&0x3|0x8);
                    return v.toString(16);
        });
    };

    hooks.getDJIUser = function(){
        var u = getCookieVal("dji_user");
        if(u){
            return u;
        }
        else{
            var g = guid();
            document.cookie = "dji_user=" + g;
            return g;
        }
    };

    hooks.getCurrentPage = function(){
        var href = window.hooks.getLocation().href;
        var page = href.toString().split(window.hooks.getLocation().host)[1];

        if(page == "/"){
            page = "/index";
        }

        return page.split("?")[0].split("#")[0];
    };

    hooks.wrapElement = function(data){
        var element = document.createElement("div");
        element.innerHTML = data;
        return element;
    };

    var getEpoch = function(){
        return new Date().getTime();
    };

    hooks.engageEvent = function(name){
        var _this = this;
        _this.name = name;
        _this.lastEngaged = getEpoch();

        addEventListener(name, function(evt){
            _this.lastEngaged = getEpoch(); 
        });

        var isEngaged = function(currentEpoch, engagedMilliseconds){
            return (Number(currentEpoch) - Number(_this.lastEngaged)) < engagedMilliseconds;
        };

        return {
            isEngaged: isEngaged
        };
    };

    hooks.engaged = function(){
        var names = ["scroll", "keydown", "mousemove"];
        var engagedMilliseconds = 1000;
        var events = [];

        for(var i = 0; i < names.length; i++){
            events.push(window.hooks.engageEvent(names[i]));
        }

        var isEngaged = function(currentEpoch){
            for(var i = 0; i < events.length; i++){
                if(events[i].isEngaged(getEpoch(), engagedMilliseconds)){
                    return true;
                }
            }
            return false;
        };

        return {
            isEngaged: isEngaged
        };
    };

    var addEventListener = function(evt, callback){
        if(window.addEventListener){
            window.addEventListener(evt, callback, false);
        }else if(document.attachEvent){
             document.attachEvent("on" + evt, callback);
        }
    };

    hooks.putTracker = function(activityType, data){
      
            var user = {"type":"djcs_info","value":{"UUID":"test"}};
            var payload = merge(hooks.getMetadata(), data);
            var url = window.hooks.commandUrl + "/v1/event.gif?"+
                         "key=" + window.btoa(unescape(encodeURIComponent(window.hooks.getCleanHref()))) + 
                         "&v=" + hooksVersion +
                         "&activityType=" + activityType + 
                         "&user=" + window.btoa(unescape(encodeURIComponent(JSON.stringify(user)))) + 
                         "&data=" + window.btoa(unescape(encodeURIComponent(JSON.stringify(payload))));
            var img = new window.Image(1, 1);
            img.src = url;
    };

    var parseHostname = function(url) {
        if(!(url) || url === "") return "";
        var a=document.createElement('a');
        a.href=url;
        return a.hostname;
    };

    hooks.getConfigData = function(){
        return window.dji_config || {};
    };

    // defaults for mouse position
    var mouse = {
        x: -1,
        y: -1
    };

    addEventListener("mousemove", function(event){
        // update last seen location on move
        event = event || window.event; // IE-ism
        mouse = {
            x: event.clientX,
            y: event.clientY
        };
    });

    hooks.getMetadata = function(){
        var data = { 
                    hostname: window.hooks.getLocation().hostname,
                    page: window.hooks.getCurrentPage(),
                    referrerHostname: parseHostname(document.referrer), 
                    referrer:document.referrer,
                    queryObject: window.hooks.getQueryObject(),
                    metaTags: window.hooks.parseMetatags(document.getElementsByTagName("meta")),
                    title: window.hooks.getTitle(),
                    mouse: mouse,
                    top: window.hooks.getTop(),
                    left: window.hooks.getLeft(),
                    width: window.hooks.getWidth(),
                    user: window.hooks.getUser(),
                    dji_user: window.hooks.getDJIUser(),
                    s_vi: window.hooks.getSVI(),
                    cke: window.hooks.getCke(),
                    height: window.hooks.getHeight(),
                    ua: window.navigator.userAgent
                   };
        data = merge(data, window.hooks.getConfigData());

        if(_sf_async_config){
            data._sf_async_config = _sf_async_config;
        }

        return data;
    };

    hooks.getTop = function(){
        if(window.pageYOffset)
        {
            return window.pageYOffset;
        }
        if(document.body){
            return document.body.scrollTop;
        }
        if(document.documentElement){
            return document.documentElement.scrollTop;
        }

        return 0;
    };

    hooks.getLeft = function(){
        if(window.pageYOffset)
        {
            return window.pageXOffset;
        }
        if(document.body){
            return document.body.scrollLeft;
        }
        if(document.documentElement){
            return document.documentElement.scrollLeft;
        }

        return 0;
    };

    hooks.getHeight = function(){
        return Math.max(document.body.scrollHeight, document.documentElement.scrollHeight) || 0;
    };

    hooks.getWidth = function(){
        return Math.max(document.body.scrollWidth, document.documentElement.scrollWidth) || 0;
    };

    var startCountingEngaged = function(){
        var q = [];
        var engagedSeconds = 0;
        var mgr = window.hooks.engaged();
        var intervalId = 0;

        var logEngaged = function(){
            var isEngaged = mgr.isEngaged(getEpoch());
            if(isEngaged){
                totalEngagedSeconds++;
            }
            q.push(isEngaged);
            if(q.length > (pingMilliseconds/1000)){
                for(var i = 0; i < q.length; i++){
                    if(q[i]){
                        engagedSeconds++;
                    }
                }
                window.clearInterval(intervalId);
            }
        };

        intervalId = window.setInterval(logEngaged, 1000);
    };

    hooks.sendLoad = function(){
        window.hooks.putTracker("load", {});
    };

    hooks.getCleanHref = function(){
        return window.hooks.getLocation().href.replace(window.hooks.getLocation().hash,"");
    };

    var init_overlay = function(){
        var v = new Date().getTime();
        var css = '<link href="' + window.hooks.baseUrl + '/css/overlay.css?v=' + v + '" rel="stylesheet" type="text/css" />';
        document.body.appendChild(window.hooks.wrapElement(css));

        var script = document.createElement("script");
        script.src = window.hooks.baseUrl + "/scripts/overlay.js?v=" + v;
        script.async = true;
        document.body.appendChild(script);
    };

    addEventListener("mousedown", function(event){
        event = event || window.event;
        var target = event.target || event.srcElement;
        if(target && target.href){
            var tags = document.getElementsByTagName(target.tagName);
            var page = window.hooks.getCurrentPage();

            page = page.split("?")[0];

            var data = {
                href: target.href.split("?")[0],
                textContent: encodeURIComponent(target.outerText.trim()),
                index: Array.prototype.indexOf.call(tags, target)
            };
            window.hooks.putTracker("click", data);
        }
    });

    addEventListener("beforeunload", function(event){
            var page =  window.hooks.getCurrentPage();
             var end = getEpoch();

            var data = {
                totalEngagedSeconds: totalEngagedSeconds,
                value: end - window.hooks.start
            };

            window.hooks.putTracker("timeSpent", data);
    });


   // namespacing pattern taken from jquery
   if ( typeof window === "object" && typeof window.document === "object" ) {
        window.hooks = merge(window.hooks, hooks);
    }

    if(window.parent){
        window.parent.postMessage({href:window.hooks.getLocation().href, activityType: "init"},"*");
       addEventListener("message", function(event) {
            event = event || window.event;
            if(event && /dj-overlay/.test(event.origin) || /dj-insights/.test(event.origin) || /insights.dowjones.net/.test(event.origin)){
                switch(event.data.activityType){
                    case "init_overlay":
                    if(event.data.baseUrl){
                        window.hooks.baseUrl = event.data.baseUrl;
                    }
                    init_overlay();
                    window.clearInterval(this.pingIntervalId);
                    break;
                }
            }
        });
    }


    hooks.sendLoad();
    startCountingEngaged();
    var pingIntervalId = window.setInterval(startCountingEngaged, pingMilliseconds);
})( window );
module.exports =

  READABILITY_TOKEN: '33cd31b9cce9187a74eb3f2c5ac114b6c0082c74'

  ALLOWED_REACT_NODES: [
    # from docs: ref-04-tags-and-attributes
    # html
    'a', 'abbr', 'address', 'area', 'article', 'aside', 'audio', 'b', 'base',
    'bdi', 'bdo', 'big', 'blockquote', 'body', 'br', 'button', 'canvas',
    'caption', 'cite', 'code', 'col', 'colgroup', 'data', 'datalist', 'dd',
    'del', 'details', 'dfn', 'div', 'dl', 'dt', 'em', 'embed', 'fieldset',
    'figcaption', 'figure', 'footer', 'form', 'h1', 'h2', 'h3', 'h4', 'h5',
    'h6', 'head', 'header', 'hr', 'html', 'i', 'iframe', 'img', 'input', 'ins',
    'kbd', 'keygen', 'label', 'legend', 'li', 'link', 'main', 'map', 'mark',
    'menu', 'menuitem', 'meta', 'meter', 'nav', 'noscript', 'object', 'ol',
    'optgroup', 'option', 'output', 'p', 'param', 'pre', 'progress', 'q', 'rp',
    'rt', 'ruby', 's', 'samp', 'script', 'section', 'select', 'small', 'source',
    'span', 'strong', 'style', 'sub', 'summary', 'sup', 'table', 'tbody', 'td',
    'textarea', 'tfoot', 'th', 'thead', 'time', 'title', 'tr', 'track', 'u',
    'ul', 'var', 'video', 'wbr',
    # svg
    'circle', 'defs', 'ellipse', 'g', 'line', 'linearGradient', 'mask', 'path',
    'pattern', 'polygon', 'polyline', 'radialGradient', 'rect', 'stop',
    'svg', 'text', 'tspan'
  ]

  ALLOWED_REACT_ATTRIBUTES: [
    # standard html
    'accept', 'accessKey', 'action', 'allowFullScreen', 'allowTransparency',
    'alt', 'async', 'autoComplete', 'autoFocus', 'autoPlay', 'cellPadding',
    'cellSpacing', 'charSet', 'checked', 'className', 'cols', 'colSpan',
    'content', 'contentEditable', 'contextMenu', 'controls', 'coords',
    'crossOrigin', 'data', 'dateTime', 'defer', 'dir', 'disabled', 'download',
    'draggable', 'encType', 'form', 'formNoValidate', 'frameBorder', 'height',
    'hidden', 'href', 'hrefLang', 'htmlFor', 'httpEquiv', 'icon', 'id', 'label',
    'lang', 'list', 'loop', 'max', 'maxLength', 'mediaGroup', 'method', 'min',
    'multiple', 'muted', 'name', 'noValidate', 'pattern', 'placeholder',
    'poster', 'preload', 'radioGroup', 'readOnly', 'rel', 'required', 'role',
    'rows', 'rowSpan', 'sandbox', 'scope', 'scrollLeft', 'scrolling',
    'scrollTop', 'seamless', 'selected', 'shape', 'size', 'span', 'spellCheck',
    'src', 'srcDoc', 'srcSet', 'start', 'step', 'style', 'tabIndex', 'target',
    'title', 'type', 'useMap', 'value', 'width', 'wmode',
    # nonstandard html
    'autoCapitalize', 'autoCorrect', 'property', 'itemProp', 'itemScope',
    'itemType',
    # svg
    'cx', 'cy', 'd', 'dx', 'dy', 'fill', 'fillOpacity', 'fontFamily',
    'fontSize', 'fx', 'fy', 'gradientTransform', 'gradientUnits', 'markerEnd',
    'markerMid','markerStart', 'offset', 'opacity', 'patternContentUnits',
    'patternUnits', 'points', 'preserveAspectRatio', 'r', 'rx', 'ry',
    'spreadMethod', 'stopColor', 'stopOpacity', 'stroke', 'strokeDasharray',
    'strokeLinecap', 'strokeOpacity', 'strokeWidth', 'textAnchor', 'transform',
    'version', 'viewBox', 'x1', 'x2', 'x', 'y1', 'y2', 'y'
  ]

  INLINE_ELEMENTS: [
    # from https://developer.mozilla.org/en-US/docs/Web/HTML/Inline_elemente
    'b', 'big', 'i', 'small', 'tt', 'abbr', 'acronym', 'cite', 'code', 'dfn',
    'em', 'kbd', 'strong', 'samp', 'var', 'a', 'bdo', 'br', 'img', 'map',
    'object', 'q', 'script', 'span', 'sub', 'sup', 'button', 'input', 'label',
    'select', 'textarea',
  ]
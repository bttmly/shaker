# requires jQuery http://code.jquery.com/jquery-2.1.0.min.js
# requires StyleFix (bundled with PrefixFree) https://raw.github.com/LeaVerou/prefixfree/gh-pages/prefixfree.min.js

# adapted from http://youmightnotneedjquery.com/
extend = ( out ) ->
  out or= {}
  i = 1
  while i < arguments.length
    continue  unless arguments[i]
    for own key of arguments[i]
      out[key] = arguments[i][key]
    i++
  out

# adapted from http://justjson.blogspot.com/2013/08/css-animation-detect-animation-end.html
animEnd = do ( d = document.createElement "div" ) ->
  eventNames =
    'animation': 'animationend',
    '-o-animation': 'oAnimationEnd',
    '-moz-animation': 'animationend',
    '-webkit-animation': 'webkitAnimationEnd'
  for prop, evt of eventNames
    return evt if d.style[prop]?

defaults =
  amount : 5
  shakes : 5
  className : "shaking-shaking"
  animationName : "shaky-shaky"
  duration : .5
  direction : "horizontal"
  concave : false
  flat : false
  shakeModifier : ( step, totalSteps ) ->
      ( totalSteps - step ) / totalSteps

class Shaker
  constructor : ( opts ) ->
    settings = extend {}, defaults, opts
    { @amount, @shakes, @className, @animationName, @duration, @direction, @concave, @shakeModifier, @flat } = settings
    @makeRules()
    @makeSheet()
  
  makeRules : ->
    
    if @direction is "horizontal"
      @translate = "translateX"
      @rotate = "rotateY"
    else if @direction is "vertical"
      @translate = "translateY"
      @rotate = "rotateX"

    # start CSS rule string
    str = "@keyframes #{ @animationName } {\n"
    
    # add rules for start and finish
    str += "0, 100% { #{ @translate }(0), #{ @rotate }(0) }\n"
    
    # iterate over steps
    for i in [1...@shakes]
      
      # add keyframe percentage to CSS string
      str += "#{i * 100 / @shakes}% {\n"
      
      # alternates shake direction
      if i % 2 is 1 then o = -1 else o = 1
      
      # vertical shake feels more natural this way
      if @direction is "vertical" then d = -1 else d = 1
        
      if @concave then d = -1 * d
       
      # calculate rotate amount, add unit
      rotate = if @flat then 0 else @shakeModifier( i, @shakes ) * d * o * 90 * @amount / 100 + "deg"
      
      # calculate translate amount, add unit
      translate = @shakeModifier( i, @shakes ) * o * @amount + "%"

      # add rule to CSS string
      str += "transform: #{ @translate }(#{translate}) #{ @rotate }(#{rotate});\n}\n"
    
    # finish keyframes rule
    str += "}\n"

    @keyframesRule = str
    @classRule = ".#{ @className } { animation-name: #{ @animationName };\n animation-duration: #{ @duration }s; }"
    
  makeSheet : ->
    @stylesheet = document.createElement "style"
    @stylesheet.appendChild document.createTextNode "#{ @keyframesRule }\n #{ @classRule }"
    document.getElementsByTagName( "head" )[0].appendChild @stylesheet
    StyleFix.styleElement @stylesheet
    
  destroySheet : ->
    document.getElementsByTagName( "head" )[0].removeChild @stylesheet
    
  shake : ( el, cb ) ->

      handler = ( ->
        el.classList.remove @className
        if cb then cb.bind( @ )( el )
        el.removeEventListener animEnd, handler
      ).bind( @ )

      el.classList.add @className
      el.addEventListener animEnd, handler

this.Shaker = Shaker


getStyle = (oElm, strCssRule) ->
  strValue = ""
  if document.defaultView and document.defaultView.getComputedStyle
    strValue = document.defaultView.getComputedStyle(oElm, "").getPropertyValue(strCssRule)
  else if oElm.currentStyle
    strCssRule = strCssRule.replace(/\-(\w)/g, (strMatch, p1) ->
      p1.toUpperCase()
    )
    strValue = oElm.currentStyle[strCssRule]
  strValue
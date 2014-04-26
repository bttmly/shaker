# requires jQuery http://code.jquery.com/jquery-2.1.0.min.js
# requires StyleFix (bundled with PrefixFree) https://raw.github.com/LeaVerou/prefixfree/gh-pages/prefixfree.min.js

defaults =
  amount : 5
  shakes : 5
  className : "shaking-shaking"
  animationName : "shaky-shaky"
  duration : .5
  direction : "horizontal"
  concave : false
  flat : false
  multiplier : ( i, t ) ->
      ( t - i ) / t

class Shaker
  constructor : ( opts ) ->
    settings = $.extend {}, defaults, opts
    { @amount, @shakes, @className, @animationName, @duration, @direction, @concave, @multiplier, @flat } = settings
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
      rotate = if @flat then 0 else @multiplier( i, @shakes ) * d * o * 90 * @amount / 100 + "deg"
      
      # calculate translate amount, add unit
      translate = @multiplier( i, @shakes ) * o * @amount + "%"

      # add rule to CSS string
      str += "transform: #{ @translate }(#{translate}) #{ @rotate }(#{rotate});\n}\n"
    
    # finish keyframes rule
    str += "}\n"

    @keyframesRule = str
    @classRule = ".#{ @className } { animation-name: #{ @animationName }; animation-duration: #{ @duration }s }"
    
  makeSheet : ->
    @stylesheet = document.createElement "style"
    @stylesheet.innerHTML = """
#{ @keyframesRule }
#{ @classRule }
    """
    document.getElementsByTagName( "head" )[0].appendChild @stylesheet
    StyleFix.styleElement @stylesheet
    
  destroySheet : ->
    document.getElementsByTagName( "head" )[0].removeChild @stylesheet
    
  shake : do ->
    animStart = "webkitAnimationStart oanimationstart msAnimationStart animationstart"
    animEnd = "webkitAnimationEnd oanimationend msAnimationEnd animationend"
    ( el, cb ) ->
      el.addClass @className
      el.one animEnd, =>
        el.removeClass @className
        if cb then cb.bind( @ )( el )

# use this to shake jQuery OO style.
$.fn.shakeWith = ( shaker, opts, cb ) ->
  $( this ).each ( e ) ->
    args = [].slice.call( arguments )
    args.shift()
    args.unshift e
    shaker.shake.apply shaker, args 

this.Shaker = Shaker
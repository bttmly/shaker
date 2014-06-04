# Shaker
_A CoffeeScript class for, uh, shaking things._

**Instantiation**
(default params shown)
```javascript
var shaker = new Shaker({
  amount : 5, // intensity of the shake
  shakes : 5, // number of shakes
  animationName : "shaky-shaky", // name of the animation
  className : "shaking-shaking", // name of the applied class
  direction : "vertical", // or "horizontal"
  duration : .5, // in seconds
  multiplier : function( i, t ){
    return ( t - i ) / t
  }, // describes the shake amount at each increment. i = iteration, t = @shakes
  // for reasonable looking shaking, function should produce declining values as i approaches t
  flat : false // shaking in 3d is cooler anyway
  concave : false // change at your own risk
});
```

**Usage**
```javascript
shaker.shake( document.getElementById( "id" ), function( el ) {
  // "this" is the shaker
});
```

You can implement your own jQuery plugin, maybe like so (untested):
```javascript
$.fn.shakeWith = function( shaker, opts, cb) {
  $( this ).each( function( e ) {
    var args = [].slice.call( arguments );
    args.shift();
    args.unshift( e );
    shaker.shake.apply( shaker, args );
  });
};
```

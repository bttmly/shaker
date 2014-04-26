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
shaker.shake( $("#panel" ), function( el ) {
  // "this" is the shaker
  this.removeSheet(); // remove the inserted stylesheet
});

// or 

$( "#panel" ).shakeWith( shaker, function( el ) {
  // "this" is the shaker
  this.removeSheet(); // remove the inserted stylesheet  
});

```

Using it as a jQuery plugin is a little unintuitive, since the callback is called in the context of the shaker, not the jQuery object on which .shakeWith is called, which is atypical for jQuery plugins.
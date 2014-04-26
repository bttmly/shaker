# Shaker
_A CoffeeScript class for, uh, shaking things._

**Instantiation**
(default params shown)
```javascript
var shaker = new Shaker({
  amount: 5, // intensity of the shake
  steps: 5, // number of shakes
  animationName : "shaky-shaky", // name of the animation
  className : "shaking-shaking", // name of the applied class
  direction : "vertical", // or "horizontal"
  duration : .5, // in seconds
  multiplier : function( i, t ){
    return ( t - i ) / t
  }, // describes the reduction in shaking each time. i = iteration, t = @shakes
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

```
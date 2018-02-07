'use strict';
var Point = require ("openfl/geom/Point").default;
var Rectangle = require ("openfl/geom/Rectangle").default;

var Button = require ("starling/display/Button").default;
var DisplayObject = require ("starling/display/DisplayObject").default;
var Texture = require ("starling/textures/Texture").default;

var RoundButton = function(upState, text, downState)
{
    if (text === undefined) text = "";
    if (downState === undefined) downState = null;
    
    Button.call(this, upState, text, downState);
}

RoundButton.prototype = Object.create(Button.prototype);
RoundButton.prototype.constructor = RoundButton;

RoundButton.prototype.hitTest = function(localPoint)
{
    // When the user touches the screen, this method is used to find out if an object was 
    // hit. By default, this method uses the bounding box, but by overriding it, 
    // we can change the box (rectangle) to a circle (or whatever necessary).
    
    // these are the cases in which a hit test must always fail
    if (!this.visible || !this.touchable || !this.hitTestMask(localPoint)) return null;
    
    // get center of button
    var bounds = this.bounds;
    var centerX = bounds.width / 2;
    var centerY = bounds.height / 2;
    
    // calculate distance of localPoint to center. 
    // we keep it squared, since we want to avoid the 'sqrt()'-call.
    var sqDist = Math.pow(localPoint.x - centerX, 2) + 
                        Math.pow(localPoint.y - centerY, 2);
    
    // when the squared distance is smaller than the squared radius, 
    // the point is inside the circle
    var radius = bounds.width / 2 - 8;
    if (sqDist < Math.pow(radius, 2)) return this;
    else return null;
}

module.exports.RoundButton = RoundButton;
module.exports.default = RoundButton;
'use strict';
var Point = require ("openfl/geom/Point").default;
var Vector = require ("openfl/Vector").default;

var DisplayObject = require ("starling/display/DisplayObject").default;
var Sprite = require ("starling/display/Sprite").default;
var Touch = require ("starling/events/Touch").default;
var TouchEvent = require ("starling/events/TouchEvent").default;
var TouchPhase = require ("starling/events/TouchPhase").default;

var TouchSheet = function(contents)
{
    if (contents === undefined) contents = null;
    
    Sprite.call(this);
    
    this.onTouch = this.onTouch.bind(this);
    
    this.addEventListener(TouchEvent.TOUCH, this.onTouch);
    this.useHandCursor = true;
    
    if (contents != null)
    {
        contents.x = (contents.width / -2);
        contents.y = (contents.height / -2);
        this.addChild(contents);
    }
}

TouchSheet.prototype = Object.create(Sprite.prototype);
TouchSheet.prototype.constructor = TouchSheet;

TouchSheet.prototype.onTouch = function(event)
{
    var touches = event.getTouches(this, TouchPhase.MOVED);
    
    if (touches.length == 1)
    {
        // one finger touching -> move
        var delta = touches[0].getMovement(this.parent);
        this.x += delta.x;
        this.y += delta.y;
    }            
    else if (touches.length == 2)
    {
        // two fingers touching -> rotate and scale
        var touchA = touches[0];
        var touchB = touches[1];
        
        var currentPosA  = touchA.getLocation(this.parent);
        var previousPosA = touchA.getPreviousLocation(this.parent);
        var currentPosB  = touchB.getLocation(this.parent);
        var previousPosB = touchB.getPreviousLocation(this.parent);
        
        var currentVector  = currentPosA.subtract(currentPosB);
        var previousVector = previousPosA.subtract(previousPosB);
        
        var currentAngle  = Math.atan2(currentVector.y, currentVector.x);
        var previousAngle = Math.atan2(previousVector.y, previousVector.x);
        var deltaAngle = currentAngle - previousAngle;
        
        // update pivot point based on previous center
        var previousLocalA  = touchA.getPreviousLocation(this);
        var previousLocalB  = touchB.getPreviousLocation(this);
        this.pivotX = (previousLocalA.x + previousLocalB.x) * 0.5;
        this.pivotY = (previousLocalA.y + previousLocalB.y) * 0.5;
        
        // update location based on the current center
        this.x = (currentPosA.x + currentPosB.x) * 0.5;
        this.y = (currentPosA.y + currentPosB.y) * 0.5;
        
        // rotate
        this.rotation += deltaAngle;

        // scale
        var sizeDiff = currentVector.length / previousVector.length;
        this.scaleX *= sizeDiff;
        this.scaleY *= sizeDiff;
    }
    
    var touch = event.getTouch(this, TouchPhase.ENDED);
    
    if (touch != null && touch.tapCount == 2)
    this.parent.addChild(this); // bring self to front
    
    // enable this code to see when you're hovering over the object
    // touch = event.getTouch(this, TouchPhase.HOVER);            
    // alpha = touch ? 0.8 : 1.0;
}

TouchSheet.prototype.dispose = function()
{
    removeEventListener(TouchEvent.TOUCH, this.onTouch);
    Sprite.prototype.dispose.call(this);
}

module.exports.TouchSheet = TouchSheet;
module.exports.default = TouchSheet;
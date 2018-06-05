import Point from "openfl/geom/Point";
import Vector from "openfl/Vector";

import DisplayObject from "starling/display/DisplayObject";
import Sprite from "starling/display/Sprite";
import Touch from "starling/events/Touch";
import TouchEvent from "starling/events/TouchEvent";
import TouchPhase from "starling/events/TouchPhase";

class TouchSheet extends Sprite
{
    public constructor(contents:DisplayObject=null)
    {
        super();
        this.addEventListener(TouchEvent.TOUCH, this.onTouch);
        this.useHandCursor = true;
        
        if (contents != null)
        {
            contents.x = (contents.width / -2);
            contents.y = (contents.height / -2);
            this.addChild(contents);
        }
    }
    
    private onTouch = (event:TouchEvent):void =>
    {
        var touches:Vector<Touch> = event.getTouches(this, TouchPhase.MOVED);
        
        if (touches.length == 1)
        {
            // one finger touching -> move
            var delta:Point = touches[0].getMovement(this.parent);
            this.x += delta.x;
            this.y += delta.y;
        }            
        else if (touches.length == 2)
        {
            // two fingers touching -> rotate and scale
            var touchA:Touch = touches[0];
            var touchB:Touch = touches[1];
            
            var currentPosA:Point  = touchA.getLocation(this.parent);
            var previousPosA:Point = touchA.getPreviousLocation(this.parent);
            var currentPosB:Point  = touchB.getLocation(this.parent);
            var previousPosB:Point = touchB.getPreviousLocation(this.parent);
            
            var currentVector:Point  = currentPosA.subtract(currentPosB);
            var previousVector:Point = previousPosA.subtract(previousPosB);
            
            var currentAngle:number  = Math.atan2(currentVector.y, currentVector.x);
            var previousAngle:number = Math.atan2(previousVector.y, previousVector.x);
            var deltaAngle:number = currentAngle - previousAngle;
            
            // update pivot point based on previous center
            var previousLocalA:Point  = touchA.getPreviousLocation(this);
            var previousLocalB:Point  = touchB.getPreviousLocation(this);
            this.pivotX = (previousLocalA.x + previousLocalB.x) * 0.5;
            this.pivotY = (previousLocalA.y + previousLocalB.y) * 0.5;
            
            // update location based on the current center
            this.x = (currentPosA.x + currentPosB.x) * 0.5;
            this.y = (currentPosA.y + currentPosB.y) * 0.5;
            
            // rotate
            this.rotation += deltaAngle;

            // scale
            var sizeDiff:number = currentVector.length / previousVector.length;
            this.scaleX *= sizeDiff;
            this.scaleY *= sizeDiff;
        }
        
        var touch:Touch = event.getTouch(this, TouchPhase.ENDED);
        
        if (touch != null && touch.tapCount == 2)
        this.parent.addChild(this); // bring self to front
        
        // enable this code to see when you're hovering over the object
        // touch = event.getTouch(this, TouchPhase.HOVER);            
        // alpha = touch ? 0.8 : 1.0;
    }
    
    public dispose():void
    {
        this.removeEventListener(TouchEvent.TOUCH, this.onTouch);
        super.dispose();
    }
}

export default TouchSheet;
import Point from "openfl/geom/Point";
import Rectangle from "openfl/geom/Rectangle";

import Button from "starling/display/Button";
import DisplayObject from "starling/display/DisplayObject";
import Texture from "starling/textures/Texture";

class RoundButton extends Button
{
    public constructor(upState:Texture, text:string="", downState:Texture=null)
    {
        super(upState, text, downState);
    }
    
    public hitTest(localPoint:Point):DisplayObject
    {
        // When the user touches the screen, this method is used to find out if an object was 
        // hit. By default, this method uses the bounding box, but by overriding it, 
        // we can change the box (rectangle) to a circle (or whatever necessary).
        
        // these are the cases in which a hit test must always fail
        if (!this.visible || !this.touchable || !this.hitTestMask(localPoint)) return null;
        
        // get center of button
        var bounds:Rectangle = this.bounds;
        var centerX:number = bounds.width / 2;
        var centerY:number = bounds.height / 2;
        
        // calculate distance of localPoint to center. 
        // we keep it squared, since we want to avoid the 'sqrt()'-call.
        var sqDist:number = Math.pow(localPoint.x - centerX, 2) + 
                            Math.pow(localPoint.y - centerY, 2);
        
        // when the squared distance is smaller than the squared radius, 
        // the point is inside the circle
        var radius:number = bounds.width / 2 - 8;
        if (sqDist < Math.pow(radius, 2)) return this;
        else return null;
    }
}

export default RoundButton;
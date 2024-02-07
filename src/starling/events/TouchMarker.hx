// =================================================================================================
//
//	Starling Framework
//	Copyright Gamua GmbH. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

package starling.events;

import openfl.display.BitmapData;
import openfl.display.Shape;
import openfl.geom.Point;

import starling.core.Starling;
import starling.display.Image;
import starling.display.Sprite;
import starling.textures.Texture;

/** The TouchMarker is used internally to mark touches created through "simulateMultitouch". */
class TouchMarker extends Sprite
{
    @:noCompletion private var __center:Point;
    @:noCompletion private var __texture:Texture;
    
    #if commonjs
    private static function __init__ () {
        
        untyped Object.defineProperties (TouchMarker.prototype, {
            "realMarker": { get: untyped __js__ ("function () { return this.get_realMarker(); }") },
            "mockMarker": { get: untyped __js__ ("function () { return this.get_mockMarker (); }") },
            "realX": { get: untyped __js__ ("function () { return this.get_realX (); }") },
            "realY": { get: untyped __js__ ("function () { return this.get_realY (); }") },
            "mockX": { get: untyped __js__ ("function () { return this.get_mockX (); }") },
            "mockY": { get: untyped __js__ ("function () { return this.get_mockY (); }") },
        });
        
    }
    #end
    
    public function new()
    {
        super();

        __center = new Point();
        __texture = createTexture();
        
        for (i in 0...2)
        {
            var marker:Image = new Image(__texture);
            marker.pivotX = __texture.width / 2;
            marker.pivotY = __texture.height / 2;
            marker.touchable = false;
            addChild(marker);
        }
    }
    
    public override function dispose():Void
    {
        __texture.dispose();
        super.dispose();
    }
    
    public function moveMarker(x:Float, y:Float, withCenter:Bool=false):Void
    {
        if (withCenter)
        {
            __center.x += x - realMarker.x;
            __center.y += y - realMarker.y;
        }
        
        realMarker.x = x;
        realMarker.y = y;
        mockMarker.x = 2*__center.x - x;
        mockMarker.y = 2*__center.y - y;
    }
    
    public function moveCenter(x:Float, y:Float):Void
    {
        __center.x = x;
        __center.y = y;
        moveMarker(realX, realY); // reset mock position
    }
    
    private function createTexture():Texture
    {
        var scale:Float = Starling.current.contentScaleFactor;
        var radius:Float = 12 * scale;
        var width:Int = Std.int(32 * scale);
        var height:Int = Std.int(32 * scale);
        var thickness:Float = 1.5 * scale;
        var shape:Shape = new Shape();
        
        // draw dark outline
        shape.graphics.lineStyle(thickness, 0x0, 0.3);
        shape.graphics.drawCircle(width/2, height/2, radius + thickness);
        
        // draw white inner circle
        shape.graphics.beginFill(0xffffff, 0.4);
        shape.graphics.lineStyle(thickness, 0xffffff);
        shape.graphics.drawCircle(width/2, height/2, radius);
        shape.graphics.endFill();
        
        var bmpData:BitmapData = new BitmapData(width, height, true, 0x0);
        bmpData.draw(shape);
        
        return Texture.fromBitmapData(bmpData, false, false, scale);
    }
    
    private var realMarker(get, never):Image;
    private function get_realMarker():Image { return cast(getChildAt(0), Image); }
    private var mockMarker(get, never):Image;
    private function get_mockMarker():Image { return cast(getChildAt(1), Image); }
    
    public var realX(get, never):Float;
    private function get_realX():Float { return realMarker.x; }
    public var realY(get, never):Float;
    private function get_realY():Float { return realMarker.y; }
    
    public var mockX(get, never):Float;
    private function get_mockX():Float { return mockMarker.x; }
    public var mockY(get, never):Float;
    private function get_mockY():Float { return mockMarker.y; }        
}
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
import flash.display.BitmapData;
import flash.display.Shape;
import flash.geom.Point;

import starling.core.Starling;
import starling.display.Image;
import starling.display.Sprite;
import starling.textures.Texture;

/** The TouchMarker is used internally to mark touches created through "simulateMultitouch". */
class TouchMarker extends Sprite
{
    private var _center:Point;
    private var _texture:Texture;
    
    public function new()
    {
        super();
        _center = new Point();
        _texture = createTexture();
        
        for (i in 0 ... 2)
        {
            var marker:Image = new Image(_texture);
            marker.pivotX = _texture.width / 2;
            marker.pivotY = _texture.height / 2;
            marker.touchable = false;
            addChild(marker);
        }
    }
    
    public override function dispose():Void
    {
        _texture.dispose();
        super.dispose();
    }
    
    public function moveMarker(x:Float, y:Float, withCenter:Bool=false):Void
    {
        if (withCenter)
        {
            _center.x += x - realMarker.x;
            _center.y += y - realMarker.y;
        }
        
        realMarker.x = x;
        realMarker.y = y;
        mockMarker.x = 2*_center.x - x;
        mockMarker.y = 2*_center.y - y;
    }
    
    public function moveCenter(x:Float, y:Float):Void
    {
        _center.x = x;
        _center.y = y;
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
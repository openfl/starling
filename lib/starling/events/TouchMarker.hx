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

@:jsRequire("starling/events/TouchMarker", "default")

extern class TouchMarker extends Sprite
{
    public function new();
    
    public override function dispose():Void;
    
    public function moveMarker(x:Float, y:Float, withCenter:Bool=false):Void;
    
    public function moveCenter(x:Float, y:Float):Void;
}
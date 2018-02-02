package starling.events;

import starling.display.Sprite;
import starling.core.Starling;
import Std;
import starling.textures.Texture;
import js.Boot;
import starling.display.Image;

@:jsRequire("starling/events/TouchMarker", "default")

extern class TouchMarker extends starling.display.Sprite {
	var mockX(get,never) : Float;
	var mockY(get,never) : Float;
	var realX(get,never) : Float;
	var realY(get,never) : Float;
	function new() : Void;
	function moveCenter(x : Float, y : Float) : Void;
	function moveMarker(x : Float, y : Float, withCenter : Bool = false) : Void;
}

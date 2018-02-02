package starling.display;

import starling.display.DisplayObjectContainer;
import starling.utils.MatrixUtil;
import starling.utils.MathUtil;
import js.Boot;
import starling.display.DisplayObject;
import Std;

@:jsRequire("starling/display/Sprite3D", "default")

extern class Sprite3D extends DisplayObjectContainer {
	var isFlat(get,never) : Bool;
	@:keep var pivotZ(get,set) : Float;
	@:keep var rotationX(get,set) : Float;
	@:keep var rotationY(get,set) : Float;
	@:keep var rotationZ(get,set) : Float;
	@:keep var scaleZ(get,set) : Float;
	@:keep var z(get,set) : Float;
	function new() : Void;
}

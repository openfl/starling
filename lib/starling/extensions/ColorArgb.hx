package starling.extensions;

import Std;

@:jsRequire("starling/extensions/ColorArgb", "default")
extern class ColorArgb {
	var alpha : Float;
	var blue : Float;
	var green : Float;
	var red : Float;
	function new(red : Float = 0, green : Float = 0, blue : Float = 0, alpha : Float = 0) : Void;
	function _fromArgb(color : Int) : Void;
	function _fromRgb(color : Int) : Void;
	function copyFrom(argb : ColorArgb) : Void;
	function toArgb() : Int;
	function toRgb() : Int;
	static function fromArgb(color : Int) : ColorArgb;
	static function fromRgb(color : Int) : ColorArgb;
}

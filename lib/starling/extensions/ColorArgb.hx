package starling.extensions;

import Std;

@:jsRequire("starling/extensions/ColorArgb", "default")

extern class ColorArgb implements Dynamic {

	function new(?red:Dynamic, ?green:Dynamic, ?blue:Dynamic, ?alpha:Dynamic);
	var red:Dynamic;
	var green:Dynamic;
	var blue:Dynamic;
	var alpha:Dynamic;
	function toRgb():Dynamic;
	function toArgb():Dynamic;
	function _fromRgb(color:Dynamic):Dynamic;
	function _fromArgb(color:Dynamic):Dynamic;
	function copyFrom(argb:Dynamic):Dynamic;
	static function fromRgb(color:Dynamic):Dynamic;
	static function fromArgb(color:Dynamic):Dynamic;


}
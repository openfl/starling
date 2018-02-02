package starling.utils;

import starling.errors.AbstractClassError;

@:jsRequire("starling/utils/Align", "default")

extern class Align implements Dynamic {

	function Align():Dynamic;
	static var LEFT:Dynamic;
	static var RIGHT:Dynamic;
	static var TOP:Dynamic;
	static var BOTTOM:Dynamic;
	static var CENTER:Dynamic;
	static function isValid(align:Dynamic):Dynamic;
	static function isValidHorizontal(align:Dynamic):Dynamic;
	static function isValidVertical(align:Dynamic):Dynamic;


}
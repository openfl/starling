package starling.utils;

import starling.errors.AbstractClassError;

@:jsRequire("starling/utils/Align", "default")

extern class Align {
	function Align() : Void;
	static var BOTTOM(default,never) : String;
	static var CENTER(default,never) : String;
	static var LEFT(default,never) : String;
	static var RIGHT(default,never) : String;
	static var TOP(default,never) : String;
	static function isValid(align : String) : Bool;
	static function isValidHorizontal(align : String) : Bool;
	static function isValidVertical(align : String) : Bool;
}

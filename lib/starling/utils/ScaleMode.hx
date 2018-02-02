package starling.utils;



@:jsRequire("starling/utils/ScaleMode", "default")

extern class ScaleMode {
	static var NONE(default,never) : String;
	static var NO_BORDER(default,never) : String;
	static var SHOW_ALL(default,never) : String;
	static function isValid(scaleMode : String) : Bool;
}

package starling.display;

import starling.core.Starling;
import haxe.ds.StringMap;

@:jsRequire("starling/display/BlendMode", "default")

extern class BlendMode implements Dynamic {

	function new(name:Dynamic, sourceFactor:Dynamic, destinationFactor:Dynamic);
	var __name:Dynamic;
	var __sourceFactor:Dynamic;
	var __destinationFactor:Dynamic;
	function activate():Dynamic;
	function toString():Dynamic;
	var sourceFactor:Dynamic;
	function get_sourceFactor():Dynamic;
	var destinationFactor:Dynamic;
	function get_destinationFactor():Dynamic;
	var name:Dynamic;
	function get_name():Dynamic;
	static var sBlendModes:Dynamic;
	static var AUTO:Dynamic;
	static var NONE:Dynamic;
	static var NORMAL:Dynamic;
	static var ADD:Dynamic;
	static var MULTIPLY:Dynamic;
	static var SCREEN:Dynamic;
	static var ERASE:Dynamic;
	static var MASK:Dynamic;
	static var BELOW:Dynamic;
	static function get(modeName:Dynamic):Dynamic;
	static function getByFactors(srcFactor:Dynamic, dstFactor:Dynamic):Dynamic;
	static function register(name:Dynamic, srcFactor:Dynamic, dstFactor:Dynamic):Dynamic;
	static function registerDefaults():Dynamic;


}
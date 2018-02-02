package starling.display;

import starling.core.Starling;
import haxe.ds.StringMap;

@:jsRequire("starling/display/BlendMode", "default")

extern class BlendMode {
	var destinationFactor(get,never) : String;
	var name(get,never) : String;
	var sourceFactor(get,never) : String;
	function new(name : String, sourceFactor : openfl.display3D.Context3DBlendFactor, destinationFactor : openfl.display3D.Context3DBlendFactor) : Void;
	function activate() : Void;
	function toString() : String;
	static var ADD(default,never) : String;
	static var AUTO(default,never) : String;
	static var BELOW(default,never) : String;
	static var ERASE(default,never) : String;
	static var MASK(default,never) : String;
	static var MULTIPLY(default,never) : String;
	static var NONE(default,never) : String;
	static var NORMAL(default,never) : String;
	static var SCREEN(default,never) : String;
	static function get(modeName : String) : BlendMode;
	static function getByFactors(srcFactor : openfl.display3D.Context3DBlendFactor, dstFactor : openfl.display3D.Context3DBlendFactor) : Null<BlendMode>;
	static function register(name : String, srcFactor : openfl.display3D.Context3DBlendFactor, dstFactor : openfl.display3D.Context3DBlendFactor) : BlendMode;
}
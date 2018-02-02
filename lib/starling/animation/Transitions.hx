package starling.animation;

import haxe.ds.StringMap;

@:jsRequire("starling/animation/Transitions", "default")

extern class Transitions implements Dynamic {

	static var LINEAR:Dynamic;
	static var EASE_IN:Dynamic;
	static var EASE_OUT:Dynamic;
	static var EASE_IN_OUT:Dynamic;
	static var EASE_OUT_IN:Dynamic;
	static var EASE_IN_BACK:Dynamic;
	static var EASE_OUT_BACK:Dynamic;
	static var EASE_IN_OUT_BACK:Dynamic;
	static var EASE_OUT_IN_BACK:Dynamic;
	static var EASE_IN_ELASTIC:Dynamic;
	static var EASE_OUT_ELASTIC:Dynamic;
	static var EASE_IN_OUT_ELASTIC:Dynamic;
	static var EASE_OUT_IN_ELASTIC:Dynamic;
	static var EASE_IN_BOUNCE:Dynamic;
	static var EASE_OUT_BOUNCE:Dynamic;
	static var EASE_IN_OUT_BOUNCE:Dynamic;
	static var EASE_OUT_IN_BOUNCE:Dynamic;
	static var sTransitions:Dynamic;
	static function getTransition(name:Dynamic):Dynamic;
	static function register(name:Dynamic, func:Dynamic):Dynamic;
	static function registerDefaults():Dynamic;
	static function linear(ratio:Dynamic):Dynamic;
	static function easeIn(ratio:Dynamic):Dynamic;
	static function easeOut(ratio:Dynamic):Dynamic;
	static function easeInOut(ratio:Dynamic):Dynamic;
	static function easeOutIn(ratio:Dynamic):Dynamic;
	static function easeInBack(ratio:Dynamic):Dynamic;
	static function easeOutBack(ratio:Dynamic):Dynamic;
	static function easeInOutBack(ratio:Dynamic):Dynamic;
	static function easeOutInBack(ratio:Dynamic):Dynamic;
	static function easeInElastic(ratio:Dynamic):Dynamic;
	static function easeOutElastic(ratio:Dynamic):Dynamic;
	static function easeInOutElastic(ratio:Dynamic):Dynamic;
	static function easeOutInElastic(ratio:Dynamic):Dynamic;
	static function easeInBounce(ratio:Dynamic):Dynamic;
	static function easeOutBounce(ratio:Dynamic):Dynamic;
	static function easeInOutBounce(ratio:Dynamic):Dynamic;
	static function easeOutInBounce(ratio:Dynamic):Dynamic;
	static function easeCombined(startFunc:Dynamic, endFunc:Dynamic, ratio:Dynamic):Dynamic;


}
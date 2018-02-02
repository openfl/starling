package starling.utils;

import Reflect;

@:jsRequire("starling/utils/Execute", "default")

extern class Execute {
	@:has_untyped static function execute(func : haxe.Constraints.Function, args : Array<Dynamic>) : Void;
}

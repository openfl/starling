package starling.utils;

import EReg;
import Std;
import HxOverrides;

@:jsRequire("starling/utils/StringUtil", "default")

extern class StringUtil implements Dynamic {

	static function format(format:Dynamic, args:Dynamic):Dynamic;
	static function clean(string:Dynamic):Dynamic;
	static function trimStart(string:Dynamic):Dynamic;
	static function trimEnd(string:Dynamic):Dynamic;
	static function trim(string:Dynamic):Dynamic;


}
package starling.utils;

import EReg;
import Std;
import HxOverrides;

@:jsRequire("starling/utils/StringUtil", "default")

extern class StringUtil {
	static function clean(string : String) : String;
	static function format(format : String, args : Array<Dynamic>) : String;
	static function trim(string : String) : String;
	static function trimEnd(string : String) : String;
	static function trimStart(string : String) : String;
}

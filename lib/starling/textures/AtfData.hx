package starling.textures;

import Std;

@:jsRequire("starling/textures/AtfData", "default")

extern class AtfData {
	var data(get,never) : openfl.utils.ByteArray;
	var format(get,never) : String;
	var height(get,never) : Int;
	var isCubeMap(get,never) : Bool;
	var numTextures(get,never) : Int;
	var width(get,never) : Int;
	function new(data : openfl.utils.ByteArray) : Void;
	static function isAtfData(data : openfl.utils.ByteArray) : Bool;
}

package starling.textures;

import Std;

@:jsRequire("starling/textures/AtfData", "default")

extern class AtfData implements Dynamic {

	function new(data:Dynamic);
	var _format:Dynamic;
	var _width:Dynamic;
	var _height:Dynamic;
	var _numTextures:Dynamic;
	var _isCubeMap:Dynamic;
	var _data:Dynamic;
	var format:Dynamic;
	function get_format():Dynamic;
	var width:Dynamic;
	function get_width():Dynamic;
	var height:Dynamic;
	function get_height():Dynamic;
	var numTextures:Dynamic;
	function get_numTextures():Dynamic;
	var isCubeMap:Dynamic;
	function get_isCubeMap():Dynamic;
	var data:Dynamic;
	function get_data():Dynamic;
	static function isAtfData(data:Dynamic):Dynamic;


}
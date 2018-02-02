package starling.display;

import starling.display.Quad;
import starling.utils.MathUtil;
import starling.utils.Pool;
import starling.utils.RectangleUtil;
import Std;
import haxe.ds.ObjectMap;
import starling.utils.Padding;
// import starling.display.TextureSetupSettings;

@:jsRequire("starling/display/Image", "default")

extern class Image extends starling.display.Quad implements Dynamic {

	function new(texture:Dynamic);
	var __scale9Grid:Dynamic;
	var __tileGrid:Dynamic;
	var scale9Grid:Dynamic;
	function get_scale9Grid():Dynamic;
	function set_scale9Grid(value:Dynamic):Dynamic;
	var tileGrid:Dynamic;
	function get_tileGrid():Dynamic;
	function set_tileGrid(value:Dynamic):Dynamic;
	override function __setupVertices():Dynamic;
	override function set_scaleX(value:Dynamic):Dynamic;
	override function set_scaleY(value:Dynamic):Dynamic;
	override function set_texture(value:Dynamic):Dynamic;
	function __setupScale9Grid():Dynamic;
	function __setupScale9GridAttributes(startX:Dynamic, startY:Dynamic, posCols:Dynamic, posRows:Dynamic, texCols:Dynamic, texRows:Dynamic):Dynamic;
	function __setupTileGrid():Dynamic;
	static var sSetupFunctions:Dynamic;
	static var sPadding:Dynamic;
	static var sBounds:Dynamic;
	static var sBasCols:Dynamic;
	static var sBasRows:Dynamic;
	static var sPosCols:Dynamic;
	static var sPosRows:Dynamic;
	static var sTexCols:Dynamic;
	static var sTexRows:Dynamic;
	static function automateSetupForTexture(texture:Dynamic, onAssign:Dynamic, ?onRelease:Dynamic):Dynamic;
	static function resetSetupForTexture(texture:Dynamic):Dynamic;
	static function bindScale9GridToTexture(texture:Dynamic, scale9Grid:Dynamic):Dynamic;
	static function bindPivotPointToTexture(texture:Dynamic, pivotX:Dynamic, pivotY:Dynamic):Dynamic;


}
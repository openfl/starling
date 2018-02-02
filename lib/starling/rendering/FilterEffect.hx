package starling.rendering;

import starling.rendering.Effect;
import starling.utils.RenderUtil;
import starling.rendering.Program;

@:jsRequire("starling/rendering/FilterEffect", "default")

extern class FilterEffect extends starling.rendering.Effect implements Dynamic {

	function new();
	var _texture:Dynamic;
	var _textureSmoothing:Dynamic;
	var _textureRepeat:Dynamic;
	override function get_programVariantName():Dynamic;
	override function createProgram():Dynamic;
	override function beforeDraw(context:Dynamic):Dynamic;
	override function afterDraw(context:Dynamic):Dynamic;
	override function get_vertexFormat():Dynamic;
	var texture:Dynamic;
	function get_texture():Dynamic;
	function set_texture(value:Dynamic):Dynamic;
	var textureSmoothing:Dynamic;
	function get_textureSmoothing():Dynamic;
	function set_textureSmoothing(value:Dynamic):Dynamic;
	var textureRepeat:Dynamic;
	function get_textureRepeat():Dynamic;
	function set_textureRepeat(value:Dynamic):Dynamic;
	static var VERTEX_FORMAT:Dynamic;
	static var STD_VERTEX_SHADER:Dynamic;
	static function tex(resultReg:Dynamic, uvReg:Dynamic, sampler:Dynamic, texture:Dynamic, ?convertToPmaIfRequired:Dynamic):Dynamic;


}
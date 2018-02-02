package starling.rendering;

import starling.rendering.FilterEffect;
import starling.rendering.Program;
import Type;

@:jsRequire("starling/rendering/MeshEffect", "default")

extern class MeshEffect extends starling.rendering.FilterEffect implements Dynamic {

	function new();
	var _alpha:Dynamic;
	var _tinted:Dynamic;
	var _optimizeIfNotTinted:Dynamic;
	override function get_programVariantName():Dynamic;
	override function createProgram():Dynamic;
	override function beforeDraw(context:Dynamic):Dynamic;
	override function afterDraw(context:Dynamic):Dynamic;
	override function get_vertexFormat():Dynamic;
	var alpha:Dynamic;
	function get_alpha():Dynamic;
	function set_alpha(value:Dynamic):Dynamic;
	var tinted:Dynamic;
	function get_tinted():Dynamic;
	function set_tinted(value:Dynamic):Dynamic;
	static var VERTEX_FORMAT:Dynamic;
	static var sRenderAlpha:Dynamic;


}
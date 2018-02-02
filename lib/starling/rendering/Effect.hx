package starling.rendering;

import starling.core.Starling;
import js.Boot;
import Std;
import starling.errors.MissingContextError;
import starling.rendering.Program;
import haxe.ds.IntMap;
import StringTools;
import starling.rendering.VertexDataFormat;
import haxe.ds.StringMap;
import Type;

@:jsRequire("starling/rendering/Effect", "default")

extern class Effect implements Dynamic {

	function new();
	var _vertexBuffer:Dynamic;
	var _vertexBufferSize:Dynamic;
	var _indexBuffer:Dynamic;
	var _indexBufferSize:Dynamic;
	var _indexBufferUsesQuadLayout:Dynamic;
	var _mvpMatrix3D:Dynamic;
	function _onRestore(a1:Dynamic):Dynamic;
	var _programBaseName:Dynamic;
	function dispose():Dynamic;
	function onContextCreated(event:Dynamic):Dynamic;
	function purgeBuffers(?vertexBuffer:Dynamic, ?indexBuffer:Dynamic):Dynamic;
	function uploadIndexData(indexData:Dynamic, ?bufferUsage:Dynamic):Dynamic;
	function uploadVertexData(vertexData:Dynamic, ?bufferUsage:Dynamic):Dynamic;
	function render(?firstIndex:Dynamic, ?numTriangles:Dynamic):Dynamic;
	function beforeDraw(context:Dynamic):Dynamic;
	function afterDraw(context:Dynamic):Dynamic;
	function createProgram():Dynamic;
	var programVariantName:Dynamic;
	function get_programVariantName():Dynamic;
	var programBaseName:Dynamic;
	function get_programBaseName():Dynamic;
	function set_programBaseName(value:Dynamic):Dynamic;
	var programName:Dynamic;
	function get_programName():Dynamic;
	var program:Dynamic;
	function get_program():Dynamic;
	function onRestore(a1:Dynamic):Dynamic;
	function get_onRestore():Dynamic;
	function set_onRestore(value:Dynamic):Dynamic;
	var vertexFormat:Dynamic;
	function get_vertexFormat():Dynamic;
	var mvpMatrix3D:Dynamic;
	function get_mvpMatrix3D():Dynamic;
	function set_mvpMatrix3D(value:Dynamic):Dynamic;
	var indexBuffer:Dynamic;
	function get_indexBuffer():Dynamic;
	var indexBufferSize:Dynamic;
	function get_indexBufferSize():Dynamic;
	var vertexBuffer:Dynamic;
	function get_vertexBuffer():Dynamic;
	var vertexBufferSize:Dynamic;
	function get_vertexBufferSize():Dynamic;
	static var VERTEX_FORMAT:Dynamic;
	static var sProgramNameCache:Dynamic;


}
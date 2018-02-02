package starling.styles;

import starling.events.EventDispatcher;
import Type;
import starling.rendering.MeshEffect;

@:jsRequire("starling/styles/MeshStyle", "default")

extern class MeshStyle extends starling.events.EventDispatcher implements Dynamic {

	function new();
	var _type:Dynamic;
	var _target:Dynamic;
	var _texture:Dynamic;
	var _textureSmoothing:Dynamic;
	var _textureRepeat:Dynamic;
	var _textureRoot:Dynamic;
	var _vertexData:Dynamic;
	var _indexData:Dynamic;
	function copyFrom(meshStyle:Dynamic):Dynamic;
	function clone():Dynamic;
	function createEffect():Dynamic;
	function updateEffect(effect:Dynamic, state:Dynamic):Dynamic;
	function canBatchWith(meshStyle:Dynamic):Dynamic;
	function batchVertexData(targetStyle:Dynamic, ?targetVertexID:Dynamic, ?matrix:Dynamic, ?vertexID:Dynamic, ?numVertices:Dynamic):Dynamic;
	function batchIndexData(targetStyle:Dynamic, ?targetIndexID:Dynamic, ?offset:Dynamic, ?indexID:Dynamic, ?numIndices:Dynamic):Dynamic;
	function setRequiresRedraw():Dynamic;
	function setVertexDataChanged():Dynamic;
	function setIndexDataChanged():Dynamic;
	function onTargetAssigned(target:Dynamic):Dynamic;
	override function addEventListener(type:Dynamic, listener:Dynamic):Dynamic;
	override function removeEventListener(type:Dynamic, listener:Dynamic):Dynamic;
	function onEnterFrame(event:Dynamic):Dynamic;
	function setTarget(?target:Dynamic, ?vertexData:Dynamic, ?indexData:Dynamic):Dynamic;
	function getVertexPosition(vertexID:Dynamic, ?out:Dynamic):Dynamic;
	function setVertexPosition(vertexID:Dynamic, x:Dynamic, y:Dynamic):Dynamic;
	function getVertexAlpha(vertexID:Dynamic):Dynamic;
	function setVertexAlpha(vertexID:Dynamic, alpha:Dynamic):Dynamic;
	function getVertexColor(vertexID:Dynamic):Dynamic;
	function setVertexColor(vertexID:Dynamic, color:Dynamic):Dynamic;
	function getTexCoords(vertexID:Dynamic, ?out:Dynamic):Dynamic;
	function setTexCoords(vertexID:Dynamic, u:Dynamic, v:Dynamic):Dynamic;
	var vertexData:Dynamic;
	function get_vertexData():Dynamic;
	var indexData:Dynamic;
	function get_indexData():Dynamic;
	var type:Dynamic;
	function get_type():Dynamic;
	var color:Dynamic;
	function get_color():Dynamic;
	function set_color(value:Dynamic):Dynamic;
	var vertexFormat:Dynamic;
	function get_vertexFormat():Dynamic;
	var texture:Dynamic;
	function get_texture():Dynamic;
	function set_texture(value:Dynamic):Dynamic;
	var textureSmoothing:Dynamic;
	function get_textureSmoothing():Dynamic;
	function set_textureSmoothing(value:Dynamic):Dynamic;
	var textureRepeat:Dynamic;
	function get_textureRepeat():Dynamic;
	function set_textureRepeat(value:Dynamic):Dynamic;
	var target:Dynamic;
	function get_target():Dynamic;
	static var VERTEX_FORMAT:Dynamic;
	static var sPoint:Dynamic;


}
package starling.display;

import starling.display.DisplayObject;
import starling.utils.MeshUtil;
import starling.utils.MatrixUtil;
import Type;
import starling.styles.MeshStyle;
import starling.rendering.VertexData;
import starling.rendering.IndexData;

@:jsRequire("starling/display/Mesh", "default")

extern class Mesh extends starling.display.DisplayObject implements Dynamic {

	function new(vertexData:Dynamic, indexData:Dynamic, ?style:Dynamic);
	var __style:Dynamic;
	var __vertexData:Dynamic;
	var __indexData:Dynamic;
	var __pixelSnapping:Dynamic;
	override function dispose():Dynamic;
	override function hitTest(localPoint:Dynamic):Dynamic;
	override function getBounds(targetSpace:Dynamic, ?out:Dynamic):Dynamic;
	override function render(painter:Dynamic):Dynamic;
	function setStyle(?meshStyle:Dynamic, ?mergeWithPredecessor:Dynamic):Dynamic;
	function __createDefaultMeshStyle():Dynamic;
	function setVertexDataChanged():Dynamic;
	function setIndexDataChanged():Dynamic;
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
	var style:Dynamic;
	function get_style():Dynamic;
	function set_style(value:Dynamic):Dynamic;
	var texture:Dynamic;
	function get_texture():Dynamic;
	function set_texture(value:Dynamic):Dynamic;
	var color:Dynamic;
	function get_color():Dynamic;
	function set_color(value:Dynamic):Dynamic;
	var textureSmoothing:Dynamic;
	function get_textureSmoothing():Dynamic;
	function set_textureSmoothing(value:Dynamic):Dynamic;
	var textureRepeat:Dynamic;
	function get_textureRepeat():Dynamic;
	function set_textureRepeat(value:Dynamic):Dynamic;
	var pixelSnapping:Dynamic;
	function get_pixelSnapping():Dynamic;
	function set_pixelSnapping(value:Dynamic):Dynamic;
	var numVertices:Dynamic;
	function get_numVertices():Dynamic;
	var numIndices:Dynamic;
	function get_numIndices():Dynamic;
	var numTriangles:Dynamic;
	function get_numTriangles():Dynamic;
	var vertexFormat:Dynamic;
	function get_vertexFormat():Dynamic;
	static var sDefaultStyle:Dynamic;
	static function sDefaultStyleFactory(?a1:Dynamic):Dynamic;
	static var defaultStyle:Dynamic;
	static function get_defaultStyle():Dynamic;
	static function set_defaultStyle(value:Dynamic):Dynamic;
	static function defaultStyleFactory(?a1:Dynamic):Dynamic;
	static function get_defaultStyleFactory():Dynamic;
	static function set_defaultStyleFactory(value:Dynamic):Dynamic;
	static function fromPolygon(polygon:Dynamic, ?style:Dynamic):Dynamic;


}
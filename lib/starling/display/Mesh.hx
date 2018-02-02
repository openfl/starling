package starling.display;

import starling.display.DisplayObject;
import starling.utils.MeshUtil;
import starling.utils.MatrixUtil;
import Type;
import starling.styles.MeshStyle;
import starling.rendering.VertexData;
import starling.rendering.IndexData;

@:jsRequire("starling/display/Mesh", "default")

extern class Mesh extends DisplayObject {
	var color(get,set) : UInt;
	var numIndices(get,never) : Int;
	var numTriangles(get,never) : Int;
	var numVertices(get,never) : Int;
	var pixelSnapping(get,set) : Bool;
	var style(get,set) : starling.styles.MeshStyle;
	var texture(get,set) : starling.textures.Texture;
	var textureRepeat(get,set) : Bool;
	var textureSmoothing(get,set) : String;
	var vertexFormat(get,never) : starling.rendering.VertexDataFormat;
	function new(vertexData : starling.rendering.VertexData, indexData : starling.rendering.IndexData, ?style : starling.styles.MeshStyle) : Void;
	function getTexCoords(vertexID : Int, ?out : openfl.geom.Point) : openfl.geom.Point;
	function getVertexAlpha(vertexID : Int) : Float;
	function getVertexColor(vertexID : Int) : UInt;
	function getVertexPosition(vertexID : Int, ?out : openfl.geom.Point) : openfl.geom.Point;
	function setIndexDataChanged() : Void;
	function setStyle(?meshStyle : starling.styles.MeshStyle, mergeWithPredecessor : Bool = false) : Void;
	function setTexCoords(vertexID : Int, u : Float, v : Float) : Void;
	function setVertexAlpha(vertexID : Int, alpha : Float) : Void;
	function setVertexColor(vertexID : Int, color : UInt) : Void;
	function setVertexDataChanged() : Void;
	function setVertexPosition(vertexID : Int, x : Float, y : Float) : Void;
	static var defaultStyle(get,set) : Class<Dynamic>;
	static var defaultStyleFactory(get,set) : Mesh -> starling.styles.MeshStyle;
	static function fromPolygon(polygon : starling.geom.Polygon, ?style : starling.styles.MeshStyle) : Mesh;
}

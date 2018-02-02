package starling.styles;

import starling.events.EventDispatcher;
import Type;
import starling.rendering.MeshEffect;

@:jsRequire("starling/styles/MeshStyle", "default")

@:meta(Event(name = "enterFrame", type = "starling.events.EnterFrameEvent")) extern class MeshStyle extends starling.events.EventDispatcher {
	var color(get,set) : UInt;
	var indexData(get,never) : starling.rendering.IndexData;
	var target(get,never) : starling.display.Mesh;
	var texture(get,set) : starling.textures.Texture;
	var textureRepeat(get,set) : Bool;
	var textureSmoothing(get,set) : String;
	var type(get,never) : Class<Dynamic>;
	var vertexData(get,never) : starling.rendering.VertexData;
	var vertexFormat(get,never) : starling.rendering.VertexDataFormat;
	@:keep function new() : Void;
	function batchIndexData(targetStyle : MeshStyle, targetIndexID : Int = 0, offset : Int = 0, indexID : Int = 0, numIndices : Int = 0) : Void;
	function batchVertexData(targetStyle : MeshStyle, targetVertexID : Int = 0, ?matrix : openfl.geom.Matrix, vertexID : Int = 0, numVertices : Int = 0) : Void;
	function canBatchWith(meshStyle : MeshStyle) : Bool;
	function clone() : MeshStyle;
	function copyFrom(meshStyle : MeshStyle) : Void;
	function createEffect() : starling.rendering.MeshEffect;
	function getTexCoords(vertexID : Int, ?out : openfl.geom.Point) : openfl.geom.Point;
	function getVertexAlpha(vertexID : Int) : Float;
	function getVertexColor(vertexID : Int) : UInt;
	function getVertexPosition(vertexID : Int, ?out : openfl.geom.Point) : openfl.geom.Point;
	function setTexCoords(vertexID : Int, u : Float, v : Float) : Void;
	function setVertexAlpha(vertexID : Int, alpha : Float) : Void;
	function setVertexColor(vertexID : Int, color : UInt) : Void;
	function setVertexPosition(vertexID : Int, x : Float, y : Float) : Void;
	function updateEffect(effect : starling.rendering.MeshEffect, state : starling.rendering.RenderState) : Void;
	static var VERTEX_FORMAT : starling.rendering.VertexDataFormat;
}

package starling.geom;

import Std;
import js.Boot;
import Type;
import starling.rendering.IndexData;
import starling.utils.Pool;
import starling.utils.MathUtil;
import starling.geom.Ellipse;
import starling.geom.Rectangle;

@:jsRequire("starling/geom/Polygon", "default")

extern class Polygon {
	var area(get,never) : Float;
	var isConvex(get,never) : Bool;
	var isSimple(get,never) : Bool;
	var numTriangles(get,never) : Int;
	var numVertices(get,set) : Int;
	function new(?vertices : Array<Dynamic>) : Void;
	function addVertices(args : Array<Dynamic>) : Void;
	function clone() : Polygon;
	function contains(x : Float, y : Float) : Bool;
	function containsPoint(point : openfl.geom.Point) : Bool;
	function copyToVertexData(target : starling.rendering.VertexData, targetVertexID : Int = 0, ?attrName : String) : Void;
	function getVertex(index : Int, ?out : openfl.geom.Point) : openfl.geom.Point;
	function reverse() : Void;
	function setVertex(index : Int, x : Float, y : Float) : Void;
	function toString() : String;
	function triangulate(?indexData : starling.rendering.IndexData, offset : Int = 0) : starling.rendering.IndexData;
	static function createCircle(x : Float, y : Float, radius : Float, numSides : Int = 0) : Polygon;
	static function createEllipse(x : Float, y : Float, radiusX : Float, radiusY : Float, numSides : Int = 0) : Polygon;
	static function createRectangle(x : Float, y : Float, width : Float, height : Float) : Polygon;
}

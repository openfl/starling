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

extern class Polygon implements Dynamic {

	function new(?vertices:Dynamic);
	var __coords:Dynamic;
	function clone():Dynamic;
	function reverse():Dynamic;
	function addVertices(args:Dynamic):Dynamic;
	function setVertex(index:Dynamic, x:Dynamic, y:Dynamic):Dynamic;
	function getVertex(index:Dynamic, ?out:Dynamic):Dynamic;
	function contains(x:Dynamic, y:Dynamic):Dynamic;
	function containsPoint(point:Dynamic):Dynamic;
	function triangulate(?indexData:Dynamic, ?offset:Dynamic):Dynamic;
	function copyToVertexData(target:Dynamic, ?targetVertexID:Dynamic, ?attrName:Dynamic):Dynamic;
	function toString():Dynamic;
	var isSimple:Dynamic;
	function get_isSimple():Dynamic;
	var isConvex:Dynamic;
	function get_isConvex():Dynamic;
	var area:Dynamic;
	function get_area():Dynamic;
	var numVertices:Dynamic;
	function get_numVertices():Dynamic;
	function set_numVertices(value:Dynamic):Dynamic;
	var numTriangles:Dynamic;
	function get_numTriangles():Dynamic;
	static var sRestIndices:Dynamic;
	static function createEllipse(x:Dynamic, y:Dynamic, radiusX:Dynamic, radiusY:Dynamic, ?numSides:Dynamic):Dynamic;
	static function createCircle(x:Dynamic, y:Dynamic, radius:Dynamic, ?numSides:Dynamic):Dynamic;
	static function createRectangle(x:Dynamic, y:Dynamic, width:Dynamic, height:Dynamic):Dynamic;
	static function isConvexTriangle(ax:Dynamic, ay:Dynamic, bx:Dynamic, by:Dynamic, cx:Dynamic, cy:Dynamic):Dynamic;
	static function areVectorsIntersecting(ax:Dynamic, ay:Dynamic, bx:Dynamic, by:Dynamic, cx:Dynamic, cy:Dynamic, dx:Dynamic, dy:Dynamic):Dynamic;


}
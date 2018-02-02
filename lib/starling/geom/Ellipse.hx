package starling.geom;

import starling.geom.ImmutablePolygon;
import Std;
import starling.rendering.IndexData;

@:jsRequire("starling/geom/Ellipse", "default")

extern class Ellipse extends starling.geom.ImmutablePolygon implements Dynamic {

	function new(x:Dynamic, y:Dynamic, radiusX:Dynamic, radiusY:Dynamic, ?numSides:Dynamic);
	var __x:Dynamic;
	var __y:Dynamic;
	var __radiusX:Dynamic;
	var __radiusY:Dynamic;
	function getVertices(numSides:Dynamic):Dynamic;
	override function triangulate(?indexData:Dynamic, ?offset:Dynamic):Dynamic;
	override function contains(x:Dynamic, y:Dynamic):Dynamic;
	override function get_area():Dynamic;
	override function get_isSimple():Dynamic;
	override function get_isConvex():Dynamic;


}
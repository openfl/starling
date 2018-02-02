package starling.geom;

import starling.geom.Polygon;
import Type;

@:jsRequire("starling/geom/ImmutablePolygon", "default")

extern class ImmutablePolygon extends starling.geom.Polygon implements Dynamic {

	function new(vertices:Dynamic);
	var __frozen:Dynamic;
	override function addVertices(args:Dynamic):Dynamic;
	override function setVertex(index:Dynamic, x:Dynamic, y:Dynamic):Dynamic;
	override function reverse():Dynamic;
	override function set_numVertices(value:Dynamic):Dynamic;
	function getImmutableError():Dynamic;


}
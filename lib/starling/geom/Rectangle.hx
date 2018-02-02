package starling.geom;

import starling.geom.ImmutablePolygon;
import starling.rendering.IndexData;

@:jsRequire("starling/geom/Rectangle", "default")

extern class Rectangle extends starling.geom.ImmutablePolygon implements Dynamic {

	function new(x:Dynamic, y:Dynamic, width:Dynamic, height:Dynamic);
	var __x:Dynamic;
	var __y:Dynamic;
	var __width:Dynamic;
	var __height:Dynamic;
	override function triangulate(?indexData:Dynamic, ?offset:Dynamic):Dynamic;
	override function contains(x:Dynamic, y:Dynamic):Dynamic;
	override function get_area():Dynamic;
	override function get_isSimple():Dynamic;
	override function get_isConvex():Dynamic;


}
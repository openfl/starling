package starling.display;

import starling.display.DisplayObjectContainer;
import starling.geom.Polygon;
import starling.rendering.VertexData;
import starling.rendering.IndexData;
import starling.display.Mesh;

@:jsRequire("starling/display/Canvas", "default")

extern class Canvas extends starling.display.DisplayObjectContainer implements Dynamic {

	function new();
	var __polygons:Dynamic;
	var __fillColor:Dynamic;
	var __fillAlpha:Dynamic;
	override function dispose():Dynamic;
	override function hitTest(localPoint:Dynamic):Dynamic;
	function drawCircle(x:Dynamic, y:Dynamic, radius:Dynamic):Dynamic;
	function drawEllipse(x:Dynamic, y:Dynamic, width:Dynamic, height:Dynamic):Dynamic;
	function drawRectangle(x:Dynamic, y:Dynamic, width:Dynamic, height:Dynamic):Dynamic;
	function drawPolygon(polygon:Dynamic):Dynamic;
	function beginFill(?color:Dynamic, ?alpha:Dynamic):Dynamic;
	function endFill():Dynamic;
	function clear():Dynamic;
	function __appendPolygon(polygon:Dynamic):Dynamic;


}
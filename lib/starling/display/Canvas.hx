package starling.display;

import starling.display.DisplayObjectContainer;
import starling.geom.Polygon;
import starling.rendering.VertexData;
import starling.rendering.IndexData;
import starling.display.Mesh;

@:jsRequire("starling/display/Canvas", "default")

extern class Canvas extends DisplayObjectContainer {
	function new() : Void;
	function beginFill(color : UInt = 0, alpha : Float = 0) : Void;
	function clear() : Void;
	function drawCircle(x : Float, y : Float, radius : Float) : Void;
	function drawEllipse(x : Float, y : Float, width : Float, height : Float) : Void;
	function drawPolygon(polygon : starling.geom.Polygon) : Void;
	function drawRectangle(x : Float, y : Float, width : Float, height : Float) : Void;
	function endFill() : Void;
}
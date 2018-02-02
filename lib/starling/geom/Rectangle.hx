package starling.geom;

import starling.geom.ImmutablePolygon;
import starling.rendering.IndexData;

@:jsRequire("starling/geom/Rectangle", "default")

extern class Rectangle extends ImmutablePolygon {
	function new(x : Float, y : Float, width : Float, height : Float) : Void;
}

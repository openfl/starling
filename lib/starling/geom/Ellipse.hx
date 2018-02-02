package starling.geom;

import starling.geom.ImmutablePolygon;
import Std;
import starling.rendering.IndexData;

@:jsRequire("starling/geom/Ellipse", "default")
extern class Ellipse extends ImmutablePolygon {
	function new(x : Float, y : Float, radiusX : Float, radiusY : Float, numSides : Int = 0) : Void;
}

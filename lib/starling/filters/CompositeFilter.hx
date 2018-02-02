package starling.filters;

import starling.filters.FragmentFilter;
// import starling.filters.CompositeEffect;

@:jsRequire("starling/filters/CompositeFilter", "default")

extern class CompositeFilter extends FragmentFilter {
	var compositeEffect(get,never) : starling.rendering.Effect; //CompositeEffect;
	function new() : Void;
	function getAlphaAt(layerID : Int) : Float;
	function getColorAt(layerID : Int) : UInt;
	function getOffsetAt(layerID : Int, ?out : openfl.geom.Point) : openfl.geom.Point;
	function setAlphaAt(layerID : Int, alpha : Float) : Void;
	function setColorAt(layerID : Int, color : UInt, replace : Bool = false) : Void;
	function setOffsetAt(layerID : Int, x : Float, y : Float) : Void;
}

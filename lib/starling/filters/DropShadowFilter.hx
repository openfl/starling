package starling.filters;

import starling.filters.FragmentFilter;
import starling.filters.CompositeFilter;
import starling.filters.BlurFilter;

@:jsRequire("starling/filters/DropShadowFilter", "default")

extern class DropShadowFilter extends FragmentFilter {
	var alpha(get,set) : Float;
	var angle(get,set) : Float;
	var blur(get,set) : Float;
	var color(get,set) : UInt;
	var distance(get,set) : Float;
	function new(distance : Float = 0, angle : Float = 0, color : UInt = 0, alpha : Float = 0, blur : Float = 0, resolution : Float = 0) : Void;
}

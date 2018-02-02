package starling.filters;

import starling.filters.FragmentFilter;
import starling.filters.BlurFilter;
import starling.filters.CompositeFilter;

@:jsRequire("starling/filters/GlowFilter", "default")

extern class GlowFilter extends FragmentFilter {
	var alpha(get,set) : Float;
	var blur(get,set) : Float;
	var color(get,set) : UInt;
	function new(color : UInt = 0, alpha : Float = 0, blur : Float = 0, resolution : Float = 0) : Void;
}

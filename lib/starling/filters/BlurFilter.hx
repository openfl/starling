package starling.filters;

import starling.filters.FragmentFilter;
// import starling.filters.BlurEffect;
import starling.core.Starling;

@:jsRequire("starling/filters/BlurFilter", "default")
extern class BlurFilter extends FragmentFilter {
	var blurX(get,set) : Float;
	var blurY(get,set) : Float;
	function new(blurX : Float = 0, blurY : Float = 0, resolution : Float = 0) : Void;
}

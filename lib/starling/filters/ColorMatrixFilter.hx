package starling.filters;

import starling.filters.FragmentFilter;
// import starling.filters.ColorMatrixEffect;
import starling.utils.Color;

@:jsRequire("starling/filters/ColorMatrixFilter", "default")

extern class ColorMatrixFilter extends FragmentFilter {
	var colorEffect(get,never) : starling.rendering.Effect; //ColorMatrixEffect;
	var matrix(get,set) : openfl.Vector<Float>;
	function new(?matrix : openfl.Vector<Float>) : Void;
	function adjustBrightness(value : Float) : Void;
	function adjustContrast(value : Float) : Void;
	function adjustHue(value : Float) : Void;
	function adjustSaturation(sat : Float) : Void;
	function concat(matrix : openfl.Vector<Float>) : Void;
	function concatValues(m0 : Float, m1 : Float, m2 : Float, m3 : Float, m4 : Float, m5 : Float, m6 : Float, m7 : Float, m8 : Float, m9 : Float, m10 : Float, m11 : Float, m12 : Float, m13 : Float, m14 : Float, m15 : Float, m16 : Float, m17 : Float, m18 : Float, m19 : Float) : Void;
	function invert() : Void;
	function reset() : Void;
	function tint(color : UInt, amount : Float = 0) : Void;
}

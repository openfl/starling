package starling.filters;

import starling.filters.FragmentFilter;
import starling.filters.ColorMatrixEffect;
import starling.utils.Color;

@:jsRequire("starling/filters/ColorMatrixFilter", "default")

extern class ColorMatrixFilter extends starling.filters.FragmentFilter implements Dynamic {

	function new(?matrix:Dynamic);
	override function createEffect():Dynamic;
	function invert():Dynamic;
	function adjustSaturation(sat:Dynamic):Dynamic;
	function adjustContrast(value:Dynamic):Dynamic;
	function adjustBrightness(value:Dynamic):Dynamic;
	function adjustHue(value:Dynamic):Dynamic;
	function tint(color:Dynamic, ?amount:Dynamic):Dynamic;
	function reset():Dynamic;
	function concat(matrix:Dynamic):Dynamic;
	function concatValues(m0:Dynamic, m1:Dynamic, m2:Dynamic, m3:Dynamic, m4:Dynamic, m5:Dynamic, m6:Dynamic, m7:Dynamic, m8:Dynamic, m9:Dynamic, m10:Dynamic, m11:Dynamic, m12:Dynamic, m13:Dynamic, m14:Dynamic, m15:Dynamic, m16:Dynamic, m17:Dynamic, m18:Dynamic, m19:Dynamic):Dynamic;
	var matrix:Dynamic;
	function get_matrix():Dynamic;
	function set_matrix(value:Dynamic):Dynamic;
	var colorEffect:Dynamic;
	function get_colorEffect():Dynamic;
	static var LUMA_R:Dynamic;
	static var LUMA_G:Dynamic;
	static var LUMA_B:Dynamic;
	static var sMatrix:Dynamic;


}
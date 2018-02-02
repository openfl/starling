package starling.filters;

import starling.filters.FragmentFilter;
import starling.filters.BlurFilter;
import starling.filters.CompositeFilter;

@:jsRequire("starling/filters/GlowFilter", "default")

extern class GlowFilter extends starling.filters.FragmentFilter implements Dynamic {

	function new(?color:Dynamic, ?alpha:Dynamic, ?blur:Dynamic, ?resolution:Dynamic);
	var _blurFilter:Dynamic;
	var _compositeFilter:Dynamic;
	override function dispose():Dynamic;
	override function process(painter:Dynamic, helper:Dynamic, ?input0:Dynamic, ?input1:Dynamic, ?input2:Dynamic, ?input3:Dynamic):Dynamic;
	override function get_numPasses():Dynamic;
	function updatePadding():Dynamic;
	var color:Dynamic;
	function get_color():Dynamic;
	function set_color(value:Dynamic):Dynamic;
	var alpha:Dynamic;
	function get_alpha():Dynamic;
	function set_alpha(value:Dynamic):Dynamic;
	var blur:Dynamic;
	function get_blur():Dynamic;
	function set_blur(value:Dynamic):Dynamic;
	override function get_resolution():Dynamic;
	override function set_resolution(value:Dynamic):Dynamic;


}
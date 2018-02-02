package starling.filters;

import starling.filters.FragmentFilter;
import starling.filters.BlurEffect;
import starling.core.Starling;

@:jsRequire("starling/filters/BlurFilter", "default")

extern class BlurFilter extends starling.filters.FragmentFilter implements Dynamic {

	function new(?blurX:Dynamic, ?blurY:Dynamic, ?resolution:Dynamic);
	var __blurX:Dynamic;
	var __blurY:Dynamic;
	override function process(painter:Dynamic, helper:Dynamic, ?input0:Dynamic, ?input1:Dynamic, ?input2:Dynamic, ?input3:Dynamic):Dynamic;
	override function createEffect():Dynamic;
	override function set_resolution(value:Dynamic):Dynamic;
	function updatePadding():Dynamic;
	override function get_numPasses():Dynamic;
	var totalBlurX:Dynamic;
	function get_totalBlurX():Dynamic;
	var totalBlurY:Dynamic;
	function get_totalBlurY():Dynamic;
	var blurX:Dynamic;
	function get_blurX():Dynamic;
	function set_blurX(value:Dynamic):Dynamic;
	var blurY:Dynamic;
	function get_blurY():Dynamic;
	function set_blurY(value:Dynamic):Dynamic;
	static function getNumPasses(blur:Dynamic):Dynamic;


}
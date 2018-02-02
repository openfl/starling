package starling.filters;

import starling.filters.FragmentFilter;
import starling.filters.CompositeEffect;

@:jsRequire("starling/filters/CompositeFilter", "default")

extern class CompositeFilter extends starling.filters.FragmentFilter implements Dynamic {

	function new();
	override function process(painter:Dynamic, helper:Dynamic, ?input0:Dynamic, ?input1:Dynamic, ?input2:Dynamic, ?input3:Dynamic):Dynamic;
	override function createEffect():Dynamic;
	function getOffsetAt(layerID:Dynamic, ?out:Dynamic):Dynamic;
	function setOffsetAt(layerID:Dynamic, x:Dynamic, y:Dynamic):Dynamic;
	function getColorAt(layerID:Dynamic):Dynamic;
	function setColorAt(layerID:Dynamic, color:Dynamic, ?replace:Dynamic):Dynamic;
	function getAlphaAt(layerID:Dynamic):Dynamic;
	function setAlphaAt(layerID:Dynamic, alpha:Dynamic):Dynamic;
	var compositeEffect:Dynamic;
	function get_compositeEffect():Dynamic;


}
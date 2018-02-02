package starling.filters;

import starling.filters.FragmentFilter;
import starling.utils.Padding;

@:jsRequire("starling/filters/FilterChain", "default")

extern class FilterChain extends starling.filters.FragmentFilter implements Dynamic {

	function new(args:Dynamic);
	var _filters:Dynamic;
	override function dispose():Dynamic;
	override function setRequiresRedraw():Dynamic;
	override function process(painter:Dynamic, helper:Dynamic, ?input0:Dynamic, ?input1:Dynamic, ?input2:Dynamic, ?input3:Dynamic):Dynamic;
	override function get_numPasses():Dynamic;
	function getFilterAt(index:Dynamic):Dynamic;
	function addFilter(filter:Dynamic):Dynamic;
	function addFilterAt(filter:Dynamic, index:Dynamic):Dynamic;
	function removeFilter(filter:Dynamic, ?dispose:Dynamic):Dynamic;
	function removeFilterAt(index:Dynamic, ?dispose:Dynamic):Dynamic;
	function getFilterIndex(filter:Dynamic):Dynamic;
	function updatePadding():Dynamic;
	function __onEnterFrame(event:Dynamic):Dynamic;
	var numFilters:Dynamic;
	function get_numFilters():Dynamic;
	static var sPadding:Dynamic;


}
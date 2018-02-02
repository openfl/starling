package starling.filters;

import starling.filters.FragmentFilter;
import starling.utils.Padding;

@:jsRequire("starling/filters/FilterChain", "default")

extern class FilterChain extends FragmentFilter {
	var numFilters(get,never) : Int;
	function new(args : Array<FragmentFilter>) : Void;
	function addFilter(filter : FragmentFilter) : Void;
	function addFilterAt(filter : FragmentFilter, index : Int) : Void;
	function getFilterAt(index : Int) : FragmentFilter;
	function getFilterIndex(filter : FragmentFilter) : Int;
	function removeFilter(filter : FragmentFilter, dispose : Bool = false) : FragmentFilter;
	function removeFilterAt(index : Int, dispose : Bool = false) : FragmentFilter;
}

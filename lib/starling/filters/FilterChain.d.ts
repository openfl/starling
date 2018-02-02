import starling_filters_FragmentFilter from "./../../starling/filters/FragmentFilter";
import starling_utils_Padding from "./../../starling/utils/Padding";
import openfl_Vector from "openfl/Vector";
import js__$Boot_HaxeError from "./../../js/_Boot/HaxeError";
import openfl_errors_ArgumentError from "openfl/errors/ArgumentError";

declare namespace starling.filters {

export class FilterChain extends starling_filters_FragmentFilter {

	constructor(args:any);
	_filters:any;
	dispose():any;
	setRequiresRedraw():any;
	process(painter:any, helper:any, input0?:any, input1?:any, input2?:any, input3?:any):any;
	get_numPasses():any;
	getFilterAt(index:any):any;
	addFilter(filter:any):any;
	addFilterAt(filter:any, index:any):any;
	removeFilter(filter:any, dispose?:any):any;
	removeFilterAt(index:any, dispose?:any):any;
	getFilterIndex(filter:any):any;
	updatePadding():any;
	__onEnterFrame(event:any):any;
	numFilters:any;
	get_numFilters():any;
	static sPadding:any;


}

}

export default starling.filters.FilterChain;
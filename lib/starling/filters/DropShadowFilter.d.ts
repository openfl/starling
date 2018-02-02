import starling_filters_FragmentFilter from "./../../starling/filters/FragmentFilter";
import starling_filters_CompositeFilter from "./../../starling/filters/CompositeFilter";
import starling_filters_BlurFilter from "./../../starling/filters/BlurFilter";

declare namespace starling.filters {

export class DropShadowFilter extends starling_filters_FragmentFilter {

	constructor(distance?:any, angle?:any, color?:any, alpha?:any, blur?:any, resolution?:any);
	_blurFilter:any;
	_compositeFilter:any;
	_distance:any;
	_angle:any;
	dispose():any;
	process(painter:any, helper:any, input0?:any, input1?:any, input2?:any, input3?:any):any;
	get_numPasses():any;
	updatePadding():any;
	color:any;
	get_color():any;
	set_color(value:any):any;
	alpha:any;
	get_alpha():any;
	set_alpha(value:any):any;
	distance:any;
	get_distance():any;
	set_distance(value:any):any;
	angle:any;
	get_angle():any;
	set_angle(value:any):any;
	blur:any;
	get_blur():any;
	set_blur(value:any):any;
	get_resolution():any;
	set_resolution(value:any):any;


}

}

export default starling.filters.DropShadowFilter;
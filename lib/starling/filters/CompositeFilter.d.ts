import starling_filters_FragmentFilter from "./../../starling/filters/FragmentFilter";
import starling_filters_CompositeEffect from "./../../starling/filters/CompositeEffect";
import openfl_geom_Point from "openfl/geom/Point";

declare namespace starling.filters {

export class CompositeFilter extends starling_filters_FragmentFilter {

	constructor();
	process(painter:any, helper:any, input0?:any, input1?:any, input2?:any, input3?:any):any;
	createEffect():any;
	getOffsetAt(layerID:any, out?:any):any;
	setOffsetAt(layerID:any, x:any, y:any):any;
	getColorAt(layerID:any):any;
	setColorAt(layerID:any, color:any, replace?:any):any;
	getAlphaAt(layerID:any):any;
	setAlphaAt(layerID:any, alpha:any):any;
	compositeEffect:any;
	get_compositeEffect():any;


}

}

export default starling.filters.CompositeFilter;
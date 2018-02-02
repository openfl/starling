import starling_filters_FragmentFilter from "./../../starling/filters/FragmentFilter";
import starling_filters_BlurEffect from "./../../starling/filters/BlurEffect";
import starling_core_Starling from "./../../starling/core/Starling";

declare namespace starling.filters {

export class BlurFilter extends starling_filters_FragmentFilter {

	constructor(blurX?:any, blurY?:any, resolution?:any);
	__blurX:any;
	__blurY:any;
	process(painter:any, helper:any, input0?:any, input1?:any, input2?:any, input3?:any):any;
	createEffect():any;
	set_resolution(value:any):any;
	updatePadding():any;
	get_numPasses():any;
	totalBlurX:any;
	get_totalBlurX():any;
	totalBlurY:any;
	get_totalBlurY():any;
	blurX:any;
	get_blurX():any;
	set_blurX(value:any):any;
	blurY:any;
	get_blurY():any;
	set_blurY(value:any):any;
	static getNumPasses(blur:any):any;


}

}

export default starling.filters.BlurFilter;
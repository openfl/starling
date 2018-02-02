import starling_filters_FragmentFilter from "./../../starling/filters/FragmentFilter";
import starling_filters_DisplacementMapEffect from "./../../starling/filters/DisplacementMapEffect";
import openfl_geom_Rectangle from "openfl/geom/Rectangle";

declare namespace starling.filters {

export class DisplacementMapFilter extends starling_filters_FragmentFilter {

	constructor(mapTexture:any, componentX?:any, componentY?:any, scaleX?:any, scaleY?:any);
	_mapX:any;
	_mapY:any;
	process(painter:any, pool:any, input0?:any, input1?:any, input2?:any, input3?:any):any;
	createEffect():any;
	updateVertexData(inputTexture:any, mapTexture:any, mapOffsetX?:any, mapOffsetY?:any):any;
	updatePadding():any;
	componentX:any;
	get_componentX():any;
	set_componentX(value:any):any;
	componentY:any;
	get_componentY():any;
	set_componentY(value:any):any;
	scaleX:any;
	get_scaleX():any;
	set_scaleX(value:any):any;
	scaleY:any;
	get_scaleY():any;
	set_scaleY(value:any):any;
	mapX:any;
	get_mapX():any;
	set_mapX(value:any):any;
	mapY:any;
	get_mapY():any;
	set_mapY(value:any):any;
	mapTexture:any;
	get_mapTexture():any;
	set_mapTexture(value:any):any;
	mapRepeat:any;
	get_mapRepeat():any;
	set_mapRepeat(value:any):any;
	dispEffect:any;
	get_dispEffect():any;
	static sBounds:any;


}

}

export default starling.filters.DisplacementMapFilter;
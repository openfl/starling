import starling_events_EventDispatcher from "./../../starling/events/EventDispatcher";
import starling_core_Starling from "./../../starling/core/Starling";
import js__$Boot_HaxeError from "./../../js/_Boot/HaxeError";
import openfl_errors_IllegalOperationError from "openfl/errors/IllegalOperationError";
import starling_filters_FilterHelper from "./../../starling/filters/FilterHelper";
import starling_filters_FilterQuad from "./../../starling/filters/FilterQuad";
import starling_utils_Pool from "./../../starling/utils/Pool";
import Std from "./../../Std";
import starling_display_Stage from "./../../starling/display/Stage";
import starling_utils_RectangleUtil from "./../../starling/utils/RectangleUtil";
import starling_utils_MatrixUtil from "./../../starling/utils/MatrixUtil";
import js_Boot from "./../../js/Boot";
import starling_rendering_FilterEffect from "./../../starling/rendering/FilterEffect";
import starling_rendering_VertexData from "./../../starling/rendering/VertexData";
import starling_rendering_IndexData from "./../../starling/rendering/IndexData";
import starling_utils_Padding from "./../../starling/utils/Padding";
import openfl_errors_ArgumentError from "openfl/errors/ArgumentError";
import openfl_geom_Matrix3D from "openfl/geom/Matrix3D";
import openfl_display3D__$Context3DTextureFormat_Context3DTextureFormat_$Impl_$ from "./../../openfl/display3D/_Context3DTextureFormat/Context3DTextureFormat_Impl_";

declare namespace starling.filters {

export class FragmentFilter extends starling_events_EventDispatcher {

	constructor();
	_quad:any;
	_target:any;
	_effect:any;
	_vertexData:any;
	_indexData:any;
	_padding:any;
	_helper:any;
	_resolution:any;
	_antiAliasing:any;
	_textureFormat:any;
	_textureSmoothing:any;
	_alwaysDrawToBackBuffer:any;
	_cacheRequested:any;
	_cached:any;
	dispose():any;
	onContextCreated(event:any):any;
	render(painter:any):any;
	renderPasses(painter:any, forCache:any):any;
	process(painter:any, helper:any, input0?:any, input1?:any, input2?:any, input3?:any):any;
	createEffect():any;
	cache():any;
	clearCache():any;
	addEventListener(type:any, listener:any):any;
	removeEventListener(type:any, listener:any):any;
	onEnterFrame(event:any):any;
	effect:any;
	get_effect():any;
	vertexData:any;
	get_vertexData():any;
	indexData:any;
	get_indexData():any;
	setRequiresRedraw():any;
	numPasses:any;
	get_numPasses():any;
	onTargetAssigned(target:any):any;
	padding:any;
	get_padding():any;
	set_padding(value:any):any;
	isCached:any;
	get_isCached():any;
	resolution:any;
	get_resolution():any;
	set_resolution(value:any):any;
	antiAliasing:any;
	get_antiAliasing():any;
	set_antiAliasing(value:any):any;
	textureSmoothing:any;
	get_textureSmoothing():any;
	set_textureSmoothing(value:any):any;
	textureFormat:any;
	get_textureFormat():any;
	set_textureFormat(value:any):any;
	alwaysDrawToBackBuffer:any;
	get_alwaysDrawToBackBuffer():any;
	set_alwaysDrawToBackBuffer(value:any):any;
	setTarget(target:any):any;
	static sMatrix3D:any;


}

}

export default starling.filters.FragmentFilter;
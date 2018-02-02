import starling_filters_IFilterHelper from "./../../starling/filters/IFilterHelper";
import starling_utils_Pool from "./../../starling/utils/Pool";
import starling_textures_Texture from "./../../starling/textures/Texture";
import starling_utils_MathUtil from "./../../starling/utils/MathUtil";
import Std from "./../../Std";
import starling_textures_SubTexture from "./../../starling/textures/SubTexture";
import starling_core_Starling from "./../../starling/core/Starling";
import openfl_geom_Rectangle from "openfl/geom/Rectangle";
import openfl_Vector from "openfl/Vector";
import openfl_geom_Matrix3D from "openfl/geom/Matrix3D";

declare namespace starling.filters {

export class FilterHelper {

	constructor(textureFormat?:any);
	_width:any;
	_height:any;
	_nativeWidth:any;
	_nativeHeight:any;
	_pool:any;
	_usePotTextures:any;
	_textureFormat:any;
	_preferredScale:any;
	_scale:any;
	_sizeStep:any;
	_numPasses:any;
	_projectionMatrix:any;
	_renderTarget:any;
	_targetBounds:any;
	_target:any;
	_clipRect:any;
	sRegion:any;
	dispose():any;
	start(numPasses:any, drawLastPassToBackBuffer:any):any;
	getTexture(resolution?:any):any;
	putTexture(texture:any):any;
	purge():any;
	setSize(width:any, height:any):any;
	getNativeSize(size:any, textureScale:any):any;
	projectionMatrix3D:any;
	get_projectionMatrix3D():any;
	set_projectionMatrix3D(value:any):any;
	renderTarget:any;
	get_renderTarget():any;
	set_renderTarget(value:any):any;
	clipRect:any;
	get_clipRect():any;
	set_clipRect(value:any):any;
	targetBounds:any;
	get_targetBounds():any;
	set_targetBounds(value:any):any;
	target:any;
	get_target():any;
	set_target(value:any):any;
	textureScale:any;
	get_textureScale():any;
	set_textureScale(value:any):any;
	textureFormat:any;
	get_textureFormat():any;
	set_textureFormat(value:any):any;


}

}

export default starling.filters.FilterHelper;
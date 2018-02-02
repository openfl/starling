import starling_textures_Texture from "./../../starling/textures/Texture";
import openfl_geom_Rectangle from "openfl/geom/Rectangle";
import haxe_Log from "./../../haxe/Log";
import openfl_geom_Matrix from "openfl/geom/Matrix";
import Std from "./../../Std";

declare namespace starling.textures {

export class SubTexture extends starling_textures_Texture {

	constructor(parent:any, region?:any, ownsParent?:any, frame?:any, rotated?:any, scaleModifier?:any);
	_parent:any;
	_ownsParent:any;
	_region:any;
	_frame:any;
	_rotated:any;
	_width:any;
	_height:any;
	_scale:any;
	_transformationMatrix:any;
	_transformationMatrixToRoot:any;
	setTo(parent:any, region?:any, ownsParent?:any, frame?:any, rotated?:any, scaleModifier?:any):any;
	updateMatrices():any;
	dispose():any;
	parent:any;
	get_parent():any;
	ownsParent:any;
	get_ownsParent():any;
	rotated:any;
	get_rotated():any;
	region:any;
	get_region():any;
	get_transformationMatrix():any;
	get_transformationMatrixToRoot():any;
	get_base():any;
	get_root():any;
	get_format():any;
	get_width():any;
	get_height():any;
	get_nativeWidth():any;
	get_nativeHeight():any;
	get_mipMapping():any;
	get_premultipliedAlpha():any;
	get_scale():any;
	get_frame():any;


}

}

export default starling.textures.SubTexture;
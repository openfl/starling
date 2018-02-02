import starling_textures_Texture from "./../../starling/textures/Texture";
import js__$Boot_HaxeError from "./../../js/_Boot/HaxeError";
import starling_errors_NotSupportedError from "./../../starling/errors/NotSupportedError";
import starling_errors_AbstractMethodError from "./../../starling/errors/AbstractMethodError";
import starling_utils_Color from "./../../starling/utils/Color";
import Std from "./../../Std";
import starling_core_Starling from "./../../starling/core/Starling";
import js_Boot from "./../../js/Boot";
import openfl_errors_Error from "openfl/errors/Error";
import openfl_display3D__$Context3DTextureFormat_Context3DTextureFormat_$Impl_$ from "./../../openfl/display3D/_Context3DTextureFormat/Context3DTextureFormat_Impl_";

declare namespace starling.textures {

export class ConcreteTexture extends starling_textures_Texture {

	constructor(base:any, format:any, width:any, height:any, mipMapping:any, premultipliedAlpha:any, optimizedForRenderTexture?:any, scale?:any);
	_base:any;
	_format:any;
	_width:any;
	_height:any;
	_mipMapping:any;
	_premultipliedAlpha:any;
	_optimizedForRenderTexture:any;
	_scale:any;
	_onRestore(a1:any):any;
	_dataUploaded:any;
	dispose():any;
	uploadBitmap(bitmap:any, async?:any):any;
	uploadBitmapData(data:any, async?:any):any;
	uploadAtfData(data:any, offset?:any, async?:any):any;
	attachNetStream(netStream:any, onComplete?:any):any;
	attachVideo(type:any, attachment:any, onComplete?:any):any;
	onContextCreated():any;
	createBase():any;
	recreateBase():any;
	clear(color?:any, alpha?:any):any;
	setDataUploaded():any;
	optimizedForRenderTexture:any;
	get_optimizedForRenderTexture():any;
	isPotTexture:any;
	get_isPotTexture():any;
	onRestore(a1:any):any;
	get_onRestore():any;
	set_onRestore(value:any):any;
	get_base():any;
	get_root():any;
	get_format():any;
	get_width():any;
	get_height():any;
	get_nativeWidth():any;
	get_nativeHeight():any;
	get_scale():any;
	get_mipMapping():any;
	get_premultipliedAlpha():any;


}

}

export default starling.textures.ConcreteTexture;
import starling_core_Starling from "./../../starling/core/Starling";
import starling_utils_Color from "./../../starling/utils/Color";
import openfl_display3D__$Context3DTextureFormat_Context3DTextureFormat_$Impl_$ from "./../../openfl/display3D/_Context3DTextureFormat/Context3DTextureFormat_Impl_";
import openfl_display3D__$Context3DWrapMode_Context3DWrapMode_$Impl_$ from "./../../openfl/display3D/_Context3DWrapMode/Context3DWrapMode_Impl_";
import openfl_display3D__$Context3DTextureFilter_Context3DTextureFilter_$Impl_$ from "./../../openfl/display3D/_Context3DTextureFilter/Context3DTextureFilter_Impl_";
import openfl_display3D__$Context3DMipFilter_Context3DMipFilter_$Impl_$ from "./../../openfl/display3D/_Context3DMipFilter/Context3DMipFilter_Impl_";
import Std from "./../../Std";
import js_Boot from "./../../js/Boot";
import js__$Boot_HaxeError from "./../../js/_Boot/HaxeError";
import openfl_errors_ArgumentError from "openfl/errors/ArgumentError";
import starling_utils_Execute from "./../../starling/utils/Execute";
import openfl_errors_Error from "openfl/errors/Error";
import haxe_Timer from "./../../haxe/Timer";
import openfl_display3D__$Context3DRenderMode_Context3DRenderMode_$Impl_$ from "./../../openfl/display3D/_Context3DRenderMode/Context3DRenderMode_Impl_";

declare namespace starling.utils {

export class RenderUtil {

	constructor();
	static clear(rgb?:any, alpha?:any, depth?:any, stencil?:any):any;
	static getTextureLookupFlags(format:any, mipMapping:any, repeat?:any, smoothing?:any):any;
	static getTextureVariantBits(texture:any):any;
	static setSamplerStateAt(sampler:any, mipMapping:any, smoothing?:any, repeat?:any):any;
	static createAGALTexOperation(resultReg:any, uvReg:any, sampler:any, texture:any, convertToPmaIfRequired?:any, tempReg?:any):any;
	static requestContext3D(stage3D:any, renderMode:any, profile:any):any;


}

}

export default starling.utils.RenderUtil;
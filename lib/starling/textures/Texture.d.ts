import openfl_geom_Point from "openfl/geom/Point";
import starling_utils_MatrixUtil from "./../../starling/utils/MatrixUtil";
import starling_textures_TextureOptions from "./../../starling/textures/TextureOptions";
import openfl_geom_Rectangle from "openfl/geom/Rectangle";
import openfl_geom_Matrix from "openfl/geom/Matrix";
import Std from "./../../Std";
import openfl_display_Bitmap from "openfl/display/Bitmap";
import js_Boot from "./../../js/Boot";
import openfl_display3D__$Context3DTextureFormat_Context3DTextureFormat_$Impl_$ from "./../../openfl/display3D/_Context3DTextureFormat/Context3DTextureFormat_Impl_";
import openfl_display_BitmapData from "openfl/display/BitmapData";
import openfl_utils_ByteArray from "openfl/utils/ByteArray";
import js__$Boot_HaxeError from "./../../js/_Boot/HaxeError";
import openfl_errors_ArgumentError from "openfl/errors/ArgumentError";
import Type from "./../../Type";
import openfl_display3D_textures_Texture from "openfl/display3D/textures/Texture";
import starling_textures_ConcretePotTexture from "./../../starling/textures/ConcretePotTexture";
import openfl_display3D_textures_RectangleTexture from "openfl/display3D/textures/RectangleTexture";
import starling_textures_ConcreteRectangleTexture from "./../../starling/textures/ConcreteRectangleTexture";
import openfl_display3D_textures_VideoTexture from "openfl/display3D/textures/VideoTexture";
import starling_textures_ConcreteVideoTexture from "./../../starling/textures/ConcreteVideoTexture";
import starling_core_Starling from "./../../starling/core/Starling";
import starling_errors_MissingContextError from "./../../starling/errors/MissingContextError";
import starling_textures_AtfData from "./../../starling/textures/AtfData";
import Reflect from "./../../Reflect";
import starling_utils_SystemUtil from "./../../starling/utils/SystemUtil";
import starling_errors_NotSupportedError from "./../../starling/errors/NotSupportedError";
import openfl_display3D__$Context3DProfile_Context3DProfile_$Impl_$ from "./../../openfl/display3D/_Context3DProfile/Context3DProfile_Impl_";
import starling_utils_MathUtil from "./../../starling/utils/MathUtil";
import starling_textures_SubTexture from "./../../starling/textures/SubTexture";

declare namespace starling.textures {

export class Texture {

	constructor();
	dispose():any;
	setupVertexPositions(vertexData:any, vertexID?:any, attrName?:any, bounds?:any):any;
	setupTextureCoordinates(vertexData:any, vertexID?:any, attrName?:any):any;
	localToGlobal(u:any, v:any, out?:any):any;
	globalToLocal(u:any, v:any, out?:any):any;
	setTexCoords(vertexData:any, vertexID:any, attrName:any, u:any, v:any):any;
	getTexCoords(vertexData:any, vertexID:any, attrName?:any, out?:any):any;
	frame:any;
	get_frame():any;
	frameWidth:any;
	get_frameWidth():any;
	frameHeight:any;
	get_frameHeight():any;
	width:any;
	get_width():any;
	height:any;
	get_height():any;
	nativeWidth:any;
	get_nativeWidth():any;
	nativeHeight:any;
	get_nativeHeight():any;
	scale:any;
	get_scale():any;
	base:any;
	get_base():any;
	root:any;
	get_root():any;
	format:any;
	get_format():any;
	mipMapping:any;
	get_mipMapping():any;
	premultipliedAlpha:any;
	get_premultipliedAlpha():any;
	transformationMatrix:any;
	get_transformationMatrix():any;
	transformationMatrixToRoot:any;
	get_transformationMatrixToRoot():any;
	static sDefaultOptions:any;
	static sRectangle:any;
	static sMatrix:any;
	static sPoint:any;
	static fromData(data:any, options?:any):any;
	static fromTextureBase(base:any, width:any, height:any, options?:any):any;
	static fromEmbeddedAsset(assetClass:any, mipMapping?:any, optimizeForRenderToTexture?:any, scale?:any, format?:any, forcePotTexture?:any):any;
	static fromBitmap(bitmap:any, generateMipMaps?:any, optimizeForRenderToTexture?:any, scale?:any, format?:any, forcePotTexture?:any, async?:any):any;
	static fromBitmapData(data:any, generateMipMaps?:any, optimizeForRenderToTexture?:any, scale?:any, format?:any, forcePotTexture?:any, async?:any):any;
	static fromAtfData(data:any, scale?:any, useMipMaps?:any, async?:any, premultipliedAlpha?:any):any;
	static fromNetStream(stream:any, scale?:any, onComplete?:any):any;
	static fromVideoAttachment(type:any, attachment:any, scale:any, onComplete:any):any;
	static fromColor(width:any, height:any, color?:any, alpha?:any, optimizeForRenderToTexture?:any, scale?:any, format?:any, forcePotTexture?:any):any;
	static empty(width:any, height:any, premultipliedAlpha?:any, mipMapping?:any, optimizeForRenderToTexture?:any, scale?:any, format?:any, forcePotTexture?:any):any;
	static fromTexture(texture:any, region?:any, frame?:any, rotated?:any, scaleModifier?:any):any;
	static maxSize:any;
	static get_maxSize():any;
	static asyncBitmapUploadEnabled:any;
	static get_asyncBitmapUploadEnabled():any;
	static set_asyncBitmapUploadEnabled(value:any):any;


}

}

export default starling.textures.Texture;
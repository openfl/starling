import starling_textures_ConcreteTexture from "./../../starling/textures/ConcreteTexture";
import starling_core_Starling from "./../../starling/core/Starling";
import Std from "./../../Std";
import openfl_display_BitmapData from "openfl/display/BitmapData";
import Reflect from "./../../Reflect";
import js__$Boot_HaxeError from "./../../js/_Boot/HaxeError";
import js_Boot from "./../../js/Boot";
import openfl_errors_Error from "openfl/errors/Error";
import haxe_Timer from "./../../haxe/Timer";
import openfl_events_Event from "openfl/events/Event";
import openfl_geom_Matrix from "openfl/geom/Matrix";
import openfl_geom_Rectangle from "openfl/geom/Rectangle";
import openfl_geom_Point from "openfl/geom/Point";
import starling_utils_MathUtil from "./../../starling/utils/MathUtil";
import openfl_errors_ArgumentError from "openfl/errors/ArgumentError";

declare namespace starling.textures {

export class ConcretePotTexture extends starling_textures_ConcreteTexture {

	constructor(base:any, format:any, width:any, height:any, mipMapping:any, premultipliedAlpha:any, optimizedForRenderTexture?:any, scale?:any);
	_textureReadyCallback(a1:any):any;
	dispose():any;
	createBase():any;
	uploadBitmapData(data:any, async?:any):any;
	get_isPotTexture():any;
	uploadAtfData(data:any, offset?:any, async?:any):any;
	upload(source:any, mipLevel:any, isAsync:any):any;
	uploadAsync(source:any, mipLevel:any):any;
	onTextureReady(event:any):any;
	potBase:any;
	get_potBase():any;
	static sMatrix:any;
	static sRectangle:any;
	static sOrigin:any;
	static sAsyncUploadEnabled:any;
	static asyncUploadEnabled:any;
	static get_asyncUploadEnabled():any;
	static set_asyncUploadEnabled(value:any):any;


}

}

export default starling.textures.ConcretePotTexture;
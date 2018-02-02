import starling_textures_ConcreteTexture from "./../../starling/textures/ConcreteTexture";
import starling_core_Starling from "./../../starling/core/Starling";
import Std from "./../../Std";
import Reflect from "./../../Reflect";
import js__$Boot_HaxeError from "./../../js/_Boot/HaxeError";
import js_Boot from "./../../js/Boot";
import openfl_errors_Error from "openfl/errors/Error";
import haxe_Timer from "./../../haxe/Timer";
import openfl_events_Event from "openfl/events/Event";

declare namespace starling.textures {

export class ConcreteRectangleTexture extends starling_textures_ConcreteTexture {

	constructor(base:any, format:any, width:any, height:any, premultipliedAlpha:any, optimizedForRenderTexture?:any, scale?:any);
	_textureReadyCallback(a1:any):any;
	uploadBitmapData(data:any, async?:any):any;
	createBase():any;
	rectBase:any;
	get_rectBase():any;
	upload(source:any, isAsync:any):any;
	uploadAsync(source:any):any;
	onTextureReady(event:any):any;
	static sAsyncUploadEnabled:any;
	static asyncUploadEnabled:any;
	static get_asyncUploadEnabled():any;
	static set_asyncUploadEnabled(value:any):any;


}

}

export default starling.textures.ConcreteRectangleTexture;
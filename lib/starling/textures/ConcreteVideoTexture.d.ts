import starling_textures_ConcreteTexture from "./../../starling/textures/ConcreteTexture";
import starling_core_Starling from "./../../starling/core/Starling";
import Reflect from "./../../Reflect";
import openfl_display3D__$Context3DTextureFormat_Context3DTextureFormat_$Impl_$ from "./../../openfl/display3D/_Context3DTextureFormat/Context3DTextureFormat_Impl_";

declare namespace starling.textures {

export class ConcreteVideoTexture extends starling_textures_ConcreteTexture {

	constructor(base:any, scale?:any);
	_textureReadyCallback(a1:any):any;
	_disposed:any;
	dispose():any;
	createBase():any;
	attachVideo(type:any, attachment:any, onComplete?:any):any;
	onTextureReady(event:any):any;
	get_nativeWidth():any;
	get_nativeHeight():any;
	get_width():any;
	get_height():any;
	videoBase:any;
	get_videoBase():any;


}

}

export default starling.textures.ConcreteVideoTexture;
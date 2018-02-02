import starling_textures_SubTexture from "./../../starling/textures/SubTexture";
import starling_core_Starling from "./../../starling/core/Starling";
import openfl_geom_Rectangle from "openfl/geom/Rectangle";
import js__$Boot_HaxeError from "./../../js/_Boot/HaxeError";
import openfl_errors_IllegalOperationError from "openfl/errors/IllegalOperationError";
import starling_textures_Texture from "./../../starling/textures/Texture";
import starling_display_Image from "./../../starling/display/Image";

declare namespace starling.textures {

export class RenderTexture extends starling_textures_SubTexture {

	constructor(width:any, height:any, persistent?:any, scale?:any, format?:any);
	_activeTexture:any;
	_bufferTexture:any;
	_helperImage:any;
	_drawing:any;
	_bufferReady:any;
	_isPersistent:any;
	dispose():any;
	draw(object:any, matrix?:any, alpha?:any, antiAliasing?:any):any;
	drawBundled(drawingBlock:any, antiAliasing?:any):any;
	__render(object:any, matrix?:any, alpha?:any):any;
	__renderBundled(renderBlock:any, object?:any, matrix?:any, alpha?:any, antiAliasing?:any):any;
	clear(color?:any, alpha?:any):any;
	isDoubleBuffered:any;
	get_isDoubleBuffered():any;
	isPersistent:any;
	get_isPersistent():any;
	get_base():any;
	get_root():any;
	static USE_DOUBLE_BUFFERING_DATA_NAME:any;
	static sClipRect:any;
	static useDoubleBuffering:any;
	static get_useDoubleBuffering():any;
	static set_useDoubleBuffering(value:any):any;


}

}

export default starling.textures.RenderTexture;
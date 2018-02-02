import starling_core_Starling from "./../../starling/core/Starling";

declare namespace starling.textures {

export class TextureOptions {

	constructor(scale?:any, mipMapping?:any, format?:any, premultipliedAlpha?:any, forcePotTexture?:any);
	_scale:any;
	_format:any;
	_mipMapping:any;
	_optimizeForRenderToTexture:any;
	_premultipliedAlpha:any;
	_forcePotTexture:any;
	_onReady(a1:any):any;
	clone():any;
	scale:any;
	get_scale():any;
	set_scale(value:any):any;
	format:any;
	get_format():any;
	set_format(value:any):any;
	mipMapping:any;
	get_mipMapping():any;
	set_mipMapping(value:any):any;
	optimizeForRenderToTexture:any;
	get_optimizeForRenderToTexture():any;
	set_optimizeForRenderToTexture(value:any):any;
	forcePotTexture:any;
	get_forcePotTexture():any;
	set_forcePotTexture(value:any):any;
	onReady(a1:any):any;
	get_onReady():any;
	set_onReady(value:any):any;
	premultipliedAlpha:any;
	get_premultipliedAlpha():any;
	set_premultipliedAlpha(value:any):any;


}

}

export default starling.textures.TextureOptions;
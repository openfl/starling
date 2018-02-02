import starling_core_Starling from "./../../starling/core/Starling";
import openfl_display3D__$Context3DBlendFactor_Context3DBlendFactor_$Impl_$ from "./../../openfl/display3D/_Context3DBlendFactor/Context3DBlendFactor_Impl_";
import js__$Boot_HaxeError from "./../../js/_Boot/HaxeError";
import openfl_errors_ArgumentError from "openfl/errors/ArgumentError";
import haxe_ds_StringMap from "./../../haxe/ds/StringMap";

declare namespace starling.display {

export class BlendMode {

	constructor(name:any, sourceFactor:any, destinationFactor:any);
	__name:any;
	__sourceFactor:any;
	__destinationFactor:any;
	activate():any;
	toString():any;
	sourceFactor:any;
	get_sourceFactor():any;
	destinationFactor:any;
	get_destinationFactor():any;
	name:any;
	get_name():any;
	static sBlendModes:any;
	static AUTO:any;
	static NONE:any;
	static NORMAL:any;
	static ADD:any;
	static MULTIPLY:any;
	static SCREEN:any;
	static ERASE:any;
	static MASK:any;
	static BELOW:any;
	static get(modeName:any):any;
	static getByFactors(srcFactor:any, dstFactor:any):any;
	static register(name:any, srcFactor:any, dstFactor:any):any;
	static registerDefaults():any;


}

}

export default starling.display.BlendMode;
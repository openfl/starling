import Std from "./../../Std";

declare namespace starling.extensions {

export class ColorArgb {

	constructor(red?:any, green?:any, blue?:any, alpha?:any);
	red:any;
	green:any;
	blue:any;
	alpha:any;
	toRgb():any;
	toArgb():any;
	_fromRgb(color:any):any;
	_fromArgb(color:any):any;
	copyFrom(argb:any):any;
	static fromRgb(color:any):any;
	static fromArgb(color:any):any;


}

}

export default starling.extensions.ColorArgb;
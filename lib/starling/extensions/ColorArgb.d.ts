declare namespace starling.extensions
{
	export class ColorArgb
	{
		alpha:number;
		blue:number;
		green:number;
		red:number;
		constructor(red?:number, green?:number, blue?:number, alpha?:number);
		_fromArgb(color:number):void;
		_fromRgb(color:number):void;
		copyFrom(argb:ColorArgb):void;
		toArgb():number;
		toRgb():number;
		static fromArgb(color:number):ColorArgb;
		static fromRgb(color:number):ColorArgb;
	}
}

export default starling.extensions.ColorArgb;
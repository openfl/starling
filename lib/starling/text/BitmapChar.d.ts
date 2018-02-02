import haxe_ds_IntMap from "./../../haxe/ds/IntMap";
import starling_display_Image from "./../../starling/display/Image";

declare namespace starling.text {

export class BitmapChar {

	constructor(id:any, texture:any, xOffset:any, yOffset:any, xAdvance:any);
	__texture:any;
	__charID:any;
	__xOffset:any;
	__yOffset:any;
	__xAdvance:any;
	__kernings:any;
	addKerning(charID:any, amount:any):any;
	getKerning(charID:any):any;
	createImage():any;
	charID:any;
	get_charID():any;
	xOffset:any;
	get_xOffset():any;
	yOffset:any;
	get_yOffset():any;
	xAdvance:any;
	get_xAdvance():any;
	texture:any;
	get_texture():any;
	width:any;
	get_width():any;
	height:any;
	get_height():any;


}

}

export default starling.text.BitmapChar;
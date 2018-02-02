import starling_text_ITextCompositor from "./../../starling/text/ITextCompositor";
import Std from "./../../Std";
import haxe_Log from "./../../haxe/Log";
import openfl_geom_Rectangle from "openfl/geom/Rectangle";
import starling_textures_Texture from "./../../starling/textures/Texture";
import starling_text_BitmapChar from "./../../starling/text/BitmapChar";
import openfl_Vector from "openfl/Vector";
import HxOverrides from "./../../HxOverrides";
import starling_display_Sprite from "./../../starling/display/Sprite";
import starling_text_CharLocation from "./../../starling/text/CharLocation";
import starling_utils_ArrayUtil from "./../../starling/utils/ArrayUtil";
import starling_text_TextOptions from "./../../starling/text/TextOptions";
import starling_text_MiniBitmapFont from "./../../starling/text/MiniBitmapFont";
import js__$Boot_HaxeError from "./../../js/_Boot/HaxeError";
import openfl_errors_ArgumentError from "openfl/errors/ArgumentError";
import haxe_ds_IntMap from "./../../haxe/ds/IntMap";
import starling_display_Image from "./../../starling/display/Image";

declare namespace starling.text {

export class BitmapFont {

	constructor(texture?:any, fontXml?:any);
	__texture:any;
	__chars:any;
	__name:any;
	__size:any;
	__lineHeight:any;
	__baseline:any;
	__offsetX:any;
	__offsetY:any;
	__padding:any;
	__helperImage:any;
	dispose():any;
	parseFontXml(fontXml:any):any;
	getChar(charID:any):any;
	addChar(charID:any, bitmapChar:any):any;
	getCharIDs(result?:any):any;
	hasChars(text:any):any;
	createSprite(width:any, height:any, text:any, format:any, options?:any):any;
	fillMeshBatch(meshBatch:any, width:any, height:any, text:any, format:any, options?:any):any;
	clearMeshBatch(meshBatch:any):any;
	arrangeChars(width:any, height:any, text:any, format:any, options:any):any;
	name:any;
	get_name():any;
	size:any;
	get_size():any;
	lineHeight:any;
	get_lineHeight():any;
	set_lineHeight(value:any):any;
	smoothing:any;
	get_smoothing():any;
	set_smoothing(value:any):any;
	baseline:any;
	get_baseline():any;
	set_baseline(value:any):any;
	offsetX:any;
	get_offsetX():any;
	set_offsetX(value:any):any;
	offsetY:any;
	get_offsetY():any;
	set_offsetY(value:any):any;
	padding:any;
	get_padding():any;
	set_padding(value:any):any;
	get_texture():any;
	static NATIVE_SIZE:any;
	static MINI:any;
	static CHAR_SPACE:any;
	static CHAR_TAB:any;
	static CHAR_NEWLINE:any;
	static CHAR_CARRIAGE_RETURN:any;
	static sLines:any;
	static sDefaultOptions:any;


}

}

export default starling.text.BitmapFont;
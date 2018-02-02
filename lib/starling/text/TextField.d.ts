import starling_display_DisplayObjectContainer from "./../../starling/display/DisplayObjectContainer";
import starling_text_BitmapFont from "./../../starling/text/BitmapFont";
import starling_core_Starling from "./../../starling/core/Starling";
import starling_utils_RectangleUtil from "./../../starling/utils/RectangleUtil";
import js__$Boot_HaxeError from "./../../js/_Boot/HaxeError";
import openfl_errors_ArgumentError from "openfl/errors/ArgumentError";
import starling_display_Sprite from "./../../starling/display/Sprite";
import starling_display_Quad from "./../../starling/display/Quad";
import openfl_geom_Matrix from "openfl/geom/Matrix";
import starling_text_TrueTypeCompositor from "./../../starling/text/TrueTypeCompositor";
import openfl_display3D__$Context3DTextureFormat_Context3DTextureFormat_$Impl_$ from "./../../openfl/display3D/_Context3DTextureFormat/Context3DTextureFormat_Impl_";
import starling_utils_SystemUtil from "./../../starling/utils/SystemUtil";
import js_Boot from "./../../js/Boot";
import haxe_ds_StringMap from "./../../haxe/ds/StringMap";
import openfl_geom_Rectangle from "openfl/geom/Rectangle";
import starling_text_TextFormat from "./../../starling/text/TextFormat";
import starling_text_TextOptions from "./../../starling/text/TextOptions";
import starling_display_MeshBatch from "./../../starling/display/MeshBatch";

declare namespace starling.text {

export class TextField extends starling_display_DisplayObjectContainer {

	constructor(width:any, height:any, text?:any, format?:any);
	_text:any;
	_options:any;
	_format:any;
	_textBounds:any;
	_hitArea:any;
	_compositor:any;
	_requiresRecomposition:any;
	_border:any;
	_meshBatch:any;
	_style:any;
	_recomposing:any;
	dispose():any;
	render(painter:any):any;
	recompose():any;
	updateText():any;
	updateBorder():any;
	setRequiresRecomposition():any;
	isHorizontalAutoSize:any;
	get_isHorizontalAutoSize():any;
	isVerticalAutoSize:any;
	get_isVerticalAutoSize():any;
	textBounds:any;
	get_textBounds():any;
	getBounds(targetSpace:any, out?:any):any;
	hitTest(localPoint:any):any;
	set_width(value:any):any;
	set_height(value:any):any;
	text:any;
	get_text():any;
	set_text(value:any):any;
	format:any;
	get_format():any;
	set_format(value:any):any;
	options:any;
	get_options():any;
	border:any;
	get_border():any;
	set_border(value:any):any;
	autoScale:any;
	get_autoScale():any;
	set_autoScale(value:any):any;
	autoSize:any;
	get_autoSize():any;
	set_autoSize(value:any):any;
	wordWrap:any;
	get_wordWrap():any;
	set_wordWrap(value:any):any;
	batchable:any;
	get_batchable():any;
	set_batchable(value:any):any;
	isHtmlText:any;
	get_isHtmlText():any;
	set_isHtmlText(value:any):any;
	pixelSnapping:any;
	get_pixelSnapping():any;
	set_pixelSnapping(value:any):any;
	style:any;
	get_style():any;
	set_style(value:any):any;
	static COMPOSITOR_DATA_NAME:any;
	static sMatrix:any;
	static sDefaultCompositor:any;
	static sDefaultTextureFormat:any;
	static defaultTextureFormat:any;
	static get_defaultTextureFormat():any;
	static set_defaultTextureFormat(value:any):any;
	static defaultCompositor:any;
	static get_defaultCompositor():any;
	static set_defaultCompositor(value:any):any;
	static updateEmbeddedFonts():any;
	static registerCompositor(compositor:any, name:any):any;
	static unregisterCompositor(name:any, dispose?:any):any;
	static getCompositor(name:any):any;
	static registerBitmapFont(bitmapFont:any, name?:any):any;
	static unregisterBitmapFont(name:any, dispose?:any):any;
	static getBitmapFont(name:any):any;
	static compositors:any;
	static get_compositors():any;
	static sStringCache:any;
	static convertToLowerCase(string:any):any;


}

}

export default starling.text.TextField;
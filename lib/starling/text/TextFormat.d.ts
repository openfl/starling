import starling_events_EventDispatcher from "./../../starling/events/EventDispatcher";
import openfl_text_TextFormat from "openfl/text/TextFormat";
import Std from "./../../Std";
import openfl_text__$TextFormatAlign_TextFormatAlign_$Impl_$ from "./../../openfl/text/_TextFormatAlign/TextFormatAlign_Impl_";
import starling_utils_Align from "./../../starling/utils/Align";
import js__$Boot_HaxeError from "./../../js/_Boot/HaxeError";
import openfl_errors_ArgumentError from "openfl/errors/ArgumentError";

declare namespace starling.text {

export class TextFormat extends starling_events_EventDispatcher {

	constructor(font?:any, size?:any, color?:any, horizontalAlign?:any, verticalAlign?:any);
	__font:any;
	__size:any;
	__color:any;
	__bold:any;
	__italic:any;
	__underline:any;
	__horizontalAlign:any;
	__verticalAlign:any;
	__kerning:any;
	__leading:any;
	__letterSpacing:any;
	copyFrom(format:any):any;
	clone():any;
	setTo(font?:any, size?:any, color?:any, horizontalAlign?:any, verticalAlign?:any):any;
	toNativeFormat(out?:any):any;
	font:any;
	get_font():any;
	set_font(value:any):any;
	size:any;
	get_size():any;
	set_size(value:any):any;
	color:any;
	get_color():any;
	set_color(value:any):any;
	bold:any;
	get_bold():any;
	set_bold(value:any):any;
	italic:any;
	get_italic():any;
	set_italic(value:any):any;
	underline:any;
	get_underline():any;
	set_underline(value:any):any;
	horizontalAlign:any;
	get_horizontalAlign():any;
	set_horizontalAlign(value:any):any;
	verticalAlign:any;
	get_verticalAlign():any;
	set_verticalAlign(value:any):any;
	kerning:any;
	get_kerning():any;
	set_kerning(value:any):any;
	leading:any;
	get_leading():any;
	set_leading(value:any):any;
	letterSpacing:any;
	get_letterSpacing():any;
	set_letterSpacing(value:any):any;


}

}

export default starling.text.TextFormat;
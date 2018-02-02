import starling_events_EventDispatcher from "./../../starling/events/EventDispatcher";
import Type from "./../../Type";
import starling_core_Starling from "./../../starling/core/Starling";
import starling_text_TextField from "./../../starling/text/TextField";

declare namespace starling.text {

export class TextOptions extends starling_events_EventDispatcher {

	constructor(wordWrap?:any, autoScale?:any);
	__wordWrap:any;
	__autoScale:any;
	__autoSize:any;
	__isHtmlText:any;
	__textureScale:any;
	__textureFormat:any;
	__padding:any;
	copyFrom(options:any):any;
	clone():any;
	wordWrap:any;
	get_wordWrap():any;
	set_wordWrap(value:any):any;
	autoSize:any;
	get_autoSize():any;
	set_autoSize(value:any):any;
	autoScale:any;
	get_autoScale():any;
	set_autoScale(value:any):any;
	isHtmlText:any;
	get_isHtmlText():any;
	set_isHtmlText(value:any):any;
	textureScale:any;
	get_textureScale():any;
	set_textureScale(value:any):any;
	textureFormat:any;
	get_textureFormat():any;
	set_textureFormat(value:any):any;
	padding:any;
	get_padding():any;
	set_padding(value:any):any;


}

}

export default starling.text.TextOptions;
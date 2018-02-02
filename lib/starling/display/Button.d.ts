import starling_display_DisplayObjectContainer from "./../../starling/display/DisplayObjectContainer";
import starling_text_TextField from "./../../starling/text/TextField";
import Std from "./../../Std";
import openfl_ui_Mouse from "openfl/ui/Mouse";
import js__$Boot_HaxeError from "./../../js/_Boot/HaxeError";
import openfl_errors_ArgumentError from "openfl/errors/ArgumentError";
import starling_display_Sprite from "./../../starling/display/Sprite";
import starling_display_Image from "./../../starling/display/Image";
import openfl_geom_Rectangle from "openfl/geom/Rectangle";

declare namespace starling.display {

export class Button extends starling_display_DisplayObjectContainer {

	constructor(upState:any, text?:any, downState?:any, overState?:any, disabledState?:any);
	__upState:any;
	__downState:any;
	__overState:any;
	__disabledState:any;
	__contents:any;
	__body:any;
	__textField:any;
	__textBounds:any;
	__overlay:any;
	__scaleWhenDown:any;
	__scaleWhenOver:any;
	__alphaWhenDown:any;
	__alphaWhenDisabled:any;
	__enabled:any;
	__state:any;
	__triggerBounds:any;
	dispose():any;
	readjustSize(resetTextBounds?:any):any;
	__createTextField():any;
	__onTouch(event:any):any;
	state:any;
	get_state():any;
	set_state(value:any):any;
	__setStateTexture(texture:any):any;
	scaleWhenDown:any;
	get_scaleWhenDown():any;
	set_scaleWhenDown(value:any):any;
	scaleWhenOver:any;
	get_scaleWhenOver():any;
	set_scaleWhenOver(value:any):any;
	alphaWhenDown:any;
	get_alphaWhenDown():any;
	set_alphaWhenDown(value:any):any;
	alphaWhenDisabled:any;
	get_alphaWhenDisabled():any;
	set_alphaWhenDisabled(value:any):any;
	enabled:any;
	get_enabled():any;
	set_enabled(value:any):any;
	text:any;
	get_text():any;
	set_text(value:any):any;
	textFormat:any;
	get_textFormat():any;
	set_textFormat(value:any):any;
	textStyle:any;
	get_textStyle():any;
	set_textStyle(value:any):any;
	style:any;
	get_style():any;
	set_style(value:any):any;
	upState:any;
	get_upState():any;
	set_upState(value:any):any;
	downState:any;
	get_downState():any;
	set_downState(value:any):any;
	overState:any;
	get_overState():any;
	set_overState(value:any):any;
	disabledState:any;
	get_disabledState():any;
	set_disabledState(value:any):any;
	textBounds:any;
	get_textBounds():any;
	set_textBounds(value:any):any;
	color:any;
	get_color():any;
	set_color(value:any):any;
	textureSmoothing:any;
	get_textureSmoothing():any;
	set_textureSmoothing(value:any):any;
	overlay:any;
	get_overlay():any;
	get_useHandCursor():any;
	set_useHandCursor(value:any):any;
	pixelSnapping:any;
	get_pixelSnapping():any;
	set_pixelSnapping(value:any):any;
	set_width(value:any):any;
	set_height(value:any):any;
	scale9Grid:any;
	get_scale9Grid():any;
	set_scale9Grid(value:any):any;
	static MAX_DRAG_DIST:any;


}

}

export default starling.display.Button;
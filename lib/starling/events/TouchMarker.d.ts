import starling_display_Sprite from "./../../starling/display/Sprite";
import starling_core_Starling from "./../../starling/core/Starling";
import Std from "./../../Std";
import openfl_display_Shape from "openfl/display/Shape";
import openfl_display_BitmapData from "openfl/display/BitmapData";
import starling_textures_Texture from "./../../starling/textures/Texture";
import js_Boot from "./../../js/Boot";
import starling_display_Image from "./../../starling/display/Image";
import openfl_geom_Point from "openfl/geom/Point";

declare namespace starling.events {

export class TouchMarker extends starling_display_Sprite {

	constructor();
	__center:any;
	__texture:any;
	dispose():any;
	moveMarker(x:any, y:any, withCenter?:any):any;
	moveCenter(x:any, y:any):any;
	createTexture():any;
	realMarker:any;
	get_realMarker():any;
	mockMarker:any;
	get_mockMarker():any;
	realX:any;
	get_realX():any;
	realY:any;
	get_realY():any;
	mockX:any;
	get_mockX():any;
	mockY:any;
	get_mockY():any;


}

}

export default starling.events.TouchMarker;
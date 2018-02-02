import starling_display_Quad from "./../../starling/display/Quad";
import starling_utils_MathUtil from "./../../starling/utils/MathUtil";
import starling_utils_Pool from "./../../starling/utils/Pool";
import starling_utils_RectangleUtil from "./../../starling/utils/RectangleUtil";
import Std from "./../../Std";
import haxe_ds_ObjectMap from "./../../haxe/ds/ObjectMap";
import starling_utils_Padding from "./../../starling/utils/Padding";
import openfl_geom_Rectangle from "openfl/geom/Rectangle";
import openfl_Vector from "openfl/Vector";
import starling_display_TextureSetupSettings from "./../../starling/display/TextureSetupSettings";

declare namespace starling.display {

export class Image extends starling_display_Quad {

	constructor(texture:any);
	__scale9Grid:any;
	__tileGrid:any;
	scale9Grid:any;
	get_scale9Grid():any;
	set_scale9Grid(value:any):any;
	tileGrid:any;
	get_tileGrid():any;
	set_tileGrid(value:any):any;
	__setupVertices():any;
	set_scaleX(value:any):any;
	set_scaleY(value:any):any;
	set_texture(value:any):any;
	__setupScale9Grid():any;
	__setupScale9GridAttributes(startX:any, startY:any, posCols:any, posRows:any, texCols:any, texRows:any):any;
	__setupTileGrid():any;
	static sSetupFunctions:any;
	static sPadding:any;
	static sBounds:any;
	static sBasCols:any;
	static sBasRows:any;
	static sPosCols:any;
	static sPosRows:any;
	static sTexCols:any;
	static sTexRows:any;
	static automateSetupForTexture(texture:any, onAssign:any, onRelease?:any):any;
	static resetSetupForTexture(texture:any):any;
	static bindScale9GridToTexture(texture:any, scale9Grid:any):any;
	static bindPivotPointToTexture(texture:any, pivotX:any, pivotY:any):any;


}

}

export default starling.display.Image;
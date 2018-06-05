import IFilterHelper from "./../../starling/filters/IFilterHelper";
import Pool from "./../../starling/utils/Pool";
import Texture from "./../../starling/textures/Texture";
import MathUtil from "./../../starling/utils/MathUtil";
import SubTexture from "./../../starling/textures/SubTexture";
import Starling from "./../../starling/core/Starling";
import Rectangle from "openfl/geom/Rectangle";
import Vector from "openfl/Vector";
import Matrix3D from "openfl/geom/Matrix3D";
import DisplayObject from "./../DisplayObject";

declare namespace starling.filters
{
	export class FilterHelper implements IFilterHelper
	{
		clipRect:Rectangle;
		projectionMatrix3D:Matrix3D;
		renderTarget:Texture;
		target:DisplayObject;
		targetBounds:Rectangle;
		textureFormat:string;
		textureScale:number;
		constructor(textureFormat?:string);
		dispose():void;
		getTexture(resolution?:number):Texture;
		purge():void;
		putTexture(texture:Texture):void;
		start(numPasses:number, drawLastPassToBackBuffer:boolean):void;
		
		// get_target():DisplayObject;
		// get_targetBounds():Rectangle;
	}
}

export default starling.filters.FilterHelper;
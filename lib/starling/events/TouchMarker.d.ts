import Sprite from "./../../starling/display/Sprite";
import Starling from "./../../starling/core/Starling";
import Shape from "openfl/display/Shape";
import BitmapData from "openfl/display/BitmapData";
import Texture from "./../../starling/textures/Texture";
import Image from "./../../starling/display/Image";
import Point from "openfl/geom/Point";

declare namespace starling.events
{
	/** The TouchMarker is used internally to mark touches created through "simulateMultitouch". */
	export class TouchMarker extends Sprite
	{
		public constructor();
		
		public /*override*/ dispose():void;
		
		public moveMarker(x:number, y:number, withCenter?:boolean):void;
		
		public moveCenter(x:number, y:number):void;
	}
}

export default starling.events.TouchMarker;
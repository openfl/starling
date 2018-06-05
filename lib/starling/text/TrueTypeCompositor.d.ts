import ITextCompositor from "./../../starling/text/ITextCompositor";
import Texture from "./../../starling/textures/Texture";
import SystemUtil from "./../../starling/utils/SystemUtil";
import MathUtil from "./../../starling/utils/MathUtil";
import Matrix from "openfl/geom/Matrix";
import Quad from "./../../starling/display/Quad";
import TextField from "openfl/text/TextField";
import TextFormat from "openfl/text/TextFormat";
import MeshBatch from "./../display/MeshBatch";
import MeshStyle from "./../styles/MeshStyle";
import BitmapData from "openfl/display/BitmapData";
import TextOptions from "./TextOptions";

declare namespace starling.text
{
	/** This text compositor uses a Flash TextField to render system- or embedded fonts into
	 *  a texture.
	 *
	 *  <p>You typically don't have to instantiate this class. It will be used internally by
	 *  Starling's text fields.</p>
	 */
	export class TrueTypeCompositor implements ITextCompositor
	{
		/** Creates a new TrueTypeCompositor instance. */
		public constructor();
	
		/** @inheritDoc */
		public dispose():void;
	
		/** @inheritDoc */
		public fillMeshBatch(meshBatch:MeshBatch, width:number, height:number, text:string,
									  format:TextFormat, options?:TextOptions):void;
	
		/** @inheritDoc */
		public clearMeshBatch(meshBatch:MeshBatch):void;
		
		/** @protected */
		public getDefaultMeshStyle(previousStyle:MeshStyle,
											format:TextFormat, options:TextOptions):MeshStyle;
	}
	
	export class BitmapDataEx extends BitmapData
	{
		public scale:number;
		protected get_scale():number;
		protected set_scale(value:number):number;
	}
}

export default starling.text.TrueTypeCompositor;
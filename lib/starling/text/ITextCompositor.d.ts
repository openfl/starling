import MeshBatch from "./../display/MeshBatch";
import MeshStyle from "./../styles/MeshStyle";
import TextFormat from "./TextFormat";
import TextOptions from "./TextOptions";

declare namespace starling.text
{
	/** A text compositor arranges letters for Starling's TextField. */
	interface ITextCompositor
	{
		/** Draws the given text into a MeshBatch, using the supplied format and options. */
		public fillMeshBatch(meshBatch:MeshBatch, width:number, height:number, text:string,
							   format:TextFormat, options?:TextOptions):void;
	
		/** Clears the MeshBatch (filled by the same class) and disposes any resources that
		 *  are no longer needed. */
		public clearMeshBatch(meshBatch:MeshBatch):void;
		
		/** Creates and/or sets up the default MeshStyle to be used for rendering.
		 *  If <code>previousStyle</code> has the correct type, it is configured as needed and
		 *  then returned; otherwise, a new style is created, configured and returned.
		 *  The method may return <code>null</code> if there are no special style requirements. */
		getDefaultMeshStyle(previousStyle:MeshStyle,
									 format:TextFormat, options:TextOptions):MeshStyle;
	
		/** Frees all resources allocated by the compositor. */
		public dispose():void;
	}
}

export default starling.text.ITextCompositor;
import StringUtil from "./../../starling/utils/StringUtil";

declare namespace starling.rendering
{
	/** Points to a location within a list of MeshBatches.
	 *
	 *  <p>Starling uses these tokens in its render cache. Each call to
	 *  <code>painter.pushState()</code> or <code>painter.popState()</code> provides a token
	 *  referencing the current location within the cache. In the next frame, if the relevant
	 *  part of the display tree has not changed, these tokens can be used to render directly
	 *  from the cache instead of constructing new MeshBatches.</p>
	 *
	 *  @see Painter
	 */
	export class BatchToken
	{
		/** The ID of the current MeshBatch. */
		public batchID:number;
	
		/** The ID of the next vertex within the current MeshBatch. */
		public vertexID:number;
	
		/** The ID of the next index within the current MeshBatch. */
		public indexID:number;
	
		/** Creates a new BatchToken. */
		public constructor(batchID?:number, vertexID?:number, indexID?:number);
	
		/** Copies the properties from the given token to this instance. */
		public copyFrom(token:BatchToken):void;
	
		/** Changes all properties at once. */
		public setTo(batchID?:number, vertexID?:number, indexID?:number):void;
	
		/** Resets all properties to zero. */
		public reset():void;
	
		/** Indicates if this token contains the same values as the given one. */
		public equals(other:BatchToken):boolean;
	
		/** Creates a String representation of this instance. */
		public toString():string;
	}
}

export default starling.rendering.BatchToken;
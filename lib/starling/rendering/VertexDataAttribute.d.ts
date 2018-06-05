import ArgumentError from "openfl/errors/ArgumentError";

declare namespace starling.rendering
{
	/** Holds the properties of a single attribute in a VertexDataFormat instance.
	 *  The member variables must never be changed; they are only <code>public</code>
	 *  for performance reasons. */
	export class VertexDataAttribute
	{
		/** Creates a new instance with the given properties. */
		public constructor(name:string, format:string, offset:number);
	}
}

export default starling.rendering.VertexDataAttribute;
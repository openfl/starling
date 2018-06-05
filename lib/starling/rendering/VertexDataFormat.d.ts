import Starling from "./../../starling/core/Starling";
import ArgumentError from "openfl/errors/ArgumentError";
import StringUtil from "./../../starling/utils/StringUtil";
import VertexDataAttribute from "./../../starling/rendering/VertexDataAttribute";
import Vector from "openfl/Vector";
import VertexBuffer3D from "openfl/display3D/VertexBuffer3D";

declare namespace starling.rendering
{
	/** Describes the memory layout of VertexData instances, as used for every single vertex.
	 *
	 *  <p>The format is set up via a simple String. Here is an example:</p>
	 *
	 *  <listing>
	 *  format = VertexDataFormat.fromString("position:number2, color:bytes4");</listing>
	 *
	 *  <p>This String describes two attributes: "position" and "color". The keywords after
	 *  the colons depict the format and size of the data that each attribute uses; in this
	 *  case, we store two floats for the position (taking up the x- and y-coordinates) and four
	 *  bytes for the color. (The available formats are the same as those defined in the
	 *  <code>Context3DVertexBufferFormat</code> class:
	 *  <code>float1, float2, float3, float4, bytes4</code>.)</p>
	 *
	 *  <p>You cannot create a VertexData instance with its constructor; instead, you must use the
	 *  static <code>fromString</code>-method. The reason for this behavior: the class maintains
	 *  a cache, and a call to <code>fromString</code> will return an existing instance if an
	 *  equivalent format has already been created in the past. That saves processing time and
	 *  memory.</p>
	 *
	 *  <p>VertexDataFormat instances are immutable, i.e. they are solely defined by their format
	 *  string and cannot be changed later.</p>
	 *
	 *  @see VertexData
	 */
	export class VertexDataFormat
	{
		/** Don't use the constructor, but call <code>VertexDataFormat.fromString</code> instead.
		 *  This allows for efficient format caching. */
		public constructor();
	
		/** Creates a new VertexDataFormat instance from the given String, or returns one from
		 *  the cache (if an equivalent String has already been used before).
		 *
		 *  @param format
		 *
		 *  Describes the attributes of each vertex, consisting of a comma-separated
		 *  list of attribute names and their format, e.g.:
		 *
		 *  <pre>"position:number2, texCoords:number2, color:bytes4"</pre>
		 *
		 *  <p>This set of attributes will be allocated for each vertex, and they will be
		 *  stored in exactly the given order.</p>
		 *
		 *  <ul>
		 *    <li>Names are used to access the specific attributes of a vertex. They are
		 *        completely arbitrary.</li>
		 *    <li>The available formats can be found in the <code>Context3DVertexBufferFormat</code>
		 *        class in the <code>flash.display3D</code> package.</li>
		 *    <li>Both names and format strings are case-sensitive.</li>
		 *    <li>Always use <code>bytes4</code> for color data that you want to access with the
		 *        respective methods.</li>
		 *    <li>Furthermore, the attribute names of colors should include the string "color"
		 *        (or the uppercase variant). If that's the case, the "alpha" channel of the color
		 *        will automatically be initialized with "1.0" when the VertexData object is
		 *        created or resized.</li>
		 *  </ul>
		 */
		public static fromString(format:string):VertexDataFormat;
	
		/** Creates a new VertexDataFormat instance by appending the given format string
		 *  to the current instance's format. */
		public extend(format:string):VertexDataFormat;
	
		// query methods
	
		/** Returns the size of a certain vertex attribute in bytes. */
		public getSize(attrName:string):number;
	
		/** Returns the size of a certain vertex attribute in 32 bit units. */
		public getSizeIn32Bits(attrName:string):number;
	
		/** Returns the offset (in bytes) of an attribute within a vertex. */
		public getOffset(attrName:string):number;
	
		/** Returns the offset (in 32 bit units) of an attribute within a vertex. */
		public getOffsetIn32Bits(attrName:string):number;
	
		/** Returns the format of a certain vertex attribute, identified by its name.
		 *  Typical values: <code>float1, float2, float3, float4, bytes4</code>. */
		public getFormat(attrName:string):string;
	
		/** Returns the name of the attribute at the given position within the vertex format. */
		public getName(attrIndex:number):string;
	
		/** Indicates if the format contains an attribute with the given name. */
		public hasAttribute(attrName:string):boolean;
	
		// context methods
	
		/** Specifies which vertex data attribute corresponds to a single vertex shader
		 *  program input. This wraps the <code>Context3D</code>-method with the same name,
		 *  automatically replacing <code>attrName</code> with the corresponding values for
		 *  <code>bufferOffset</code> and <code>format</code>. */
		public setVertexBufferAt(index:number, buffer:VertexBuffer3D, attrName:string):void;
	
		/** Returns the normalized format string. */
		public toString():string;
	
		// properties
	
		/** Returns the normalized format string. */
		public readonly formatString:string;
		protected get_formatString():string;
	
		/** The size (in bytes) of each vertex. */
		public readonly vertexSize:number;
		protected get_vertexSize():number;
	
		/** The size (in 32 bit units) of each vertex. */
		public readonly vertexSizeIn32Bits:number;
		protected get_vertexSizeIn32Bits():number;
	
		/** The number of attributes per vertex. */
		public readonly numAttributes:number;
		protected get_numAttributes():number;
	}
}

export default starling.rendering.VertexDataFormat;
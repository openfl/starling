
import ArgumentError from "openfl/errors/ArgumentError";
import IllegalOperationError from "openfl/errors/IllegalOperationError";
import StringUtil from "./../../starling/utils/StringUtil";
import Point from "openfl/geom/Point";
import Vector3D from "openfl/geom/Vector3D";
import Rectangle from "openfl/geom/Rectangle";
import MatrixUtil from "./../../starling/utils/MatrixUtil";
import MathUtil from "./../../starling/utils/MathUtil";
import Starling from "./../../starling/core/Starling";
import MissingContextError from "./../../starling/errors/MissingContextError";
import ByteArray from "openfl/utils/ByteArray";
import MeshStyle from "./../../starling/styles/MeshStyle";
import VertexDataFormat from "./../../starling/rendering/VertexDataFormat";

declare namespace starling.rendering
{
	/** The VertexData class manages a raw list of vertex information, allowing direct upload
	 *  to Stage3D vertex buffers. <em>You only have to work with this class if you're writing
	 *  your own rendering code (e.g. if you create custom display objects).</em>
	 *
	 *  <p>To render objects with Stage3D, you have to organize vertices and indices in so-called
	 *  vertex- and index-buffers. Vertex buffers store the coordinates of the vertices that make
	 *  up an object; index buffers reference those vertices to determine which vertices spawn
	 *  up triangles. Those buffers reside in graphics memory and can be accessed very
	 *  efficiently by the GPU.</p>
	 *
	 *  <p>Before you can move data into the buffers, you have to set it up in conventional
	 *  memory — that is, in a Vector or a ByteArray. Since it's quite cumbersome to manually
	 *  create and manipulate those data structures, the IndexData and VertexData classes provide
	 *  a simple way to do just that. The data is stored sequentially (one vertex or index after
	 *  the other) so that it can easily be uploaded to a buffer.</p>
	 *
	 *  <strong>Vertex Format</strong>
	 *
	 *  <p>The VertexData class requires a custom format string on initialization, or an instance
	 *  of the VertexDataFormat class. Here is an example:</p>
	 *
	 *  <listing>
	 *  vertexData = new VertexData("position:number2, color:bytes4");
	 *  vertexData.setPoint(0, "position", 320, 480);
	 *  vertexData.setColor(0, "color", 0xff00ff);</listing>
	 *
	 *  <p>This instance is set up with two attributes: "position" and "color". The keywords
	 *  after the colons depict the format and size of the data that each property uses; in this
	 *  case, we store two floats for the position (for the x- and y-coordinates) and four
	 *  bytes for the color. Please refer to the VertexDataFormat documentation for details.</p>
	 *
	 *  <p>The attribute names are then used to read and write data to the respective positions
	 *  inside a vertex. Furthermore, they come in handy when copying data from one VertexData
	 *  instance to another: attributes with equal name and data format may be transferred between
	 *  different VertexData objects, even when they contain different sets of attributes or have
	 *  a different layout.</p>
	 *
	 *  <strong>Colors</strong>
	 *
	 *  <p>Always use the format <code>bytes4</code> for color data. The color access methods
	 *  expect that format, since it's the most efficient way to store color data. Furthermore,
	 *  you should always include the string "color" (or "Color") in the name of color data;
	 *  that way, it will be recognized as such and will always have its value pre-filled with
	 *  pure white at full opacity.</p>
	 *
	 *  <strong>Premultiplied Alpha</strong>
	 *
	 *  <p>Per default, color values are stored with premultiplied alpha values, which
	 *  means that the <code>rgb</code> values were multiplied with the <code>alpha</code> values
	 *  before saving them. You can change this behavior with the <code>premultipliedAlpha</code>
	 *  property.</p>
	 *
	 *  <p>Beware: with premultiplied alpha, the alpha value always affects the resolution of
	 *  the RGB channels. A small alpha value results in a lower accuracy of the other channels,
	 *  and if the alpha value reaches zero, the color information is lost altogether.</p>
	 *
	 *  <strong>Tinting</strong>
	 *
	 *  <p>Some low-end hardware is very sensitive when it comes to fragment shader complexity.
	 *  Thus, Starling optimizes shaders for non-tinted meshes. The VertexData class keeps track
	 *  of its <code>tinted</code>-state, at least at a basic level: whenever you change color
	 *  or alpha value of a vertex to something different than white (<code>0xffffff</code>) with
	 *  full alpha (<code>1.0</code>), the <code>tinted</code> property is enabled.</p>
	 *
	 *  <p>However, that value is not entirely accurate: when you restore the color of just a
	 *  range of vertices, or copy just a subset of vertices to another instance, the property
	 *  might wrongfully indicate a tinted mesh. If that's the case, you can either call
	 *  <code>updateTinted()</code> or assign a custom value to the <code>tinted</code>-property.
	 *  </p>
	 *
	 *  @see VertexDataFormat
	 *  @see IndexData
	 */
	export class VertexData
	{
		/** Creates an empty VertexData object with the given format and initial capacity.
		 *
		 *  @param format
		 *
		 *  Either a VertexDataFormat instance or a String that describes the data format.
		 *  Refer to the VertexDataFormat class for more information. If you don't pass a format,
		 *  the default <code>MeshStyle.VERTEX_FORMAT</code> will be used.
		 *
		 *  @param initialCapacity
		 *
		 *  The initial capacity affects just the way the internal ByteArray is allocated, not the
		 *  <code>numIndices</code> value, which will always be zero when the constructor returns.
		 *  The reason for this behavior is the peculiar way in which ByteArrays organize their
		 *  memory:
		 *
		 *  <p>The first time you set the length of a ByteArray, it will adhere to that:
		 *  a ByteArray with length 20 will take up 20 bytes (plus some overhead). When you change
		 *  it to a smaller length, it will stick to the original value, e.g. with a length of 10
		 *  it will still take up 20 bytes. However, now comes the weird part: change it to
		 *  anything above the original length, and it will allocate 4096 bytes!</p>
		 *
		 *  <p>Thus, be sure to always make a generous educated guess, depending on the planned
		 *  usage of your VertexData instances.</p>
		 */
		public constructor(format?:any, initialCapacity?:number);
	
		/** Explicitly frees up the memory used by the ByteArray. */
		public clear():void;
	
		/** Creates a duplicate of the vertex data object. */
		public clone():VertexData;
	
		/** Copies the vertex data (or a range of it, defined by 'vertexID' and 'numVertices')
		 *  of this instance to another vertex data object, starting at a certain target index.
		 *  If the target is not big enough, it will be resized to fit all the new vertices.
		 *
		 *  <p>If you pass a non-null matrix, the 2D position of each vertex will be transformed
		 *  by that matrix before storing it in the target object. (The position being either an
		 *  attribute with the name "position" or, if such an attribute is not found, the first
		 *  attribute of each vertex. It must consist of two float values containing the x- and
		 *  y-coordinates of the vertex.)</p>
		 *
		 *  <p>Source and target do not need to have the exact same format. Only properties that
		 *  exist in the target will be copied; others will be ignored. If a property with the
		 *  same name but a different format exists in the target, an exception will be raised.
		 *  Beware, though, that the copy-operation becomes much more expensive when the formats
		 *  differ.</p>
		 */
		public copyTo(target:VertexData, targetVertexID?:number, matrix?:Matrix,
							   vertexID?:number, numVertices?:number):void;
	
		/** Copies a specific attribute of all contained vertices (or a range of them, defined by
		 *  'vertexID' and 'numVertices') to another VertexData instance. Beware that both name
		 *  and format of the attribute must be identical in source and target.
		 *  If the target is not big enough, it will be resized to fit all the new vertices.
		 *
		 *  <p>If you pass a non-null matrix, the specified attribute will be transformed by
		 *  that matrix before storing it in the target object. It must consist of two float
		 *  values.</p>
		 */
		public copyAttributeTo(target:VertexData, targetVertexID:number, attrName:string,
										matrix?:Matrix, vertexID?:number, numVertices?:number):void;
	
		/** Optimizes the ByteArray so that it has exactly the required capacity, without
		 *  wasting any memory. If your VertexData object grows larger than the initial capacity
		 *  you passed to the constructor, call this method to avoid the 4k memory problem. */
		public trim():void;
	
		/** Returns a string representation of the VertexData object,
		 *  describing both its format and size. */
		public toString():string;
	
		// read / write attributes
	
		/** Reads an unsigned integer value from the specified vertex and attribute. */
		public getUnsignedInt(vertexID:number, attrName:string):number;
	
		/** Writes an unsigned integer value to the specified vertex and attribute. */
		public setUnsignedInt(vertexID:number, attrName:string, value:number):void;
	
		/** Reads a float value from the specified vertex and attribute. */
		public getFloat(vertexID:number, attrName:string):number;
	
		/** Writes a float value to the specified vertex and attribute. */
		public setFloat(vertexID:number, attrName:string, value:number):void;
	
		/** Reads a Point from the specified vertex and attribute. */
		public getPoint(vertexID:number, attrName:string, out?:Point):Point;
	
		/** Writes the given coordinates to the specified vertex and attribute. */
		public setPoint(vertexID:number, attrName:string, x:number, y:number):void;
	
		/** Reads a Vector3D from the specified vertex and attribute.
		 *  The 'w' property of the Vector3D is ignored. */
		public getPoint3D(vertexID:number, attrName:string, out?:Vector3D):Vector3D;
	
		/** Writes the given coordinates to the specified vertex and attribute. */
		public setPoint3D(vertexID:number, attrName:string, x:number, y:number, z:number):void;
	
		/** Reads a Vector3D from the specified vertex and attribute, including the fourth
		 *  coordinate ('w'). */
		public getPoint4D(vertexID:number, attrName:string, out?:Vector3D):Vector3D;
	
		/** Writes the given coordinates to the specified vertex and attribute. */
		public setPoint4D(vertexID:number, attrName:string,
								   x:number, y:number, z:number, w?:number):void;
	
		/** Reads an RGB color from the specified vertex and attribute (no alpha). */
		public getColor(vertexID:number, attrName?:string):number;
	
		/** Writes the RGB color to the specified vertex and attribute (alpha is not changed). */
		public setColor(vertexID:number, attrName:string, color:number):void;
	
		/** Reads the alpha value from the specified vertex and attribute. */
		public getAlpha(vertexID:number, attrName?:string):number;
	
		/** Writes the given alpha value to the specified vertex and attribute (range 0-1). */
		public setAlpha(vertexID:number, attrName:string, alpha:number):void;
	
		// bounds helpers
	
		/** Calculates the bounds of the 2D vertex positions identified by the given name.
		 *  The positions may optionally be transformed by a matrix before calculating the bounds.
		 *  If you pass an 'out' Rectangle, the result will be stored in this rectangle
		 *  instead of creating a new object. To use all vertices for the calculation, set
		 *  'numVertices' to '-1'. */
		public getBounds(attrName?:string, matrix?:Matrix,
								  vertexID?:number, numVertices?:number, out?:Rectangle):Rectangle;
	
		/** Calculates the bounds of the 2D vertex positions identified by the given name,
		 *  projected into the XY-plane of a certain 3D space as they appear from the given
		 *  camera position. Note that 'camPos' is expected in the target coordinate system
		 *  (the same that the XY-plane lies in).
		 *
		 *  <p>If you pass an 'out' Rectangle, the result will be stored in this rectangle
		 *  instead of creating a new object. To use all vertices for the calculation, set
		 *  'numVertices' to '-1'.</p> */
		public getBoundsProjected(attrName:string, matrix:Matrix3D,
										   camPos:Vector3D, vertexID?:number, numVertices?:number,
										   out?:Rectangle):Rectangle;
	
		/** Indicates if color attributes should be stored premultiplied with the alpha value.
		 *  Changing this value does <strong>not</strong> modify any existing color data.
		 *  If you want that, use the <code>setPremultipliedAlpha</code> method instead.
		 *  @default true */
		public premultipliedAlpha:boolean;
		protected get_premultipliedAlpha():boolean;
		protected set_premultipliedAlpha(value:boolean):boolean;
	
		/** Changes the way alpha and color values are stored. Optionally updates all existing
		 *  vertices. */
		public setPremultipliedAlpha(value:boolean, updateData:boolean):void;
	
		/** Updates the <code>tinted</code> property from the actual color data. This might make
		 *  sense after copying part of a tinted VertexData instance to another, since not each
		 *  color value is checked in the process. An instance is tinted if any vertices have a
		 *  non-white color or are not fully opaque. */
		public updateTinted(attrName?:string):boolean;
	
		// modify multiple attributes
	
		/** Transforms the 2D positions of subsequent vertices by multiplication with a
		 *  transformation matrix. */
		public transformPoints(attrName:string, matrix:Matrix,
										vertexID?:number, numVertices?:number):void;
	
		/** Translates the 2D positions of subsequent vertices by a certain offset. */
		public translatePoints(attrName:string, deltaX:number, deltaY:number,
										vertexID?:number, numVertices?:number):void;
	
		/** Multiplies the alpha values of subsequent vertices by a certain factor. */
		public scaleAlphas(attrName:string, factor:number,
									vertexID?:number, numVertices?:number):void;
	
		/** Writes the given RGB and alpha values to the specified vertices. */
		public colorize(attrName?:string, color?:number, alpha?:number,
								 vertexID?:number, numVertices?:number):void;
	
		// format helpers
	
		/** Returns the format of a certain vertex attribute, identified by its name.
		  * Typical values: <code>float1, float2, float3, float4, bytes4</code>. */
		public getFormat(attrName:string):string;
	
		/** Returns the size of a certain vertex attribute in bytes. */
		public getSize(attrName:string):number;
	
		/** Returns the size of a certain vertex attribute in 32 bit units. */
		public getSizeIn32Bits(attrName:string):number;
	
		/** Returns the offset (in bytes) of an attribute within a vertex. */
		public getOffset(attrName:string):number;
	
		/** Returns the offset (in 32 bit units) of an attribute within a vertex. */
		public getOffsetIn32Bits(attrName:string):number;
	
		/** Indicates if the VertexData instances contains an attribute with the specified name. */
		public hasAttribute(attrName:string):boolean;
	
		// VertexBuffer helpers
	
		/** Creates a vertex buffer object with the right size to fit the complete data.
		 *  Optionally, the current data is uploaded right away. */
		public createVertexBuffer(upload?:boolean,
										   bufferUsage?:string):VertexBuffer3D;
	
		/** Uploads the complete data (or a section of it) to the given vertex buffer. */
		public uploadToVertexBuffer(buffer:VertexBuffer3D, vertexID?:number, numVertices?:number):void;
	
		// properties
	
		/** The total number of vertices. If you make the object bigger, it will be filled up with
		 *  <code>1.0</code> for all alpha values and zero for everything else. */
		public numVertices:number;
		protected get_numVertices():number;
		protected set_numVertices(value:number):number;
	
		/** The raw vertex data; not a copy! */
		public readonly rawData:ByteArray;
		protected get_rawData():ByteArray;
	
		/** The format that describes the attributes of each vertex.
		 *  When you assign a different format, the raw data will be converted accordingly,
		 *  i.e. attributes with the same name will still point to the same data.
		 *  New properties will be filled up with zeros (except for colors, which will be
		 *  initialized with an alpha value of 1.0). As a side-effect, the instance will also
		 *  be trimmed. */
		public format:VertexDataFormat;
		protected get_format():VertexDataFormat;
		protected set_format(value:VertexDataFormat):VertexDataFormat;
	
		/** Indicates if the mesh contains any vertices that are not white or not fully opaque.
		 *  If <code>false</code> (and the value wasn't modified manually), the result is 100%
		 *  accurate; <code>true</code> represents just an educated guess. To be entirely sure,
		 *  you may call <code>updateTinted()</code>.
		 */
		public tinted:boolean;
		protected get_tinted():boolean;
		protected set_tinted(value:boolean):boolean;
	
		/** The format string that describes the attributes of each vertex. */
		public readonly formatString:string;
		protected get_formatString():string;
	
		/** The size (in bytes) of each vertex. */
		public readonly vertexSize:number;
		protected get_vertexSize():number;
	
		/** The size (in 32 bit units) of each vertex. */
		public readonly vertexSizeIn32Bits:number;
		protected get_vertexSizeIn32Bits():number;
	
		/** The size (in bytes) of the raw vertex data. */
		public readonly size:number;
		protected get_size():number;
	
		/** The size (in 32 bit units) of the raw vertex data. */
		public readonly sizeIn32Bits:number;
		protected get_sizeIn32Bits():number;
	}
}

export default starling.rendering.VertexData;
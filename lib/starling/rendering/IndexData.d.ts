

import EOFError from "openfl/errors/EOFError";
import Vector from "openfl/Vector";
import StringUtil from "./../../starling/utils/StringUtil";
import ByteArray from "openfl/utils/ByteArray";
import Starling from "./../../starling/core/Starling";
import MissingContextError from "./../../starling/errors/MissingContextError";
import IndexBuffer3D from "openfl/display3D/IndexBuffer3D";

declare namespace starling.rendering
{
	/** The IndexData class manages a raw list of vertex indices, allowing direct upload
	 *  to Stage3D index buffers. <em>You only have to work with this class if you're writing
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
	 *  a simple way to do just that. The data is stored in a ByteArray (one index or vertex after
	 *  the other) that can easily be uploaded to a buffer.</p>
	 *
	 *  <strong>Basic Quad Layout</strong>
	 *
	 *  <p>In many cases, the indices we are working with will reference just quads, i.e.
	 *  triangles composing rectangles. That means that many IndexData instances will contain
	 *  similar or identical data — a great opportunity for optimization!</p>
	 *
	 *  <p>If an IndexData instance follows a specific layout, it will be recognized
	 *  automatically and many operations can be executed much faster. In Starling, that
	 *  layout is called "basic quad layout". In order to recognize this specific sequence,
	 *  the indices of each quad have to use the following order:</p>
	 *
	 *  <pre>n, n+1, n+2, n+1, n+3, n+2</pre>
	 *
	 *  <p>The subsequent quad has to use <code>n+4</code> as starting value, the next one
	 *  <code>n+8</code>, etc. Here is an example with 3 quads / 6 triangles:</p>
	 *
	 *  <pre>0, 1, 2, 1, 3, 2,   4, 5, 6, 5, 7, 6,   8, 9, 10, 9, 11, 10</pre>
	 *
	 *  <p>If you are describing quad-like meshes, make sure to always use this layout.</p>
	 *
	 *  @see VertexData
	 */
	export class IndexData
	{
		/** Creates an empty IndexData instance with the given capacity (in indices).
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
		 *  usage of your IndexData instances.</p>
		 */
		public constructor(initialCapacity?:number);
	
		/** Explicitly frees up the memory used by the ByteArray, thus removing all indices.
		 *  Quad layout will be restored (until adding data violating that layout). */
		public clear():void;
	
		/** Creates a duplicate of the IndexData object. */
		public clone():IndexData;
	
		/** Copies the index data (or a range of it, defined by 'indexID' and 'numIndices')
		 *  of this instance to another IndexData object, starting at a certain target index.
		 *  If the target is not big enough, it will grow to fit all the new indices.
		 *
		 *  <p>By passing a non-zero <code>offset</code>, you can raise all copied indices
		 *  by that value in the target object.</p>
		 */
		public copyTo(target:IndexData, targetIndexID?:number, offset?:number,
							   indexID?:number, numIndices?:number):void;
	
		/** Sets an index at the specified position. */
		public setIndex(indexID:number, index:number):void;
	
		/** Reads the index from the specified position. */
		public getIndex(indexID:number):number;
	
		/** Adds an offset to all indices in the specified range. */
		public offsetIndices(offset:number, indexID?:number, numIndices?:number):void;
	
		/** Appends three indices representing a triangle. Reference the vertices clockwise,
		 *  as this defines the front side of the triangle. */
		public addTriangle(a:number, b:number, c:number):void;
	
		/** Appends two triangles spawning up the quad with the given indices.
		 *  The indices of the vertices are arranged like this:
		 *
		 *  <pre>
		 *  a - b
		 *  | / |
		 *  c - d
		 *  </pre>
		 *
		 *  <p>To make sure the indices will follow the basic quad layout, make sure each
		 *  parameter increments the one before it (e.g. <code>0, 1, 2, 3</code>).</p>
		 */
		public addQuad(a:number, b:number, c:number, d:number):void;
	
		/** Creates a vector containing all indices. If you pass an existing vector to the method,
		 *  its contents will be overwritten. */
		public toVector(out?:Vector<number>):Vector<number>;
	
		/** Returns a string representation of the IndexData object,
		 *  including a comma-separated list of all indices. */
		public toString():string;
	
		// IndexBuffer helpers
	
		/** Creates an index buffer object with the right size to fit the complete data.
		 *  Optionally, the current data is uploaded right away. */
		public createIndexBuffer(upload?:boolean,
										  bufferUsage?:string):IndexBuffer3D;
	
		/** Uploads the complete data (or a section of it) to the given index buffer. */
		public uploadToIndexBuffer(buffer:IndexBuffer3D, indexID?:number, numIndices?:number):void;
	
		/** Optimizes the ByteArray so that it has exactly the required capacity, without
		 *  wasting any memory. If your IndexData object grows larger than the initial capacity
		 *  you passed to the constructor, call this method to avoid the 4k memory problem. */
		public trim():void;
	
		// properties
	
		/** The total number of indices.
		 *
		 *  <p>If this instance contains only standardized, basic quad indices, resizing
		 *  will automatically fill up with appropriate quad indices. Otherwise, it will fill
		 *  up with zeroes.</p>
		 *
		 *  <p>If you set the number of indices to zero, quad layout will be restored.</p> */
		public numIndices:number;
		protected get_numIndices():number;
		protected set_numIndices(value:number):number;
	
		/** The number of triangles that can be spawned up with the contained indices.
		 *  (In other words: the number of indices divided by three.) */
		public numTriangles:number;
		protected get_numTriangles():number;
		protected set_numTriangles(value:number):number;
	
		/** The number of quads that can be spawned up with the contained indices.
		 *  (In other words: the number of triangles divided by two.) */
		public numQuads:number;
		protected get_numQuads():number;
		protected set_numQuads(value:number):number;
	
		/** The number of bytes required for each index value. */
		public readonly indexSizeInBytes:number;
		protected get_indexSizeInBytes():number;
	
		/** Indicates if all indices are following the basic quad layout.
		 *
		 *  <p>This property is automatically updated if an index is set to a value that violates
		 *  basic quad layout. Once the layout was violated, the instance will always stay that
		 *  way, even if you fix that violating value later. Only calling <code>clear</code> or
		 *  manually enabling the property will restore quad layout.</p>
		 *
		 *  <p>If you enable this property on an instance, all indices will immediately be
		 *  replaced with indices following standard quad layout.</p>
		 *
		 *  <p>Please look at the class documentation for more information about that kind
		 *  of layout, and why it is important.</p>
		 *
		 *  @default true
		 */
		public useQuadLayout:boolean;
		protected get_useQuadLayout():boolean;
		protected set_useQuadLayout(value:boolean):boolean;
	
		/** The raw index data; not a copy! Beware: the referenced ByteArray may change any time.
		 *  Never store a reference to it, and never modify its contents manually. */
		public readonly rawData:ByteArray;
		protected get_rawData():ByteArray;
	}
}

export default starling.rendering.IndexData;
import Point from "openfl/geom/Point";
import Rectangle from "openfl/geom/Rectangle";
import Polygon from "./../geom/Polygon";
import IndexData from "./../rendering/IndexData";
import Painter from "./../rendering/Painter";
import VertexData from "./../rendering/VertexData";
import MeshStyle from "./../styles/MeshStyle";
import DisplayObject from "./DisplayObject";
import Texture from "./../textures/Texture";
import VertexDataFormat from "./../rendering/VertexDataFormat";

declare namespace starling.display
{
	/** The base class for all tangible (non-container) display objects, spawned up by a number
	 *  of triangles.
	 *
	 *  <p>Since Starling uses Stage3D for rendering, all rendered objects must be constructed
	 *  from triangles. A mesh stores the information of its triangles through VertexData and
	 *  IndexData structures. The default format stores position, color and texture coordinates
	 *  for each vertex.</p>
	 *
	 *  <p>How a mesh is rendered depends on its style. Per default, this is an instance
	 *  of the <code>MeshStyle</code> base class; however, subclasses may extend its behavior
	 *  to add support for color transformations, normal mapping, etc.</p>
	 *
	 *  @see MeshBatch
	 *  @see starling.styles.MeshStyle
	 *  @see starling.rendering.VertexData
	 *  @see starling.rendering.IndexData
	 */
	export class Mesh extends DisplayObject
	{
		/** Creates a new mesh with the given vertices and indices.
		 *  If you don't pass a style, an instance of <code>MeshStyle</code> will be created
		 *  for you. Note that the format of the vertex data will be matched to the
		 *  given style right away. */
		public constructor(vertexData:VertexData, indexData:IndexData, style?:MeshStyle);
	
		/** @inheritDoc */
		/*override*/ public dispose():void;
	
		/** @inheritDoc */
		/*override*/ public hitTest(localPoint:Point):DisplayObject;
	
		/** @inheritDoc */
		/*override*/ public getBounds(targetSpace:DisplayObject, out?:Rectangle):Rectangle;
	
		/** @inheritDoc */
		/*override*/ public render(painter:Painter):void;
	
		/** Sets the style that is used to render the mesh. Styles (which are always subclasses of
		 *  <code>MeshStyle</code>) provide a means to completely modify the way a mesh is rendered.
		 *  For example, they may add support for color transformations or normal mapping.
		 *
		 *  <p>When assigning a new style, the vertex format will be changed to fit it.
		 *  Do not use the same style instance on multiple objects! Instead, make use of
		 *  <code>style.clone()</code> to assign an identical style to multiple meshes.</p>
		 *
		 *  @param meshStyle             the style to assign. If <code>null</code>, the default
		 *                               style will be created.
		 *  @param mergeWithPredecessor  if enabled, all attributes of the previous style will be
		 *                               be copied to the new one, if possible.
		 *  @see #defaultStyle
		 *  @see #defaultStyleFactory
		 */
		public setStyle(meshStyle?:MeshStyle, mergeWithPredecessor?:boolean):void;
	
		/** This method is called whenever the mesh's vertex data was changed.
		 *  The base implementation simply forwards to <code>setRequiresRedraw</code>. */
		public setVertexDataChanged():void;
	
		/** This method is called whenever the mesh's index data was changed.
		 *  The base implementation simply forwards to <code>setRequiresRedraw</code>. */
		public setIndexDataChanged():void;
	
		// vertex manipulation
	
		/** The position of the vertex at the specified index, in the mesh's local coordinate
		 *  system.
		 *
		 *  <p>Only modify the position of a vertex if you know exactly what you're doing, as
		 *  some classes might not work correctly when their vertices are moved. E.g. the
		 *  <code>Quad</code> class expects its vertices to spawn up a perfectly rectangular
		 *  area; some of its optimized methods won't work correctly if that premise is no longer
		 *  fulfilled or the original bounds change.</p>
		 */
		public getVertexPosition(vertexID:number, out?:Point):Point;
	
		public setVertexPosition(vertexID:number, x:number, y:number):void;
	
		/** Returns the alpha value of the vertex at the specified index. */
		public getVertexAlpha(vertexID:number):number;
	
		/** Sets the alpha value of the vertex at the specified index to a certain value. */
		public setVertexAlpha(vertexID:number, alpha:number):void;
	
		/** Returns the RGB color of the vertex at the specified index. */
		public getVertexColor(vertexID:number):number;
	
		/** Sets the RGB color of the vertex at the specified index to a certain value. */
		public setVertexColor(vertexID:number, color:number):void;
	
		/** Returns the texture coordinates of the vertex at the specified index. */
		public getTexCoords(vertexID:number, out?:Point):Point;
	
		/** Sets the texture coordinates of the vertex at the specified index to the given values. */
		public setTexCoords(vertexID:number, u:number, v:number):void;
	
		// properties
	
		/** The vertex data describing all vertices of the mesh.
		 *  Any change requires a call to <code>setRequiresRedraw</code>. */
		protected readonly vertexData:VertexData;
		protected get_vertexData():VertexData;
	
		/** The index data describing how the vertices are interconnected.
		 *  Any change requires a call to <code>setRequiresRedraw</code>. */
		protected readonly indexData:IndexData;
		protected get_indexData():IndexData;
	
		/** The style that is used to render the mesh. Styles (which are always subclasses of
		 *  <code>MeshStyle</code>) provide a means to completely modify the way a mesh is rendered.
		 *  For example, they may add support for color transformations or normal mapping.
		 *  Beware: a style instance may only be used on one mesh at a time.
		 *
		 *  @default MeshStyle
		 *  @see #setStyle()
		 */
		public style:MeshStyle;
		protected get_style():MeshStyle;
		protected set_style(value:MeshStyle):MeshStyle;
	
		/** The texture that is mapped to the mesh (or <code>null</code>, if there is none). */
		public texture:Texture;
		protected get_texture():Texture;
		protected set_texture(value:Texture):Texture;
	
		/** Changes the color of all vertices to the same value.
		 *  The getter simply returns the color of the first vertex. */
		public color:number;
		protected get_color():number;
		protected set_color(value:number):number;
	
		/** The smoothing filter that is used for the texture.
		 *  @default bilinear */
		public textureSmoothing:string;
		protected get_textureSmoothing():string;
		protected set_textureSmoothing(value:string):string;
	
		/** Indicates if pixels at the edges will be repeated or clamped. Only works for
		 *  power-of-two textures; for a solution that works with all kinds of textures,
		 *  see <code>Image.tileGrid</code>. @default false */
		public textureRepeat:boolean;
		protected get_textureRepeat():boolean;
		protected set_textureRepeat(value:boolean):boolean;
	
		/** Controls whether or not the instance snaps to the nearest pixel. This can prevent the
		 *  object from looking blurry when it's not exactly aligned with the pixels of the screen.
		 *  @default false */
		public pixelSnapping:boolean;
		protected get_pixelSnapping():boolean;
		protected set_pixelSnapping(value:boolean):boolean;
	
		/** The total number of vertices in the mesh. */
		public readonly numVertices:number;
		protected get_numVertices():number;
	
		/** The total number of indices referencing vertices. */
		public readonly numIndices:number;
		protected get_numIndices():number;
	
		/** The total number of triangles in this mesh.
		 *  (In other words: the number of indices divided by three.) */
		public readonly numTriangles:number;
		protected get_numTriangles():number;
	
		/** The format used to store the vertices. */
		public readonly vertexFormat:VertexDataFormat;
		protected get_vertexFormat():VertexDataFormat;
	
		// static properties
	
		/** The default style used for meshes if no specific style is provided. The default is
		 *  <code>starling.rendering.MeshStyle</code>, and any assigned class must be a subclass
		 *  of the same. */
		public static defaultStyle:any;
		protected static get_defaultStyle():any;
		protected static set_defaultStyle(value:any):any;
	
		/** A factory method that is used to create the 'MeshStyle' for a mesh if no specific
		 *  style is provided. That's useful if you are creating a hierarchy of objects, all
		 *  of which need to have a certain style. Different to the <code>defaultStyle</code>
		 *  property, this method allows plugging in custom logic and passing arguments to the
		 *  constructor. Return <code>null</code> to fall back to the default behavior (i.e.
		 *  to instantiate <code>defaultStyle</code>). The <code>mesh</code>-parameter is optional
		 *  and may be omitted.
		 *
		 *  <listing>
		 *  Mesh.defaultStyleFactory = function(mesh:Mesh):MeshStyle
		 *  {
		 *      return new ColorizeMeshStyle(Math.random() * 0xffffff);
		 *  }</listing>
		 */
		public static defaultStyleFactory:(mesh:Mesh)=>MeshStyle;
		protected static get_defaultStyleFactory():(mesh:Mesh)=>MeshStyle;
		protected static set_defaultStyleFactory(value:(mesh:Mesh)=>MeshStyle):(mesh:Mesh)=>MeshStyle;
	
		// static methods
	
		/** Creates a mesh from the specified polygon.
		 *  Vertex positions and indices will be set up according to the polygon;
		 *  any other vertex attributes (e.g. texture coordinates) need to be set up manually.
		 */
		public static fromPolygon(polygon:Polygon, style?:MeshStyle):Mesh;
	}
}

export default starling.display.Mesh;
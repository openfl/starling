import EventDispatcher from "./../../starling/events/EventDispatcher";
import MeshEffect from "./../../starling/rendering/MeshEffect";
import Point from "openfl/geom/Point";
import VertexDataFormat from "./../rendering/VertexDataFormat";
import IndexData from "./../rendering/IndexData";
import VertexData from "./../rendering/VertexData";
import RenderState from "./../rendering/RenderState";
import Matrix from "openfl/geom/Matrix";
import Texture from "./../textures/Texture";
import Mesh from "./../display/Mesh";

declare namespace starling.styles
{
	/** Dispatched every frame on styles assigned to display objects connected to the stage. */
	// @:meta(Event(name="enterFrame", type="starling.events.EnterFrameEvent"))
	
	/** MeshStyles provide a means to completely modify the way a mesh is rendered.
	 *  The base class provides Starling's standard mesh rendering functionality: colored and
	 *  (optionally) textured meshes. Subclasses may add support for additional features like
	 *  color transformations, normal mapping, etc.
	 *
	 *  <p><strong>Using styles</strong></p>
	 *
	 *  <p>First, create an instance of the desired style. Configure the style by updating its
	 *  properties, then assign it to the mesh. Here is an example that uses a fictitious
	 *  <code>ColorStyle</code>:</p>
	 *
	 *  <listing>
	 *  image:Image = new Image(heroTexture);
	 *  colorStyle:ColorStyle = new ColorStyle();
	 *  colorStyle.redOffset = 0.5;
	 *  colorStyle.redMultiplier = 2.0;
	 *  image.style = colorStyle;</listing>
	 *
	 *  <p>Beware:</p>
	 *
	 *  <ul>
	 *    <li>A style instance may only be used on one object at a time.</li>
	 *    <li>A style might require the use of a specific vertex format;
	 *        when the style is assigned, the mesh is converted to that format.</li>
	 *  </ul>
	 *
	 *  <p><strong>Creating your own styles</strong></p>
	 *
	 *  <p>To create custom rendering code in Starling, you need to extend two classes:
	 *  <code>MeshStyle</code> and <code>MeshEffect</code>. While the effect class contains
	 *  the actual AGAL rendering code, the style provides the API that other developers will
	 *  interact with.</p>
	 *
	 *  <p>Subclasses of <code>MeshStyle</code> will add specific properties that configure the
	 *  style's outcome, like the <code>redOffset</code> and <code>redMultiplier</code> properties
	 *  in the sample above. Here's how to properly create such a class:</p>
	 *
	 *  <ul>
	 *    <li>Always provide a constructor that can be called without any arguments.</li>
	 *    <li>Override <code>copyFrom</code> — that's necessary for batching.</li>
	 *    <li>Override <code>createEffect</code> — this method must return the
	 *        <code>MeshEffect</code> that will do the actual Stage3D rendering.</li>
	 *    <li>Override <code>updateEffect</code> — this configures the effect created above
	 *        right before rendering.</li>
	 *    <li>Override <code>canBatchWith</code> if necessary — this method figures out if one
	 *        instance of the style can be batched with another. If they all can, you can leave
	 *        this out.</li>
	 *  </ul>
	 *
	 *  <p>If the style requires a custom vertex format, you must also:</p>
	 *
	 *  <ul>
	 *    <li>add a static constant called <code>VERTEX_FORMAT</code> to the class and</li>
	 *    <li>override <code>get vertexFormat</code> and let it return exactly that format.</li>
	 *  </ul>
	 *
	 *  <p>When that's done, you can turn to the implementation of your <code>MeshEffect</code>;
	 *  the <code>createEffect</code>-override will return an instance of this class.
	 *  Directly before rendering begins, Starling will then call <code>updateEffect</code>
	 *  to set it up.</p>
	 *
	 *  @see starling.rendering.MeshEffect
	 *  @see starling.rendering.VertexDataFormat
	 *  @see starling.display.Mesh
	 */
	export class MeshStyle extends EventDispatcher
	{
		/** The vertex format expected by this style (the same as found in the MeshEffect-class). */
		public static VERTEX_FORMAT:VertexDataFormat;
	
		/** Creates a new MeshStyle instance.
		 *  Subclasses must provide a constructor that can be called without any arguments. */
		public constructor();
		
		/** Copies all properties of the given style to the current instance (or a subset, if the
		 *  classes don't match). Must be overridden by all subclasses!
		 */
		public copyFrom(meshStyle:MeshStyle):void;
	
		/** Creates a clone of this instance. The method will work for subclasses automatically,
		 *  no need to override it. */
		public clone():MeshStyle;
	
		/** Creates the effect that does the actual, low-level rendering.
		 *  To be overridden by subclasses!
		 */
		public createEffect():MeshEffect;
	
		/** Updates the settings of the given effect to match the current style.
		 *  The given <code>effect</code> will always match the class returned by
		 *  <code>createEffect</code>.
		 *
		 *  <p>To be overridden by subclasses!</p>
		 */
		public updateEffect(effect:MeshEffect, state:RenderState):void;
	
		/** Indicates if the current instance can be batched with the given style.
		 *  To be overridden by subclasses if default behavior is not sufficient.
		 *  The base implementation just checks if the styles are of the same type
		 *  and if the textures are compatible.
		 */
		public canBatchWith(meshStyle:MeshStyle):boolean;
	
		/** Copies the vertex data of the style's current target to the target of another style.
		 *  If you pass a matrix, all vertices will be transformed during the process.
		 *
		 *  <p>This method is used when batching meshes together for rendering. The parameter
		 *  <code>targetStyle</code> will point to the style of a <code>MeshBatch</code> (a
		 *  subclass of <code>Mesh</code>). Subclasses may override this method if they need
		 *  to modify the vertex data in that process.</p>
		 */
		public batchVertexData(targetStyle:MeshStyle, targetVertexID?:number,
										matrix?:Matrix, vertexID?:number, numVertices?:number):void;
	
		/** Copies the index data of the style's current target to the target of another style.
		 *  The given offset value will be added to all indices during the process.
		 *
		 *  <p>This method is used when batching meshes together for rendering. The parameter
		 *  <code>targetStyle</code> will point to the style of a <code>MeshBatch</code> (a
		 *  subclass of <code>Mesh</code>). Subclasses may override this method if they need
		 *  to modify the index data in that process.</p>
		 */
		public batchIndexData(targetStyle:MeshStyle, targetIndexID?:number, offset?:number,
									   indexID?:number, numIndices?:number):void;
	
		// enter frame event
	
		/*override*/ public addEventListener(type:string, listener:Function):void;
	
		/*override*/ public removeEventListener(type:string, listener:Function):void;
	
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
	
		/** Returns a reference to the vertex data of the assigned target (or <code>null</code>
		 *  if there is no target). Beware: the style itself does not own any vertices;
		 *  it is limited to manipulating those of the target mesh. */
		public readonly vertexData:VertexData;
		protected get_vertexData():VertexData;
	
		/** Returns a reference to the index data of the assigned target (or <code>null</code>
		 *  if there is no target). Beware: the style itself does not own any indices;
		 *  it is limited to manipulating those of the target mesh. */
		public readonly indexData:IndexData;
		protected get_indexData():IndexData;
	
		/** The actual class of this style. */
		public readonly type:any;
		protected get_type():any;
	
		/** Changes the color of all vertices to the same value.
		 *  The getter simply returns the color of the first vertex. */
		public color:number;
		protected get_color():number;
		protected set_color(value:number):number;
	
		/** The format used to store the vertices. */
		public readonly vertexFormat:VertexDataFormat;
		protected get_vertexFormat():VertexDataFormat;
	
		/** The texture that is mapped to the mesh (or <code>null</code>, if there is none). */
		public texture:Texture;
		protected get_texture():Texture;
		protected set_texture(value:Texture):Texture;
	
		/** The smoothing filter that is used for the texture. @default bilinear */
		public textureSmoothing:string;
		protected get_textureSmoothing():string;
		protected set_textureSmoothing(value:string):string;
	
		/** Indicates if pixels at the edges will be repeated or clamped.
		 *  Only works for power-of-two textures. @default false */
		public textureRepeat:boolean;
		protected get_textureRepeat():boolean;
		protected set_textureRepeat(value:boolean):boolean;
	
		/** The target the style is currently assigned to. */
		public readonly target:Mesh;
		protected get_target():Mesh;
	}
}

export default starling.styles.MeshStyle;
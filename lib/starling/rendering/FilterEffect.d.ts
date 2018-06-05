import Effect from "./../../starling/rendering/Effect";
import RenderUtil from "./../../starling/utils/RenderUtil";
import Program from "./../../starling/rendering/Program";

declare namespace starling.rendering
{
	/** An effect drawing a mesh of textured vertices.
	 *  This is the standard effect that is the base for all fragment filters;
	 *  if you want to create your own fragment filters, you will have to extend this class.
	 *
	 *  <p>For more information about the usage and creation of effects, please have a look at
	 *  the documentation of the parent class, "Effect".</p>
	 *
	 *  @see Effect
	 *  @see MeshEffect
	 *  @see starling.filters.FragmentFilter
	 */
	export class FilterEffect extends Effect
	{
		/** The vertex format expected by <code>uploadVertexData</code>:
		 *  <code>"position:number2, texCoords:number2"</code> */
		public static VERTEX_FORMAT:VertexDataFormat;
	
		/** The AGAL code for the standard vertex shader that most filters will use.
		 *  It simply transforms the vertex coordinates to clip-space and passes the texture
		 *  coordinates to the fragment program (as 'v0'). */
		public static STD_VERTEX_SHADER:string;
	
		/** Creates a new FilterEffect instance. */
		public constructor();
	
		/** The texture to be mapped onto the vertices. */
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
	}
}

export default starling.rendering.FilterEffect;
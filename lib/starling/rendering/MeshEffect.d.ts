import FilterEffect from "./../../starling/rendering/FilterEffect";
import Program from "./../../starling/rendering/Program";
import Vector from "openfl/Vector";
import VertexDataFormat from "./VertexDataFormat";

declare namespace starling.rendering
{
	/** An effect drawing a mesh of textured, colored vertices.
	 *  This is the standard effect that is the base for all mesh styles;
	 *  if you want to create your own mesh styles, you will have to extend this class.
	 *
	 *  <p>For more information about the usage and creation of effects, please have a look at
	 *  the documentation of the root class, "Effect".</p>
	 *
	 *  @see Effect
	 *  @see FilterEffect
	 *  @see starling.styles.MeshStyle
	 */
	export class MeshEffect extends FilterEffect
	{
		/** The vertex format expected by <code>uploadVertexData</code>:
		 *  <code>"position:number2, texCoords:number2, color:bytes4"</code> */
		public static VERTEX_FORMAT:VertexDataFormat;
	
		/** Creates a new MeshEffect instance. */
		public constructor();
	
		/** The alpha value of the object rendered by the effect. Must be taken into account
		 *  by all subclasses. */
		public alpha:number;
		protected get_alpha():number;
		protected set_alpha(value:number):number;
	
		/** Indicates if the rendered vertices are tinted in any way, i.e. if there are vertices
		 *  that have a different color than fully opaque white. The base <code>MeshEffect</code>
		 *  class uses this information to simplify the fragment shader if possible. May be
		 *  ignored by subclasses. */
		public tinted:boolean;
		protected get_tinted():boolean;
		protected set_tinted(value:boolean):boolean;
	}
}

export default starling.rendering.MeshEffect;
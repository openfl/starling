import Mesh from "./../../starling/display/Mesh";
import Rectangle from "openfl/geom/Rectangle";
import RectangleUtil from "./../../starling/utils/RectangleUtil";
import Vector3D from "openfl/geom/Vector3D";
import Matrix from "openfl/geom/Matrix";
import Point from "openfl/geom/Point";
import Matrix3D from "openfl/geom/Matrix3D";
import VertexData from "./../../starling/rendering/VertexData";
import MeshStyle from "./../../starling/styles/MeshStyle";
import IndexData from "./../../starling/rendering/IndexData";
import ArgumentError from "openfl/errors/ArgumentError";
import DisplayObject from "./DisplayObject";
import Texture from "./../textures/Texture";

declare namespace starling.display
{
	/** A Quad represents a colored and/or textured rectangle.
	 *
	 *  <p>Quads may have a color and a texture. When assigning a texture, the colors of the
	 *  vertices will "tint" the texture, i.e. the vertex color will be multiplied with the color
	 *  of the texture at the same position. That's why the default color of a quad is pure white:
	 *  tinting with white does not change the texture color (that's a multiplication with one).</p>
	 *
	 *  <p>A quad is, by definition, always rectangular. The basic quad class will always contain
	 *  exactly four vertices, arranged like this:</p>
	 *
	 *  <pre>
	 *  0 - 1
	 *  | / |
	 *  2 - 3
	 *  </pre>
	 *
	 *  <p>You can set the color of each vertex individually; and since the colors will smoothly
	 *  fade into each other over the area of the quad, you can use this to create simple linear
	 *  color gradients (e.g. by assigning one color to vertices 0 and 1 and another to vertices
	 *  2 and 3).</p>
	 *
	 *  <p>However, note that the number of vertices may be different in subclasses.
	 *  Check the property <code>numVertices</code> if you are unsure.</p>
	 *
	 *  @see starling.textures.Texture
	 *  @see Image
	 */
	export class Quad extends Mesh
	{
		/** Creates a quad with a certain size and color. */
		public constructor(width:number, height:number, color?:number);
	
		/** @inheritDoc */
		public /*override*/ getBounds(targetSpace:DisplayObject, out?:Rectangle):Rectangle;
	
		/** @inheritDoc */
		/*override*/ public hitTest(localPoint:Point):DisplayObject;
	
		/** Readjusts the dimensions of the quad. Use this method without any arguments to
		 *  synchronize quad and texture size after assigning a texture with a different size.
		 *  You can also force a certain width and height by passing positive, non-zero
		 *  values for width and height. */
		public readjustSize(width?:number, height?:number):void;
	
		/** Creates a quad from the given texture.
		 *  The quad will have the same size as the texture. */
		public static fromTexture(texture:Texture):Quad;
	
		/** The texture that is mapped to the quad (or <code>null</code>, if there is none).
		 *  Per default, it is mapped to the complete quad, i.e. to the complete area between the
		 *  top left and bottom right vertices. This can be changed with the
		 *  <code>setTexCoords</code>-method.
		 *
		 *  <p>Note that the size of the quad will not change when you assign a texture, which
		 *  means that the texture might be distorted at first. Call <code>readjustSize</code> to
		 *  synchronize quad and texture size.</p>
		 *
		 *  <p>You could also set the texture via the <code>style.texture</code> property.
		 *  That way, however, the texture frame won't be taken into account. Since only rectangular
		 *  objects can make use of a texture frame, only a property on the Quad class can do that.
		 *  </p>
		 */
		/*override*/ protected set_texture(value:Texture):Texture;
	}
}

export default starling.display.Quad;
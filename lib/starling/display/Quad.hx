// =================================================================================================
//
//	Starling Framework
//	Copyright Gamua GmbH. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

package starling.display;

import openfl.errors.ArgumentError;
import openfl.geom.Matrix;
import openfl.geom.Matrix3D;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.geom.Vector3D;

import starling.rendering.IndexData;
import starling.rendering.VertexData;
import starling.styles.MeshStyle;
import starling.textures.Texture;
import starling.utils.RectangleUtil;

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

@:jsRequire("starling/display/Quad", "default")

extern class Quad extends Mesh
{
    /** Creates a quad with a certain size and color. */
    public function new(width:Float, height:Float, color:UInt=0xffffff);

    /** @inheritDoc */
    public override function getBounds(targetSpace:DisplayObject, out:Rectangle=null):Rectangle;

    /** @inheritDoc */
    override public function hitTest(localPoint:Point):DisplayObject;

    /** Readjusts the dimensions of the quad. Use this method without any arguments to
     *  synchronize quad and texture size after assigning a texture with a different size.
     *  You can also force a certain width and height by passing positive, non-zero
     *  values for width and height. */
    public function readjustSize(width:Float=-1, height:Float=-1):Void;

    /** Creates a quad from the given texture.
     *  The quad will have the same size as the texture. */
    public static function fromTexture(texture:Texture):Quad;

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
    override private function set_texture(value:Texture):Texture;
}
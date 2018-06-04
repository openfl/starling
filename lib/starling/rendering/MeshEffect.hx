// =================================================================================================
//
//	Starling Framework
//	Copyright Gamua GmbH. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

package starling.rendering;

import openfl.display3D.Context3D;
import openfl.display3D.Context3DProgramType;
//import openfl.utils.getQualifiedClassName;
import openfl.Vector;

import starling.utils.RenderUtil;

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

@:jsRequire("starling/rendering/MeshEffect", "default")

extern class MeshEffect extends FilterEffect
{
    /** The vertex format expected by <code>uploadVertexData</code>:
     *  <code>"position:float2, texCoords:float2, color:bytes4"</code> */
    public static var VERTEX_FORMAT:VertexDataFormat;

    /** Creates a new MeshEffect instance. */
    public function new();

    /** The alpha value of the object rendered by the effect. Must be taken into account
     *  by all subclasses. */
    public var alpha(get, set):Float;
    private function get_alpha():Float;
    private function set_alpha(value:Float):Float;

    /** Indicates if the rendered vertices are tinted in any way, i.e. if there are vertices
     *  that have a different color than fully opaque white. The base <code>MeshEffect</code>
     *  class uses this information to simplify the fragment shader if possible. May be
     *  ignored by subclasses. */
    public var tinted(get, set):Bool;
    private function get_tinted():Bool;
    private function set_tinted(value:Bool):Bool;
}
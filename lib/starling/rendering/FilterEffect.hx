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

import starling.textures.Texture;
import starling.textures.TextureSmoothing;
import starling.utils.RenderUtil;

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

@:jsRequire("starling/rendering/FilterEffect", "default")

extern class FilterEffect extends Effect
{
    /** The vertex format expected by <code>uploadVertexData</code>:
     *  <code>"position:float2, texCoords:float2"</code> */
    public static var VERTEX_FORMAT:VertexDataFormat;

    /** The AGAL code for the standard vertex shader that most filters will use.
     *  It simply transforms the vertex coordinates to clip-space and passes the texture
     *  coordinates to the fragment program (as 'v0'). */
    public static var STD_VERTEX_SHADER:String;

    /** Creates a new FilterEffect instance. */
    public function new();

    /** The texture to be mapped onto the vertices. */
    public var texture(get, set):Texture;
    private function get_texture():Texture;
    private function set_texture(value:Texture):Texture;

    /** The smoothing filter that is used for the texture. @default bilinear */
    public var textureSmoothing(get, set):String;
    private function get_textureSmoothing():String;
    private function set_textureSmoothing(value:String):String;

    /** Indicates if pixels at the edges will be repeated or clamped.
     *  Only works for power-of-two textures. @default false */
    public var textureRepeat(get, set):Bool;
    private function get_textureRepeat():Bool;
    private function set_textureRepeat(value:Bool):Bool;
}
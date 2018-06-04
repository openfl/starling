// =================================================================================================
//
//	Starling Framework
//	Copyright Gamua GmbH. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

package starling.textures;

import openfl.display3D.textures.TextureBase;
import openfl.display3D.Context3DTextureFormat;
import openfl.geom.Matrix;
import openfl.geom.Rectangle;
import openfl.system.Capabilities;

/** A SubTexture represents a section of another texture. This is achieved solely by
 *  manipulation of texture coordinates, making the class very efficient. 
 *
 *  <p><em>Note that it is OK to create subtextures of subtextures.</em></p>
 */

@:jsRequire("starling/textures/SubTexture", "default")

extern class SubTexture extends Texture
{
    /** Creates a new SubTexture containing the specified region of a parent texture.
     *
     *  @param parent     The texture you want to create a SubTexture from.
     *  @param region     The region of the parent texture that the SubTexture will show
     *                    (in points). If <code>null</code>, the complete area of the parent.
     *  @param ownsParent If <code>true</code>, the parent texture will be disposed
     *                    automatically when the SubTexture is disposed.
     *  @param frame      If the texture was trimmed, the frame rectangle can be used to restore
     *                    the trimmed area.
     *  @param rotated    If true, the SubTexture will show the parent region rotated by
     *                    90 degrees (CCW).
     *  @param scaleModifier  The scale factor of the SubTexture will be calculated by
     *                    multiplying the parent texture's scale factor with this value.
     */
    public function new(parent:Texture, region:Rectangle=null,
                        ownsParent:Bool=false, frame:Rectangle=null,
                        rotated:Bool=false, scaleModifier:Float=1);

    /** Disposes the parent texture if this texture owns it. */
    public override function dispose():Void;

    /** The texture which the SubTexture is based on. */
    public var parent(get, never):Texture;
    private function get_parent():Texture;
    
    /** Indicates if the parent texture is disposed when this object is disposed. */
    public var ownsParent(get, never):Bool;
    private function get_ownsParent():Bool;
    
    /** If true, the SubTexture will show the parent region rotated by 90 degrees (CCW). */
    public var rotated(get, never):Bool;
    private function get_rotated():Bool;

    /** The region of the parent texture that the SubTexture is showing (in points).
     *
     *  <p>CAUTION: not a copy, but the actual object! Do not modify!</p> */
    public var region(get, never):Rectangle;
    private function get_region():Rectangle;
}
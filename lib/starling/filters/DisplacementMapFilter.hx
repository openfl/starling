// =================================================================================================
//
//	Starling Framework
//	Copyright Gamua GmbH. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

package starling.filters;

import openfl.display.BitmapDataChannel;
import openfl.display3D.Context3D;
import openfl.display3D.Context3DProgramType;
import openfl.geom.Matrix3D;
import openfl.geom.Rectangle;
import openfl.Vector;

import starling.core.Starling;
import starling.display.Stage;
import starling.rendering.FilterEffect;
import starling.rendering.Painter;
import starling.rendering.Program;
import starling.rendering.VertexDataFormat;
import starling.textures.Texture;
import starling.utils.RenderUtil;

/** The DisplacementMapFilter class uses the pixel values from the specified texture (called
 *  the map texture) to perform a displacement of an object. You can use this filter
 *  to apply a warped or mottled effect to any object that inherits from the DisplayObject
 *  class.
 *
 *  <p>The filter uses the following formula:</p>
 *  <listing>dstPixel[x, y] = srcPixel[x + ((componentX(x, y) - 128) &#42; scaleX) / 256,
 *                      y + ((componentY(x, y) - 128) &#42; scaleY) / 256]
 *  </listing>
 *
 *  <p>Where <code>componentX(x, y)</code> gets the componentX property color value from the
 *  map texture at <code>(x - mapX, y - mapY)</code>.</p>
 *
 *  <strong>Clamping to the Edges</strong>
 *
 *  <p>Per default, the filter allows the object to grow beyond its actual bounds to make
 *  room for the displacement (depending on <code>scaleX/Y</code>). If you want to clamp the
 *  displacement to the actual object bounds, set all margins to zero via a call to
 *  <code>filter.padding.setTo()</code>. This works only with rectangular, stage-aligned
 *  objects, though.</p>
 */

@:jsRequire("starling/filters/DisplacementMapFilter", "default")

extern class DisplacementMapFilter extends FragmentFilter
{
    /** Creates a new displacement map filter that uses the provided map texture. */
    public function new(mapTexture:Texture,
                        componentX:UInt=0, componentY:UInt=0,
                        scaleX:Float=0.0, scaleY:Float=0.0);

    /** @private */
    override public function process(painter:Painter, pool:IFilterHelper,
                                     input0:Texture = null, input1:Texture = null,
                                     input2:Texture = null, input3:Texture = null):Texture;

    // properties

    /** Describes which color channel to use in the map image to displace the x result.
     *  Possible values are constants from the BitmapDataChannel class. */
    public var componentX(get, set):UInt;
    private function get_componentX():UInt;
    private function set_componentX(value:UInt):UInt;

    /** Describes which color channel to use in the map image to displace the y result.
     *  Possible values are constants from the BitmapDataChannel class. */
    public var componentY(get, set):UInt;
    private function get_componentY():UInt;
    private function set_componentY(value:UInt):UInt;

    /** The multiplier used to scale the x displacement result from the map calculation. */
    public var scaleX(get, set):Float;
    private function get_scaleX():Float;
    private function set_scaleX(value:Float):Float;

    /** The multiplier used to scale the y displacement result from the map calculation. */
    public var scaleY(get, set):Float;
    private function get_scaleY():Float;
    private function set_scaleY(value:Float):Float;

    /** The horizontal offset of the map texture relative to the origin. @default 0 */
    public var mapX(get, set):Float;
    private function get_mapX():Float;
    private function set_mapX(value:Float):Float;

    /** The vertical offset of the map texture relative to the origin. @default 0 */
    public var mapY(get, set):Float;
    private function get_mapY():Float;
    private function set_mapY(value:Float):Float;

    /** The texture that will be used to calculate displacement. */
    public var mapTexture(get, set):Texture;
    private function get_mapTexture():Texture;
    private function set_mapTexture(value:Texture):Texture;

    /** Indicates if pixels at the edge of the map texture will be repeated.
     *  Note that this only works if the map texture is a power-of-two texture!
     */
    public var mapRepeat(get, set):Bool;
    private function get_mapRepeat():Bool;
    private function set_mapRepeat(value:Bool):Bool;

    public var dispEffect(get, never):DisplacementMapEffect;
    private function get_dispEffect():DisplacementMapEffect;
}


extern class DisplacementMapEffect extends FilterEffect
{
    public static var VERTEX_FORMAT:VertexDataFormat;

    public function new();

    // properties

    public var componentX(get, set):UInt;
    private function get_componentX():UInt;
    private function set_componentX(value:UInt):UInt;

    public var componentY(get, set):UInt;
    private function get_componentY():UInt;
    private function set_componentY(value:UInt):UInt;

    public var scaleX(get, set):Float;
    private function get_scaleX():Float;
    private function set_scaleX(value:Float):Float;

    public var scaleY(get, set):Float;
    private function get_scaleY():Float;
    private function set_scaleY(value:Float):Float;

    public var mapTexture(get, set):Texture;
    private function get_mapTexture():Texture;
    private function set_mapTexture(value:Texture):Texture;

    public var mapRepeat(get, set):Bool;
    private function get_mapRepeat():Bool;
    private function set_mapRepeat(value:Bool):Bool;
}
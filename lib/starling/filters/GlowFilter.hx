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

import starling.rendering.Painter;
import starling.textures.Texture;

/** The GlowFilter class lets you apply a glow effect to display objects.
 *  It is similar to the drop shadow filter with the distance and angle properties set to 0.
 *
 *  <p>This filter can also be used to create outlines around objects. The trick is to
 *  assign an alpha value that's (much) greater than <code>1.0</code>, and full resolution.
 *  For example, the following code will yield a nice black outline:</p>
 *
 *  <listing>object.filter = new GlowFilter(0x0, 30, 1, 1.0);</listing>
 */

@:jsRequire("starling/filters/GlowFilter", "default")

extern class GlowFilter extends FragmentFilter
{
    /** Initializes a new GlowFilter instance with the specified parameters.
     *
     * @param color      the color of the glow
     * @param alpha      the alpha value of the glow. Values between 0 and 1 modify the
     *                   opacity; values > 1 will make it stronger, i.e. produce a harder edge.
     * @param blur       the amount of blur used to create the glow. Note that high
     *                   values will cause the number of render passes to grow.
     * @param quality 	 the quality of the glow's blur, '1' being the best (range 0.1 - 1.0)
     */
    public function new(color:UInt=0xffff00, alpha:Float=1.0, blur:Float=1.0,
                        quality:Float=0.5);

    /** @inheritDoc */
    override public function dispose():Void;

    /** @private */
    override public function process(painter:Painter, helper:IFilterHelper,
                                     input0:Texture = null, input1:Texture = null,
                                     input2:Texture = null, input3:Texture = null):Texture;

    /** The color of the glow. @default 0xffff00 */
    public var color(get, set):UInt;
    private function get_color():UInt;
    private function set_color(value:UInt):UInt;

    /** The alpha value of the glow. Values between 0 and 1 modify the opacity;
     *  values > 1 will make it stronger, i.e. produce a harder edge. @default 1.0 */
    public var alpha(get, set):Float;
    private function get_alpha():Float;
    private function set_alpha(value:Float):Float;

    /** The amount of blur with which the glow is created.
     *  The number of required passes will be <code>Math.ceil(value) × 2</code>.
     *  @default 1.0 */
    public var blur(get, set):Float;
    private function get_blur():Float;
    private function set_blur(value:Float):Float;
	
	/** The quality used for blurring the glow.
	 *  Forwarded to the internally used <em>BlurFilter</em>. */
	public var quality(get, set):Float;
    private function get_quality():Float;
    private function set_quality(value:Float):Float;
}
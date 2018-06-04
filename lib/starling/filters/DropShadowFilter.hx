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
import starling.utils.Padding;

/** The DropShadowFilter class lets you add a drop shadow to display objects.
 *  To create the shadow, the class internally uses the BlurFilter.
 */

@:jsRequire("starling/filters/DropShadowFilter", "default")

extern class DropShadowFilter extends FragmentFilter
{
    /** Creates a new DropShadowFilter instance with the specified parameters.
     *
     * @param distance   the offset distance of the shadow, in points.
     * @param angle      the angle with which the shadow is offset, in radians.
     * @param color      the color of the shadow.
     * @param alpha      the alpha value of the shadow. Values between 0 and 1 modify the
     *                   opacity; values > 1 will make it stronger, i.e. produce a harder edge.
     * @param blur       the amount of blur with which the shadow is created. Note that high
     *                   values will cause the number of render passes to grow.
     * @param quality 	 the quality of the shadow blur, '1' being the best (range 0.1 - 1.0)
     */
    public function new(distance:Float=4.0, angle:Float=0.785,
                        color:UInt=0x0, alpha:Float=0.5, blur:Float=1.0,
                        quality:Float=0.5);

    /** @inheritDoc */
    override public function dispose():Void;

    /** @private */
    override public function process(painter:Painter, helper:IFilterHelper,
                                     input0:Texture = null, input1:Texture = null,
                                     input2:Texture = null, input3:Texture = null):Texture;

    /** The color of the shadow. @default 0x0 */
    public var color(get, set):UInt;
    private function get_color():UInt;
    private function set_color(value:UInt):UInt;

    /** The alpha value of the shadow. Values between 0 and 1 modify the opacity;
     *  values > 1 will make it stronger, i.e. produce a harder edge. @default 0.5 */
    public var alpha(get, set):Float;
    private function get_alpha():Float;
    private function set_alpha(value:Float):Float;

    /** The offset distance for the shadow, in points. @default 4.0 */
    public var distance(get, set):Float;
    private function get_distance():Float;
    private function set_distance(value:Float):Float;

    /** The angle with which the shadow is offset, in radians. @default Math.PI / 4 */
    public var angle(get, set):Float;
    private function get_angle():Float;
    private function set_angle(value:Float):Float;

    /** The amount of blur with which the shadow is created.
     *  The number of required passes will be <code>Math.ceil(value) × 2</code>.
     *  @default 1.0 */
    public var blur(get, set):Float;
    private function get_blur():Float;
    private function set_blur(value:Float):Float;

    /** The quality used for blurring the shadow.
     *  Forwarded to the internally used <em>BlurFilter</em>. */
    public var quality(get, set):Float;
    private function get_quality():Float;
    private function set_quality(value:Float):Float;
}
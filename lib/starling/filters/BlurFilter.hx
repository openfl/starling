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

import openfl.display3D.Context3D;
import openfl.display3D.Context3DProgramType;
import openfl.Vector;

import starling.core.Starling;
import starling.rendering.FilterEffect;
import starling.rendering.Painter;
import starling.rendering.Program;
import starling.textures.Texture;
import starling.utils.MathUtil;

/** The BlurFilter applies a Gaussian blur to an object. The strength of the blur can be
 *  set for x- and y-axis separately. */

@:jsRequire("starling/filters/BlurFilter", "default")

extern class BlurFilter extends FragmentFilter
{
    /** Create a new BlurFilter. For each blur direction, the number of required passes is
     *
     *  <p>The blur is rendered for each direction (x and y) separately; the number of
     *  draw calls add up. The blur value itself is internally multiplied with the current
     *  <code>contentScaleFactor</code> in order to guarantee a consistent look on HiDPI
     *  displays (dubbed 'totalBlur' below).</p>
     *
     *  <p>The number of draw calls per blur value is the following:</p>
     *  <ul><li>totalBlur &lt;= 1: 1 draw call</li>
     *      <li>totalBlur &lt;= 2: 2 draw calls</li>
     *      <li>totalBlur &lt;= 4: 3 draw calls</li>
     *      <li>totalBlur &lt;= 8: 4 draw calls</li>
     *      <li>... etc.</li>
     *  </ul>
     */
    public function new(blurX:Float=1.0, blurY:Float=1.0, resolution:Float=1.0);

    /** @private */
    override public function process(painter:Painter, helper:IFilterHelper,
                                     input0:Texture = null, input1:Texture = null,
                                     input2:Texture = null, input3:Texture = null):Texture;

    /** The blur values scaled by the current contentScaleFactor. */
    private var totalBlurX(get, never):Float;
    private function get_totalBlurX():Float;
    private var totalBlurY(get, never):Float;
    private function get_totalBlurY():Float;

    /** The blur factor in x-direction.
     *  The number of required passes will be <code>Math.ceil(value)</code>. */
    public var blurX(get, set):Float;
    private function get_blurX():Float;
    private function set_blurX(value:Float):Float;

    /** The blur factor in y-direction.
     *  The number of required passes will be <code>Math.ceil(value)</code>. */
    public var blurY(get, set):Float;
    private function get_blurY():Float;
    private function set_blurY(value:Float):Float;

    /** The quality of the blur effect. Low values will look as if the target was drawn
     *  multiple times in close proximity (range: 0.1 - 1).
     *
     *  <p>Typically, it's better to reduce the filter resolution instead; however, if that
     *  is not an option (e.g. when using the BlurFilter as part of a composite filter),
     *  this property may provide an alternative.</p>
     *
     *  @default 1.0
     */
    public var quality(get, set):Float;
    public function get_quality():Float;
    public function set_quality(value:Float):Float;
}


extern class BlurEffect extends FilterEffect
{
    public static var HORIZONTAL:String;
    public static var VERTICAL:String;

    /** Creates a new BlurEffect. */
    public function new():Void;

    public var direction(get, set):String;
    private function get_direction():String;
    private function set_direction(value:String):String;

    public var strength(get, set):Float;
    private function get_strength():Float;
    private function set_strength(value:Float):Float;

    public var quality(get, set):Float;
    private function get_quality():Float;
    private function set_quality(value:Float):Float;
}
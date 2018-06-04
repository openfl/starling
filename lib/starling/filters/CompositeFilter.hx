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
import openfl.errors.ArgumentError;
import openfl.geom.Point;
import openfl.Vector;

import starling.rendering.FilterEffect;
import starling.rendering.Painter;
import starling.rendering.Program;
import starling.rendering.VertexDataFormat;
import starling.textures.Texture;
import starling.utils.Color;
import starling.utils.RenderUtil;
import starling.utils.StringUtil;
import starling.utils.MathUtil;

/** The CompositeFilter class allows to combine several layers of textures into one texture.
 *  It's mainly used as a building block for more complex filters; e.g. the DropShadowFilter
 *  uses this class to draw the shadow (the result of a BlurFilter) behind an object.
 */

@:jsRequire("starling/filters/CompositeFilter", "default")

extern class CompositeFilter extends FragmentFilter
{
    /** Creates a new instance. */
    public function new();

    /** Combines up to four input textures into one new texture,
     *  adhering to the properties of each layer. */
    override public function process(painter:Painter, helper:IFilterHelper,
                                     input0:Texture = null, input1:Texture = null,
                                     input2:Texture = null, input3:Texture = null):Texture;

    /** Returns the position (in points) at which a certain layer will be drawn. */
    public function getOffsetAt(layerID:Int, out:Point=null):Point;

    /** Indicates the position (in points) at which a certain layer will be drawn. */
    public function setOffsetAt(layerID:Int, x:Float, y:Float):Void;

    /** Returns the RGB color with which a layer is tinted when it is being drawn.
     *  @default 0xffffff */
    public function getColorAt(layerID:Int):UInt;

    /** Adjusts the RGB color with which a layer is tinted when it is being drawn.
     *  If <code>replace</code> is enabled, the pixels are not tinted, but instead
     *  the RGB channels will replace the texture's color entirely.
     */
    public function setColorAt(layerID:Int, color:UInt, replace:Bool=false):Void;

    /** Indicates the alpha value with which the layer is drawn.
     *  @default 1.0 */
    public function getAlphaAt(layerID:Int):Float;

    /** Adjusts the alpha value with which the layer is drawn. */
    public function setAlphaAt(layerID:Int, alpha:Float):Void;

    public var compositeEffect(get, never):CompositeEffect;
    private function get_compositeEffect():CompositeEffect;
}


extern class CompositeEffect extends FilterEffect
{
    public static var VERTEX_FORMAT:VertexDataFormat;

    public function new(numLayers:Int=4);

    public function getLayerAt(layerID:Int):CompositeLayer;
	
    // properties

    public var numLayers(get, never):Int;
    private function get_numLayers():Int;

    override private function set_texture(value:Texture):Texture;
}

extern class CompositeLayer
{
    public var texture:Texture;
    public var x:Float;
    public var y:Float;
    public var color:UInt;
    public var alpha:Float;
    public var replaceColor:Bool;

    public function new();
}
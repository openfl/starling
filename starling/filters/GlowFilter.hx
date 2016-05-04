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
 */
class GlowFilter extends FragmentFilter
{
    private var _blurFilter:BlurFilter;
    private var _compositeFilter:CompositeFilter;

    /** Initializes a new GlowFilter instance with the specified parameters. */
    public function new(color:UInt=0xffff00, alpha:Float=1.0, blur:Float=1.0,
                               resolution:Float=0.5)
    {
        super();
        _compositeFilter = new CompositeFilter();
        _blurFilter = new BlurFilter(blur, blur, resolution);

        this.color = color;
        this.alpha = alpha;

        updatePadding();
    }

    /** @inheritDoc */
    override public function dispose():Void
    {
        _blurFilter.dispose();
        _compositeFilter.dispose();

        super.dispose();
    }

    /** @private */
    override public function process(painter:Painter, helper:IFilterHelper,
                                     input0:Texture = null, input1:Texture = null,
                                     input2:Texture = null, input3:Texture = null):Texture
    {
        var glow:Texture = _blurFilter.process(painter, helper, input0);
        var result:Texture = _compositeFilter.process(painter, helper, glow, input0);
        helper.putTexture(glow);
        return result;
    }

    /** @private */
    @:noCompletion override private function get_numPasses():Int
    {
        return _blurFilter.numPasses + _compositeFilter.numPasses;
    }

    private function updatePadding():Void
    {
        padding.copyFrom(_blurFilter.padding);
    }

    /** The color of the glow. @default 0xffff00 */
    public var color(get, set):UInt;
    @:noCompletion private function get_color():UInt { return _compositeFilter.getColorAt(0); }
    @:noCompletion private function set_color(value:UInt):UInt
    {
        if (color != value)
        {
            _compositeFilter.setColorAt(0, value, true);
            setRequiresRedraw();
        }
        return value;
    }

    /** The alpha transparency value for the color. @default 1.0 */
    public var alpha(get, set):Float;
    @:noCompletion private function get_alpha():Float { return _compositeFilter.getAlphaAt(0); }
    @:noCompletion private function set_alpha(value:Float):Float
    {
        if (alpha != value)
        {
            _compositeFilter.setAlphaAt(0, value);
            setRequiresRedraw();
        }
        return value;
    }

    /** The amount of blur with which the glow is created.
     *  The number of required passes will be <code>Math.ceil(value) Ã? 2</code>.
     *  @default 1.0 */
    public var blur(get, set):Float;
    @:noCompletion private function get_blur():Float { return _blurFilter.blurX; }
    @:noCompletion private function set_blur(value:Float):Float
    {
        if (blur != value)
        {
            _blurFilter.blurX = _blurFilter.blurY = value;
            updatePadding();
        }
        return value;
    }

    /** @private */
    @:noCompletion override private function get_resolution():Float { return _blurFilter.resolution; }
    @:noCompletion override private function set_resolution(value:Float):Float
    {
        if (resolution != value)
        {
            _blurFilter.resolution = value;
            updatePadding();
        }
        return value;
    }
}

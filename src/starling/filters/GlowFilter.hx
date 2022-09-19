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
class GlowFilter extends FragmentFilter
{
    private var _blurFilter:BlurFilter;
    private var _compositeFilter:CompositeFilter;
	private var _inner:Bool;
	private var _knockout:Bool;

    #if commonjs
    private static function __init__ () {
        
        untyped Object.defineProperties (GlowFilter.prototype, {
            "color": { get: untyped __js__ ("function () { return this.get_color (); }"), set: untyped __js__ ("function (v) { return this.set_color (v); }") },
            "alpha": { get: untyped __js__ ("function () { return this.get_alpha (); }"), set: untyped __js__ ("function (v) { return this.set_alpha (v); }") },
            "blur": { get: untyped __js__ ("function () { return this.get_blur (); }"), set: untyped __js__ ("function (v) { return this.set_blur (v); }") },
            "quality": { get: untyped __js__ ("function () { return this.get_quality (); }"), set: untyped __js__ ("function (v) { return this.set_quality (v); }") },
			"inner": { get: untyped __js__ ("function () { return this.get_inner (); }"), set: untyped __js__ ("function (v) { return this.set_inner (v); }") },
			"knockout": { get: untyped __js__ ("function () { return this.get_knockout (); }"), set: untyped __js__ ("function (v) { return this.set_knockout (v); }") },
        });
        
    }
    #end

    /** Initializes a new GlowFilter instance with the specified parameters.
     *
     * @param color      the color of the glow
     * @param alpha      the alpha value of the glow. Values between 0 and 1 modify the
     *                   opacity; values > 1 will make it stronger, i.e. produce a harder edge.
     * @param blur       the amount of blur used to create the glow. Note that high
     *                   values will cause the number of render passes to grow.
     * @param quality 	 the quality of the glow's blur, '1' being the best (range 0.1 - 1.0)
	 * @param inner      if enabled, the glow will be drawn inside the object.
	 * @param knockout   if enabled, only the glow will be drawn.
     */
    public function new(color:UInt=0xffff00, alpha:Float=1.0, blur:Float=1.0,
                        quality:Float=0.5, inner:Bool=false, knockout:Bool=false)
    {
        super();
        
		_compositeFilter = new CompositeFilter();
        _blurFilter = new BlurFilter(blur, blur);
		
		this.color = color;
		this.alpha = alpha;
		this.quality = quality;
		this.inner = inner;
		this.knockout = knockout;

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
        var result:Texture = _compositeFilter.process(painter, helper, input0, glow);
        helper.putTexture(glow);
        return result;
    }

    /** @private */
    override private function get_numPasses():Int
    {
        return _blurFilter.numPasses + _compositeFilter.numPasses;
    }

    private function updatePadding():Void
    {
        padding.copyFrom(_blurFilter.padding);
    }

    /** The color of the glow. @default 0xffff00 */
    public var color(get, set):UInt;
    private function get_color():UInt { return _compositeFilter.getColorAt(1); }
    private function set_color(value:UInt):UInt
    {
        if (color != value || !_compositeFilter.getReplaceColorAt(1))
        {
            _compositeFilter.setColorAt(1, value, true);
            setRequiresRedraw();
        }
        return value;
    }

    /** The alpha value of the glow. Values between 0 and 1 modify the opacity;
     *  values > 1 will make it stronger, i.e. produce a harder edge. @default 1.0 */
    public var alpha(get, set):Float;
    private function get_alpha():Float { return _compositeFilter.getAlphaAt(1); }
    private function set_alpha(value:Float):Float
    {
        if (alpha != value)
        {
            _compositeFilter.setAlphaAt(1, value);
            setRequiresRedraw();
        }
        return value;
    }

    /** The amount of blur with which the glow is created.
     *  The number of required passes will be <code>Math.ceil(value) × 2</code>.
     *  @default 1.0 */
    public var blur(get, set):Float;
    private function get_blur():Float { return _blurFilter.blurX; }
    private function set_blur(value:Float):Float
    {
        if (blur != value)
        {
            _blurFilter.blurX = _blurFilter.blurY = value;
            setRequiresRedraw();
            updatePadding();
        }
        return value;
    }
	
	/** The quality used for blurring the glow.
	 *  Forwarded to the internally used <em>BlurFilter</em>. */
	public var quality(get, set):Float;
    private function get_quality():Float { return _blurFilter.quality; }
    private function set_quality(value:Float):Float
    {
        if (quality != value)
        {
            _blurFilter.quality = value;
            setRequiresRedraw();
            updatePadding();
        }
        return value;
    }
	
	/** Indicates whether or not the glow is an inner glow. The default is
	 *  <code>false</code>, an outer glow (a glow around the outer edges of the object). */
	public var inner(get, set):Bool;
	public function get_inner():Bool { return _inner; }
	public function set_inner(value:Bool) :Bool
	{
		_inner = value;
		_compositeFilter.setModeAt(1, getMode(_inner, _knockout));
		_compositeFilter.setInvertAlphaAt(1, _inner);
		setRequiresRedraw();
		return value;
	}

	/** If enabled, applies a knockout effect, which effectively makes the object's fill
	 *  transparent. @default false */
	public var knockout(get, set):Bool;
	public function get_knockout():Bool { return _knockout; }
	public function set_knockout(value:Bool):Bool
	{
		_knockout = value;
		_compositeFilter.setModeAt(1, getMode(_inner, _knockout));
		setRequiresRedraw();
		return value;
	}

	private static function getMode(inner:Bool, knockout:Bool):String
	{
		return knockout
			? (inner ? CompositeMode.INSIDE_KNOCKOUT : CompositeMode.OUTSIDE_KNOCKOUT)
			: (inner ? CompositeMode.INSIDE : CompositeMode.OUTSIDE);
	}
}
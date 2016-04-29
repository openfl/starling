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
class DropShadowFilter extends FragmentFilter
{
    private var _blurFilter:BlurFilter;
    private var _compositeFilter:CompositeFilter;
    private var _distance:Float;
    private var _angle:Float;

    /** Creates a new DropShadowFilter instance with the specified parameters. */
    public function new(distance:Float=4.0, angle:Float=0.785,
                                     color:UInt=0x0, alpha:Float=0.5, blur:Float=1.0)
    {
        super();
        _compositeFilter = new CompositeFilter();
        _blurFilter = new BlurFilter(blur, blur);
        _distance = distance;
        _angle = angle;

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
    override public function process(painter:Painter, pool:ITexturePool,
                                     input0:Texture = null, input1:Texture = null,
                                     input2:Texture = null, input3:Texture = null):Texture
    {
        var shadow:Texture = _blurFilter.process(painter, pool, input0);
        var result:Texture = _compositeFilter.process(painter, pool, shadow, input0);
        pool.putTexture(shadow);
        return result;
    }

    private function updatePadding():Void
    {
        var offsetX:Float = Math.cos(_angle) * _distance;
        var offsetY:Float = Math.sin(_angle) * _distance;

        _compositeFilter.setOffsetAt(0, offsetX, offsetY);

        var blurPadding:Padding = _blurFilter.padding;
        var left:Float = blurPadding.left;
        var right:Float = blurPadding.right;
        var top:Float = blurPadding.top;
        var bottom:Float = blurPadding.bottom;

        if (offsetX > 0) right += offsetX; else left -= offsetX;
        if (offsetY > 0) bottom += offsetY; else top -= offsetY;

        padding.setTo(left, right, top, bottom);
    }

    /** The color of the shadow. @default 0x0 */
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

    /** The alpha value of the shadow. @default 0.5 */
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

    /** The offset distance for the shadow, in points. @default 4.0 */
    public var distance(get, set):Float;
    @:noCompletion private function get_distance():Float { return _distance; }
    @:noCompletion private function set_distance(value:Float):Float
    {
        if (_distance != value)
        {
            _distance = value;
            updatePadding();
        }
        return value;
    }

    /** The angle with which the shadow is offset, in radians. @default Math.PI / 4 */
    public var angle(get, set):Float;
    @:noCompletion private function get_angle():Float { return _angle; }
    @:noCompletion private function set_angle(value:Float):Float
    {
        if (_angle != value)
        {
            _angle = value;
            updatePadding();
        }
        return value;
    }

    /** The amount of blur with which the shadow is created.
     *  The number of required passes will be <code>Math.ceil(value) × 2</code>.
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
}

// =================================================================================================
//
//	Starling Framework
//	Copyright Gamua GmbH. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

package starling.filters
{
import starling.rendering.Painter;
import starling.textures.Texture;
import starling.utils.Padding;

/** The DropShadowFilter class lets you add a drop shadow to display objects.
 *  To create the shadow, the class internally uses the BlurFilter.
 */
public class DropShadowFilter extends FragmentFilter
{
    private var _blurFilter:BlurFilter;
    private var _compositeFilter:CompositeFilter;
    private var _distance:Float;
    private var _angle:Float;

    /** Creates a new DropShadowFilter instance with the specified parameters. */
    public function DropShadowFilter(distance:Float=4.0, angle:Float=0.785,
                                     color:UInt=0x0, alpha:Float=0.5, blur:Float=1.0)
    {
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
    public function get color():UInt { return _compositeFilter.getColorAt(0); }
    public function set color(value:UInt):Void
    {
        if (color != value)
        {
            _compositeFilter.setColorAt(0, value, true);
            setRequiresRedraw();
        }
    }

    /** The alpha value of the shadow. @default 0.5 */
    public function get alpha():Float { return _compositeFilter.getAlphaAt(0); }
    public function set alpha(value:Float):Void
    {
        if (alpha != value)
        {
            _compositeFilter.setAlphaAt(0, value);
            setRequiresRedraw();
        }
    }

    /** The offset distance for the shadow, in points. @default 4.0 */
    public function get distance():Float { return _distance; }
    public function set distance(value:Float):Void
    {
        if (_distance != value)
        {
            _distance = value;
            updatePadding();
        }
    }

    /** The angle with which the shadow is offset, in radians. @default Math.PI / 4 */
    public function get angle():Float { return _angle; }
    public function set angle(value:Float):Void
    {
        if (_angle != value)
        {
            _angle = value;
            updatePadding();
        }
    }

    /** The amount of blur with which the shadow is created.
     *  The number of required passes will be <code>Math.ceil(value) × 2</code>.
     *  @default 1.0 */
    public function get blur():Float { return _blurFilter.blurX; }
    public function set blur(value:Float):Void
    {
        if (blur != value)
        {
            _blurFilter.blurX = _blurFilter.blurY = value;
            updatePadding();
        }
    }
}
}

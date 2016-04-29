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
import flash.display3D.Context3DProfile;
import flash.geom.Rectangle;
import starling.utils.ArrayUtil;

import starling.core.Starling;
import starling.textures.SubTexture;
import starling.textures.Texture;
import starling.utils.MathUtil;

/** @private
 *
 *  This class manages texture creation, pooling and disposal of all textures
 *  during filter processing.
 */
class TexturePool implements ITexturePool
{
    private var _scale:Float;
    private var _width:Float;
    private var _height:Float;
    private var _nativeWidth:Int;
    private var _nativeHeight:Int;
    private var _pool:Array<Texture>;
    private var _usePotTextures:Bool;
    private var _sizeStep:Int;

    // helpers
    private var sRegion:Rectangle = new Rectangle();

    /** Creates a new, empty instance. */
    public function new()
    {
        _usePotTextures = Starling.current.profile == Context3DProfile.BASELINE_CONSTRAINED;
        _sizeStep = 64; // must be POT!
        _pool = new Array<Texture>();

        setSize(_sizeStep, _sizeStep, 1);
    }

    /** Purges the pool. */
    public function dispose():Void
    {
        purge();
    }

    /** Updates the size of the returned textures. Small size changes may allow the
     *  existing textures to be reused; big size changes will automatically dispose
     *  them. */
    public function setSize(width:Float, height:Float, scale:Float=-1):Void
    {
        if (scale <= 0) scale = Starling.current.contentScaleFactor;

        var factor:Float;
        var maxNativeSize:Int   = Texture.maxSize;
        var newNativeWidth:Int  = getNativeSize(width,  scale);
        var newNativeHeight:Int = getNativeSize(height, scale);

        if (newNativeWidth > maxNativeSize || newNativeHeight > maxNativeSize)
        {
            factor = maxNativeSize / Math.max(newNativeWidth, newNativeHeight);
            newNativeWidth  *= Std.int(factor);
            newNativeHeight *= Std.int(factor);
            scale *= factor;
        }

        if (_nativeWidth != newNativeWidth || _nativeHeight != newNativeHeight)
        {
            purge();

            _nativeWidth  = newNativeWidth;
            _nativeHeight = newNativeHeight;
        }

        _width  = width;
        _height = height;
        _scale  = scale;
    }

    /** @inheritDoc */
    public function getTexture():Texture
    {
        var texture:Texture;

        if (_pool.length != 0)
            texture = _pool.pop();
        else
            texture = Texture.empty(_nativeWidth / _scale, _nativeHeight / _scale,
                true, false, true, _scale);

        if (texture.width != _width || texture.height != _height)
        {
            sRegion.setTo(0, 0, _width, _height);
            texture = new SubTexture(texture.root, sRegion, true);
        }

        texture.root.clear();
        return texture;
    }

    /** @inheritDoc */
    public function putTexture(texture:Texture):Void
    {
        if (texture != null)
        {
            if (texture.root.nativeWidth == _nativeWidth && texture.root.nativeHeight == _nativeHeight)
                _pool.insert(_pool.length, texture);
            else
                texture.dispose();
        }
    }

    /** Purges the pool and disposes all textures. */
    public function purge():Void
    {
        var len:Int = _pool.length;
        for (i in 0 ... len)
            _pool[i].dispose();

        ArrayUtil.clear(_pool);
    }

    private function getNativeSize(size:Float, textureScale:Float):Int
    {
        var nativeSize:Float = size * textureScale;

        if (_usePotTextures)
            return nativeSize > _sizeStep ? MathUtil.getNextPowerOfTwo(nativeSize) : _sizeStep;
        else
            return Math.ceil(nativeSize / _sizeStep) * _sizeStep;
    }

    /** The width of the returned textures (in points). */
    public var textureWidth(get, never):Float;
    @:noCompletion private function get_textureWidth():Float { return _width; }

    /** The height of the returned textures (in points). */
    public var textureHeight(get, never):Float;
    @:noCompletion private function get_textureHeight():Float { return _height; }

    /** The scale factor of the returned textures. */
    public var textureScale(get, never):Float;
    @:noCompletion private function get_textureScale():Float { return _scale; }
}

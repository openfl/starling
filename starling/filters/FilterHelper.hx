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
import flash.display3D.Context3DProfile;
import flash.geom.Matrix3D;
import flash.geom.Rectangle;

import starling.core.Starling;
import starling.core.starling_internal;
import starling.display.DisplayObject;
import starling.textures.SubTexture;
import starling.textures.Texture;
import starling.utils.MathUtil;

use namespace starling_internal;

/** @private
 *
 *  This class manages texture creation, pooling and disposal of all textures
 *  during filter processing.
 */
internal class FilterHelper implements IFilterHelper
{
    private var _width:Float;
    private var _height:Float;
    private var _nativeWidth:Int;
    private var _nativeHeight:Int;
    private var _pool:Vector.<Texture>;
    private var _usePotTextures:Bool;
    private var _textureFormat:String;
    private var _preferredScale:Float;
    private var _scale:Float;
    private var _sizeStep:Int;
    private var _numPasses:Int;
    private var _projectionMatrix:Matrix3D;
    private var _renderTarget:Texture;
    private var _targetBounds:Rectangle;
    private var _target:DisplayObject;

    // helpers
    private var sRegion:Rectangle = new Rectangle();

    /** Creates a new, empty instance. */
    public function FilterHelper(textureFormat:String="bgra")
    {
        _usePotTextures = Starling.current.profile == Context3DProfile.BASELINE_CONSTRAINED;
        _preferredScale = Starling.contentScaleFactor;
        _textureFormat = textureFormat;
        _sizeStep = 64; // must be POT!
        _pool = new <Texture>[];
        _projectionMatrix = new Matrix3D();
        _targetBounds = new Rectangle();

        setSize(_sizeStep, _sizeStep);
    }

    /** Purges the pool. */
    public function dispose():Void
    {
        purge();
    }

    /** Starts a new round of rendering. If <code>numPasses</code> is greater than zero, each
     *  <code>getTexture()</code> call will be counted as one pass; the final pass will then
     *  return <code>null</code> instead of a texture, to indicate that this pass should be
     *  rendered to the back buffer.
     */
    public function start(numPasses:Int, drawLastPassToBackBuffer:Bool):Void
    {
        _numPasses = drawLastPassToBackBuffer ? numPasses : -1;
    }

    /** @inheritDoc */
    public function getTexture(resolution:Float=1.0):Texture
    {
        var texture:Texture;
        var subTexture:SubTexture;

        if (_numPasses >= 0)
            if (_numPasses-- == 0) return null;

        if (_pool.length)
            texture = _pool.pop();
        else
            texture = Texture.empty(_nativeWidth / _scale, _nativeHeight / _scale,
                true, false, true, _scale, _textureFormat);

        if (!MathUtil.isEquivalent(texture.width,  _width,  0.1) ||
            !MathUtil.isEquivalent(texture.height, _height, 0.1) ||
            !MathUtil.isEquivalent(texture.scale,  _scale * resolution))
        {
            sRegion.setTo(0, 0, _width * resolution, _height * resolution);
            subTexture = texture as SubTexture;

            if (subTexture)
                subTexture.setTo(texture.root, sRegion, true, null, false, resolution);
            else
                texture = new SubTexture(texture.root, sRegion, true, null, false, resolution);
        }

        texture.root.clear();
        return texture;
    }

    /** @inheritDoc */
    public function putTexture(texture:Texture):Void
    {
        if (texture)
        {
            if (texture.root.nativeWidth == _nativeWidth && texture.root.nativeHeight == _nativeHeight)
                _pool.insertAt(_pool.length, texture);
            else
                texture.dispose();
        }
    }

    /** Purges the pool and disposes all textures. */
    public function purge():Void
    {
        for (var i:Int = 0, len:Int = _pool.length; i < len; ++i)
            _pool[i].dispose();

        _pool.length = 0;
    }

    /** Updates the size of the returned textures. Small size changes may allow the
     *  existing textures to be reused; big size changes will automatically dispose
     *  them. */
    private function setSize(width:Float, height:Float):Void
    {
        var factor:Float;
        var newScale:Float = _preferredScale;
        var maxNativeSize:Int   = Texture.maxSize;
        var newNativeWidth:Int  = getNativeSize(width,  newScale);
        var newNativeHeight:Int = getNativeSize(height, newScale);

        if (newNativeWidth > maxNativeSize || newNativeHeight > maxNativeSize)
        {
            factor = maxNativeSize / Math.max(newNativeWidth, newNativeHeight);
            newNativeWidth  *= factor;
            newNativeHeight *= factor;
            newScale *= factor;
        }

        if (_nativeWidth != newNativeWidth || _nativeHeight != newNativeHeight ||
            _scale != newScale)
        {
            purge();

            _scale = newScale;
            _nativeWidth  = newNativeWidth;
            _nativeHeight = newNativeHeight;
        }

        _width  = width;
        _height = height;
    }

    private function getNativeSize(size:Float, textureScale:Float):Int
    {
        var nativeSize:Float = size * textureScale;

        if (_usePotTextures)
            return nativeSize > _sizeStep ? MathUtil.getNextPowerOfTwo(nativeSize) : _sizeStep;
        else
            return Math.ceil(nativeSize / _sizeStep) * _sizeStep;
    }

    /** The projection matrix that was active when the filter started processing. */
    public function get projectionMatrix3D():Matrix3D { return _projectionMatrix; }
    public function set projectionMatrix3D(value:Matrix3D):Void
    {
        _projectionMatrix.copyFrom(value);
    }

    /** The render target that was active when the filter started processing. */
    public function get renderTarget():Texture { return _renderTarget; }
    public function set renderTarget(value:Texture):Void
    {
        _renderTarget = value;
    }

    /** @inheritDoc */
    public function get targetBounds():Rectangle { return _targetBounds; }
    public function set targetBounds(value:Rectangle):Void
    {
        _targetBounds.copyFrom(value);
        setSize(value.width, value.height);
    }

    /** @inheritDoc */
    public function get target():DisplayObject { return _target; }
    public function set target(value:DisplayObject):Void { _target = value; }

    /** The scale factor of the returned textures. */
    public function get textureScale():Float { return _preferredScale; }
    public function set textureScale(value:Float):Void
    {
        _preferredScale = value > 0 ? value : Starling.contentScaleFactor;
    }

    /** The texture format of the returned textures. @default BGRA */
    public function get textureFormat():String { return _textureFormat; }
    public function set textureFormat(value:String):Void { _textureFormat = value; }
}
}

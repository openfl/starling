// =================================================================================================
//
//	Starling Framework
//	Copyright Gamua GmbH. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

package starling.textures;

import openfl.display3D.textures.TextureBase;
import openfl.display3D.Context3DTextureFormat;
import openfl.geom.Matrix;
import openfl.geom.Rectangle;

/** A SubTexture represents a section of another texture. This is achieved solely by
 *  manipulation of texture coordinates, making the class very efficient. 
 *
 *  <p><em>Note that it is OK to create subtextures of subtextures.</em></p>
 */
class SubTexture extends Texture
{
    private var _parent:Texture;
    private var _ownsParent:Bool;
    private var _region:Rectangle;
    private var _frame:Rectangle;
    private var _rotated:Bool;
    private var _width:Float;
    private var _height:Float;
    private var _scale:Float;
    private var _transformationMatrix:Matrix;
    private var _transformationMatrixToRoot:Matrix;

    /** Creates a new SubTexture containing the specified region of a parent texture.
     *
     *  @param parent     The texture you want to create a SubTexture from.
     *  @param region     The region of the parent texture that the SubTexture will show
     *                    (in points). If <code>null</code>, the complete area of the parent.
     *  @param ownsParent If <code>true</code>, the parent texture will be disposed
     *                    automatically when the SubTexture is disposed.
     *  @param frame      If the texture was trimmed, the frame rectangle can be used to restore
     *                    the trimmed area.
     *  @param rotated    If true, the SubTexture will show the parent region rotated by
     *                    90 degrees (CCW).
     *  @param scaleModifier  The scale factor of the SubTexture will be calculated by
     *                    multiplying the parent texture's scale factor with this value.
     */
    public function new(parent:Texture, region:Rectangle=null,
                        ownsParent:Bool=false, frame:Rectangle=null,
                        rotated:Bool=false, scaleModifier:Float=1)
    {
        super();
        setTo(parent, region, ownsParent, frame, rotated, scaleModifier);
    }

    /** @private
     *
     *  <p>Textures are supposed to be immutable, and Starling uses this assumption for
     *  optimizations and simplifications all over the place. However, in some situations where
     *  the texture is not accessible to the outside, this can be overruled in order to avoid
     *  allocations.</p>
     */
    @:allow(starling) private function setTo(parent:Texture, region:Rectangle=null,
                                             ownsParent:Bool=false, frame:Rectangle=null,
                                             rotated:Bool=false, scaleModifier:Float=1):Void
    {
        if (_region == null) _region = new Rectangle();
        if (region != null) _region.copyFrom(region);
        else _region.setTo(0, 0, parent.width, parent.height);

        if (frame != null)
        {
            if (_frame != null) _frame.copyFrom(frame);
            else _frame = frame.clone();
        }
        else _frame = null;

        _parent = parent;
        _ownsParent = ownsParent;
        _rotated = rotated;
        _width  = (rotated ? _region.height : _region.width)  / scaleModifier;
        _height = (rotated ? _region.width  : _region.height) / scaleModifier;
        _scale = _parent.scale * scaleModifier;

        if (_frame != null && (_frame.x > 0 || _frame.y > 0 ||
            _frame.right < _width || _frame.bottom < _height))
        {
            trace("[Starling] Warning: frames inside the texture's region are unsupported.");
        }

        updateMatrices();
    }

    private function updateMatrices():Void
    {
        if (_transformationMatrix != null) _transformationMatrix.identity();
        else _transformationMatrix = new Matrix();

        if (_transformationMatrixToRoot != null) _transformationMatrixToRoot.identity();
        else _transformationMatrixToRoot = new Matrix();

        if (_rotated)
        {
            _transformationMatrix.translate(0, -1);
            _transformationMatrix.rotate(Math.PI / 2.0);
        }

        _transformationMatrix.scale(_region.width  / _parent.width,
                                    _region.height / _parent.height);
        _transformationMatrix.translate(_region.x  / _parent.width,
                                        _region.y  / _parent.height);

        var texture:SubTexture = this;
        while (texture != null)
        {
            _transformationMatrixToRoot.concat(texture._transformationMatrix);
            texture = Std.is(texture.parent, SubTexture) ? cast texture.parent : null;
        }
    }
    
    /** Disposes the parent texture if this texture owns it. */
    public override function dispose():Void
    {
        if (_ownsParent) _parent.dispose();
        super.dispose();
    }

    /** The texture which the SubTexture is based on. */
    public var parent(get, never):Texture;
    private function get_parent():Texture { return _parent; }
    
    /** Indicates if the parent texture is disposed when this object is disposed. */
    public var ownsParent(get, never):Bool;
    private function get_ownsParent():Bool { return _ownsParent; }
    
    /** If true, the SubTexture will show the parent region rotated by 90 degrees (CCW). */
    public var rotated(get, never):Bool;
    private function get_rotated():Bool { return _rotated; }

    /** The region of the parent texture that the SubTexture is showing (in points).
     *
     *  <p>CAUTION: not a copy, but the actual object! Do not modify!</p> */
    public var region(get, never):Rectangle;
    private function get_region():Rectangle { return _region; }

    /** @inheritDoc */
    private override function get_transformationMatrix():Matrix { return _transformationMatrix; }

    /** @inheritDoc */
    private override function get_transformationMatrixToRoot():Matrix { return _transformationMatrixToRoot; }
    
    /** @inheritDoc */
    private override function get_base():TextureBase { return _parent.base; }
    
    /** @inheritDoc */
    private override function get_root():ConcreteTexture { return _parent.root; }
    
    /** @inheritDoc */
    private override function get_format():Context3DTextureFormat { return _parent.format; }
    
    /** @inheritDoc */
    private override function get_width():Float { return _width; }
    
    /** @inheritDoc */
    private override function get_height():Float { return _height; }
    
    /** @inheritDoc */
    private override function get_nativeWidth():Float { return _width * _scale; }
    
    /** @inheritDoc */
    private override function get_nativeHeight():Float { return _height * _scale; }
    
    /** @inheritDoc */
    private override function get_mipMapping():Bool { return _parent.mipMapping; }
    
    /** @inheritDoc */
    private override function get_premultipliedAlpha():Bool { return _parent.premultipliedAlpha; }
    
    /** @inheritDoc */
    private override function get_scale():Float { return _scale; }

    /** @inheritDoc */
    private override function get_frame():Rectangle { return _frame; }
}
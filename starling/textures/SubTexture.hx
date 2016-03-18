// =================================================================================================
//
//	Starling Framework
//	Copyright Gamua GmbH. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

package starling.textures
{
import flash.display3D.textures.TextureBase;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;

/** A SubTexture represents a section of another texture. This is achieved solely by
 *  manipulation of texture coordinates, making the class very efficient. 
 *
 *  <p><em>Note that it is OK to create subtextures of subtextures.</em></p>
 */
public class SubTexture extends Texture
{
    private var _parent:Texture;
    private var _ownsParent:Bool;
    private var _region:Rectangle;
    private var _frame:Rectangle;
    private var _rotated:Bool;
    private var _width:Float;
    private var _height:Float;
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
     */
    public function SubTexture(parent:Texture, region:Rectangle=null,
                               ownsParent:Bool=false, frame:Rectangle=null,
                               rotated:Bool=false)
    {
        // TODO: in a future version, the order of arguments of this constructor should
        //       be fixed ('ownsParent' at the very end).
        
        _parent = parent;
        _region = region ? region.clone() : new Rectangle(0, 0, parent.width, parent.height);
        _frame = frame ? frame.clone() : null;
        _ownsParent = ownsParent;
        _rotated = rotated;
        _width  = rotated ? _region.height : _region.width;
        _height = rotated ? _region.width  : _region.height;
        _transformationMatrixToRoot = new Matrix();
        _transformationMatrix = new Matrix();
        
        if (rotated)
        {
            _transformationMatrix.translate(0, -1);
            _transformationMatrix.rotate(Math.PI / 2.0);
        }

        if (_frame && (_frame.x > 0 || _frame.y > 0 ||
            _frame.right < _width || _frame.bottom < _height))
        {
            trace("[Starling] Warning: frames inside the texture's region are unsupported.");
        }

        _transformationMatrix.scale(_region.width  / _parent.width,
                                    _region.height / _parent.height);
        _transformationMatrix.translate(_region.x  / _parent.width,
                                        _region.y  / _parent.height);

        var texture:SubTexture = this;
        while (texture)
        {
            _transformationMatrixToRoot.concat(texture._transformationMatrix);
            texture = texture.parent as SubTexture;
        }
    }
    
    /** Disposes the parent texture if this texture owns it. */
    public override function dispose():Void
    {
        if (_ownsParent) _parent.dispose();
        super.dispose();
    }

    /** The texture which the SubTexture is based on. */
    public function get parent():Texture { return _parent; }
    
    /** Indicates if the parent texture is disposed when this object is disposed. */
    public function get ownsParent():Bool { return _ownsParent; }
    
    /** If true, the SubTexture will show the parent region rotated by 90 degrees (CCW). */
    public function get rotated():Bool { return _rotated; }

    /** The region of the parent texture that the SubTexture is showing (in points).
     *
     *  <p>CAUTION: not a copy, but the actual object! Do not modify!</p> */
    public function get region():Rectangle { return _region; }

    /** @inheritDoc */
    public override function get transformationMatrix():Matrix { return _transformationMatrix; }

    /** @inheritDoc */
    public override function get transformationMatrixToRoot():Matrix { return _transformationMatrixToRoot; }
    
    /** @inheritDoc */
    public override function get base():TextureBase { return _parent.base; }
    
    /** @inheritDoc */
    public override function get root():ConcreteTexture { return _parent.root; }
    
    /** @inheritDoc */
    public override function get format():String { return _parent.format; }
    
    /** @inheritDoc */
    public override function get width():Float { return _width; }
    
    /** @inheritDoc */
    public override function get height():Float { return _height; }
    
    /** @inheritDoc */
    public override function get nativeWidth():Float { return _width * scale; }
    
    /** @inheritDoc */
    public override function get nativeHeight():Float { return _height * scale; }
    
    /** @inheritDoc */
    public override function get mipMapping():Bool { return _parent.mipMapping; }
    
    /** @inheritDoc */
    public override function get premultipliedAlpha():Bool { return _parent.premultipliedAlpha; }
    
    /** @inheritDoc */
    public override function get scale():Float { return _parent.scale; }

    /** @inheritDoc */
    public override function get frame():Rectangle { return _frame; }
}
}
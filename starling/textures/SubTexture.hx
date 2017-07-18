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

import flash.display3D.textures.TextureBase;
import flash.display3D.Context3DTextureFormat;
import flash.errors.ArgumentError;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;
import starling.rendering.VertexData;

import openfl.Vector;

import starling.utils.MatrixUtil;
import starling.utils.RectangleUtil;

/** A SubTexture represents a section of another texture. This is achieved solely by 
 *  manipulation of texture coordinates, making the class very efficient. 
 *
 *  <p><em>Note that it is OK to create subtextures of subtextures.</em></p>
 */
class SubTexture extends Texture
{
    private var __parent:Texture;
    private var mOwnsParent:Bool;
    private var mRegion:Rectangle;
    private var __frame:Rectangle;
    private var __rotated:Bool;
    private var __width:Float;
    private var __height:Float;
    private var __transformationMatrix:Matrix;
    
    /** Helper object. */
    private static var sTexCoords:Point = new Point();
    private static var sMatrix:Matrix = new Matrix();
    
    /** Creates a new SubTexture containing the specified region of a parent texture.
     *
     * @param parent     The texture you want to create a SubTexture from.
     * @param region     The region of the parent texture that the SubTexture will show
     *                   (in points). If <code>null</code>, the complete area of the parent.
     * @param ownsParent If <code>true</code>, the parent texture will be disposed
     *                   automatically when the SubTexture is disposed.
     * @param frame      If the texture was trimmed, the frame rectangle can be used to restore
     *                   the trimmed area.
     * @param rotated    If true, the SubTexture will show the parent region rotated by
     *                   90 degrees (CCW).
     */
    public function new(parent:Texture, region:Rectangle=null,
                        ownsParent:Bool=false, frame:Rectangle=null,
                        rotated:Bool=false)
    {
        super();
        // TODO: in a future version, the order of arguments of this constructor should
        //       be fixed ('ownsParent' at the very end).
        
        __parent = parent;
        mRegion = region != null ? region.clone() : new Rectangle(0, 0, parent.width, parent.height);
        __frame = frame != null ? frame.clone() : null;
        mOwnsParent = ownsParent;
        __rotated = rotated;
        __width  = rotated ? mRegion.height : mRegion.width;
        __height = rotated ? mRegion.width  : mRegion.height;
        __transformationMatrix = new Matrix();
        
        if (rotated)
        {
            __transformationMatrix.translate(0, -1);
            __transformationMatrix.rotate(Math.PI / 2.0);
        }

        if (__frame != null && (__frame.x > 0 || __frame.y > 0 ||
            __frame.right < __width || __frame.bottom < __height))
        {
            trace("[Starling] Warning: frames inside the texture's region are unsupported.");
        }

        __transformationMatrix.scale(mRegion.width  / __parent.width,
                                    mRegion.height / __parent.height);
        __transformationMatrix.translate(mRegion.x  / __parent.width,
                                        mRegion.y  / __parent.height);
    }
    
    /** Disposes the parent texture if this texture owns it. */
    public override function dispose():Void
    {
        if (mOwnsParent) __parent.dispose();
        super.dispose();
    }
    
    /** @inheritDoc */
    public override function adjustVertexData(vertexData:VertexData, vertexID:Int, count:Int):Void
    {
        var startIndex:Int = vertexID * VertexData.ELEMENTS_PER_VERTEX + VertexData.TEXCOORD_OFFSET;
        var stride:Int = VertexData.ELEMENTS_PER_VERTEX - 2;
        
        adjustTexCoords(vertexData.rawData, startIndex, stride, count);
        
        if (__frame != null)
        {
            if (count != 4)
                throw new ArgumentError("Textures with a frame can only be used on quads");
            
            var deltaRight:Float  = __frame.width  + __frame.x - __width;
            var deltaBottom:Float = __frame.height + __frame.y - __height;
            
            vertexData.translateVertex(vertexID,     -__frame.x, -__frame.y);
            vertexData.translateVertex(vertexID + 1, -deltaRight, -__frame.y);
            vertexData.translateVertex(vertexID + 2, -__frame.x, -deltaBottom);
            vertexData.translateVertex(vertexID + 3, -deltaRight, -deltaBottom);
        }
    }

    /** @inheritDoc */
    public override function adjustTexCoords(texCoords:Vector<Float>,
                                             startIndex:Int=0, stride:Int=0, count:Int=-1):Void
    {
        if (count < 0)
            count = Std.int((texCoords.length - startIndex - 2) / (stride + 2) + 1);

        var endIndex:Int = startIndex + count * (2 + stride);
        var texture:SubTexture = this;
        var u:Float, v:Float;
        
        sMatrix.identity();
        
        while (texture != null)
        {
            sMatrix.concat(texture.__transformationMatrix);
            texture = Std.is(texture.parent, SubTexture) ? cast texture.parent : null;
        }
        
        var i:Int = startIndex;
        while (i < endIndex)
        {
            u = texCoords[    i   ];
            v = texCoords[i+1];
            
            MatrixUtil.transformCoords(sMatrix, u, v, sTexCoords);
            
            texCoords[    i   ] = sTexCoords.x;
            texCoords[i + 1] = sTexCoords.y;
            i += 2 + stride;
        }
    }
    
    /** The texture which the SubTexture is based on. */
    public var parent(get, never):Texture;
    private function get_parent():Texture { return __parent; }
    
    /** Indicates if the parent texture is disposed when this object is disposed. */
    public var ownsParent(get, never):Bool;
    private function get_ownsParent():Bool { return mOwnsParent; }
    
    /** If true, the SubTexture will show the parent region rotated by 90 degrees (CCW). */
    public var rotated(get, never):Bool;
    private function get_rotated():Bool { return __rotated; }

    /** The region of the parent texture that the SubTexture is showing (in points).
     *
     * <p>CAUTION: not a copy, but the actual object! Do not modify!</p> */
    public var region(get, never):Rectangle;
    private function get_region():Rectangle { return mRegion; }

    /** The clipping rectangle, which is the region provided on initialization 
     * scaled into [0.0, 1.0]. */
    public var clipping(get, never):Rectangle;
    private function get_clipping():Rectangle
    {
        var topLeft:Point = new Point();
        var bottomRight:Point = new Point();
        
        MatrixUtil.transformCoords(__transformationMatrix, 0.0, 0.0, topLeft);
        MatrixUtil.transformCoords(__transformationMatrix, 1.0, 1.0, bottomRight);
        
        var clipping:Rectangle = new Rectangle(topLeft.x, topLeft.y,
            bottomRight.x - topLeft.x, bottomRight.y - topLeft.y);
        
        RectangleUtil.normalize(clipping);
        return clipping;
    }
    
    /** The matrix that is used to transform the texture coordinates into the coordinate
     * space of the parent texture (used internally by the "adjust..."-methods).
     *
     * <p>CAUTION: not a copy, but the actual object! Do not modify!</p> */
    public var transformationMatrix(get, never):Matrix;
    private function get_transformationMatrix():Matrix { return __transformationMatrix; }
    
    /** @inheritDoc */
    private override function get_base():TextureBase { return __parent.base; }
    
    /** @inheritDoc */
    private override function get_root():ConcreteTexture { return __parent.root; }
    
    /** @inheritDoc */
    private override function get_format():Context3DTextureFormat { return __parent.format; }
    
    /** @inheritDoc */
    private override function get_width():Float { return __width; }
    
    /** @inheritDoc */
    private override function get_height():Float { return __height; }
    
    /** @inheritDoc */
    private override function get_nativeWidth():Float { return __width * scale; }
    
    /** @inheritDoc */
    private override function get_nativeHeight():Float { return __height * scale; }
    
    /** @inheritDoc */
    private override function get_mipMapping():Bool { return __parent.mipMapping; }
    
    /** @inheritDoc */
    private override function get_premultipliedAlpha():Bool { return __parent.premultipliedAlpha; }
    
    /** @inheritDoc */
    private override function get_scale():Float { return __parent.scale; }
    
    /** @inheritDoc */
    private override function get_repeat():Bool { return __parent.repeat; }
    
    /** @inheritDoc */
    private override function get_frame():Rectangle { return __frame; }
}
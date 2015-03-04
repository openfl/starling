// =================================================================================================
//
//	Starling Framework
//	Copyright 2011 Gamua OG. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

package starling.textures;
import flash.display3D.textures.TextureBase;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;
import haxe.ds.Vector;
import openfl.utils.Float32Array;
import openfl.display3D.Context3DTextureFormat;
import openfl.errors.ArgumentError;

import starling.utils.MatrixUtil;
import starling.utils.RectangleUtil;
import starling.utils.VertexData;

/** A SubTexture represents a section of another texture. This is achieved solely by 
 *  manipulation of texture coordinates, making the class very efficient. 
 *
 *  <p><em>Note that it is OK to create subtextures of subtextures.</em></p>
 */
class SubTexture extends Texture
{
    private var mParent:Texture;
    private var mOwnsParent:Bool;
    private var mFrame:Rectangle;
    private var mRotated:Bool;
    private var mWidth:Float;
    private var mHeight:Float;
    private var mTransformationMatrix:Matrix;
    
    /** Helper object. */
    private static var sTexCoords:Point = new Point();
    private static var sMatrix:Matrix = new Matrix();
    
    /** Creates a new subtexture containing the specified region of a parent texture.
     *
     *  @param parentTexture: The texture you want to create a SubTexture from.
     *  @param region:  The region of the parent texture that the SubTexture will show
     *                  (in points).
     *  @param ownsParent: if true, the parent texture will be disposed automatically
     *                  when the subtexture is disposed.
     *  @param frame:   If the texture was trimmed, the frame rectangle can be used to restore
     *                  the trimmed area.
     *  @param rotated: If true, the SubTexture will show the parent region rotated by
     *                  90 degrees (CCW).
     */
    public function new(parentTexture:Texture, region:Rectangle,
                               ownsParent:Bool=false, frame:Rectangle=null,
                               rotated:Bool=false)
    {
        super();
        // TODO: in a future version, the order of arguments of this constructor should
        //       be fixed ('ownsParent' at the very end).
        
        if (region == null)
            region = new Rectangle(0, 0, parentTexture.width, parentTexture.height);
        
        mParent = parentTexture;
        mFrame = frame != null ? frame.clone() : null;
        mOwnsParent = ownsParent;
        mRotated = rotated;
        mWidth  = rotated ? region.height : region.width;
        mHeight = rotated ? region.width  : region.height;
        mTransformationMatrix = new Matrix();
        
        if (rotated)
        {
            mTransformationMatrix.translate(0, -1);
            mTransformationMatrix.rotate(Math.PI / 2.0);
        }
        
        mTransformationMatrix.scale(region.width  / mParent.width,
                                    region.height / mParent.height);
        mTransformationMatrix.translate(region.x / mParent.width,
                                        region.y / mParent.height);
    }
    
    /** Disposes the parent texture if this texture owns it. */
    public override function dispose():Void
    {
        if (mOwnsParent) mParent.dispose();
        super.dispose();
    }
    
    /** @inheritDoc */
    public override function adjustVertexData(vertexData:VertexData, vertexID:Int, count:Int):Void
    {
        var startIndex:Int = vertexID * VertexData.ELEMENTS_PER_VERTEX + VertexData.TEXCOORD_OFFSET;
        var stride:Int = VertexData.ELEMENTS_PER_VERTEX - 2;
        
        adjustTexCoords(vertexData.rawData, startIndex, stride, count);
        
        if (mFrame != null)
        {
            if (count != 4)
                throw new ArgumentError("Textures with a frame can only be used on quads");
            
            var deltaRight:Float  = mFrame.width  + mFrame.x - mWidth;
            var deltaBottom:Float = mFrame.height + mFrame.y - mHeight;
            
            vertexData.translateVertex(vertexID,     -mFrame.x, -mFrame.y);
            vertexData.translateVertex(vertexID + 1, -deltaRight, -mFrame.y);
            vertexData.translateVertex(vertexID + 2, -mFrame.x, -deltaBottom);
            vertexData.translateVertex(vertexID + 3, -deltaRight, -deltaBottom);
        }
    }

    /** @inheritDoc */
    public override function adjustTexCoords(texCoords:Float32Array,
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
            sMatrix.concat(texture.mTransformationMatrix);
            texture = Std.is(texture.parent, SubTexture) ? cast texture.parent : null;
        }
        
        //for (var i:Int=startIndex; i<endIndex; i += 2 + stride)
        var i:Int = startIndex;
        while(i<endIndex)
        {
            u = texCoords[    i   ];
            v = texCoords[Std.int(i+1)];
            
            MatrixUtil.transformCoords(sMatrix, u, v, sTexCoords);
            
            texCoords[    i   ] = sTexCoords.x;
            texCoords[Std.int(i + 1)] = sTexCoords.y;

            i += 2 + stride;
        }
    }
    
    /** The texture which the subtexture is based on. */ 
    public var parent(get, never):Texture;
    private function get_parent():Texture { return mParent; }
    
    /** Indicates if the parent texture is disposed when this object is disposed. */
    public var ownsParent(get, never):Bool;
    private function get_ownsParent():Bool { return mOwnsParent; }
    
    /** If true, the SubTexture will show the parent region rotated by 90 degrees (CCW). */
    public var rotated(get, never):Bool;
    private function get_rotated():Bool { return mRotated; }

    /** The clipping rectangle, which is the region provided on initialization 
     *  scaled into [0.0, 1.0]. */
    public var clipping(get, never):Rectangle;
    private function get_clipping():Rectangle
    {
        var topLeft:Point = new Point();
        var bottomRight:Point = new Point();
        
        MatrixUtil.transformCoords(mTransformationMatrix, 0.0, 0.0, topLeft);
        MatrixUtil.transformCoords(mTransformationMatrix, 1.0, 1.0, bottomRight);
        
        var clipping:Rectangle = new Rectangle(topLeft.x, topLeft.y,
            bottomRight.x - topLeft.x, bottomRight.y - topLeft.y);
        
        RectangleUtil.normalize(clipping);
        return clipping;
    }
    
    /** The matrix that is used to transform the texture coordinates into the coordinate
     *  space of the parent texture (used internally by the "adjust..."-methods).
     *
     *  <p>CAUTION: not a copy, but the actual object! Do not modify!</p> */
    public var transformationMatrix(get, never):Matrix;
    private function get_transformationMatrix():Matrix { return mTransformationMatrix; }
    
    /** @inheritDoc */
    public override function get_base():TextureBase { return mParent.base; }
    
    /** @inheritDoc */
    public override function get_root():ConcreteTexture { return mParent.root; }
    
    /** @inheritDoc */
    public override function get_format():Context3DTextureFormat { return mParent.format; }
    
    /** @inheritDoc */
    public override function get_width():Float { return mWidth; }
    
    /** @inheritDoc */
    public override function get_height():Float { return mHeight; }
    
    /** @inheritDoc */
    public override function get_nativeWidth():Float { return mWidth * scale; }
    
    /** @inheritDoc */
    public override function get_nativeHeight():Float { return mHeight * scale; }
    
    /** @inheritDoc */
    public override function get_mipMapping():Bool { return mParent.mipMapping; }
    
    /** @inheritDoc */
    public override function get_premultipliedAlpha():Bool { return mParent.premultipliedAlpha; }
    
    /** @inheritDoc */
    public override function get_scale():Float { return mParent.scale; }
    
    /** @inheritDoc */
    public override function get_repeat():Bool { return mParent.repeat; }
    
    /** @inheritDoc */
    public override function get_frame():Rectangle { return mFrame; }
}
// =================================================================================================
//
//	Starling Framework
//	Copyright 2011 Gamua OG. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

package starling.core;
import openfl.display3D.Context3DBlendFactor;
import openfl.display3D.shaders.AGLSLShaderUtils;
import starling.utils.TextureUtils;

import openfl.display3D.Context3D;
import openfl.display3D.Context3DProgramType;
import openfl.display3D.Context3DTextureFormat;
import openfl.display3D.Program3D;
import openfl.geom.Matrix;
import openfl.geom.Matrix3D;
import openfl.geom.Point;
import openfl.geom.Rectangle;

import starling.display.BlendMode;
import starling.display.DisplayObject;
import starling.display.Quad;
import starling.display.QuadBatch;
import starling.errors.MissingContextError;
import starling.textures.Texture;
import starling.textures.TextureSmoothing;
import starling.utils.Color;
import starling.utils.MatrixUtil;
import starling.utils.RectangleUtil;

/** A class that contains helper methods simplifying Stage3D rendering.
 *
 *  A RenderSupport instance is passed to any "render" method of display objects. 
 *  It allows manipulation of the current transformation matrix (similar to the matrix 
 *  manipulation methods of OpenGL 1.x) and other helper methods.
 */
class RenderSupport
{
    // members
    
    private var mProjectionMatrix:Matrix;
    private var mModelViewMatrix:Matrix;
    private var mMvpMatrix:Matrix;
    private var mMvpMatrix3D:Matrix3D;
    private var mMatrixStack:Array<Matrix>;
    private var mMatrixStackSize:Int;
    
    private var mDrawCount:Int;
    private var mBlendMode:String;
    private var mRenderTarget:Texture;
    
    private var mClipRectStack:Array<Rectangle>;
    private var mClipRectStackSize:Int;
    
    private var mQuadBatches:Array<QuadBatch>;
    private var mCurrentQuadBatchID:Int;
    
    /** helper objects */
    private static var sPoint:Point = new Point();
    private static var sClipRect:Rectangle = new Rectangle();
    private static var sBufferRect:Rectangle = new Rectangle();
    private static var sScissorRect:Rectangle = new Rectangle();
    
    // construction
    
    /** Creates a new RenderSupport object with an empty matrix stack. */
    public function new()
    {
        mProjectionMatrix = new Matrix();
        mModelViewMatrix = new Matrix();
        mMvpMatrix = new Matrix();
        mMvpMatrix3D = new Matrix3D();
        mMatrixStack = new Array<Matrix>();
        mMatrixStackSize = 0;
        mDrawCount = 0;
        mRenderTarget = null;
        mBlendMode = BlendMode.NORMAL;
        mClipRectStack = new Array<Rectangle>();
        mClipRectStackSize = 0;
        
        mCurrentQuadBatchID = 0;
        mQuadBatches = [new QuadBatch()];
        
        loadIdentity();
        setOrthographicProjection(0, 0, 400, 300);
    }
    
    /** Disposes all quad batches. */
    public function dispose():Void
    {
        for(quadBatch in mQuadBatches)
            quadBatch.dispose();
    }
    
    // matrix manipulation
    
    /** Sets up the projection matrix for ortographic 2D rendering. */
    public function setOrthographicProjection(x:Float, y:Float, width:Float, height:Float):Void
    {
        mProjectionMatrix.setTo(2.0/width, 0, 0, -2.0/height, 
            -(2*x + width) / width, (2*y + height) / height);
        
        applyClipRect();
    }
    
    /** Changes the modelview matrix to the identity matrix. */
    public function loadIdentity():Void
    {
        mModelViewMatrix.identity();
    }
    
    /** Prepends a translation to the modelview matrix. */
    public function translateMatrix(dx:Float, dy:Float):Void
    {
        MatrixUtil.prependTranslation(mModelViewMatrix, dx, dy);
    }
    
    /** Prepends a rotation (angle in radians) to the modelview matrix. */
    public function rotateMatrix(angle:Float):Void
    {
        MatrixUtil.prependRotation(mModelViewMatrix, angle);
    }
    
    /** Prepends an incremental scale change to the modelview matrix. */
    public function scaleMatrix(sx:Float, sy:Float):Void
    {
        MatrixUtil.prependScale(mModelViewMatrix, sx, sy);
    }
    
    /** Prepends a matrix to the modelview matrix by multiplying it with another matrix. */
    public function prependMatrix(matrix:Matrix):Void
    {
        MatrixUtil.prependMatrix(mModelViewMatrix, matrix);
    }
    
    /** Prepends translation, scale and rotation of an object to the modelview matrix. */
    public function transformMatrix(object:DisplayObject):Void
    {
        MatrixUtil.prependMatrix(mModelViewMatrix, object.transformationMatrix);
    }
    
    /** Pushes the current modelview matrix to a stack from which it can be restored later. */
    public function pushMatrix():Void
    {
        if (mMatrixStack.length < mMatrixStackSize + 1)
            mMatrixStack.push(new Matrix());
        
        mMatrixStack[Std.int(mMatrixStackSize++)].copyFrom(mModelViewMatrix);
    }
    
    /** Restores the modelview matrix that was last pushed to the stack. */
    public function popMatrix():Void
    {
        mModelViewMatrix.copyFrom(mMatrixStack[Std.int(--mMatrixStackSize)]);
    }
    
    /** Empties the matrix stack, resets the modelview matrix to the identity matrix. */
    public function resetMatrix():Void
    {
        mMatrixStackSize = 0;
        loadIdentity();
    }
    
    /** Prepends translation, scale and rotation of an object to a custom matrix. */
    public static function transformMatrixForObject(matrix:Matrix, object:DisplayObject):Void
    {
        MatrixUtil.prependMatrix(matrix, object.transformationMatrix);
    }
    
    /** Calculates the product of modelview and projection matrix. 
     *  CAUTION: Use with care! Each call returns the same instance. */
    public var mvpMatrix(get, never):Matrix;
    public function get_mvpMatrix():Matrix
    {
        mMvpMatrix.copyFrom(mModelViewMatrix);
        mMvpMatrix.concat(mProjectionMatrix);
        return mMvpMatrix;
    }
    
    /** Calculates the product of modelview and projection matrix and saves it in a 3D matrix. 
     *  CAUTION: Use with care! Each call returns the same instance. */
    public var mvpMatrix3D(get, never):Matrix3D;
    public function get_mvpMatrix3D():Matrix3D
    {
        return MatrixUtil.convertTo3D(mvpMatrix, mMvpMatrix3D);
    }
    
    /** Returns the current modelview matrix.
     *  CAUTION: Use with care! Each call returns the same instance. */
    public var modelViewMatrix(get, never):Matrix;
    public function get_modelViewMatrix():Matrix { return mModelViewMatrix; }
    
    /** Returns the current projection matrix.
     *  CAUTION: Use with care! Each call returns the same instance. */
    public var projectionMatrix(get, set):Matrix;
    public function get_projectionMatrix():Matrix { return mProjectionMatrix; }
    public function set_projectionMatrix(value:Matrix):Matrix 
    {
        mProjectionMatrix.copyFrom(value);
        applyClipRect();
        return mProjectionMatrix;
    }
    
    // blending
    
    /** Activates the current blend mode on the active rendering context. */
    public function applyBlendMode(premultipliedAlpha:Bool):Void
    {
        setBlendFactors(premultipliedAlpha, mBlendMode);
    }
    
    /** The blend mode to be used on rendering. To apply the factor, you have to manually call
     *  'applyBlendMode' (because the actual blend factors depend on the PMA mode). */
    public var blendMode(get, set):String;
    public function get_blendMode():String { return mBlendMode; }
    public function set_blendMode(value:String):String
    {
        if (value != BlendMode.AUTO) mBlendMode = value;
        return mBlendMode;
    }
    
    // render targets
    
    /** The texture that is currently being rendered into, or 'null' to render into the 
     *  back buffer. If you set a new target, it is immediately activated. */
    public var renderTarget(get, set):Texture;
    public function get_renderTarget():Texture { return mRenderTarget; }
    public function set_renderTarget(target:Texture):Texture 
    {
        setRenderTarget(target);
        return mRenderTarget;
    }

    /** Changes the the current render target.
     *  @param target       Either a texture or 'null' to render into the back buffer.
     *  @param antiAliasing Only supported for textures, beginning with AIR 13, and only on
     *                      Desktop. Values range from 0 (no antialiasing) to 4 (best quality).
     */
    public function setRenderTarget(target:Texture, antiAliasing:Int=0):Void
    {
        mRenderTarget = target;
        applyClipRect();
        
        if (target != null) Starling.current.context.setRenderToTexture(target.base, false, antiAliasing);
        else        Starling.current.context.setRenderToBackBuffer();
    }
    
    // clipping
    
    /** The clipping rectangle can be used to limit rendering in the current render target to
     *  a certain area. This method expects the rectangle in stage coordinates. Internally,
     *  it uses the 'scissorRectangle' of stage3D, which works with pixel coordinates. 
     *  Any pushed rectangle is intersected with the previous rectangle; the method returns
     *  that intersection. */ 
    public function pushClipRect(rectangle:Rectangle):Rectangle
    {
        if (mClipRectStack.length < mClipRectStackSize + 1)
            mClipRectStack.push(new Rectangle());
        
        mClipRectStack[mClipRectStackSize].copyFrom(rectangle);
        rectangle = mClipRectStack[mClipRectStackSize];
        
        // intersect with the last pushed clip rect
        if (mClipRectStackSize > 0)
            RectangleUtil.intersect(rectangle, mClipRectStack[mClipRectStackSize-1], 
                                    rectangle);
        
        ++mClipRectStackSize;
        applyClipRect();
        
        // return the intersected clip rect so callers can skip draw calls if it's empty
        return rectangle;
    }
    
    /** Restores the clipping rectangle that was last pushed to the stack. */
    public function popClipRect():Void
    {
        if (mClipRectStackSize > 0)
        {
            --mClipRectStackSize;
            applyClipRect();
        }
    }
    
    /** Updates the context3D scissor rectangle using the current clipping rectangle. This
     *  method is called automatically when either the render target, the projection matrix,
     *  or the clipping rectangle changes. */
    public function applyClipRect():Void
    {
        finishQuadBatch();
        
        var context:Context3D = Starling.current.context;
        if (context == null) return;
        
        if (mClipRectStackSize > 0)
        {
            var width:Int, height:Int;
            var rect:Rectangle = mClipRectStack[mClipRectStackSize-1];
            
            if (mRenderTarget != null)
            {
                width  = Std.int(mRenderTarget.root.nativeWidth);
                height = Std.int(mRenderTarget.root.nativeHeight);
            }
            else
            {
                width  = Starling.current.backBufferWidth;
                height = Starling.current.backBufferHeight;
            }
            
            // convert to pixel coordinates (matrix transformation ends up in range [-1, 1])
            MatrixUtil.transformCoords(mProjectionMatrix, rect.x, rect.y, sPoint);
            sClipRect.x = (sPoint.x * 0.5 + 0.5) * width;
            sClipRect.y = (0.5 - sPoint.y * 0.5) * height;
            
            MatrixUtil.transformCoords(mProjectionMatrix, rect.right, rect.bottom, sPoint);
            sClipRect.right  = (sPoint.x * 0.5 + 0.5) * width;
            sClipRect.bottom = (0.5 - sPoint.y * 0.5) * height;
            
            sBufferRect.setTo(0, 0, width, height);
            RectangleUtil.intersect(sClipRect, sBufferRect, sScissorRect);
            
            // an empty rectangle is not allowed, so we set it to the smallest possible size
            if (sScissorRect.width < 1 || sScissorRect.height < 1)
                sScissorRect.setTo(0, 0, 1, 1);
            
            context.setScissorRectangle(sScissorRect);
        }
        else
        {
            context.setScissorRectangle(null);
        }
    }
    
    // optimized quad rendering
    
    /** Adds a quad to the current batch of unrendered quads. If there is a state change,
     *  all previous quads are rendered at once, and the batch is reset. */
    public function batchQuad(quad:Quad, parentAlpha:Float, 
                              texture:Texture=null, smoothing:String=null):Void
    {
        if (mQuadBatches[mCurrentQuadBatchID].isStateChange(quad.tinted, parentAlpha, texture, 
                                                            smoothing, mBlendMode))
        {
            finishQuadBatch();
        }
        
        mQuadBatches[mCurrentQuadBatchID].addQuad(quad, parentAlpha, texture, smoothing, 
                                                  mModelViewMatrix, mBlendMode);
    }
    
    /** Adds a batch of quads to the current batch of unrendered quads. If there is a state 
     *  change, all previous quads are rendered at once. 
     *  
     *  <p>Note that you should call this method only for objects with a small number of quads 
     *  (we recommend no more than 16). Otherwise, the additional CPU effort will be more
     *  expensive than what you save by avoiding the draw call.</p> */
    public function batchQuadBatch(quadBatch:QuadBatch, parentAlpha:Float):Void
    {
        if (mQuadBatches[mCurrentQuadBatchID].isStateChange(
            quadBatch.tinted, parentAlpha, quadBatch.texture, quadBatch.smoothing, mBlendMode))
        {
            finishQuadBatch();
        }
        
        mQuadBatches[mCurrentQuadBatchID].addQuadBatch(quadBatch, parentAlpha, 
                                                       mModelViewMatrix, mBlendMode);
    }
    
    /** Renders the current quad batch and resets it. */
    public function finishQuadBatch():Void
    {
        var currentBatch:QuadBatch = mQuadBatches[mCurrentQuadBatchID];
        
        if (currentBatch.numQuads != 0)
        {
            currentBatch.renderCustom(mProjectionMatrix);
            currentBatch.reset();
            
            ++mCurrentQuadBatchID;
            ++mDrawCount;
            
            if (mQuadBatches.length <= mCurrentQuadBatchID)
                mQuadBatches.push(new QuadBatch());
        }
    }
    
    /** Resets matrix stack, blend mode, quad batch index, and draw count. */
    public function nextFrame():Void
    {
        resetMatrix();
        trimQuadBatches();
        
        mCurrentQuadBatchID = 0;
        mBlendMode = BlendMode.NORMAL;
        mDrawCount = 0;
    }

    /** Disposes redundant quad batches if the number of allocated batches is more than
     *  twice the number of used batches. Only executed when there are at least 16 batches. */
    private function trimQuadBatches():Void
    {
        var numUsedBatches:Int  = mCurrentQuadBatchID + 1;
        var numTotalBatches:Int = mQuadBatches.length;
        
        if (numTotalBatches >= 16 && numTotalBatches > 2*numUsedBatches)
        {
            var numToRemove:Int = numTotalBatches - numUsedBatches;
            for (i in 0 ... numToRemove)
                mQuadBatches.pop().dispose();
        }
    }
    
    // other helper methods
    
    /** Deprecated. Call 'setBlendFactors' instead. */
    public static function setDefaultBlendFactors(premultipliedAlpha:Bool):Void
    {
        setBlendFactors(premultipliedAlpha);
    }
    
    /** Sets up the blending factors that correspond with a certain blend mode. */
    public static function setBlendFactors(premultipliedAlpha:Bool, blendMode:String="normal"):Void
    {
        var blendFactors:Array<Context3DBlendFactor> = BlendMode.getBlendFactors(blendMode, premultipliedAlpha); 
        Starling.current.context.setBlendFactors(blendFactors[0], blendFactors[1]);
    }
    
    /** Clears the render context with a certain color and alpha value. */
    public static function _clear(rgb:UInt=0, alpha:Float=0.0):Void
    {
        Starling.current.context.clear(
            Color.getRed(rgb)   / 255.0, 
            Color.getGreen(rgb) / 255.0, 
            Color.getBlue(rgb)  / 255.0,
            alpha);
    }
    
    /** Clears the render context with a certain color and alpha value. */
    public function clear(rgb:UInt=0, alpha:Float=0.0):Void
    {
        Starling.current.context.clear(
            Color.getRed(rgb)   / 255.0, 
            Color.getGreen(rgb) / 255.0, 
            Color.getBlue(rgb)  / 255.0,
            alpha);
    }
    
    /** Assembles fragment- and vertex-shaders, cast(passed, Strings), to a Program3D. If you
     *  pass a 'resultProgram', it will be uploaded to that program; otherwise, a new program
     *  will be created on the current Stage3D context. */ 
    public static function assembleAgal(vertexShader:String, fragmentShader:String,
                                        resultProgram:Program3D=null):Program3D
    {
        if (resultProgram == null) 
        {
            var context:Context3D = Starling.current.context;
            if (context == null) throw new MissingContextError();
            resultProgram = context.createProgram();
        }
        
        resultProgram.upload(
            AGLSLShaderUtils.createShader(Context3DProgramType.VERTEX, vertexShader),
            AGLSLShaderUtils.createShader(Context3DProgramType.FRAGMENT, fragmentShader));
        
        return resultProgram;
    }
    
    /** Returns the flags that are required for AGAL texture lookup, 
     *  including the '&lt;' and '&gt;' delimiters. */
    public static function getTextureLookupFlags(format:String, mipMapping:Bool,
                                                 repeat:Bool=false,
                                                 smoothing:String="bilinear"):String
    {
        var options:Array<String> = ["2d", repeat ? "repeat" : "clamp"];
        
        if (format == "compressed")
            options.push("dxt1");
        else if (format == "compressedAlpha")
            options.push("dxt5");
        
        if (smoothing == TextureSmoothing.NONE)
        {
            options.push("nearest");
            options.push(mipMapping ? "mipnearest" : "mipnone");
        }
        else if (smoothing == TextureSmoothing.BILINEAR)
        {
            options.push("linear");
            options.push(mipMapping ? "mipnearest" : "mipnone");
        }
        else
        {
            options.push("linear");
            options.push(mipMapping ? "miplinear" : "mipnone");
        }
        
        return "<" + options.join(",") + ">";
    }
    
    // statistics
    
    /** Raises the draw count by a specific value. Call this method in custom render methods
     *  to keep the statistics display in sync. */
    public function raiseDrawCount(value:UInt=1):Void { mDrawCount += value; }
    
    /** Indicates the number of stage3D draw calls. */
    public var drawCount(get, never):Int;
    public function get_drawCount():Int { return mDrawCount; }
}
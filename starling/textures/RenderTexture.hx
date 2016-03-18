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
import flash.display3D.Context3D;
import flash.display3D.VertexBuffer3D;
import flash.display3D.textures.TextureBase;
import flash.geom.Matrix;
import flash.geom.Rectangle;
import openfl.display3D.Context3DTextureFormat;

import starling.core.RenderSupport;
import starling.core.Starling;
import starling.display.BlendMode;
import starling.display.DisplayObject;
import starling.display.Image;
import starling.errors.MissingContextError;
import starling.filters.FragmentFilter;
import starling.utils.SystemUtil;
//import starling.utils.execute;
import starling.utils.PowerOfTwo.getNextPowerOfTwo;

/** A RenderTexture is a dynamic texture onto which you can draw any display object.
 * 
 *  <p>After creating a render texture, just call the <code>drawObject</code> method to render 
 *  an object directly onto the texture. The object will be drawn onto the texture at its current
 *  position, adhering its current rotation, scale and alpha properties.</p> 
 *  
 *  <p>Drawing is done very efficiently, as it is happening directly in graphics memory. After 
 *  you have drawn objects onto the texture, the performance will be just like that of a normal 
 *  texture - no matter how many objects you have drawn.</p>
 *  
 *  <p>If you draw lots of objects at once, it is recommended to bundle the drawing calls in 
 *  a block via the <code>drawBundled</code> method, like shown below. That will speed it up 
 *  immensely, allowing you to draw hundreds of objects very quickly.</p>
 *  
 * 	<pre>
 *  renderTexture.drawBundled(function():void
 *  {
 *     for (var i:int=0; i&lt;numDrawings; ++i)
 *     {
 *         image.rotation = (2 &#42; Math.PI / numDrawings) &#42; i;
 *         renderTexture.draw(image);
 *     }   
 *  });
 *  </pre>
 *  
 *  <p>To erase parts of a render texture, you can use any display object like a "rubber" by
 *  setting its blending mode to "BlendMode.ERASE".</p>
 * 
 *  <p>Beware that render textures can't be restored when the Starling's render context is lost.
 *  </p>
 *
 *  <strong>Persistence</strong>
 *
 *  <p>Persistent render textures (see the 'persistent' flag in the constructor) are more
 *  expensive, because they might have to use two render buffers internally. Disable this
 *  parameter if you don't need that.</p>
 *
 *  <p>On modern hardware, you can make use of the static 'optimizePersistentBuffers'
 *  property to overcome the need for double buffering. Use this feature with care, though!</p>
 *
 */
class RenderTexture extends SubTexture
{
    inline private static var CONTEXT_POT_SUPPORT_KEY:String = "RenderTexture.supportsNonPotDimensions";
    inline private static var PMA:Bool = true;
    
    private var mActiveTexture:Texture;
    private var mBufferTexture:Texture;
    private var mHelperImage:Image;
    private var mDrawing:Bool;
    private var mBufferReady:Bool;
    private var mIsPersistent:Bool;
    private var mSupport:RenderSupport;
    
    /** helper object */
    private static var sClipRect:Rectangle = new Rectangle();
    
    /** Indicates if new persistent textures should use a single render buffer instead of
     *  the default double buffering approach. That's faster and requires less memory, but is
     *  not supported on all hardware.
     *
     *  <p>You can safely enable this property on all iOS and Desktop systems. On Android,
     *  it's recommended to enable it only on reasonably modern hardware, e.g. only when
     *  at least one of the 'Standard' profiles is supported.</p>
     *
     *  <p>Beware: this feature requires at least Flash/AIR version 15.</p>
     *
     *  @default false
     */
    public static var optimizePersistentBuffers:Bool = false;

    /** Creates a new RenderTexture with a certain size (in points). If the texture is
     *  persistent, the contents of the texture remains intact after each draw call, allowing
     *  you to use the texture just like a canvas. If it is not, it will be cleared before each
     *  draw call.
     *
     *  <p>Beware that persistence requires an additional texture buffer (i.e. the required
     *  memory is doubled). You can avoid that via 'optimizePersistentBuffers', though.</p>
     */
    public function new(width:Int, height:Int, persistent:Bool=true,
                                  scale:Float=-1, format:Context3DTextureFormat=null, repeat:Bool=false)
    {
        if (format == null) format = Context3DTextureFormat.BGRA;
        // TODO: when Adobe has fixed this bug on the iPad 1 (see 'supportsNonPotDimensions'),
        //       we can remove 'legalWidth/Height' and just pass on the original values.
        //
        // [Workaround]

        if (scale <= 0) scale = Starling.current.contentScaleFactor;

        var legalWidth:Float  = width;
        var legalHeight:Float = height;

        if (!supportsNonPotDimensions)
        {
            legalWidth  = getNextPowerOfTwo(Std.int(width  * scale)) / scale;
            legalHeight = getNextPowerOfTwo(Std.int(height * scale)) / scale;
        }

        // [/Workaround]

        mActiveTexture = Texture.empty(legalWidth, legalHeight, PMA, false, true, scale, format, repeat);
        mActiveTexture.root.onRestore = mActiveTexture.root.clear;
        
        super(mActiveTexture, new Rectangle(0, 0, width, height), true, null, false);
        
        var rootWidth:Float  = mActiveTexture.root.width;
        var rootHeight:Float = mActiveTexture.root.height;
        
        mIsPersistent = persistent;
        mSupport = new RenderSupport();
        mSupport.setProjectionMatrix(0, 0, rootWidth, rootHeight, width, height);
        
        if (persistent && (!optimizePersistentBuffers || !SystemUtil.supportsRelaxedTargetClearRequirement))
        {
            mBufferTexture = Texture.empty(legalWidth, legalHeight, PMA, false, true, scale, format, repeat);
            mBufferTexture.root.onRestore = mBufferTexture.root.clear;
            mHelperImage = new Image(mBufferTexture);
            mHelperImage.smoothing = TextureSmoothing.NONE; // solves some antialias-issues
        }
    }
    
    /** @inheritDoc */
    public override function dispose():Void
    {
        mSupport.dispose();
        mActiveTexture.dispose();
        
        if (isDoubleBuffered)
        {
            mBufferTexture.dispose();
            mHelperImage.dispose();
        }
        
        super.dispose();
    }
    
    /** Draws an object into the texture. Note that any filters on the object will currently
     *  be ignored.
     * 
     *  @param object       The object to draw.
     *  @param matrix       If 'matrix' is null, the object will be drawn adhering its 
     *                      properties for position, scale, and rotation. If it is not null,
     *                      the object will be drawn in the orientation depicted by the matrix.
     *  @param alpha        The object's alpha value will be multiplied with this value.
     *  @param antiAliasing Only supported beginning with AIR 13, and only on Desktop.
     *                      Values range from 0 (no antialiasing) to 4 (best quality).
     */
    public function draw(object:DisplayObject, matrix:Matrix=null, alpha:Float=1.0,
                         antiAliasing:Int=0):Void
    {
        if (object == null) return;
        
        if (mDrawing)
            render(object, matrix, alpha);
        else
            renderBundled(render, object, matrix, alpha, antiAliasing);
    }
    
    /** Bundles several calls to <code>draw</code> together in a block. This avoids buffer 
     *  switches and allows you to draw multiple objects into a non-persistent texture.
     *  Note that the 'antiAliasing' setting provided here overrides those provided in
     *  individual 'draw' calls.
     *  
     *  @param drawingBlock  a callback with the form: <pre>function():void;</pre>
     *  @param antiAliasing  Only supported beginning with AIR 13, and only on Desktop.
     *                       Values range from 0 (no antialiasing) to 4 (best quality). */
    public function drawBundled(drawingBlock:DisplayObject->Matrix->Float->Void, antiAliasing:Int=0):Void
    {
        renderBundled(drawingBlock, null, null, 1.0, antiAliasing);
    }
    
    private function render(object:DisplayObject, matrix:Matrix=null, alpha:Float=1.0):Void
    {
        var filter:FragmentFilter = object.filter;
        var mask:DisplayObject = object.mask;

        mSupport.loadIdentity();
        mSupport.blendMode = object.blendMode == BlendMode.AUTO ?
            BlendMode.NORMAL : object.blendMode;

        if (matrix != null) mSupport.prependMatrix(matrix);
        else        mSupport.transformMatrix(object);

        if (mask != null)   mSupport.pushMask(mask);

        if (filter != null) filter.render(object, mSupport, alpha);
        else        object.render(mSupport, alpha);

        if (mask != null)   mSupport.popMask();
    }
    
    private function renderBundled(renderBlock:DisplayObject->Matrix->Float->Void, object:DisplayObject=null,
                                   matrix:Matrix=null, alpha:Float=1.0,
                                   antiAliasing:Int=0):Void
    {
        var context:Context3D = Starling.current.context;
        if (context == null) throw new MissingContextError();
        if (!Starling.current.contextValid) return;

        // switch buffers
        if (isDoubleBuffered)
        {
            var tmpTexture:Texture = mActiveTexture;
            mActiveTexture = mBufferTexture;
            mBufferTexture = tmpTexture;
            mHelperImage.texture = mBufferTexture;
        }

        var previousRenderTarget:Texture = mSupport.renderTarget;
        
        // limit drawing to relevant area
        sClipRect.setTo(0, 0, mActiveTexture.width, mActiveTexture.height);

        mSupport.pushClipRect(sClipRect);
        mSupport.setRenderTarget(mActiveTexture, antiAliasing);
        
        if (isDoubleBuffered || !isPersistent || !mBufferReady)
            mSupport.clear();

        // draw buffer
        if (isDoubleBuffered && mBufferReady)
            mHelperImage.render(mSupport, 1.0);
        else
            mBufferReady = true;
        
        try
        {
            mDrawing = true;
            renderBlock(object, matrix, alpha);
        }
        //finally
        {
            mDrawing = false;
            mSupport.finishQuadBatch();
            mSupport.nextFrame();
            mSupport.renderTarget = previousRenderTarget;
            mSupport.popClipRect();
        }
    }
    
    /** Clears the render texture with a certain color and alpha value. Call without any
     *  arguments to restore full transparency. */
    public function clear(rgb:UInt=0, alpha:Float=0.0):Void
    {
        if (!Starling.current.contextValid) return;
        var previousRenderTarget:Texture = mSupport.renderTarget;

        mSupport.renderTarget = mActiveTexture;
        mSupport.clear(rgb, alpha);
        mSupport.renderTarget = previousRenderTarget;
        mBufferReady = true;
    }
    
    /** On the iPad 1 (and maybe other hardware?) clearing a non-POT RectangleTexture causes
     *  an error in the next "createVertexBuffer" call. Thus, we're forced to make this
     *  really ... elegant check here. */
    private var supportsNonPotDimensions(get, never):Bool;
    private function get_supportsNonPotDimensions():Bool
    {
        // TODO: Check if the device supports npot texture
        return true;
        //var target:Starling = Starling.current;
        //var context:Context3D = Starling.current.context;
        //var support:Dynamic = target.contextData[CONTEXT_POT_SUPPORT_KEY];
//
        //if (support == null)
        //{
            //if (target.profile != "baselineConstrained" && "createRectangleTexture" in context)
            //{
                //var texture:TextureBase;
                //var buffer:VertexBuffer3D;
//
                //try
                //{
                    //texture = context["createRectangleTexture"](2, 3, "bgra", true);
                    //context.setRenderToTexture(texture);
                    //context.clear();
                    //context.setRenderToBackBuffer();
                    //context.createVertexBuffer(1, 1);
                    //support = true;
                //}
                //catch (e:Error)
                //{
                    //support = false;
                //}
                ////finally
                //{
                    //if (texture) texture.dispose();
                    //if (buffer) buffer.dispose();
                //}
            //}
            //else
            //{
                //support = false;
            //}
//
            //target.contextData[CONTEXT_POT_SUPPORT_KEY] = support;
        //}

        //return support;
    }

    // properties

    /** Indicates if the render texture is using double buffering. This might be necessary for
     *  persistent textures, depending on the runtime version and the value of
     *  'forceDoubleBuffering'. */
    private var isDoubleBuffered(get, never):Bool;
    private function get_isDoubleBuffered():Bool { return mBufferTexture != null; }

    /** Indicates if the texture is persistent over multiple draw calls. */
    public var isPersistent(get, never):Bool;
    public function get_isPersistent():Bool { return mIsPersistent; }
    
    /** @inheritDoc */
    public override function get_base():TextureBase { return mActiveTexture.base; }
    
    /** @inheritDoc */
    public override function get_root():ConcreteTexture { return mActiveTexture.root; }
}
// =================================================================================================
//
//	Starling Framework
//	Copyright Gamua GmbH. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

package starling.rendering;
import flash.display.Stage3D;
import flash.display3D.Context3D;
import flash.display3D.Context3DCompareMode;
import flash.display3D.Context3DRenderMode;
import flash.display3D.Context3DStencilAction;
import flash.display3D.Context3DTriangleFace;
import flash.display3D.textures.TextureBase;
import flash.errors.IllegalOperationError;
import flash.geom.Matrix;
import flash.geom.Matrix3D;
import flash.geom.Rectangle;
import flash.geom.Vector3D;
import flash.utils.Dictionary;
import flash.display3D.Context3DProfile;
import flash.errors.Error;
import starling.utils.ArrayUtil;
import starling.utils.SafeCast.safe_cast;

#if 0
import starling.core.starling_internal;
#end
import starling.display.BlendMode;
import starling.display.DisplayObject;
import starling.display.Mesh;
import starling.display.MeshBatch;
import starling.display.Quad;
import starling.events.Event;
import starling.textures.Texture;
import starling.utils.MathUtil;
import starling.utils.MatrixUtil;
import starling.utils.MeshSubset;
import starling.utils.Pool;
import starling.utils.RectangleUtil;
import starling.utils.RenderUtil;
import starling.utils.SystemUtil;

#if 0
use namespace starling_internal;
#end

#if flash
typedef WeakObjectMap<K, V> = haxe.ds.WeakMap<{}, V>;
#else
typedef WeakObjectMap<K, V> = haxe.ds.ObjectMap<{}, V>;
#end

/** A class that orchestrates rendering of all Starling display objects.
 *
 *  <p>A Starling instance contains exactly one 'Painter' instance that should be used for all
 *  rendering purposes. Each frame, it is passed to the render methods of all rendered display
 *  objects. To access it outside a render method, call <code>Starling.painter</code>.</p>
 *
 *  <p>The painter is responsible for drawing all display objects to the screen. At its
 *  core, it is a wrapper for many Context3D methods, but that's not all: it also provides
 *  a convenient state mechanism, supports masking and acts as middleman between display
 *  objects and renderers.</p>
 *
 *  <strong>The State Stack</strong>
 *
 *  <p>The most important concept of the Painter class is the state stack. A RenderState
 *  stores a combination of settings that are currently used for rendering, e.g. the current
 *  projection- and modelview-matrices and context-related settings. It can be accessed
 *  and manipulated via the <code>state</code> property. Use the methods
 *  <code>pushState</code> and <code>popState</code> to store a specific state and restore
 *  it later. That makes it easy to write rendering code that doesn't have any side effects.</p>
 *
 *  <listing>
 *  painter.pushState(); // save a copy of the current state on the stack
 *  painter.state.renderTarget = renderTexture;
 *  painter.state.transformModelviewMatrix(object.transformationMatrix);
 *  painter.state.alpha = 0.5;
 *  painter.prepareToDraw(); // apply all state settings at the render context
 *  drawSomething(); // insert Stage3D rendering code here
 *  painter.popState(); // restores previous state</listing>
 *
 *  @see RenderState
 */
class Painter
{
    // members

    private var _stage3D:Stage3D;
    private var _context:Context3D;
    private var _shareContext:Bool;
    private var _programs:Map<String, Program>;
    private var _data:Map<String, Dynamic>;
    private var _drawCount:Int;
    private var _frameID:UInt;
    private var _pixelSize:Float;
    private var _enableErrorChecking:Bool;
    private var _stencilReferenceValues:WeakObjectMap<{}, UInt>;
    private var _clipRectStack:Array<Rectangle>;
    private var _batchProcessor:BatchProcessor;
    private var _batchCache:BatchProcessor;
    private var _batchCacheExclusions:Array<DisplayObject>;

    private var _actualRenderTarget:TextureBase;
    private var _actualCulling:Null<Context3DTriangleFace>;
    private var _actualBlendMode:String;

    private var _backBufferWidth:Float;
    private var _backBufferHeight:Float;
    private var _backBufferScaleFactor:Float;

    private var _state:RenderState;
    private var _stateStack:Array<RenderState>;
    private var _stateStackPos:Int;
    private var _stateStackLength:Int;

    // helper objects
    private static var sMatrix:Matrix = new Matrix();
    private static var sPoint3D:Vector3D = new Vector3D();
    private static var sClipRect:Rectangle = new Rectangle();
    private static var sBufferRect:Rectangle = new Rectangle();
    private static var sScissorRect:Rectangle = new Rectangle();
    private static var sMeshSubset:MeshSubset = new MeshSubset();

    // construction
    
    /** Creates a new Painter object. Normally, it's not necessary to create any custom
     *  painters; instead, use the global painter found on the Starling instance. */
    public function new(stage3D:Stage3D)
    {
        _stage3D = stage3D;
        _stage3D.addEventListener(Event.CONTEXT3D_CREATE, onContextCreated, false, 10, true);
        _context = _stage3D.context3D;
        _shareContext = _context != null && _context.driverInfo != "Disposed";
        _backBufferWidth  = _context != null ? _context.backBufferWidth  : 0;
        _backBufferHeight = _context != null ? _context.backBufferHeight : 0;
        _backBufferScaleFactor = _pixelSize = 1.0;
        _stencilReferenceValues = new WeakObjectMap();
        _clipRectStack = new Array<Rectangle>();
        _programs = new Map();
        _data = new Map();

        _batchProcessor = new BatchProcessor();
        _batchProcessor.onBatchComplete = drawBatch;

        _batchCache = new BatchProcessor();
        _batchCache.onBatchComplete = drawBatch;
        _batchCacheExclusions = new Array<DisplayObject>();

        _state = new RenderState();
        _state.onDrawRequired = finishMeshBatch;
        _stateStack = new Array<RenderState>();
        _stateStackPos = -1;
        _stateStackLength = 0;
    }
    
    /** Disposes all quad batches, programs, and - if it is not being shared -
     *  the render context. */
    public function dispose():Void
    {
        _batchProcessor.dispose();
        _batchCache.dispose();

        if (!_shareContext)
        #if flash
            _context.dispose(false);
        #else
            _context.dispose();
        #end

        for (program in _programs)
            program.dispose();
    }

    // context handling

    /** Requests a context3D object from the stage3D object.
     *  This is called by Starling internally during the initialization process.
     *  You normally don't need to call this method yourself. (For a detailed description
     *  of the parameters, look at the documentation of the method with the same name in the
     *  "RenderUtil" class.)
     *
     *  @see starling.utils.RenderUtil
     */
    public function requestContext3D(renderMode:Context3DRenderMode, profile:Dynamic):Void
    {
        RenderUtil.requestContext3D(_stage3D, renderMode, profile);
    }

    private function onContextCreated(event:Dynamic):Void
    {
        _context = _stage3D.context3D;
        _context.enableErrorChecking = _enableErrorChecking;
        _actualBlendMode = null;
        _actualCulling = null;
    }

    /** Sets the viewport dimensions and other attributes of the rendering buffer.
     *  Starling will call this method internally, so most apps won't need to mess with this.
     *
     * @param viewPort                the position and size of the area that should be rendered
     *                                into, in pixels.
     * @param contentScaleFactor      only relevant for Desktop (!) HiDPI screens. If you want
     *                                to support high resolutions, pass the 'contentScaleFactor'
     *                                of the Flash stage; otherwise, '1.0'.
     * @param antiAlias               from 0 (none) to 16 (very high quality).
     * @param enableDepthAndStencil   indicates whether the depth and stencil buffers should
     *                                be enabled. Note that on AIR, you also have to enable
     *                                this setting in the app-xml (application descriptor);
     *                                otherwise, this setting will be silently ignored.
     */
    public function configureBackBuffer(viewPort:Rectangle, contentScaleFactor:Float,
                                        antiAlias:Int, enableDepthAndStencil:Bool):Void
    {
        enableDepthAndStencil = enableDepthAndStencil && SystemUtil.supportsDepthAndStencil;

        // Changing the stage3D position might move the back buffer to invalid bounds
        // temporarily. To avoid problems, we set it to the smallest possible size first.

        #if 0
        if (_context.profile == Context3DProfile.BASELINE_CONSTRAINED)
            _context.configureBackBuffer(32, 32, antiAlias, enableDepthAndStencil);
        #end

        // If supporting HiDPI mode would exceed the maximum buffer size
        // (can happen e.g in software mode), we stick to the low resolution.

        if (viewPort.width  * contentScaleFactor > _context.maxBackBufferWidth ||
            viewPort.height * contentScaleFactor > _context.maxBackBufferHeight)
        {
            contentScaleFactor = 1.0;
        }

        _stage3D.x = viewPort.x;
        _stage3D.y = viewPort.y;

        #if flash
        _context.configureBackBuffer(Std.int(viewPort.width), Std.int(viewPort.height),
                antiAlias, enableDepthAndStencil, contentScaleFactor != 1.0);
        #else
        _context.configureBackBuffer(Std.int(viewPort.width), Std.int(viewPort.height), antiAlias, enableDepthAndStencil);
        #end

        _backBufferWidth  = viewPort.width;
        _backBufferHeight = viewPort.height;
        _backBufferScaleFactor = contentScaleFactor;
    }

    // program management

    /** Registers a program under a certain name.
     *  If the name was already used, the previous program is overwritten. */
    public function registerProgram(name:String, program:Program):Void
    {
        deleteProgram(name);
        _programs[name] = program;
    }

    /** Deletes the program of a certain name. */
    public function deleteProgram(name:String):Void
    {
        var program:Program = getProgram(name);
        if (program != null)
        {
            program.dispose();
            _programs.remove(name);
        }
    }

    /** Returns the program registered under a certain name, or null if no program with
     *  this name has been registered. */
    public function getProgram(name:String):Program
    {
        var program:Program = _programs[name];
        if (program != null) return program;
        else return null;
    }

    /** Indicates if a program is registered under a certain name. */
    public function hasProgram(name:String):Bool
    {
        return _programs.exists(name);
    }

    // state stack

    /** Pushes the current render state to a stack from which it can be restored later.
     *
     *  <p>If you pass a BatchToken, it will be updated to point to the current location within
     *  the render cache. That way, you can later reference this location to render a subset of
     *  the cache.</p>
     */
    public function pushState(token:BatchToken=null):Void
    {
        _stateStackPos++;

        if (_stateStackLength < _stateStackPos + 1) _stateStack[_stateStackLength++] = new RenderState();
        if (token != null) _batchProcessor.fillToken(token);

        _stateStack[_stateStackPos].copyFrom(_state, false);
        @:privateAccess _stateStack[_stateStackPos]._projectionMatrix3D = null;
    }
    
    /** Pushes the current render state to a stack from which it can be restored later.
     */
    public function pushState3D(token:BatchToken=null):Void
    {
        _stateStackPos++;

        if (_stateStackLength < _stateStackPos + 1) _stateStack[_stateStackLength++] = new RenderState();
        if (token != null) _batchProcessor.fillToken(token);

        _stateStack[_stateStackPos].copyFrom(_state, true);
    }

    /** Modifies the current state with a transformation matrix, alpha factor, and blend mode.
     *
     *  @param transformationMatrix Used to transform the current <code>modelviewMatrix</code>.
     *  @param alphaFactor          Multiplied with the current alpha value.
     *  @param blendMode            Replaces the current blend mode; except for "auto", which
     *                              means the current value remains unchanged.
     */
    public function setStateTo(transformationMatrix:Matrix, alphaFactor:Float=1.0,
                               blendMode:String="auto"):Void
    {
        if (transformationMatrix != null) MatrixUtil.prependMatrix(@:privateAccess _state._modelviewMatrix, transformationMatrix);
        if (alphaFactor != 1.0) @:privateAccess _state._alpha *= alphaFactor;
        if (blendMode != BlendMode.AUTO) _state.blendMode = blendMode;
    }

    /** Restores the render state that was last pushed to the stack. If this changes
     *  blend mode, clipping rectangle, render target or culling, the current batch
     *  will be drawn right away.
     *
     *  <p>If you pass a BatchToken, it will be updated to point to the current location within
     *  the render cache. That way, you can later reference this location to render a subset of
     *  the cache.</p>
     */
    public function popState(token:BatchToken=null):Void
    {
        if (_stateStackPos < 0)
            throw new IllegalOperationError("Cannot pop empty state stack");

        _state.copyFrom(_stateStack[_stateStackPos], true); // -> might cause 'finishMeshBatch'
        _stateStackPos--;

        if (token != null) _batchProcessor.fillToken(token);
    }

    // masks

    /** Draws a display object into the stencil buffer, incrementing the buffer on each
     *  used pixel. The stencil reference value is incremented as well; thus, any subsequent
     *  stencil tests outside of this area will fail.
     *
     *  <p>If 'mask' is part of the display list, it will be drawn at its conventional stage
     *  coordinates. Otherwise, it will be drawn with the current modelview matrix.</p>
     *
     *  <p>As an optimization, this method might update the clipping rectangle of the render
     *  state instead of utilizing the stencil buffer. This is possible when the mask object
     *  is of type <code>starling.display.Quad</code> and is aligned parallel to the stage
     *  axes.</p>
     *
     *  <p>Note that masking breaks the render cache; the masked object must be redrawn anew
     *  in the next frame. If you pass <code>maskee</code>, the method will automatically
     *  call <code>excludeFromCache(maskee)</code> for you.</p>
     */
    public function drawMask(mask:DisplayObject, maskee:DisplayObject=null):Void
    {
        if (_context == null) return;

        finishMeshBatch();

        if (isRectangularMask(mask, sMatrix))
        {
            mask.getBounds(mask, sClipRect);
            RectangleUtil.getBounds(sClipRect, sMatrix, sClipRect);
            pushClipRect(sClipRect);
        }
        else
        {
            _context.setStencilActions(Context3DTriangleFace.FRONT_AND_BACK,
                Context3DCompareMode.EQUAL, Context3DStencilAction.INCREMENT_SATURATE);

            renderMask(mask);
            stencilReferenceValue++;

            _context.setStencilActions(Context3DTriangleFace.FRONT_AND_BACK,
                Context3DCompareMode.EQUAL, Context3DStencilAction.KEEP);
        }

        excludeFromCache(maskee);
    }

    /** Draws a display object into the stencil buffer, decrementing the
     *  buffer on each used pixel. This effectively erases the object from the stencil buffer,
     *  restoring the previous state. The stencil reference value will be decremented.
     *
     *  <p>Note: if the mask object meets the requirements of using the clipping rectangle,
     *  it will be assumed that this erase operation undoes the clipping rectangle change
     *  caused by the corresponding <code>drawMask()</code> call.</p>
     */
    public function eraseMask(mask:DisplayObject):Void
    {
        if (_context == null) return;

        finishMeshBatch();

        if (isRectangularMask(mask, sMatrix))
        {
            popClipRect();
        }
        else
        {
            _context.setStencilActions(Context3DTriangleFace.FRONT_AND_BACK,
                Context3DCompareMode.EQUAL, Context3DStencilAction.DECREMENT_SATURATE);

            renderMask(mask);
            stencilReferenceValue--;

            _context.setStencilActions(Context3DTriangleFace.FRONT_AND_BACK,
                Context3DCompareMode.EQUAL, Context3DStencilAction.KEEP);
        }
    }

    private function renderMask(mask:DisplayObject):Void
    {
        pushState();
        _state.alpha = 0.0;

        if (mask.stage != null)
            mask.getTransformationMatrix(null, _state.modelviewMatrix);
        else
            _state.transformModelviewMatrix(mask.transformationMatrix);

        mask.render(this);
        finishMeshBatch();

        popState();
    }

    private function pushClipRect(clipRect:Rectangle):Void
    {
        var stack:Array<Rectangle> = _clipRectStack;
        var stackLength:UInt = stack.length;
        var intersection:Rectangle = Pool.getRectangle();

        if (stackLength != 0)
            RectangleUtil.intersect(stack[stackLength - 1], clipRect, intersection);
        else
            intersection.copyFrom(clipRect);

        stack[stackLength] = intersection;
        _state.clipRect = intersection;
    }

    private function popClipRect():Void
    {
        var stack:Array<Rectangle> = _clipRectStack;
        var stackLength:UInt = stack.length;

        if (stackLength == 0)
            throw new Error("Trying to pop from empty clip rectangle stack");

        stackLength--;
        Pool.putRectangle(stack.pop());
        _state.clipRect = stackLength != 0 ? stack[stackLength - 1] : null;
    }

    /** Figures out if the mask can be represented by a scissor rectangle; this is possible
     *  if it's just a simple (untextured) quad that is parallel to the stage axes. The 'out'
     *  parameter will be filled with the transformation matrix required to move the mask into
     *  stage coordinates. */
    private function isRectangularMask(mask:DisplayObject, out:Matrix):Bool
    {
        var quad:Quad = safe_cast(mask, Quad);
        if (quad != null && !quad.is3D && quad.texture == null)
        {
            if (mask.stage != null) mask.getTransformationMatrix(null, out);
            else
            {
                out.copyFrom(mask.transformationMatrix);
                out.concat(_state.modelviewMatrix);
            }

            return (MathUtil.isEquivalent(out.a, 0) && MathUtil.isEquivalent(out.d, 0)) ||
                   (MathUtil.isEquivalent(out.b, 0) && MathUtil.isEquivalent(out.c, 0));
        }
        return false;
    }

    // mesh rendering
    
    /** Adds a mesh to the current batch of unrendered meshes. If the current batch is not
     *  compatible with the mesh, all previous meshes are rendered at once and the batch
     *  is cleared.
     *
     *  @param mesh    The mesh to batch.
     *  @param subset  The range of vertices to be batched. If <code>null</code>, the complete
     *                 mesh will be used.
     */
    public function batchMesh(mesh:Mesh, subset:MeshSubset=null):Void
    {
        _batchProcessor.addMesh(mesh, _state, subset);
    }

    /** Finishes the current mesh batch and prepares the next one. */
    public function finishMeshBatch():Void
    {
        _batchProcessor.finishBatch();
    }

    /** Completes all unfinished batches, cleanup procedures. */
    public function finishFrame():Void
    {
        if (_frameID % 99 == 0) // odd number -> alternating processors
            _batchProcessor.trim();

        _batchProcessor.finishBatch();
        swapBatchProcessors();
        _batchProcessor.clear();
        processCacheExclusions();
    }

    private function swapBatchProcessors():Void
    {
        var tmp:BatchProcessor = _batchProcessor;
        _batchProcessor = _batchCache;
        _batchCache = tmp;
    }

    private function processCacheExclusions():Void
    {
        var i:Int, length:Int = _batchCacheExclusions.length;
        for (i in 0 ... length) @:privateAccess _batchCacheExclusions[i].excludeFromCache();
        ArrayUtil.clear(_batchCacheExclusions);
    }

    /** Resets the current state, state stack, batch processor, stencil reference value,
     *  clipping rectangle, and draw count. Furthermore, depth testing is disabled. */
    public function nextFrame():Void
    {
        stencilReferenceValue = 0;
        ArrayUtil.clear(_clipRectStack);
        _drawCount = 0;
        _stateStackPos = -1;
        _batchProcessor.clear();
        _context.setDepthTest(false, Context3DCompareMode.ALWAYS);
        _state.reset();
    }

    /** Draws all meshes from the render cache between <code>startToken</code> and
     *  (but not including) <code>endToken</code>. The render cache contains all meshes
     *  rendered in the previous frame. */
    public function drawFromCache(startToken:BatchToken, endToken:BatchToken):Void
    {
        var meshBatch:MeshBatch;
        var subset:MeshSubset = sMeshSubset;

        if (!startToken.equals(endToken))
        {
            pushState();

            var i:Int = startToken.batchID;
            while(i <= endToken.batchID)
            {
                meshBatch = _batchCache.getBatchAt(i);
                subset.setTo(); // resets subset

                if (i == startToken.batchID)
                {
                    subset.vertexID = startToken.vertexID;
                    subset.indexID  = startToken.indexID;
                    subset.numVertices = meshBatch.numVertices - subset.vertexID;
                    subset.numIndices  = meshBatch.numIndices  - subset.indexID;
                }

                if (i == endToken.batchID)
                {
                    subset.numVertices = endToken.vertexID - subset.vertexID;
                    subset.numIndices  = endToken.indexID  - subset.indexID;
                }

                if (subset.numVertices != 0)
                {
                    _state.alpha = 1.0;
                    _state.blendMode = meshBatch.blendMode;
                    _batchProcessor.addMesh(meshBatch, _state, subset, true);
                }
                
                ++i;
            }

            popState();
        }
    }

    /** Removes all parts of the render cache past the given token. Beware that some display
     *  objects might still reference those parts of the cache! Only call it if you know
     *  exactly what you're doing. */
    public function rewindCacheTo(token:BatchToken):Void
    {
        _batchProcessor.rewindTo(token);
    }

    /** Prevents the object from being drawn from the render cache in the next frame.
     *  Different to <code>setRequiresRedraw()</code>, this does not indicate that the object
     *  has changed in any way, but just that it doesn't support being drawn from cache.
     *
     *  <p>Note that when a container is excluded from the render cache, its children will
     *  still be cached! This just means that batching is interrupted at this object when
     *  the display tree is traversed.</p>
     */
    public function excludeFromCache(object:DisplayObject):Void
    {
        if (object != null) _batchCacheExclusions[_batchCacheExclusions.length] = object;
    }

    private function drawBatch(meshBatch:MeshBatch):Void
    {
        pushState();

        state.blendMode = meshBatch.blendMode;
        state.modelviewMatrix.identity();
        state.alpha = 1.0;

        meshBatch.render(this);

        popState();
    }

    // helper methods

    /** Applies all relevant state settings to at the render context. This includes
     *  blend mode, render target and clipping rectangle. Always call this method before
     *  <code>context.drawTriangles()</code>.
     */
    public function prepareToDraw():Void
    {
        applyBlendMode();
        applyRenderTarget();
        applyClipRect();
        applyCulling();
    }

    /** Clears the render context with a certain color and alpha value. Since this also
     *  clears the stencil buffer, the stencil reference value is also reset to '0'. */
    public function clear(rgb:UInt=0, alpha:Float=0.0):Void
    {
        applyRenderTarget();
        stencilReferenceValue = 0;
        RenderUtil.clear(rgb, alpha);
    }

    /** Resets the render target to the back buffer and displays its contents. */
    public function present():Void
    {
        _state.renderTarget = null;
        _actualRenderTarget = null;
        _context.present();
    }

    private function applyBlendMode():Void
    {
        var blendMode:String = _state.blendMode;

        if (blendMode != _actualBlendMode)
        {
            BlendMode.get(_state.blendMode).activate();
            _actualBlendMode = blendMode;
        }
    }

    private function applyCulling():Void
    {
        var culling:Context3DTriangleFace = _state.culling;

        if (culling != _actualCulling)
        {
            _context.setCulling(culling);
            _actualCulling = culling;
        }
    }

    private function applyRenderTarget():Void
    {
        var target:TextureBase = _state.renderTargetBase;

        if (target != _actualRenderTarget)
        {
            if (target != null)
            {
                var antiAlias:Int  = _state.renderTargetAntiAlias;
                var depthAndStencil:Bool = _state.renderTargetSupportsDepthAndStencil;
                _context.setRenderToTexture(target, depthAndStencil, antiAlias);
            }
            else
                _context.setRenderToBackBuffer();

            _context.setStencilReferenceValue(stencilReferenceValue);
            _actualRenderTarget = target;
        }
    }

    private function applyClipRect():Void
    {
        var clipRect:Rectangle = _state.clipRect;

        if (clipRect != null)
        {
            var width:Int, height:Int;
            var projMatrix:Matrix3D = _state.projectionMatrix3D;
            var renderTarget:Texture = _state.renderTarget;

            if (renderTarget != null)
            {
                width  = Std.int(renderTarget.root.nativeWidth);
                height = Std.int(renderTarget.root.nativeHeight);
            }
            else
            {
                width  = backBufferWidth;
                height = backBufferHeight;
            }

            // convert to pixel coordinates (matrix transformation ends up in range [-1, 1])
            MatrixUtil.transformCoords3D(projMatrix, clipRect.x, clipRect.y, 0.0, sPoint3D);
            sPoint3D.project(); // eliminate w-coordinate
            sClipRect.x = (sPoint3D.x * 0.5 + 0.5) * width;
            sClipRect.y = (0.5 - sPoint3D.y * 0.5) * height;

            MatrixUtil.transformCoords3D(projMatrix, clipRect.right, clipRect.bottom, 0.0, sPoint3D);
            sPoint3D.project(); // eliminate w-coordinate
            sClipRect.right  = (sPoint3D.x * 0.5 + 0.5) * width;
            sClipRect.bottom = (0.5 - sPoint3D.y * 0.5) * height;

            sBufferRect.setTo(0, 0, width, height);
            RectangleUtil.intersect(sClipRect, sBufferRect, sScissorRect);

            // an empty rectangle is not allowed, so we set it to the smallest possible size
            if (sScissorRect.width < 1 || sScissorRect.height < 1)
                sScissorRect.setTo(0, 0, 1, 1);

            _context.setScissorRectangle(sScissorRect);
        }
        else
        {
            _context.setScissorRectangle(null);
        }
    }

    // properties
    
    /** Indicates the number of stage3D draw calls. */
    public var drawCount(get, set):Int;
    @:noCompletion private function get_drawCount():Int { return _drawCount; }
    @:noCompletion private function set_drawCount(value:Int):Int { return _drawCount = value; }

    /** The current stencil reference value of the active render target. This value
     *  is typically incremented when drawing a mask and decrementing when erasing it.
     *  The painter keeps track of one stencil reference value per render target.
     *  Only change this value if you know what you're doing!
     */
    public var stencilReferenceValue(get, set):UInt;
    @:noCompletion private function get_stencilReferenceValue():UInt
    {
        var key:Dynamic = _state.renderTarget != null ? _state.renderTargetBase : this;
        var value:Null<UInt> = _stencilReferenceValues.get(key);
        if (value != null) return value;
        else return 0;
    }

    @:noCompletion private function set_stencilReferenceValue(value:UInt):UInt
    {
        var key:Dynamic = _state.renderTarget != null ? _state.renderTargetBase : this;
        _stencilReferenceValues.set(key, value);

        if (contextValid)
            _context.setStencilReferenceValue(value);
        return value;
    }

    /** The current render state, containing some of the context settings, projection- and
     *  modelview-matrix, etc. Always returns the same instance, even after calls to "pushState"
     *  and "popState".
     *
     *  <p>When you change the current RenderState, and this change is not compatible with
     *  the current render batch, the batch will be concluded right away. Thus, watch out
     *  for changes of blend mode, clipping rectangle, render target or culling.</p>
     */
    public var state(get, never):RenderState;
    @:noCompletion private function get_state():RenderState { return _state; }

    /** The Stage3D instance this painter renders into. */
    public var stage3D(get, never):Stage3D;
    @:noCompletion private function get_stage3D():Stage3D { return _stage3D; }

    /** The Context3D instance this painter renders into. */
    public var context(get, never):Context3D;
    @:noCompletion private function get_context():Context3D { return _context; }

    /** The number of frames that have been rendered with the current Starling instance. */
    public var frameID(get, set):UInt;
    @:noCompletion private function get_frameID():UInt { return _frameID; }
    @:noCompletion private function set_frameID(value:UInt):UInt { return _frameID = value; }

    /** The size (in points) that represents one pixel in the back buffer. */
    public var pixelSize(get, set):Float;
    @:noCompletion private function get_pixelSize():Float { return _pixelSize; }
    @:noCompletion private function set_pixelSize(value:Float):Float { return _pixelSize = value; }

    /** Indicates if another Starling instance (or another Stage3D framework altogether)
     *  uses the same render context. @default false */
    public var shareContext(get, set):Bool;
    @:noCompletion private function get_shareContext():Bool { return _shareContext; }
    @:noCompletion private function set_shareContext(value:Bool):Bool { return _shareContext = value; }

    /** Indicates if Stage3D render methods will report errors. Activate only when needed,
     *  as this has a negative impact on performance. @default false */
    public var enableErrorChecking(get, set):Bool;
    @:noCompletion private function get_enableErrorChecking():Bool { return _enableErrorChecking; }
    @:noCompletion private function set_enableErrorChecking(value:Bool):Bool
    {
        _enableErrorChecking = value;
        if (_context != null) _context.enableErrorChecking = value;
        return value;
    }

    /** Returns the current width of the back buffer. In most cases, this value is in pixels;
     *  however, if the app is running on an HiDPI display with an activated
     *  'supportHighResolutions' setting, you have to multiply with 'backBufferPixelsPerPoint'
     *  for the actual pixel count. Alternatively, use the Context3D-property with the
     *  same name: it will return the exact pixel values. */
    public var backBufferWidth(get, never):Int;
    @:noCompletion private function get_backBufferWidth():Int { return Std.int(_backBufferWidth); }

    /** Returns the current height of the back buffer. In most cases, this value is in pixels;
     *  however, if the app is running on an HiDPI display with an activated
     *  'supportHighResolutions' setting, you have to multiply with 'backBufferPixelsPerPoint'
     *  for the actual pixel count. Alternatively, use the Context3D-property with the
     *  same name: it will return the exact pixel values. */
    public var backBufferHeight(get, never):Int;
    @:noCompletion private function get_backBufferHeight():Int { return Std.int(_backBufferHeight); }

    /** The number of pixels per point returned by the 'backBufferWidth/Height' properties.
     *  Except for desktop HiDPI displays with an activated 'supportHighResolutions' setting,
     *  this will always return '1'. */
    public var backBufferScaleFactor(get, never):Float;
    @:noCompletion private function get_backBufferScaleFactor():Float { return _backBufferScaleFactor; }

    /** Indicates if the Context3D object is currently valid (i.e. it hasn't been lost or
     *  disposed). */
    public var contextValid(get, never):Bool;
    @:noCompletion private function get_contextValid():Bool
    {
        #if flash
        if (_context != null)
        {
            var driverInfo:String = _context.driverInfo;
            return driverInfo != null && driverInfo != "" && driverInfo != "Disposed";
        }
        else return false;
        #else
        return _context != null;
        #end
    }

    /** The Context3D profile of the current render context, or <code>null</code>
     *  if the context has not been created yet. */
    public var profile(get, never):Context3DProfile;
    @:noCompletion private function get_profile():Context3DProfile
    {
        if (_context != null) return #if flash cast #end _context.profile;
        else return null;
    }

    /** A dictionary that can be used to save custom data related to the render context.
     *  If you need to share data that is bound to the render context (e.g. textures),
     *  use this dictionary instead of creating a static class variable.
     *  That way, the data will be available for all Starling instances that use this
     *  painter / stage3D / context. */
    public var sharedData(get, never):Map<String, Dynamic>;
    @:noCompletion private function get_sharedData():Map<String, Dynamic> { return _data; }
}
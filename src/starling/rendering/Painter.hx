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

import openfl.display.Stage3D;
import openfl.display3D.Context3D;
import openfl.display3D.Context3DCompareMode;
import openfl.display3D.Context3DStencilAction;
import openfl.display3D.Context3DTriangleFace;
import openfl.display3D.textures.TextureBase;
import openfl.errors.Error;
import openfl.errors.IllegalOperationError;
import openfl.geom.Matrix;
import openfl.geom.Matrix3D;
import openfl.geom.Rectangle;
import openfl.geom.Vector3D;
import openfl.utils.Dictionary;
import openfl.utils.Object;
import openfl.Vector;

import starling.core.Starling;
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

/** A class that orchestrates rendering of all Starling display objects.
 *
 *  <p>A Starling instance contains exactly one 'Painter' instance that should be used for all
 *  rendering purposes. Each frame, it is passed to the render methods of all rendered display
 *  objects. To access it outside a render method, call <code>Starling.painter</code>.</p>
 *
 *  <p>The painter is responsible for drawing all display objects to the screen. At its
 *  core, it is a wrapper for many Context3D methods, but that's not all: it also provides
 *  a convenient state mechanism, supports masking and acts as __iddleman between display
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
    // the key for the programs stored in 'sharedData'
    private static inline var PROGRAM_DATA_NAME:String = "starling.rendering.Painter.Programs";

    /** The value with which the stencil buffer will be cleared,
        *  and the default reference value used for stencil tests. */
    public static var DEFAULT_STENCIL_VALUE:UInt = 127;

    // members

    private var _stage3D:Stage3D;
    private var _context:Context3D;
    private var _shareContext:Bool;
    private var _drawCount:Int;
    private var _frameID:UInt = 0;
    private var _pixelSize:Float;
    private var _enableErrorChecking:Bool;
    private var _stencilReferenceValues:Dictionary<Object, UInt>;
    private var _clipRectStack:Vector<Rectangle>;
    private var _batchCacheExclusions:Vector<DisplayObject>;
    private var _batchTrimInterval:Int = 250;

    private var _batchProcessor:BatchProcessor;
    private var _batchProcessorCurr:BatchProcessor; // current  processor
    private var _batchProcessorPrev:BatchProcessor; // previous processor (cache)
    private var _batchProcessorSpec:BatchProcessor; // special  processor (no cache)

    private var _actualRenderTarget:TextureBase;
    private var _actualRenderTargetOptions:UInt;
    private var _actualCulling:String;
    private var _actualBlendMode:String;
    private var _actualDepthMask:Bool;
    private var _actualDepthTest:String;

    private var _backBufferWidth:Int;
    private var _backBufferHeight:Int;
    private var _backBufferScaleFactor:Float;

    private var _state:RenderState;
    private var _stateStack:Vector<RenderState>;
    private var _stateStackPos:Int;
    private var _stateStackLength:Int;

    // shared data
    private static var sSharedData:Map<Stage3D, Map<String, Dynamic>> = new Map();

    // helper objects
    private static var sMatrix:Matrix = new Matrix();
    private static var sPoint3D:Vector3D = new Vector3D();
    private static var sMatrix3D:Matrix3D = new Matrix3D();
    private static var sClipRect:Rectangle = new Rectangle();
    private static var sBufferRect:Rectangle = new Rectangle();
    private static var sScissorRect:Rectangle = new Rectangle();
    private static var sMeshSubset:MeshSubset = new MeshSubset();

    #if commonjs
    private static function __init__ () {
        
        untyped __js__ ("Object").defineProperties (Painter.prototype, {
            "drawCount": { get: untyped __js__ ("function () { return this.get_drawCount (); }"), set: untyped __js__ ("function (v) { return this.set_drawCount (v); }") },
            "stencilReferenceValue": { get: untyped __js__ ("function () { return this.get_stencilReferenceValue (); }"), set: untyped __js__ ("function (v) { return this.set_stencilReferenceValue (v); }") },
            "cacheEnabled": { get: untyped __js__ ("function () { return this.get_cacheEnabled (); }"), set: untyped __js__ ("function (v) { return this.set_cacheEnabled (v); }") },
            "state": { get: untyped __js__ ("function () { return this.get_state (); }") },
            "stage3D": { get: untyped __js__ ("function () { return this.get_stage3D (); }") },
            "context": { get: untyped __js__ ("function () { return this.get_context (); }") },
            "frameID": { get: untyped __js__ ("function () { return this.get_frameID (); }"), set: untyped __js__ ("function (v) { return this.set_frameID (v); }") },
            "pixelSize": { get: untyped __js__ ("function () { return this.get_pixelSize (); }"), set: untyped __js__ ("function (v) { return this.set_pixelSize (v); }") },
            "shareContext": { get: untyped __js__ ("function () { return this.get_shareContext (); }"), set: untyped __js__ ("function (v) { return this.set_shareContext (v); }") },
            "enableErrorChecking": { get: untyped __js__ ("function () { return this.get_enableErrorChecking (); }"), set: untyped __js__ ("function (v) { return this.set_enableErrorChecking (v); }") },
            "backBufferWidth": { get: untyped __js__ ("function () { return this.get_backBufferWidth (); }") },
            "backBufferHeight": { get: untyped __js__ ("function () { return this.get_backBufferHeight (); }") },
            "backBufferScaleFactor": { get: untyped __js__ ("function () { return this.get_backBufferScaleFactor (); }") },
            "contextValid": { get: untyped __js__ ("function () { return this.get_contextValid (); }") },
            "profile": { get: untyped __js__ ("function () { return this.get_profile (); }") },
            "sharedData": { get: untyped __js__ ("function () { return this.get_sharedData (); }") },
            //"programs": { get: untyped __js__ ("function () { return this.get_programs (); }") },
        });
        
    }
    #end

    // construction
    
    /** Creates a new Painter object. Normally, it's not necessary to create any custom
     *  painters; instead, use the global painter found on the Starling instance. */
    public function new(stage3D:Stage3D, sharedContext:Null<Bool>=null)
    {
        _stage3D = stage3D;
        _stage3D.addEventListener(Event.CONTEXT3D_CREATE, onContextCreated, false, 40, true);
        _context = _stage3D.context3D;
        
        if (sharedContext != null) _shareContext = sharedContext;
        else _shareContext = _context != null && _context.driverInfo != "Disposed";
        
        #if !flash
        if (!Reflect.hasField (@:privateAccess Starling.current.__nativeStage, "context3D") || Reflect.field (@:privateAccess Starling.current.__nativeStage, "context3D") == _context)
            _shareContext = false; // starling.mustAlwaysRender will also be forced to true
        #end
        
        _backBufferWidth  = _context != null ? _context.backBufferWidth  : 0;
        _backBufferHeight = _context != null ? _context.backBufferHeight : 0;
        _backBufferScaleFactor = _pixelSize = 1.0;
        _stencilReferenceValues = new Dictionary();
        _clipRectStack = new Vector<Rectangle>();

        _batchProcessorCurr = new BatchProcessor();
        _batchProcessorCurr.onBatchComplete = drawBatch;

        _batchProcessorPrev = new BatchProcessor();
        _batchProcessorPrev.onBatchComplete = drawBatch;

        _batchProcessorSpec = new BatchProcessor();
        _batchProcessorSpec.onBatchComplete = drawBatch;

        _batchProcessor = _batchProcessorCurr;
        _batchCacheExclusions = new Vector<DisplayObject>();

        _state = new RenderState();
        _state.onDrawRequired = finishMeshBatch;
        _stateStack = new Vector<RenderState>();
        _stateStackPos = -1;
        _stateStackLength = 0;
    }
    
    /** Disposes all mesh batches, programs, and - if it is not being shared -
     *  the render context. */
    public function dispose():Void
    {
        _batchProcessorCurr.dispose();
        _batchProcessorPrev.dispose();
        _batchProcessorSpec.dispose();

        if (!_shareContext)
        {
            if (_context != null) _context.dispose(false);
            sSharedData = new Map();
        }
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
    public function requestContext3D(renderMode:String, profile:Dynamic):Void
    {
        RenderUtil.requestContext3D(_stage3D, renderMode, profile);
    }

    private function onContextCreated(event:Dynamic):Void
    {
        _context = _stage3D.context3D;
        _context.enableErrorChecking = _enableErrorChecking;
    }

    /** Sets the viewport dimensions and other attributes of the rendering buffer.
     *  Starling will call this method internally, so most apps won't need to mess with this.
     *
     *  <p>Beware: if <code>shareContext</code> is enabled, the method will only update the
     *  painter's context-related information (like the size of the back buffer), but won't
     *  make any actual changes to the context.</p>
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
     * @param supportBrowserZoom      if enabled, zooming a website will adapt the size of
     *                                the back buffer.
     */
    public function configureBackBuffer(viewPort:Rectangle, contentScaleFactor:Float,
                                        antiAlias:Int, enableDepthAndStencil:Bool,
                                        supportBrowserZoom:Bool=false):Void
    {
        if (!_shareContext)
        {
            enableDepthAndStencil = enableDepthAndStencil && SystemUtil.supportsDepthAndStencil;

            // Changing the stage3D position might move the back buffer to invalid bounds
            // temporarily. To avoid problems, we set it to the smallest possible size first.

            if (_context.profile == "baselineConstrained")
                _context.configureBackBuffer(32, 32, antiAlias, enableDepthAndStencil);

            // If supporting HiDPI mode would exceed the maximum buffer size
            // (can happen e.g in software mode), we stick to the low resolution.

            if (viewPort.width  * contentScaleFactor > _context.maxBackBufferWidth ||
                viewPort.height * contentScaleFactor > _context.maxBackBufferHeight)
            {
                contentScaleFactor = 1.0;
            }

            _stage3D.x = viewPort.x;
            _stage3D.y = viewPort.y;

            _context.configureBackBuffer(Std.int(viewPort.width), Std.int(viewPort.height), antiAlias,
                enableDepthAndStencil, contentScaleFactor != 1.0 #if air, supportBrowserZoom #end);
        }

        _backBufferWidth  = Std.int(viewPort.width);
        _backBufferHeight = Std.int(viewPort.height);
        _backBufferScaleFactor = contentScaleFactor;
    }

    // program management

    /** Registers a program under a certain name.
     *  If the name was already used, the previous program is overwritten. */
    public function registerProgram(name:String, program:Program):Void
    {
        deleteProgram(name);
        programs[name] = program;
    }

    /** Deletes the program of a certain name. */
    public function deleteProgram(name:String):Void
    {
        var program:Program = getProgram(name);
        if (program != null)
        {
            program.dispose();
            programs.remove(name);
        }
    }

    /** Returns the program registered under a certain name, or null if no program with
     *  this name has been registered. */
    public function getProgram(name:String):Program
    {
        return programs[name];
    }

    /** Indicates if a program is registered under a certain name. */
    public function hasProgram(name:String):Bool
    {
        return programs.exists(name);
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

        _stateStack[_stateStackPos].copyFrom(_state);
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
        if (transformationMatrix != null) MatrixUtil.prependMatrix(_state._modelviewMatrix, transformationMatrix);
        if (alphaFactor != 1.0) _state._alpha *= alphaFactor;
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

        _state.copyFrom(_stateStack[_stateStackPos]); // -> might cause 'finishMeshBatch'
        _stateStackPos--;

        if (token != null) _batchProcessor.fillToken(token);
    }

    /** Restores the render state that was last pushed to the stack, but does NOT remove
     *  it from the stack. */
    public function restoreState():Void
    {
        if (_stateStackPos < 0)
            throw new IllegalOperationError("Cannot restore from empty state stack");

        _state.copyFrom(_stateStack[_stateStackPos]); // -> might cause 'finishMeshBatch'
    }

    /** Updates all properties of the given token so that it describes the current position
     *  within the render cache. */
    public function fillToken(token:BatchToken):Void
    {
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

        if (isRectangularMask(mask, maskee, sMatrix))
        {
            mask.getBounds(mask, sClipRect);
            RectangleUtil.getBounds(sClipRect, sMatrix, sClipRect);
            pushClipRect(sClipRect);
        }
        else
        {
            // In 'renderMask', we'll make sure the depth test always fails. Thus, the 3rd
            // parameter of 'setStencilActions' will always be ignored; the 4th is the one
            // that counts!

            if (maskee != null && maskee.maskInverted)
            {
                _context.setStencilActions(Context3DTriangleFace.FRONT_AND_BACK,
                    Context3DCompareMode.ALWAYS, Context3DStencilAction.KEEP,
                    Context3DStencilAction.DECREMENT_SATURATE);

                renderMask(mask);
            }
            else
            {
                _context.setStencilActions(Context3DTriangleFace.FRONT_AND_BACK,
                    Context3DCompareMode.EQUAL, Context3DStencilAction.KEEP,
                    Context3DStencilAction.INCREMENT_SATURATE);

                renderMask(mask);
                stencilReferenceValue++;
            }

            _context.setStencilActions(
                Context3DTriangleFace.FRONT_AND_BACK, Context3DCompareMode.EQUAL);
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
    public function eraseMask(mask:DisplayObject, maskee:DisplayObject=null):Void
    {
        if (_context == null) return;

        finishMeshBatch();

        if (isRectangularMask(mask, maskee, sMatrix))
        {
            popClipRect();
        }
        else
        {
            // In 'renderMask', we'll make sure the depth test always fails. Thus, the 3rd
            // parameter of 'setStencilActions' will always be ignored; the 4th is the one
            // that counts!

            if (maskee != null && maskee.maskInverted)
            {
                _context.setStencilActions(Context3DTriangleFace.FRONT_AND_BACK,
                    Context3DCompareMode.ALWAYS, Context3DStencilAction.KEEP,
                    Context3DStencilAction.INCREMENT_SATURATE);

                renderMask(mask);
            }
            else
            {
                _context.setStencilActions(Context3DTriangleFace.FRONT_AND_BACK,
                    Context3DCompareMode.EQUAL, Context3DStencilAction.KEEP,
                    Context3DStencilAction.DECREMENT_SATURATE);

                renderMask(mask);
                stencilReferenceValue--;
            }

            // restore default stencil action ("keep")

            _context.setStencilActions(
                Context3DTriangleFace.FRONT_AND_BACK, Context3DCompareMode.EQUAL);
        }
    }

    private function renderMask(mask:DisplayObject):Void
    {
        var matrix:Matrix = null;
        var matrix3D:Matrix3D = null;
        var wasCacheEnabled:Bool = cacheEnabled;

        pushState();
        cacheEnabled = false;
        _state.depthTest = Context3DCompareMode.NEVER; // depth test always fails ->
                                                        // color buffer won't be modified
        if (mask.stage != null)
        {
            _state.setModelviewMatricesToIdentity();

            if (mask.is3D) matrix3D = mask.getTransformationMatrix3D(null, sMatrix3D);
            else           matrix   = mask.getTransformationMatrix(null, sMatrix);
        }
        else
        {
            if (mask.is3D) matrix3D = mask.transformationMatrix3D;
            else           matrix   = mask.transformationMatrix;
        }

        if (matrix3D != null) _state.transformModelviewMatrix3D(matrix3D);
        else          _state.transformModelviewMatrix(matrix);

        mask.render(this);
        finishMeshBatch();

        cacheEnabled = wasCacheEnabled;
        popState();
    }

    private function pushClipRect(clipRect:Rectangle):Void
    {
        var stack:Vector<Rectangle> = _clipRectStack;
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
        var stack:Vector<Rectangle> = _clipRectStack;
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
    private function isRectangularMask(mask:DisplayObject, maskee:DisplayObject, out:Matrix):Bool
    {
        var quad:Quad = #if (haxe_ver < 4.2) Std.is #else Std.isOfType #end(mask, Quad) ? cast mask : null;
		var isInverted:Bool = maskee != null && maskee.maskInverted;
        var is3D:Bool = mask.is3D || (maskee != null && maskee.is3D && mask.stage == null);

        if (quad != null && !isInverted && !is3D && quad.texture == null)
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
    
    /** Indicate how often the internally used batches are being trimmed to save memory.
     *
     *  <p>While rendering, the internally used MeshBatches are used in a different way in each
     *  frame. To save memory, they should be trimmed every once in a while. This method defines
     *  how often that happens, if at all. (Default: enabled = true, interval = 250)</p>
     *
     *  @param enabled   If trimming happens at all. Only disable temporarily!
     *  @param interval  The number of frames between each trim operation.
     */
    public function enableBatchTrimming(enabled:Bool=true, interval:Int=250):Void
    {
        _batchTrimInterval = enabled ? interval : 0;
    }

    /** Completes all unfinished batches, cleanup procedures. */
    public function finishFrame():Void
    {
        if (_batchTrimInterval > 0)
        {
            var baseInterval:Int = _batchTrimInterval | 0x1; // odd number -> alternating processors
            var specInterval:Int = Std.int(_batchTrimInterval * 1.5);

            if (_frameID % baseInterval == 0) _batchProcessorCurr.trim();
            if (_frameID % specInterval == 0) _batchProcessorSpec.trim();
        }

        _batchProcessor.finishBatch();
        _batchProcessor = _batchProcessorSpec; // no cache between frames
        processCacheExclusions();
    }

    private function processCacheExclusions():Void
    {
        var i:Int, length:Int = _batchCacheExclusions.length;
        for (i in 0...length) _batchCacheExclusions[i].excludeFromCache();
        _batchCacheExclusions.length = 0;
    }

    /** Makes sure that the default context settings Starling relies on will be refreshed
        *  before the next 'draw' operation. This includes blend mode, culling, and depth test. */
    public function setupContextDefaults():Void
    {
        _actualBlendMode = null;
        _actualCulling = null;
        _actualDepthMask = false;
        _actualDepthTest = null;
    }

    /** Resets the current state, state stack, batch processor, stencil reference value,
     *  clipping rectangle, and draw count. Furthermore, depth testing is disabled. */
    public function nextFrame():Void
    {
        // update batch processors
        _batchProcessor = swapBatchProcessors();
        _batchProcessor.clear();
        _batchProcessorSpec.clear();

        setupContextDefaults();

        // reset everything else
		stencilReferenceValue = DEFAULT_STENCIL_VALUE;
		_clipRectStack.length = 0;
        _drawCount = 0;
        _stateStackPos = -1;
        _state.reset();
    }

    private function swapBatchProcessors():BatchProcessor
    {
        var tmp:BatchProcessor = _batchProcessorPrev;
        _batchProcessorPrev = _batchProcessorCurr;
        return _batchProcessorCurr = tmp;
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

            for (i in startToken.batchID...(endToken.batchID + 1))
            {
                meshBatch = _batchProcessorPrev.getBatchAt(i);
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
            }

            popState();
        }
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
        applyDepthTest();
    }

    /** Clears the render context with a certain color and alpha value. Since this also
     *  clears the stencil buffer, the stencil reference value is also reset to '0'. */
    public function clear(rgb:UInt=0, alpha:Float=0.0):Void
    {
        applyRenderTarget();
        stencilReferenceValue = DEFAULT_STENCIL_VALUE;
        RenderUtil.clear(rgb, alpha, 1.0, DEFAULT_STENCIL_VALUE);
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
        var culling:String = _state.culling;

        if (culling != _actualCulling)
        {
            _context.setCulling(culling);
            _actualCulling = culling;
        }
    }

    private function applyDepthTest():Void
    {
        var depthMask:Bool = _state.depthMask;
        var depthTest:String = _state.depthTest;

        if (depthMask != _actualDepthMask || depthTest != _actualDepthTest)
        {
            _context.setDepthTest(depthMask, depthTest);
            _actualDepthMask = depthMask;
            _actualDepthTest = depthTest;
        }
    }

    private function applyRenderTarget():Void
    {
        var target:TextureBase = _state.renderTargetBase;
        var options:UInt = _state.renderTargetOptions;

        if (target != _actualRenderTarget || options != _actualRenderTargetOptions)
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
            _actualRenderTargetOptions = options;
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
                width  = _backBufferWidth;
                height = _backBufferHeight;
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

    /** Refreshes the values of "backBufferWidth" and "backBufferHeight" from the current
     *  context dimensions and stores the given "backBufferScaleFactor". This method is
     *  called by Starling when the browser zoom factor changes (in case "supportBrowserZoom"
     *  is enabled).
     */
    public function refreshBackBufferSize(scaleFactor:Float):Void
    {
        _backBufferWidth = _context.backBufferWidth;
        _backBufferHeight = _context.backBufferHeight;
        _backBufferScaleFactor = scaleFactor;
    }

    // properties
    
    /** Indicates the number of stage3D draw calls. */
    public var drawCount(get, set):Int;
    private function get_drawCount():Int { return _drawCount; }
    private function set_drawCount(value:Int):Int { return _drawCount = value; }

    /** The current stencil reference value of the active render target. This value
     *  is typically incremented when drawing a mask and decrementing when erasing it.
     *  The painter keeps track of one stencil reference value per render target.
     *  Only change this value if you know what you're doing!
     */
    public var stencilReferenceValue(get, set):UInt;
    private function get_stencilReferenceValue():UInt
    {
        var key:Dynamic = _state.renderTarget != null ? _state.renderTargetBase : this;
        if (_stencilReferenceValues.exists(key)) return _stencilReferenceValues[key];
        else return DEFAULT_STENCIL_VALUE;
    }

    private function set_stencilReferenceValue(value:UInt):UInt
    {
        var key:Dynamic = _state.renderTarget != null ? _state.renderTargetBase : this;
        _stencilReferenceValues[key] = value;

        if (contextValid)
            _context.setStencilReferenceValue(value);
        return value;
    }

    /** Indicates if the render cache is enabled. Normally, this should be left at the default;
     *  however, some custom rendering logic might require to change this property temporarily.
     *  Also note that the cache is automatically reactivated each frame, right before the
     *  render process.
     *
     *  @default true
     */
    public var cacheEnabled(get, set):Bool;
    private function get_cacheEnabled():Bool { return _batchProcessor == _batchProcessorCurr; }
    private function set_cacheEnabled(value:Bool):Bool
    {
        if (value != cacheEnabled)
        {
            finishMeshBatch();

            if (value) _batchProcessor = _batchProcessorCurr;
            else       _batchProcessor = _batchProcessorSpec;
        }
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
    private function get_state():RenderState { return _state; }

    /** The Stage3D instance this painter renders into. */
    public var stage3D(get, never):Stage3D;
    private function get_stage3D():Stage3D { return _stage3D; }

    /** The Context3D instance this painter renders into. */
    public var context(get, never):Context3D;
    private function get_context():Context3D { return _context; }

    /** Returns the index of the current frame <strong>if</strong> the render cache is enabled;
     *  otherwise, returns zero. To get the frameID regardless of the render cache, call
     *  <code>Starling.frameID</code> instead. */
    public var frameID(get, set):UInt;
    private function set_frameID(value:UInt):UInt { return _frameID = value; }
    private function get_frameID():UInt
    {
        return _batchProcessor == _batchProcessorCurr ? _frameID : 0;
    }

    /** The size (in points) that represents one pixel in the back buffer. */
    public var pixelSize(get, set):Float;
    private function get_pixelSize():Float { return _pixelSize; }
    private function set_pixelSize(value:Float):Float { return _pixelSize = value; }

    /** Indicates if another Starling instance (or another Stage3D framework altogether)
     *  uses the same render context. @default false */
    public var shareContext(get, set):Bool;
    private function get_shareContext():Bool { return _shareContext; }
    private function set_shareContext(value:Bool):Bool { return _shareContext = value; }

    /** Indicates if Stage3D render methods will report errors. Activate only when needed,
     *  as this has a negative impact on performance. @default false */
    public var enableErrorChecking(get, set):Bool;
    private function get_enableErrorChecking():Bool { return _enableErrorChecking; }
    private function set_enableErrorChecking(value:Bool):Bool
    {
        _enableErrorChecking = value;
        if (_context != null) _context.enableErrorChecking = value;
        if (value) trace("[Starling] Warning: 'enableErrorChecking' has a " +
                "negative impact on performance. Never activate for release builds!");
        return value;
    }

    /** Returns the current width of the back buffer. In most cases, this value is in pixels;
     *  however, if the app is running on an HiDPI display with an activated
     *  'supportHighResolutions' setting, you have to multiply with 'backBufferScaleFactor'
     *  for the actual pixel count. Alternatively, use the Context3D-property with the
     *  same name: it will return the exact pixel values. */
    public var backBufferWidth(get, never):Int;
    private function get_backBufferWidth():Int { return _backBufferWidth; }

    /** Returns the current height of the back buffer. In most cases, this value is in pixels;
     *  however, if the app is running on an HiDPI display with an activated
     *  'supportHighResolutions' setting, you have to multiply with 'backBufferScaleFactor'
     *  for the actual pixel count. Alternatively, use the Context3D-property with the
     *  same name: it will return the exact pixel values. */
    public var backBufferHeight(get, never):Int;
    private function get_backBufferHeight():Int { return _backBufferHeight; }

    /** The number of pixels per point returned by the 'backBufferWidth/Height' properties.
     *  Except for desktop HiDPI displays with an activated 'supportHighResolutions' setting,
     *  this will always return '1'. */
    public var backBufferScaleFactor(get, never):Float;
    private function get_backBufferScaleFactor():Float { return _backBufferScaleFactor; }

    /** Indicates if the Context3D object is currently valid (i.e. it hasn't been lost or
     *  disposed). */
    public var contextValid(get, never):Bool;
    private function get_contextValid():Bool
    {
        if (_context != null)
        {
            var driverInfo:String = _context.driverInfo;
            return driverInfo != null && driverInfo != "" && driverInfo != "Disposed";
        }
        else return false;
    }

    /** The Context3D profile of the current render context, or <code>null</code>
     *  if the context has not been created yet. */
    public var profile(get, never):String;
    private function get_profile():String
    {
        if (_context != null) return _context.profile;
        else return null;
    }

    /** A dictionary that can be used to save custom data related to the render context.
     *  If you need to share data that is bound to the render context (e.g. textures), use
     *  this dictionary instead of creating a static class variable. That way, the data will
     *  be available for all Starling instances that use this stage3D / context. */
    public var sharedData(get, never):Map<String, Dynamic>;
    private function get_sharedData():Map<String, Dynamic>
    {
        var data:Map<String, Dynamic> = sSharedData[stage3D];
        if (data == null)
        {
            data = new Map<String, Dynamic>();
            sSharedData[stage3D] = data;
        }
        return data;
    }

    private var programs(get, never):Map<String, Program>;
    private function get_programs():Map<String, Program>
    {
        var programs:Map<String, Program> = sharedData[PROGRAM_DATA_NAME];
        if (programs == null)
        {
            programs = new Map<String, Program>();
            sharedData[PROGRAM_DATA_NAME] = programs;
        }
        return programs;
    }
}
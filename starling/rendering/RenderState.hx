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
import flash.display3D.Context3DTriangleFace;
import flash.display3D.textures.TextureBase;
import flash.geom.Matrix;
import flash.geom.Matrix3D;
import flash.geom.Rectangle;
import flash.geom.Vector3D;

import starling.display.BlendMode;
import starling.textures.Texture;
import starling.utils.MatrixUtil;
import starling.utils.Pool;
import starling.utils.RectangleUtil;

/** The RenderState stores a combination of settings that are currently used for rendering.
 *  This includes modelview and transformation matrices as well as context3D related settings.
 *
 *  <p>Starling's Painter instance stores a reference to the current RenderState.
 *  Via a stack mechanism, you can always save a specific state and restore it later.
 *  That makes it easy to write rendering code that doesn't have any side effects.</p>
 *
 *  <p>Beware that any context-related settings are not applied on the context
 *  right away, but only after calling <code>painter.prepareToDraw()</code>.
 *  However, the Painter recognizes changes to those settings and will finish the current
 *  batch right away if necessary.</p>
 *
 *  <strong>Matrix Magic</strong>
 *
 *  <p>On rendering, Starling traverses the display tree, constantly moving from one
 *  coordinate system to the next. Each display object stores its vertex coordinates
 *  in its local coordinate system; on rendering, they must be moved to a global,
 *  2D coordinate space (the so-called "clip-space"). To handle these calculations,
 *  the RenderState contains a set of matrices.</p>
 *
 *  <p>By multiplying vertex coordinates with the <code>modelviewMatrix</code>, you'll get the
 *  coordinates in "screen-space", or in other words: in stage coordinates. (Optionally,
 *  there's also a 3D version of this matrix. It comes into play when you're working with
 *  <code>Sprite3D</code> containers.)</p>
 *
 *  <p>By feeding the result of the previous transformation into the
 *  <code>projectionMatrix</code>, you'll end up with so-called "clipping coordinates",
 *  which are in the range <code>[-1, 1]</code> (just as needed by the graphics pipeline).
 *  If you've got vertices in the 3D space, this matrix will also execute a perspective
 *  projection.</p>
 *
 *  <p>Finally, there's the <code>mvpMatrix</code>, which is short for
 *  "modelviewProjectionMatrix". This is simply a combination of <code>modelview-</code> and
 *  <code>projectionMatrix</code>, combining the effects of both. Pass this matrix
 *  to the vertex shader and all your vertices will automatically end up at the right
 *  position.</p>
 *
 *  @see Painter
 *  @see starling.display.Sprite3D
 */
class RenderState
{
    /** @private */ private var _alpha:Float;
    /** @private */ private var _blendMode:String;
    /** @private */ private var _modelviewMatrix:Matrix;

    private var _renderTarget:Texture;
    private var _renderTargetOptions:UInt;
    private var _culling:Context3DTriangleFace;
    private var _clipRect:Rectangle;
    private var _onDrawRequired:Dynamic;
    private var _modelviewMatrix3D:Matrix3D;
    private var _projectionMatrix3D:Matrix3D;
    private var _mvpMatrix3D:Matrix3D;

    // helper objects
    private static var sMatrix3D:Matrix3D = new Matrix3D();

    /** Creates a new render state with the default settings. */
    public function new()
    {
        reset();
    }

    /** Duplicates all properties of another instance on the current instance. */
    public function copyFrom(renderState:RenderState):Void
    {
        if (_onDrawRequired != null)
        {
            var currentTarget:TextureBase = _renderTarget != null ? _renderTarget.base : null;
            var nextTarget:TextureBase = renderState._renderTarget != null ? renderState._renderTarget.base : null;
            var clipRectChanges:Bool = _clipRect != null || renderState._clipRect != null ?
                !RectangleUtil.compare(_clipRect, renderState._clipRect) : false;

            if (_blendMode != renderState._blendMode || _culling != renderState._culling ||
                currentTarget != nextTarget || clipRectChanges)
            {
                _onDrawRequired();
            }
        }

        _alpha = renderState._alpha;
        _blendMode = renderState._blendMode;
        _renderTarget = renderState._renderTarget;
        _renderTargetOptions = renderState._renderTargetOptions;
        _culling = renderState._culling;
        _modelviewMatrix.copyFrom(renderState._modelviewMatrix);
        _projectionMatrix3D.copyFrom(renderState._projectionMatrix3D);

        if (_modelviewMatrix3D != null || renderState._modelviewMatrix3D != null)
            this.modelviewMatrix3D = renderState._modelviewMatrix3D;

        if (_clipRect != null || renderState._clipRect != null)
            this.clipRect = renderState._clipRect;
    }

    /** Resets the RenderState to the default settings.
     *  (Check each property documentation for its default value.) */
    public function reset():Void
    {
        this.alpha = 1.0;
        this.blendMode = BlendMode.NORMAL;
        this.culling = Context3DTriangleFace.NONE;
        this.modelviewMatrix3D = null;
        this.renderTarget = null;
        this.clipRect = null;

        if (_modelviewMatrix != null) _modelviewMatrix.identity();
        else _modelviewMatrix = new Matrix();

        if (_projectionMatrix3D != null) _projectionMatrix3D.identity();
        else _projectionMatrix3D = new Matrix3D();

        if (_mvpMatrix3D == null) _mvpMatrix3D = new Matrix3D();
    }

    // matrix methods / properties

    /** Prepends the given matrix to the 2D modelview matrix. */
    public function transformModelviewMatrix(matrix:Matrix):Void
    {
        MatrixUtil.prependMatrix(_modelviewMatrix, matrix);
    }

    /** Prepends the given matrix to the 3D modelview matrix.
     *  The current contents of the 2D modelview matrix is stored in the 3D modelview matrix
     *  before doing so; the 2D modelview matrix is then reset to the identity matrix.
     */
    public function transformModelviewMatrix3D(matrix:Matrix3D):Void
    {
        if (_modelviewMatrix3D == null)
            _modelviewMatrix3D = Pool.getMatrix3D();

        _modelviewMatrix3D.prepend(MatrixUtil.convertTo3D(_modelviewMatrix, sMatrix3D));
        _modelviewMatrix3D.prepend(matrix);
        _modelviewMatrix.identity();
    }

    /** Creates a perspective projection matrix suitable for 2D and 3D rendering.
     *
     *  <p>The first 4 parameters define which area of the stage you want to view (the camera
     *  will 'zoom' to exactly this region). The final 3 parameters determine the perspective
     *  in which you're looking at the stage.</p>
     *
     *  <p>The stage is always on the rectangle that is spawned up between x- and y-axis (with
     *  the given size). All objects that are exactly on that rectangle (z equals zero) will be
     *  rendered in their true size, without any distortion.</p>
     *
     *  <p>If you pass only the first 4 parameters, the camera will be set up above the center
     *  of the stage, with a field of view of 1.0 rad.</p>
     */
    public function setProjectionMatrix(x:Float, y:Float, width:Float, height:Float,
                                        stageWidth:Float=0, stageHeight:Float=0,
                                        cameraPos:Vector3D=null):Void
    {
        MatrixUtil.createPerspectiveProjectionMatrix(
                x, y, width, height, stageWidth, stageHeight, cameraPos, _projectionMatrix3D);
    }

    /** Changes the modelview matrices (2D and, if available, 3D) to identity matrices.
     *  An object transformed an identity matrix performs no transformation.
     */
    public function setModelviewMatricesToIdentity():Void
    {
        _modelviewMatrix.identity();
        if (_modelviewMatrix3D != null) _modelviewMatrix3D.identity();
    }

    /** Returns the current 2D modelview matrix.
     *  CAUTION: Use with care! Each call returns the same instance.
     *  @default identity matrix */
    public var modelviewMatrix(get, set):Matrix;
    @:noCompletion private function get_modelviewMatrix():Matrix { return _modelviewMatrix; }
    @:noCompletion private function set_modelviewMatrix(value:Matrix):Matrix { _modelviewMatrix.copyFrom(value); return value; }

    /** Returns the current 3D modelview matrix, if there have been 3D transformations.
     *  CAUTION: Use with care! Each call returns the same instance.
     *  @default null */
    public var modelviewMatrix3D(get, set):Matrix3D;
    @:noCompletion private function get_modelviewMatrix3D():Matrix3D { return _modelviewMatrix3D; }
    @:noCompletion private function set_modelviewMatrix3D(value:Matrix3D):Matrix3D
    {
        if (value != null)
        {
            if (_modelviewMatrix3D == null) _modelviewMatrix3D = Pool.getMatrix3D(false);
            _modelviewMatrix3D.copyFrom(value);
        }
        else if (_modelviewMatrix3D != null)
        {
            Pool.putMatrix3D(_modelviewMatrix3D);
            _modelviewMatrix3D = null;
        }
        return value;
    }

    /** Returns the current projection matrix. You can use the method 'setProjectionMatrix3D'
     *  to set it up in an intuitive way.
     *  CAUTION: Use with care! Each call returns the same instance.
     *  @default identity matrix */
    public var projectionMatrix3D(get, set):Matrix3D;
    @:noCompletion private function get_projectionMatrix3D():Matrix3D { return _projectionMatrix3D; }
    @:noCompletion private function set_projectionMatrix3D(value:Matrix3D):Matrix3D { _projectionMatrix3D.copyFrom(value); return value; }

    /** Calculates the product of modelview and projection matrix and stores it in a 3D matrix.
     *  CAUTION: Use with care! Each call returns the same instance. */
    public var mvpMatrix3D(get, never):Matrix3D;
    @:noCompletion private function get_mvpMatrix3D():Matrix3D
    {
        _mvpMatrix3D.copyFrom(_projectionMatrix3D);
        if (_modelviewMatrix3D != null) _mvpMatrix3D.prepend(_modelviewMatrix3D);
        _mvpMatrix3D.prepend(MatrixUtil.convertTo3D(_modelviewMatrix, sMatrix3D));
        return _mvpMatrix3D;
    }

    // other methods

    /** Changes the the current render target.
     *
     *  @param target     Either a texture or <code>null</code> to render into the back buffer.
     *  @param enableDepthAndStencil  Indicates if depth and stencil testing will be available.
     *                    This parameter affects only texture targets.
     *  @param antiAlias  The anti-aliasing quality (<code>0</code> meaning: no anti-aliasing).
     *                    This parameter affects only texture targets. Note that at the time
     *                    of this writing, AIR supports anti-aliasing only on Desktop.
     */
    public function setRenderTarget(target:Texture, enableDepthAndStencil:Bool=true,
                                    antiAlias:Int=0):Void
    {
        var currentTarget:TextureBase = _renderTarget != null ? _renderTarget.base : null;
        var newTarget:TextureBase = target != null ? target.base : null;
        var newOptions:UInt = enableDepthAndStencil ? 1 : 0 | antiAlias << 4;

        if (currentTarget != newTarget || _renderTargetOptions != newOptions)
        {
            if (_onDrawRequired != null) _onDrawRequired();

            _renderTarget = target;
            _renderTargetOptions = newOptions;
        }
    }

    // other properties

    /** The current, cumulated alpha value. Beware that, in a standard 'render' method,
     *  this already includes the current object! The value is the product of current object's
     *  alpha value and all its parents. @default 1.0
     */
    public var alpha(get, set):Float;
    @:noCompletion private function get_alpha():Float { return _alpha; }
    @:noCompletion private function set_alpha(value:Float):Float { return _alpha = value; }

    /** The blend mode to be used on rendering. A value of "auto" is ignored, since it
     *  means that the mode should remain unchanged.
     *
     *  @default BlendMode.NORMAL
     *  @see starling.display.BlendMode
     */
    public var blendMode(get, set):String;
    @:noCompletion private function get_blendMode():String { return _blendMode; }
    @:noCompletion private function set_blendMode(value:String):String
    {
        if (value != BlendMode.AUTO && _blendMode != value)
        {
            if (_onDrawRequired != null) _onDrawRequired();
            _blendMode = value;
        }
        return value;
    }

    /** The texture that is currently being rendered into, or <code>null</code>
     *  to render into the back buffer. On assignment, calls <code>setRenderTarget</code>
     *  with its default parameters. */
    public var renderTarget(get, set):Texture;
    @:noCompletion private function get_renderTarget():Texture { return _renderTarget; }
    @:noCompletion private function set_renderTarget(value:Texture):Texture { setRenderTarget(value); return value; }

    /** @private */
    public var renderTargetBase(get, never):TextureBase;
    @:noCompletion private function get_renderTargetBase():TextureBase
    {
        return _renderTarget != null ? _renderTarget.base : null;
    }

    /** Sets the triangle culling mode. Allows to exclude triangles from rendering based on
     *  their orientation relative to the view plane.
     *  @default Context3DTriangleFace.NONE
     */
    public var culling(get, set):Context3DTriangleFace;
    @:noCompletion private function get_culling():Context3DTriangleFace { return _culling; }
    @:noCompletion private function set_culling(value:Context3DTriangleFace):Context3DTriangleFace
    {
        if (_culling != value)
        {
            if (_onDrawRequired != null) _onDrawRequired();
            _culling = value;
        }
        return value;
    }

    /** The clipping rectangle can be used to limit rendering in the current render target to
     *  a certain area. This method expects the rectangle in stage coordinates. To prevent
     *  any clipping, assign <code>null</code>.
     *
     *  @default null
     */
    public var clipRect(get, set):Rectangle;
    @:noCompletion private function get_clipRect():Rectangle { return _clipRect; }
    @:noCompletion private function set_clipRect(value:Rectangle):Rectangle
    {
        if (!RectangleUtil.compare(_clipRect, value))
        {
            if (_onDrawRequired != null) _onDrawRequired();
            if (value != null)
            {
                if (_clipRect == null) _clipRect = Pool.getRectangle();
                _clipRect.copyFrom(value);
            }
            else if (_clipRect != null)
            {
                Pool.putRectangle(_clipRect);
                _clipRect = null;
            }
        }
        return value;
    }

    /** The anti-alias setting used when setting the current render target
     *  via <code>setRenderTarget</code>. */
    public var renderTargetAntiAlias(get, never):Int;
    @:noCompletion private function get_renderTargetAntiAlias():Int
    {
        return _renderTargetOptions >> 4;
    }

    /** Indicates if the render target (set via <code>setRenderTarget</code>)
     *  has its depth and stencil buffers enabled. */
    public var renderTargetSupportsDepthAndStencil(get, never):Bool;
    @:noCompletion private function get_renderTargetSupportsDepthAndStencil():Bool
    {
        return (_renderTargetOptions & 0xf) != 0;
    }

    /** Indicates if there have been any 3D transformations.
     *  Returns <code>true</code> if the 3D modelview matrix contains a value. */
    public var is3D(get, never):Bool;
    @:noCompletion private function get_is3D():Bool { return _modelviewMatrix3D != null; }

    /** @private
     *
     *  This callback is executed whenever a state change requires a draw operation.
     *  This is the case if blend mode, render target, culling or clipping rectangle
     *  are changing. */
    public var onDrawRequired(get, set):Dynamic;
    @:noCompletion private function get_onDrawRequired():Dynamic { return _onDrawRequired; }
    @:noCompletion private function set_onDrawRequired(value:Dynamic):Dynamic { return _onDrawRequired = value; }
}

// =================================================================================================
//
//	Starling Framework
//	Copyright Gamua GmbH. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

package starling.display;

import starling.utils.Execute;
import starling.utils.Pool;
import haxe.Constraints.Function;
import openfl.display.BitmapData;

import openfl.errors.ArgumentError;
import openfl.errors.IllegalOperationError;
import openfl.geom.Matrix;
import openfl.geom.Matrix3D;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.geom.Vector3D;
import openfl.system.Capabilities;
import openfl.ui.Mouse;
import openfl.ui.MouseCursor;
import openfl.Vector;

import starling.core.Starling;
import starling.errors.AbstractMethodError;
import starling.events.Event;
import starling.events.EventDispatcher;
import starling.events.TouchEvent;
import starling.filters.FragmentFilter;
import starling.rendering.BatchToken;
import starling.rendering.Painter;
import starling.utils.Align;
import starling.utils.Color;
import starling.utils.MathUtil;
import starling.utils.MatrixUtil;
import starling.utils.SystemUtil;

/** Dispatched when an object is added to a parent. */
@:meta(Event(name="added", type="starling.events.Event"))

/** Dispatched when an object is connected to the stage (directly or indirectly). */
@:meta(Event(name="addedToStage", type="starling.events.Event"))

/** Dispatched when an object is removed from its parent. */
@:meta(Event(name="removed", type="starling.events.Event"))

/** Dispatched when an object is removed from the stage and won't be rendered any longer. */ 
@:meta(Event(name="removedFromStage", type="starling.events.Event"))

/** Dispatched once every frame on every object that is connected to the stage. */ 
@:meta(Event(name="enterFrame", type="starling.events.EnterFrameEvent"))

/** Dispatched when an object is touched. Bubbles. */
@:meta(Event(name="touch", type="starling.events.TouchEvent"))

/** Dispatched when a key on the keyboard is released. */
@:meta(Event(name="keyUp", type="starling.events.KeyboardEvent"))

/** Dispatched when a key on the keyboard is pressed. */
@:meta(Event(name="keyDown", type="starling.events.KeyboardEvent"))

/**
 *  The DisplayObject class is the base class for all objects that are rendered on the 
 *  screen.
 *  
 *  <p><strong>The Display Tree</strong></p> 
 *  
 *  <p>In Starling, all displayable objects are organized in a display tree. Only objects that
 *  are part of the display tree will be displayed (rendered).</p> 
 *   
 *  <p>The display tree consists of leaf nodes (Image, Quad) that will be rendered directly to
 *  the screen, and of container nodes (subclasses of "DisplayObjectContainer", like "Sprite").
 *  A container is simply a display object that has child nodes - which can, again, be either
 *  leaf nodes or other containers.</p> 
 *  
 *  <p>At the base of the display tree, there is the Stage, which is a container, too. To create
 *  a Starling application, you create a custom Sprite subclass, and Starling will add an
 *  instance of this class to the stage.</p>
 *  
 *  <p>A display object has properties that define its position in relation to its parent
 *  (x, y), as well as its rotation and scaling factors (scaleX, scaleY). Use the 
 *  <code>alpha</code> and <code>visible</code> properties to make an object translucent or 
 *  invisible.</p>
 *  
 *  <p>Every display object may be the target of touch events. If you don't want an object to be
 *  touchable, you can disable the "touchable" property. When it's disabled, neither the object
 *  nor its children will receive any more touch events.</p>
 *    
 *  <strong>Transforming coordinates</strong>
 *  
 *  <p>Within the display tree, each object has its own local coordinate system. If you rotate
 *  a container, you rotate that coordinate system - and thus all the children of the 
 *  container.</p>
 *  
 *  <p>Sometimes you need to know where a certain point lies relative to another coordinate 
 *  system. That's the purpose of the method <code>getTransformationMatrix</code>. It will  
 *  create a matrix that represents the transformation of a point in one coordinate system to 
 *  another.</p> 
 *  
 *  <strong>Customization</strong>
 *  
 *  <p>DisplayObject is an abstract class, which means you cannot instantiate it directly,
 *  but have to use one of its many subclasses instead. For leaf nodes, this is typically
 *  'Mesh' or its subclasses 'Quad' and 'Image'. To customize rendering of these objects,
 *  you can use fragment filters (via the <code>filter</code>-property on 'DisplayObject')
 *  or mesh styles (via the <code>style</code>-property on 'Mesh'). Look at the respective
 *  class documentation for more information.</p>
 *
 *  @see DisplayObjectContainer
 *  @see Sprite
 *  @see Stage
 *  @see Mesh
 *  @see starling.filters.FragmentFilter
 *  @see starling.styles.MeshStyle
 */
class DisplayObject extends EventDispatcher
{
    // private members
    
    private var __x:Float;
    private var __y:Float;
    private var __pivotX:Float;
    private var __pivotY:Float;
    private var __scaleX:Float;
    private var __scaleY:Float;
    private var __skewX:Float;
    private var __skewY:Float;
    private var __rotation:Float;
    private var __alpha:Float;
    private var __visible:Bool;
    private var __touchable:Bool;
    private var __blendMode:String;
    private var __name:String;
    private var __useHandCursor:Bool;
    private var __transformationMatrix:Matrix;
    private var __transformationMatrix3D:Matrix3D;
    private var __transformationChanged:Bool;
    private var __is3D:Bool = false;
    private var __maskee:DisplayObject;
    private var __maskInverted:Bool = false;

    // internal members (for fast access on rendering)

    @:allow(starling) private var __parent:DisplayObjectContainer;
    @:allow(starling) private var __lastParentOrSelfChangeFrameID:UInt;
    @:allow(starling) private var __lastChildChangeFrameID:UInt;
    @:allow(starling) private var __tokenFrameID:UInt;
    @:allow(starling) private var __pushToken:BatchToken = new BatchToken();
    @:allow(starling) private var __popToken:BatchToken = new BatchToken();
    @:allow(starling) private var __hasVisibleArea:Bool;
    @:allow(starling) private var __filter:FragmentFilter;
    @:allow(starling) private var __mask:DisplayObject;

    // helper objects

    private static var sAncestors:Vector<DisplayObject> = new Vector<DisplayObject>();
    private static var sHelperPoint:Point = new Point();
    private static var sHelperPoint3D:Vector3D = new Vector3D();
    private static var sHelperPointAlt3D:Vector3D = new Vector3D();
    private static var sHelperRect:Rectangle = new Rectangle();
    private static var sHelperMatrix:Matrix  = new Matrix();
    private static var sHelperMatrixAlt:Matrix  = new Matrix();
    private static var sHelperMatrix3D:Matrix3D  = new Matrix3D();
    private static var sHelperMatrixAlt3D:Matrix3D  = new Matrix3D();
    private static var sMaskWarningShown:Bool = false;
    
    #if commonjs
    private static function __init__ () {
        
        untyped Object.defineProperties (DisplayObject.prototype, {
            "isMask": { get: untyped __js__ ("function () { return this.get_isMask (); }") },
            "requiresRedraw": { get: untyped __js__ ("function () { return this.get_requiresRedraw (); }") },
            "transformationMatrix": { get: untyped __js__ ("function () { return this.get_transformationMatrix (); }"), set: untyped __js__ ("function (v) { return this.set_transformationMatrix (v); }") },
            "transformationMatrix3D": { get: untyped __js__ ("function () { return this.get_transformationMatrix3D (); }") },
            "is3D": { get: untyped __js__ ("function () { return this.get_is3D (); }") },
            "useHandCursor": { get: untyped __js__ ("function () { return this.get_useHandCursor (); }"), set: untyped __js__ ("function (v) { return this.set_useHandCursor (v); }") },
            "bounds": { get: untyped __js__ ("function () { return this.get_bounds (); }") },
            "width": { get: untyped __js__ ("function () { return this.get_width (); }"), set: untyped __js__ ("function (v) { return this.set_width (v); }") },
            "height": { get: untyped __js__ ("function () { return this.get_height (); }"), set: untyped __js__ ("function (v) { return this.set_height (v); }") },
            "x": { get: untyped __js__ ("function () { return this.get_x (); }"), set: untyped __js__ ("function (v) { return this.set_x (v); }") },
            "y": { get: untyped __js__ ("function () { return this.get_y (); }"), set: untyped __js__ ("function (v) { return this.set_y (v); }") },
            "pivotX": { get: untyped __js__ ("function () { return this.get_pivotX (); }"), set: untyped __js__ ("function (v) { return this.set_pivotX (v); }") },
            "pivotY": { get: untyped __js__ ("function () { return this.get_pivotY (); }"), set: untyped __js__ ("function (v) { return this.set_pivotY (v); }") },
            "scaleX": { get: untyped __js__ ("function () { return this.get_scaleX (); }"), set: untyped __js__ ("function (v) { return this.set_scaleX (v); }") },
            "scaleY": { get: untyped __js__ ("function () { return this.get_scaleY (); }"), set: untyped __js__ ("function (v) { return this.set_scaleY (v); }") },
            "scale": { get: untyped __js__ ("function () { return this.get_scale (); }"), set: untyped __js__ ("function (v) { return this.set_scale (v); }") },
            "skewX": { get: untyped __js__ ("function () { return this.get_skewX (); }"), set: untyped __js__ ("function (v) { return this.set_skewX (v); }") },
            "skewY": { get: untyped __js__ ("function () { return this.get_skewY (); }"), set: untyped __js__ ("function (v) { return this.set_skewY (v); }") },
            "rotation": { get: untyped __js__ ("function () { return this.get_rotation (); }"), set: untyped __js__ ("function (v) { return this.set_rotation (v); }") },
            "isRotated": { get: untyped __js__ ("function () { return this.get_isRotated (); }") },
            "alpha": { get: untyped __js__ ("function () { return this.get_alpha (); }"), set: untyped __js__ ("function (v) { return this.set_alpha (v); }") },
            "visible": { get: untyped __js__ ("function () { return this.get_visible (); }"), set: untyped __js__ ("function (v) { return this.set_visible (v); }") },
            "touchable": { get: untyped __js__ ("function () { return this.get_touchable (); }"), set: untyped __js__ ("function (v) { return this.set_touchable (v); }") },
            "blendMode": { get: untyped __js__ ("function () { return this.get_blendMode (); }"), set: untyped __js__ ("function (v) { return this.set_blendMode (v); }") },
            "name": { get: untyped __js__ ("function () { return this.get_name (); }"), set: untyped __js__ ("function (v) { return this.set_name (v); }") },
            "filter": { get: untyped __js__ ("function () { return this.get_filter (); }"), set: untyped __js__ ("function (v) { return this.set_filter (v); }") },
            "mask": { get: untyped __js__ ("function () { return this.get_mask (); }"), set: untyped __js__ ("function (v) { return this.set_mask (v); }") },
            "maskInverted": { get: untyped __js__ ("function () { return this.get_maskInverted (); }"), set: untyped __js__ ("function (v) { return this.set_maskInverted (v); }") },
            "parent": { get: untyped __js__ ("function () { return this.get_parent (); }") },
            "base": { get: untyped __js__ ("function () { return this.get_base (); }") },
            "root": { get: untyped __js__ ("function () { return this.get_root (); }") },
            "stage": { get: untyped __js__ ("function () { return this.get_stage (); }") },
        });
        
    }
    #end
    
    /** @private */ 
    private function new()
    {
        super();
        
        __x = __y = __pivotX = __pivotY = __rotation = __skewX = __skewY = 0.0;
        __scaleX = __scaleY = __alpha = 1.0;
        __visible = __touchable = __hasVisibleArea = true;
        __blendMode = BlendMode.AUTO;
        __transformationMatrix = new Matrix();
    }
    
    /** Disposes all resources of the display object. 
      * GPU buffers are released, event listeners are removed, filters and masks are disposed. */
    public function dispose():Void
    {
        if (__filter != null) __filter.dispose();
        if (__mask != null) __mask.dispose();
        removeEventListeners();
        mask = null; // clear 'mask.__maskee', just to be sure.
    }
    
    /** Removes the object from its parent, if it has one, and optionally disposes it. */
    public function removeFromParent(dispose:Bool=false):Void
    {
        if (__parent != null) __parent.removeChild(this, dispose);
        else if (dispose) this.dispose();
    }
    
    /** Creates a matrix that represents the transformation from the local coordinate system 
     * to another. If you pass an <code>out</code>-matrix, the result will be stored in this matrix
     * instead of creating a new object. */ 
    public function getTransformationMatrix(targetSpace:DisplayObject, 
                                            out:Matrix=null):Matrix
    {
        var commonParent:DisplayObject;
        var currentObject:DisplayObject;
        
        if (out != null) out.identity();
        else out = new Matrix();
        
        if (targetSpace == this)
        {
            return out;
        }
        else if (targetSpace == __parent || (targetSpace == null && __parent == null))
        {
            out.copyFrom(transformationMatrix);
            return out;
        }
        else if (targetSpace == null || targetSpace == base)
        {
            // targetCoordinateSpace 'null' represents the target space of the base object.
            // -> move up from this to base
            
            currentObject = this;
            while (currentObject != targetSpace)
            {
                out.concat(currentObject.transformationMatrix);
                currentObject = currentObject.__parent;
            }
            
            return out;
        }
        else if (targetSpace.__parent == this) // optimization
        {
            targetSpace.getTransformationMatrix(this, out);
            out.invert();
            
            return out;
        }
        
        // 1. find a common parent of this and the target space
        
        commonParent = __findCommonParent(this, targetSpace);
        
        // 2. move up from this to common parent
        
        currentObject = this;
        while (currentObject != commonParent)
        {
            out.concat(currentObject.transformationMatrix);
            currentObject = currentObject.__parent;
        }
        
        if (commonParent == targetSpace)
            return out;
        
        // 3. now move up from target until we reach the common parent
        
        sHelperMatrix.identity();
        currentObject = targetSpace;
        while (currentObject != commonParent)
        {
            sHelperMatrix.concat(currentObject.transformationMatrix);
            currentObject = currentObject.__parent;
        }
        
        // 4. now combine the two matrices
        
        sHelperMatrix.invert();
        out.concat(sHelperMatrix);
        
        return out;
    }
    
    /** Returns a rectangle that completely encloses the object as it appears in another 
     * coordinate system. If you pass an <code>out</code>-rectangle, the result will be stored in this 
     * rectangle instead of creating a new object. */ 
    public function getBounds(targetSpace:DisplayObject, out:Rectangle=null):Rectangle
    {
        throw new AbstractMethodError();
    }
    
    /** Returns the object that is found topmost beneath a point in local coordinates, or nil
     *  if the test fails. Untouchable and invisible objects will cause the test to fail. */
    public function hitTest(localPoint:Point):DisplayObject
    {
        // on a touch test, invisible or untouchable objects cause the test to fail
        if (!__visible || !__touchable) return null;

        // if we've got a mask and the hit occurs outside, fail
        if (__mask != null && !hitTestMask(localPoint)) return null;
        
        // otherwise, check bounding box
        if (getBounds(this, sHelperRect).containsPoint(localPoint)) return this;
        else return null;
    }

    /** Checks if a certain point is inside the display object's mask. If there is no mask,
     * this method always returns <code>true</code> (because having no mask is equivalent
     * to having one that's infinitely big). */
    public function hitTestMask(localPoint:Point):Bool
    {
        if (__mask != null)
        {
            if (__mask.stage != null) getTransformationMatrix(__mask, sHelperMatrixAlt);
            else
            {
                sHelperMatrixAlt.copyFrom(__mask.transformationMatrix);
                sHelperMatrixAlt.invert();
            }

            var helperPoint:Point = localPoint == sHelperPoint ? new Point() : sHelperPoint;
            MatrixUtil.transformPoint(sHelperMatrixAlt, localPoint, helperPoint);
            var isMaskHit:Bool = __mask.hitTest(helperPoint) != null;
            return __maskInverted ? !isMaskHit : isMaskHit;
        }
        else return true;
    }

    /** Transforms a point from the local coordinate system to global (stage) coordinates.
     * If you pass an <code>out</code>-point, the result will be stored in this point instead of 
     * creating a new object. */
    public function localToGlobal(localPoint:Point, out:Point=null):Point
    {
        if (is3D)
        {
            sHelperPoint3D.setTo(localPoint.x, localPoint.y, 0);
            return local3DToGlobal(sHelperPoint3D, out);
        }
        else
        {
            getTransformationMatrix(base, sHelperMatrixAlt);
            return MatrixUtil.transformPoint(sHelperMatrixAlt, localPoint, out);
        }
    }
    
    /** Transforms a point from global (stage) coordinates to the local coordinate system.
     * If you pass an <code>out</code>-point, the result will be stored in this point instead of 
     * creating a new object. */
    public function globalToLocal(globalPoint:Point, out:Point=null):Point
    {
        if (is3D)
        {
            globalToLocal3D(globalPoint, sHelperPoint3D);
            stage.getCameraPosition(this, sHelperPointAlt3D);
            return MathUtil.intersectLineWithXYPlane(sHelperPointAlt3D, sHelperPoint3D, out);
        }
        else
        {
            getTransformationMatrix(base, sHelperMatrixAlt);
            sHelperMatrixAlt.invert();
            return MatrixUtil.transformPoint(sHelperMatrixAlt, globalPoint, out);
        }
    }
    
    /** Renders the display object with the help of a painter object. Never call this method
     *  directly, except from within another render method.
     *
     *  @param painter Captures the current render state and provides utility functions
     *                 for rendering.
     */
    public function render(painter:Painter):Void
    {
        throw new AbstractMethodError();
    }
    
    /** Moves the pivot point to a certain position within the local coordinate system
     * of the object. If you pass no arguments, it will be centered. */ 
    public function alignPivot(horizontalAlign:String="center",
                               verticalAlign:String="center"):Void
    {
        var bounds:Rectangle = getBounds(this, sHelperRect);

        if (horizontalAlign == Align.LEFT)        pivotX = bounds.x;
        else if (horizontalAlign == Align.CENTER) pivotX = bounds.x + bounds.width / 2.0;
        else if (horizontalAlign == Align.RIGHT)  pivotX = bounds.x + bounds.width;
        else throw new ArgumentError("Invalid horizontal alignment: " + horizontalAlign);
        
        if (verticalAlign == Align.TOP)           pivotY = bounds.y;
        else if (verticalAlign == Align.CENTER)   pivotY = bounds.y + bounds.height / 2.0;
        else if (verticalAlign == Align.BOTTOM)   pivotY = bounds.y + bounds.height;
        else throw new ArgumentError("Invalid vertical alignment: " + verticalAlign);
    }

	/** Draws the object into a BitmapData object.
	 *
	 *  <p>This is achieved by drawing the object into the back buffer and then copying the
	 *  pixels of the back buffer into a texture. Beware: image sizes bigger than the back
	 *  buffer are only supported in AIR version 25 or higher and NOT in Flash Player.</p>
	 *
	 *  @param out   If you pass null, the object will be created for you.
	 *               If you pass a BitmapData object, it should have the size of the
	 *               object bounds, multiplied by the current contentScaleFactor.
	 *  @param color The RGB color value with which the bitmap will be initialized.
	 *  @param alpha The alpha value with which the bitmap will be initialized.
	 */
    public function drawToBitmapData(out:BitmapData=null,
                                       color:UInt=0x0, alpha:Float=0.0):BitmapData
    {
        var painter:Painter = Starling.current.painter;
        var stage:Stage = Starling.current.stage;
        var viewPort:Rectangle = Starling.current.viewPort;
        var stageWidth:Float = stage.stageWidth;
        var stageHeight:Float = stage.stageHeight;
        var scaleX:Float = viewPort.width  / stageWidth;
        var scaleY:Float = viewPort.height / stageHeight;
        var backBufferScale:Float = painter.backBufferScaleFactor;
        var totalScaleX:Float = scaleX * backBufferScale;
        var totalScaleY:Float = scaleY * backBufferScale;
        var projectionX:Float, projectionY:Float;
        var bounds:Rectangle;

        if (#if (haxe_ver < 4.2) Std.is #else Std.isOfType #end(this, Stage))
        {
            projectionX = viewPort.x < 0 ? -viewPort.x / scaleX : 0.0;
            projectionY = viewPort.y < 0 ? -viewPort.y / scaleY : 0.0;

            if (out == null) out = new BitmapData(Math.ceil(painter.backBufferWidth  * backBufferScale),
                                                  Math.ceil(painter.backBufferHeight * backBufferScale));
        }
        else
        {
            bounds = getBounds(__parent, sHelperRect);
            projectionX = bounds.x;
            projectionY = bounds.y;

            if (out == null) out = new BitmapData(Math.ceil(bounds.width  * totalScaleX),
                                                  Math.ceil(bounds.height * totalScaleY));
        }

        color = Color.multiply(color, alpha); // premultiply alpha

        painter.pushState();
        painter.setupContextDefaults();
        painter.state.renderTarget = null;
        painter.state.setModelviewMatricesToIdentity();
        painter.setStateTo(transformationMatrix);

        // Images that are bigger than the current back buffer are drawn in multiple steps.

        var stepX:Float;
        var stepY:Float = projectionY;
        var stepWidth:Float  = painter.backBufferWidth  / scaleX;
        var stepHeight:Float = painter.backBufferHeight / scaleY;
        var positionInBitmap:Point = Pool.getPoint(0, 0);
        var boundsInBuffer:Rectangle = Pool.getRectangle(0, 0,
                painter.backBufferWidth  * backBufferScale,
                painter.backBufferHeight * backBufferScale);

        if (__mask != null) painter.eraseMask(mask, this);

        while (positionInBitmap.y < out.height)
        {
            stepX = projectionX;
            positionInBitmap.x = 0;

            while (positionInBitmap.x < out.width)
            {
                painter.clear(color, alpha);
                painter.state.setProjectionMatrix(stepX, stepY, stepWidth, stepHeight,
                stageWidth, stageHeight, stage.cameraPosition);

                if (__mask != null)   painter.drawMask(mask, this);

                if (__filter != null) __filter.render(painter);
                else         render(painter);

                if (__mask != null)   painter.eraseMask(mask, this);

                painter.finishMeshBatch();
                Execute.execute(painter.context.drawToBitmapData, [out, boundsInBuffer, positionInBitmap]);

                stepX += stepWidth;
                positionInBitmap.x += stepWidth * totalScaleX;
            }

            stepY += stepHeight;
            positionInBitmap.y += stepHeight * totalScaleY;
        }

        painter.popState();

        Pool.putRectangle(boundsInBuffer);
        Pool.putPoint(positionInBitmap);

        return out;
    }

    // 3D transformation

    /** Creates a matrix that represents the transformation from the local coordinate system
     * to another. This method supports three dimensional objects created via 'Sprite3D'.
     * If you pass an <code>out</code>-matrix, the result will be stored in this matrix
     * instead of creating a new object. */
    public function getTransformationMatrix3D(targetSpace:DisplayObject,
                                                out:Matrix3D=null):Matrix3D
    {
        var commonParent:DisplayObject;
        var currentObject:DisplayObject;

        if (out != null) out.identity();
        else out = new Matrix3D();

        if (targetSpace == this)
        {
            return out;
        }
        else if (targetSpace == __parent || (targetSpace == null && __parent == null))
        {
            out.copyFrom(transformationMatrix3D);
            return out;
        }
        else if (targetSpace == null || targetSpace == base)
        {
            // targetCoordinateSpace 'null' represents the target space of the base object.
            // -> move up from this to base

            currentObject = this;
            while (currentObject != targetSpace)
            {
                out.append(currentObject.transformationMatrix3D);
                currentObject = currentObject.__parent;
            }

            return out;
        }
        else if (targetSpace.__parent == this) // optimization
        {
            targetSpace.getTransformationMatrix3D(this, out);
            out.invert();

            return out;
        }

        // 1. find a common parent of this and the target space

        commonParent = __findCommonParent(this, targetSpace);

        // 2. move up from this to common parent

        currentObject = this;
        while (currentObject != commonParent)
        {
            out.append(currentObject.transformationMatrix3D);
            currentObject = currentObject.__parent;
        }

        if (commonParent == targetSpace)
            return out;

        // 3. now move up from target until we reach the common parent

        sHelperMatrix3D.identity();
        currentObject = targetSpace;
        while (currentObject != commonParent)
        {
            sHelperMatrix3D.append(currentObject.transformationMatrix3D);
            currentObject = currentObject.__parent;
        }

        // 4. now combine the two matrices

        sHelperMatrix3D.invert();
        out.append(sHelperMatrix3D);

        return out;
    }

    /** Transforms a 3D point from the local coordinate system to global (stage) coordinates.
     * This is achieved by projecting the 3D point onto the (2D) view plane.
     *
     * <p>If you pass an <code>out</code>-point, the result will be stored in this point instead of
     * creating a new object.</p> */
    public function local3DToGlobal(localPoint:Vector3D, out:Point=null):Point
    {
        var stage:Stage = this.stage;
        if (stage == null) throw new IllegalOperationError("Object not connected to stage");

        getTransformationMatrix3D(stage, sHelperMatrixAlt3D);
        MatrixUtil.transformPoint3D(sHelperMatrixAlt3D, localPoint, sHelperPoint3D);
        return MathUtil.intersectLineWithXYPlane(stage.cameraPosition, sHelperPoint3D, out);
    }

    /** Transforms a point from global (stage) coordinates to the 3D local coordinate system.
     * If you pass an <code>out</code>-vector, the result will be stored in this point instead of
     * creating a new object. */
    public function globalToLocal3D(globalPoint:Point, out:Vector3D=null):Vector3D
    {
        var stage:Stage = this.stage;
        if (stage == null) throw new IllegalOperationError("Object not connected to stage");

        getTransformationMatrix3D(stage, sHelperMatrixAlt3D);
        sHelperMatrixAlt3D.invert();
        return MatrixUtil.transformCoords3D(
            sHelperMatrixAlt3D, globalPoint.x, globalPoint.y, 0, out);
    }

    // internal methods
    
    /** @private */
    private function __setParent(value:DisplayObjectContainer):Void 
    {
        // check for a recursion
        var ancestor:DisplayObject = value;
        while (ancestor != this && ancestor != null)
            ancestor = ancestor.__parent;
        
        if (ancestor == this)
            throw new ArgumentError("An object cannot be added as a child to itself or one " +
                                    "of its children (or children's children, etc.)");
        else
            __parent = value; 
    }

    /** @private */
    private function __setIs3D(value:Bool):Void
    {
        __is3D = value;
    }

    /** @private */
    private var isMask(get, never):Bool;
    private function get_isMask():Bool
    {
        return __maskee != null;
    }

    // render cache

    /** Forces the object to be redrawn in the next frame.
     *  This will prevent the object to be drawn from the render cache.
     *
     *  <p>This method is called every time the object changes in any way. When creating
     *  custom mesh styles or any other custom rendering code, call this method if the object
     *  needs to be redrawn.</p>
     *
     *  <p>If the object needs to be redrawn just because it does not support the render cache,
     *  call <code>painter.excludeFromCache()</code> in the object's render method instead.
     *  That way, Starling's <code>skipUnchangedFrames</code> policy won't be disrupted.</p>
     */
    public function setRequiresRedraw():Void
    {
        var parent:DisplayObject = __parent != null ? __parent : __maskee;
        var frameID:UInt = Starling.current != null ? Starling.current.frameID : 0;

        __lastParentOrSelfChangeFrameID = frameID;
        __hasVisibleArea = __alpha  != 0.0 && __visible && __maskee == null &&
                            __scaleX != 0.0 && __scaleY != 0.0;

        while (parent != null && parent.__lastChildChangeFrameID != frameID)
        {
            parent.__lastChildChangeFrameID = frameID;
            parent = parent.__parent != null ? parent.__parent : parent.__maskee;
        }
    }

    /** Indicates if the object needs to be redrawn in the upcoming frame, i.e. if it has
     *  changed its location relative to the stage or some other aspect of its appearance
     *  since it was last rendered. */
    public var requiresRedraw(get, never):Bool;
    private function get_requiresRedraw():Bool
    {
        var frameID:UInt = Starling.current.frameID;

        return __lastParentOrSelfChangeFrameID == frameID ||
                __lastChildChangeFrameID == frameID;
    }

    /** @private Makes sure the object is not drawn from cache in the next frame.
     *  This method is meant to be called only from <code>Painter.finishFrame()</code>,
     *  since it requires rendering to be concluded. */
    @:allow(starling) private function excludeFromCache():Void
    {
        var object:DisplayObject = this;
        var max:UInt = 0xffffffff;

        while (object != null && object.__tokenFrameID != max)
        {
            object.__tokenFrameID = max;
            object = object.__parent;
        }
    }

    // helpers

    /** @private */
    @:allow(starling) private function __setTransformationChanged():Void
    {
        __transformationChanged = true;
        setRequiresRedraw();
    }

    /** @private */
    @:allow(starling) private function __updateTransformationMatrices(
        x:Float, y:Float, pivotX:Float, pivotY:Float, scaleX:Float, scaleY:Float,
        skewX:Float, skewY:Float, rotation:Float, out:Matrix, out3D:Matrix3D):Void
    {
        if (skewX == 0.0 && skewY == 0.0)
        {
            // optimization: no skewing / rotation simplifies the matrix math

            if (rotation == 0.0)
            {
                out.setTo(scaleX, 0.0, 0.0, scaleY,
                    x - pivotX * scaleX, y - pivotY * scaleY);
            }
            else
            {
                var cos:Float = Math.cos(rotation);
                var sin:Float = Math.sin(rotation);
                var a:Float   = scaleX *  cos;
                var b:Float   = scaleX *  sin;
                var c:Float   = scaleY * -sin;
                var d:Float   = scaleY *  cos;
                var tx:Float  = x - pivotX * a - pivotY * c;
                var ty:Float  = y - pivotX * b - pivotY * d;

                out.setTo(a, b, c, d, tx, ty);
            }
        }
        else
        {
            out.identity();
            out.scale(scaleX, scaleY);
            MatrixUtil.skew(out, skewX, skewY);
            out.rotate(rotation);
            out.translate(x, y);

            if (pivotX != 0.0 || pivotY != 0.0)
            {
                // prepend pivot transformation
                out.tx = x - out.a * pivotX - out.c * pivotY;
                out.ty = y - out.b * pivotX - out.d * pivotY;
            }
        }

        if (out3D != null) MatrixUtil.convertTo3D(out, out3D);
    }

    private static function __findCommonParent(object1:DisplayObject,
                                                object2:DisplayObject):DisplayObject
    {
        var currentObject:DisplayObject = object1;

        while (currentObject != null)
        {
            sAncestors[sAncestors.length] = currentObject; // avoiding 'push'
            currentObject = currentObject.__parent;
        }

        currentObject = object2;
        while (currentObject != null && sAncestors.indexOf(currentObject) == -1)
            currentObject = currentObject.__parent;

        sAncestors.length = 0;

        if (currentObject != null) return currentObject;
        else throw new ArgumentError("Object not connected to target");
    }

    // stage event handling

    /** @private */
    public override function dispatchEvent(event:Event):Void
    {
        if (event.type == Event.REMOVED_FROM_STAGE && stage == null)
            return; // special check to avoid double-dispatch of RfS-event.
        else
            super.dispatchEvent(event);
    }
    
    // enter frame event optimization
    
    // To avoid looping through the complete display tree each frame to find out who's
    // listening to ENTER_FRAME events, we manage a list of them manually in the Stage class.
    // We need to take care that (a) it must be dispatched only when the object is
    // part of the stage, (b) it must not cause memory leaks when the user forgets to call
    // dispose and (c) there might be multiple listeners for this event.
    
    /** @inheritDoc */
    public override function addEventListener(type:String, listener:Function):Void
    {
        if (type == Event.ENTER_FRAME && !hasEventListener(type))
        {
            addEventListener(Event.ADDED_TO_STAGE, __addEnterFrameListenerToStage);
            addEventListener(Event.REMOVED_FROM_STAGE, __removeEnterFrameListenerFromStage);
            if (this.stage != null) __addEnterFrameListenerToStage();
        }
        
        super.addEventListener(type, listener);
    }
    
    /** @inheritDoc */
    public override function removeEventListener(type:String, listener:Function):Void
    {
        super.removeEventListener(type, listener);
        
        if (type == Event.ENTER_FRAME && !hasEventListener(type))
        {
            removeEventListener(Event.ADDED_TO_STAGE, __addEnterFrameListenerToStage);
            removeEventListener(Event.REMOVED_FROM_STAGE, __removeEnterFrameListenerFromStage);
            __removeEnterFrameListenerFromStage();
        }
    }
    
    /** @inheritDoc */
    public override function removeEventListeners(type:String=null):Void
    {
        if ((type == null || type == Event.ENTER_FRAME) && hasEventListener(Event.ENTER_FRAME))
        {
            removeEventListener(Event.ADDED_TO_STAGE, __addEnterFrameListenerToStage);
            removeEventListener(Event.REMOVED_FROM_STAGE, __removeEnterFrameListenerFromStage);
            __removeEnterFrameListenerFromStage();
        }

        super.removeEventListeners(type);
    }
    
    private function __addEnterFrameListenerToStage(e:Event = null):Void
    {
        Starling.current.stage.addEnterFrameListener(this);
    }
    
    private function __removeEnterFrameListenerFromStage(e:Event = null):Void
    {
        Starling.current.stage.removeEnterFrameListener(this);
    }
    
    // properties
 
    /** The transformation matrix of the object relative to its parent.
     * 
     * <p>If you assign a custom transformation matrix, Starling will try to figure out  
     * suitable values for <code>x, y, scaleX, scaleY,</code> and <code>rotation</code>.
     * However, if the matrix was created in a different way, this might not be possible. 
     * In that case, Starling will apply the matrix, but not update the corresponding 
     * properties.</p>
     * 
     * <p>CAUTION: not a copy, but the actual object!</p> */
    public var transformationMatrix(get, set):Matrix;
    @:keep private function get_transformationMatrix():Matrix
    {
        if (__transformationChanged)
        {
            __transformationChanged = false;

            if (__transformationMatrix3D == null && __is3D)
                __transformationMatrix3D = new Matrix3D();

            __updateTransformationMatrices(
                __x, __y, __pivotX, __pivotY, __scaleX, __scaleY, __skewX, __skewY, __rotation,
                __transformationMatrix, __transformationMatrix3D);
        }
        
        return __transformationMatrix;
    }

    private function set_transformationMatrix(matrix:Matrix):Matrix
    {
        var PI_Q:Float = Math.PI / 4.0;

        setRequiresRedraw();
        __transformationChanged = false;
        __transformationMatrix.copyFrom(matrix);
        __pivotX = __pivotY = 0;
        
        __x = matrix.tx;
        __y = matrix.ty;
        
        __skewX = Math.atan(-matrix.c / matrix.d);
        __skewY = Math.atan( matrix.b / matrix.a);

        // NaN check ("isNaN" causes allocation)
        if (__skewX != __skewX) __skewX = 0.0;
        if (__skewY != __skewY) __skewY = 0.0;

        __scaleY = (__skewX > -PI_Q && __skewX < PI_Q) ?  matrix.d / Math.cos(__skewX)
                                                       : -matrix.c / Math.sin(__skewX);
        __scaleX = (__skewY > -PI_Q && __skewY < PI_Q) ?  matrix.a / Math.cos(__skewY)
                                                       :  matrix.b / Math.sin(__skewY);

        if (MathUtil.isEquivalent(__skewX, __skewY))
        {
            __rotation = __skewX;
            __skewX = __skewY = 0;
        }
        else
        {
            __rotation = 0;
        }
        
        return __transformationMatrix;
    }
    
    /** The 3D transformation matrix of the object relative to its parent.
     *
     * <p>For 2D objects, this property returns just a 3D version of the 2D transformation
     * matrix. Only the 'Sprite3D' class supports real 3D transformations.</p>
     *
     * <p>CAUTION: not a copy, but the actual object!</p> */
    public var transformationMatrix3D(get, never):Matrix3D;
    private function get_transformationMatrix3D():Matrix3D
    {
        if (__transformationMatrix3D == null)
            __transformationMatrix3D = MatrixUtil.convertTo3D(__transformationMatrix);

        if (__transformationChanged)
        {
            __transformationChanged = false;
            __updateTransformationMatrices(
                __x, __y, __pivotX, __pivotY, __scaleX, __scaleY, __skewX, __skewY, __rotation,
                __transformationMatrix, __transformationMatrix3D);
        }

        return __transformationMatrix3D;
    }

    /** Indicates if this object or any of its parents is a 'Sprite3D' object. */
    public var is3D(get, never):Bool;
    private function get_is3D():Bool { return __is3D; }

    /** Indicates if the mouse cursor should transform into a hand while it's over the sprite. 
     * @default false */
    public var useHandCursor(get, set):Bool;
    private function get_useHandCursor():Bool { return __useHandCursor; }
    private function set_useHandCursor(value:Bool):Bool
    {
        if (value == __useHandCursor) return value;
        __useHandCursor = value;
        
        if (__useHandCursor)
            addEventListener(TouchEvent.TOUCH, __onTouch);
        else
            removeEventListener(TouchEvent.TOUCH, __onTouch);
        
        return value;
    }
    
    private function __onTouch(event:TouchEvent):Void
    {
        Mouse.cursor = event.interactsWith(this) ? MouseCursor.BUTTON : MouseCursor.AUTO;
    }
    
    /** The bounds of the object relative to the local coordinates of the parent. */
    public var bounds(get, never):Rectangle;
    private function get_bounds():Rectangle
    {
        return getBounds(__parent);
    }
    
    /** The width of the object in pixels.
     * Note that for objects in a 3D space (connected to a Sprite3D), this value might not
     * be accurate until the object is part of the display list. */
    public var width(get, set):Float;
    @:keep private function get_width():Float { return getBounds(__parent, sHelperRect).width; }
    @:keep private function set_width(value:Float):Float
    {
        // this method calls 'this.scaleX' instead of changing _scaleX directly.
        // that way, subclasses reacting on size changes need to override only the scaleX method.

        var actualWidth:Float;
        var scaleIsNaN:Bool = __scaleX != __scaleX; // avoid 'isNaN' call
        var scaleIsZero:Bool = __scaleX < 1e-8 && __scaleX > -1e-8;

        if (scaleIsZero || scaleIsNaN) { scaleX = 1.0; actualWidth = width; }
        else actualWidth = Math.abs(width / __scaleX);

        if (actualWidth != 0) scaleX = value / actualWidth;
        
        return value;
    }
    
    /** The height of the object in pixels.
     * Note that for objects in a 3D space (connected to a Sprite3D), this value might not
     * be accurate until the object is part of the display list. */
    public var height(get, set):Float;
    @:keep private function get_height():Float { return getBounds(__parent, sHelperRect).height; }
    @:keep private function set_height(value:Float):Float
    {
        var actualHeight:Float;
        var scaleIsNaN:Bool = __scaleY != __scaleY; // avoid 'isNaN' call
        var scaleIsZero:Bool = __scaleY < 1e-8 && __scaleY > -1e-8;
        
        if (scaleIsZero || scaleIsNaN) { scaleY = 1.0; actualHeight = height; }
        else actualHeight = Math.abs(height / __scaleY);

        if (actualHeight != 0) scaleY = value / actualHeight;
        
        return height;
    }
    
    /** The x coordinate of the object relative to the local coordinates of the parent. */
    public var x(get, set):Float;
    @:keep private function get_x():Float { return __x; }
    @:keep private function set_x(value:Float):Float
    { 
        if (__x != value)
        {
            __x = value;
            __setTransformationChanged();
        }
        return value;
    }
    
    /** The y coordinate of the object relative to the local coordinates of the parent. */
    public var y(get, set):Float;
    @:keep private function get_y():Float { return __y; }
    @:keep private function set_y(value:Float):Float
    {
        if (__y != value)
        {
            __y = value;
            __setTransformationChanged();
        }
        return value;
    }
    
    /** The x coordinate of the object's origin in its own coordinate space (default: 0). */
    public var pivotX(get, set):Float;
    @:keep private function get_pivotX():Float { return __pivotX; }
    @:keep private function set_pivotX(value:Float):Float
    {
        if (__pivotX != value)
        {
            __pivotX = value;
            __setTransformationChanged();
        }
        return value;
    }
    
    /** The y coordinate of the object's origin in its own coordinate space (default: 0). */
    public var pivotY(get, set):Float;
    @:keep private function get_pivotY():Float { return __pivotY; }
    @:keep private function set_pivotY(value:Float):Float
    { 
        if (__pivotY != value)
        {
            __pivotY = value;
            __setTransformationChanged();
        }
        return value;
    }
    
    /** The horizontal scale factor. '1' means no scale, negative values flip the object.
     * @default 1 */
    public var scaleX(get, set):Float;
    @:keep private function get_scaleX():Float { return __scaleX; }
    @:keep private function set_scaleX(value:Float):Float
    { 
        if (__scaleX != value)
        {
            __scaleX = value;
            __setTransformationChanged();
        }
        return value;
    }
    
    /** The vertical scale factor. '1' means no scale, negative values flip the object.
     * @default 1 */
    public var scaleY(get, set):Float;
    @:keep private function get_scaleY():Float { return __scaleY; }
    @:keep private function set_scaleY(value:Float):Float
    { 
        if (__scaleY != value)
        {
            __scaleY = value;
            __setTransformationChanged();
        }
        return value;
    }

    /** Sets both 'scaleX' and 'scaleY' to the same value. The getter simply returns the
     * value of 'scaleX' (even if the scaling values are different). @default 1 */
    public var scale(get, set):Float;
    @:keep private function get_scale():Float { return scaleX; }
    @:keep private function set_scale(value:Float):Float { return scaleX = scaleY = value; }
    
    /** The horizontal skew angle in radians. */
    public var skewX(get, set):Float;
    @:keep private function get_skewX():Float { return __skewX; }
    @:keep private function set_skewX(value:Float):Float
    {
        value = MathUtil.normalizeAngle(value);
        
        if (__skewX != value)
        {
            __skewX = value;
            __setTransformationChanged();
        }
        return value;
    }
    
    /** The vertical skew angle in radians. */
    public var skewY(get, set):Float;
    @:keep private function get_skewY():Float { return __skewY; }
    @:keep private function set_skewY(value:Float):Float
    {
        value = MathUtil.normalizeAngle(value);
        
        if (__skewY != value)
        {
            __skewY = value;
            __setTransformationChanged();
        }
        return value;
    }
    
    /** The rotation of the object in radians. (In Starling, all angles are measured 
     * in radians.) */
    public var rotation(get, set):Float;
    @:keep private function get_rotation():Float { return __rotation; }
    @:keep private function set_rotation(value:Float):Float
    {
        value = MathUtil.normalizeAngle(value);

        if (__rotation != value)
        {            
            __rotation = value;
            __setTransformationChanged();
        }
        return value;
    }

    /** @private Indicates if the object is rotated or skewed in any way. */
    @:allow(starling) private var isRotated(get, never):Bool;
    private function get_isRotated():Bool
    {
        return __rotation != 0.0 || __skewX != 0.0 || __skewY != 0.0;
    }
    
    /** The opacity of the object. 0 = transparent, 1 = opaque. @default 1 */
    public var alpha(get, set):Float;
    private function get_alpha():Float { return __alpha; }
    private function set_alpha(value:Float):Float 
    { 
        if (value != __alpha)
        {
            __alpha = value < 0.0 ? 0.0 : (value > 1.0 ? 1.0 : value);
            setRequiresRedraw();
        }
        return value;
    }
    
    /** The visibility of the object. An invisible object will be untouchable. */
    public var visible(get, set):Bool;
    private function get_visible():Bool { return __visible; }
    private function set_visible(value:Bool):Bool
    {
        if (value != __visible)
        {
            __visible = value;
            setRequiresRedraw();
        }
        return value; 
    }
    
    /** Indicates if this object (and its children) will receive touch events. */
    public var touchable(get, set):Bool;
    private function get_touchable():Bool { return __touchable; }
    private function set_touchable(value:Bool):Bool { return __touchable = value; }
    
    /** The blend mode determines how the object is blended with the objects underneath. 
     * @default auto
     * @see starling.display.BlendMode */ 
    public var blendMode(get, set):String;
    private function get_blendMode():String { return __blendMode; }
    private function set_blendMode(value:String):String
    {
        if (value != __blendMode)
        {
            __blendMode = value;
            setRequiresRedraw();
        }
        return value;
    }
    
    /** The name of the display object (default: null). Used by 'getChildByName()' of 
     * display object containers. */
    public var name(get, set):String;
    private function get_name():String { return __name; }
    private function set_name(value:String):String { return __name = value; }
    
    /** The filter that is attached to the display object. The <code>starling.filters</code>
     *  package contains several classes that define specific filters you can use. To combine
     *  several filters, assign an instance of the <code>FilterChain</code> class; to remove
     *  all filters, assign <code>null</code>.
     *
     *  <p>Beware that a filter instance may only be used on one object at a time! Furthermore,
     *  when you remove or replace a filter, it is NOT disposed automatically (since you might
     *  want to reuse it on a different object).</p>
     *
     *  @default null
     *  @see starling.filters.FragmentFilter
     *  @see starling.filters.FilterChain
     */
    public var filter(get, set):FragmentFilter;
    private function get_filter():FragmentFilter { return __filter; }
    private function set_filter(value:FragmentFilter):FragmentFilter
    {
        if (value != __filter)
        {
            if (__filter != null) __filter.setTarget(null);
            if (value != null) value.setTarget(this);

            __filter = value;
            setRequiresRedraw();
        }
        return value;
    }

    /** The display object that acts as a mask for the current object.
     *  Assign <code>null</code> to remove it.
     *
     *  <p>A pixel of the masked display object will only be drawn if it is within one of the
     *  mask's polygons. Texture pixels and alpha values of the mask are not taken into
     *  account. The mask object itself is never visible.</p>
     *
     *  <p>If the mask is part of the display list, masking will occur at exactly the
     *  location it occupies on the stage. If it is not, the mask will be placed in the local
     *  coordinate system of the target object (as if it was one of its children).</p>
     *
     *  <p>For rectangular masks, you can use simple quads; for other forms (like circles
     *  or arbitrary shapes) it is recommended to use a 'Canvas' instance.</p>
     *
     *  <p><strong>Note:</strong> a mask will typically cause at least two additional draw
     *  calls: one to draw the mask to the stencil buffer and one to erase it. However, if the
     *  mask object is an instance of <code>starling.display.Quad</code> and is aligned
     *  parallel to the stage axes, rendering will be optimized: instead of using the
     *  stencil buffer, the object will be clipped using the scissor rectangle. That's
     *  faster and reduces the number of draw calls, so make use of this when possible.</p>
     *
     *  <p><strong>Note:</strong> AIR apps require the <code>depthAndStencil</code> node
     *  in the application descriptor XMLs to be enabled! Otherwise, stencil masking won't
     *  work.</p>
     *
     *  @see Canvas
     *  @default null
     */
    public var mask(get, set):DisplayObject;
    private function get_mask():DisplayObject { return __mask; }
    private function set_mask(value:DisplayObject):DisplayObject
    {
        if (__mask != value)
        {
            if (!sMaskWarningShown)
            {
                if (!SystemUtil.supportsDepthAndStencil)
                    trace("[Starling] Full mask support requires 'depthAndStencil'" +
                            " to be enabled in the application descriptor.");

                sMaskWarningShown = true;
            }

            if (__mask != null) __mask.__maskee = null;
            if (value != null)
            {
                value.__maskee = this;
                value.__hasVisibleArea = false;
            }

            __mask = value;
            setRequiresRedraw();
        }
        
        return __mask;
    }
    
    /** Indicates if the masked region of this object is set to be inverted.*/
    public var maskInverted(get, set):Bool;
    private function get_maskInverted():Bool { return __maskInverted; }
    private function set_maskInverted(value:Bool):Bool { return __maskInverted = value; }

    /** The display object container that contains this display object. */
    public var parent(get, never):DisplayObjectContainer;
    private function get_parent():DisplayObjectContainer { return __parent; }
    
    /** The topmost object in the display tree the object is part of. */
    public var base(get, never):DisplayObject;
    private function get_base():DisplayObject
    {
        var currentObject:DisplayObject = this;
        while (currentObject.__parent != null) currentObject = currentObject.__parent;
        return currentObject;
    }
    
    /** The root object the display object is connected to (i.e. an instance of the class 
     * that was passed to the Starling constructor), or null if the object is not connected
     * to the stage. */
    public var root(get, never):DisplayObject;
    private function get_root():DisplayObject
    {
        var currentObject:DisplayObject = this;
        while (currentObject.__parent != null)
        {
            if (#if (haxe_ver < 4.2) Std.is #else Std.isOfType #end(currentObject.__parent, Stage)) return currentObject;
            else currentObject = currentObject.parent;
        }
        
        return null;
    }
    
    /** The stage the display object is connected to, or null if it is not connected 
     * to the stage. */
    public var stage(get, never):Stage;
    private function get_stage():Stage { return #if (haxe_ver < 4.2) Std.is #else Std.isOfType #end(this.base, Stage) ? cast this.base : null; }
}
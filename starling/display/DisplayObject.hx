// =================================================================================================
//
//	Starling Framework
//	Copyright 2011 Gamua OG. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

package starling.display;
import openfl.errors.ArgumentError;
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.system.Capabilities;
import openfl.ui.Mouse;
//import openfl.ui.MouseCursor;
//import openfl.utils.getQualifiedClassName;

import starling.core.RenderSupport;
import starling.core.Starling;
import starling.errors.AbstractClassError;
import starling.errors.AbstractMethodError;
import starling.events.Event;
import starling.events.EventDispatcher;
import starling.events.TouchEvent;
import starling.filters.FragmentFilter;
import starling.utils.HAlign;
import starling.utils.MatrixUtil;
import starling.utils.VAlign;

/** Dispatched when an object is added to a parent. */
//[Event(name="added", type="starling.events.Event")]

/** Dispatched when an object is connected to the stage (directly or indirectly). */
//[Event(name="addedToStage", type="starling.events.Event")]

/** Dispatched when an object is removed from its parent. */
//[Event(name="removed", type="starling.events.Event")]

/** Dispatched when an object is removed from the stage and won't be rendered any longer. */ 
//[Event(name="removedFromStage", type="starling.events.Event")]

/** Dispatched once every frame on every object that is connected to the stage. */ 
//[Event(name="enterFrame", type="starling.events.EnterFrameEvent")]

/** Dispatched when an object is touched. Bubbles. */
//[Event(name="touch", type="starling.events.TouchEvent")]

/** Dispatched when a key on the keyboard is released. */
//[Event(name="keyUp", type="starling.events.KeyboardEvent")]

/** Dispatched when a key on the keyboard is pressed. */
//[Event(name="keyDown", type="starling.events.KeyboardEvent")]

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
 *  <strong>Subclassing</strong>
 *  
 *  <p>Since DisplayObject is an abstract class, you cannot instantiate it directly, but have 
 *  to use one of its subclasses instead. There are already a lot of them available, and most 
 *  of the time they will suffice.</p> 
 *  
 *  <p>However, you can create custom subclasses as well. That way, you can create an object
 *  with a custom render function. You will need to implement the following methods when you 
 *  subclass DisplayObject:</p>
 *  
 *  <ul>
 *    <li><code>function render(support:RenderSupport, parentAlpha:Float):Void</code></li>
 *    <li><code>function getBounds(targetSpace:DisplayObject, 
 *                                 resultRect:Rectangle=null):Rectangle</code></li>
 *  </ul>
 *  
 *  <p>Have a look at the Quad class for a sample implementation of the 'getBounds' method.
 *  For a sample on how to write a custom render function, you can have a look at this
 *  <a href="http://wiki.starling-framework.org/manual/custom_display_objects">article</a>
 *  in the Starling Wiki.</p> 
 * 
 *  <p>When you override the render method, it is important that you call the method
 *  'finishQuadBatch' of the support object. This forces Starling to render all quads that 
 *  were accumulated before by different render methods (for performance reasons). Otherwise, 
 *  the z-ordering will be incorrect.</p> 
 * 
 *  @see DisplayObjectContainer
 *  @see Sprite
 *  @see Stage 
 */
class DisplayObject extends EventDispatcher
{
    private static var TWO_PI:Float = Math.PI * 2.0;
    
    // members
    
    private var mX:Float;
    private var mY:Float;
    private var mPivotX:Float;
    private var mPivotY:Float;
    private var mScaleX:Float;
    private var mScaleY:Float;
    private var mSkewX:Float;
    private var mSkewY:Float;
    private var mRotation:Float;
    private var mAlpha:Float;
    private var mVisible:Bool;
    private var mTouchable:Bool;
    private var mBlendMode:String;
    private var mName:String;
    private var mUseHandCursor:Bool;
    private var mParent:DisplayObjectContainer;  
    private var mTransformationMatrix:Matrix;
    private var mOrientationChanged:Bool;
    private var mFilter:FragmentFilter;
    
    /** Helper objects. */
    private static var sAncestors:Array<DisplayObject> = new Array<DisplayObject>();
    private static var sHelperRect:Rectangle = new Rectangle();
    private static var sHelperMatrix:Matrix  = new Matrix();
    
    /** @private */ 
    public function new()
    {
        //if (Capabilities.isDebugger && 
        //    getQualifiedClassName(this) == "starling.display::DisplayObject")
        //{
        //    throw new AbstractClassError();
        //}
        
        mX = mY = mPivotX = mPivotY = mRotation = mSkewX = mSkewY = 0.0;
        mScaleX = mScaleY = mAlpha = 1.0;            
        mVisible = mTouchable = true;
        mBlendMode = BlendMode.AUTO;
        mTransformationMatrix = new Matrix();
        mOrientationChanged = mUseHandCursor = false;
    }
    
    /** Disposes all resources of the display object. 
      * GPU buffers are released, event listeners are removed, filters are disposed. */
    public function dispose():Void
    {
        if (mFilter != null) mFilter.dispose();
        removeEventListeners();
    }
    
    /** Removes the object from its parent, if it has one, and optionally disposes it. */
    public function removeFromParent(dispose:Bool=false):Void
    {
        if (mParent != null) mParent.removeChild(this, dispose);
        else if (dispose) this.dispose();
    }
    
    /** Creates a matrix that represents the transformation from the local coordinate system 
     *  to another. If you pass a 'resultMatrix', the result will be stored in this matrix
     *  instead of creating a new object. */ 
    public function getTransformationMatrix(targetSpace:DisplayObject, 
                                            resultMatrix:Matrix=null):Matrix
    {
        var commonParent:DisplayObject;
        var currentObject:DisplayObject;
        
        if (resultMatrix != null) resultMatrix.identity();
        else resultMatrix = new Matrix();
        
        if (targetSpace == this)
        {
            return resultMatrix;
        }
        else if (targetSpace == mParent || (targetSpace == null && mParent == null))
        {
            resultMatrix.copyFrom(transformationMatrix);
            return resultMatrix;
        }
        else if (targetSpace == null || targetSpace == base)
        {
            // targetCoordinateSpace 'null' represents the target space of the base object.
            // -> move up from this to base
            
            currentObject = this;
            while (currentObject != targetSpace)
            {
                resultMatrix.concat(currentObject.transformationMatrix);
                currentObject = currentObject.mParent;
            }
            
            return resultMatrix;
        }
        else if (targetSpace.mParent == this) // optimization
        {
            targetSpace.getTransformationMatrix(this, resultMatrix);
            resultMatrix.invert();
            
            return resultMatrix;
        }
        
        // 1. find a common parent of this and the target space
        
        commonParent = null;
        currentObject = this;
        
        while (currentObject != null)
        {
            sAncestors[sAncestors.length] = currentObject; // avoiding 'push'
            currentObject = currentObject.mParent;
        }
        
        currentObject = targetSpace;
        while (currentObject != null && sAncestors.indexOf(currentObject) == -1)
            currentObject = currentObject.mParent;
        
        sAncestors = [];
        
        if (currentObject != null) commonParent = currentObject;
        else throw new ArgumentError("Object not connected to target");
        
        // 2. move up from this to common parent
        
        currentObject = this;
        while (currentObject != commonParent)
        {
            resultMatrix.concat(currentObject.transformationMatrix);
            currentObject = currentObject.mParent;
        }
        
        if (commonParent == targetSpace)
            return resultMatrix;
        
        // 3. now move up from target until we reach the common parent
        
        sHelperMatrix.identity();
        currentObject = targetSpace;
        while (currentObject != commonParent)
        {
            sHelperMatrix.concat(currentObject.transformationMatrix);
            currentObject = currentObject.mParent;
        }
        
        // 4. now combine the two matrices
        
        sHelperMatrix.invert();
        resultMatrix.concat(sHelperMatrix);
        
        return resultMatrix;
    }        
    
    /** Returns a rectangle that completely encloses the object as it appears in another 
     *  coordinate system. If you pass a 'resultRectangle', the result will be stored in this 
     *  rectangle instead of creating a new object. */ 
    public function getBounds(targetSpace:DisplayObject, resultRect:Rectangle=null):Rectangle
    {
        throw new AbstractMethodError();
    }
    
    /** Returns the object that is found topmost beneath a point in local coordinates, or nil if 
     *  the test fails. If "forTouch" is true, untouchable and invisible objects will cause
     *  the test to fail. */
    public function hitTest(localPoint:Point, forTouch:Bool=false):DisplayObject
    {
        // on a touch test, invisible or untouchable objects cause the test to fail
        if (forTouch && (!mVisible || !mTouchable)) return null;
        
        // otherwise, check bounding box
        if (getBounds(this, sHelperRect).containsPoint(localPoint)) return this;
        else return null;
    }
    
    /** Transforms a point from the local coordinate system to global (stage) coordinates.
     *  If you pass a 'resultPoint', the result will be stored in this point instead of 
     *  creating a new object. */
    public function localToGlobal(localPoint:Point, resultPoint:Point=null):Point
    {
        getTransformationMatrix(base, sHelperMatrix);
        return MatrixUtil.transformCoords(sHelperMatrix, localPoint.x, localPoint.y, resultPoint);
    }
    
    /** Transforms a point from global (stage) coordinates to the local coordinate system.
     *  If you pass a 'resultPoint', the result will be stored in this point instead of 
     *  creating a new object. */
    public function globalToLocal(globalPoint:Point, resultPoint:Point=null):Point
    {
        getTransformationMatrix(base, sHelperMatrix);
        sHelperMatrix.invert();
        return MatrixUtil.transformCoords(sHelperMatrix, globalPoint.x, globalPoint.y, resultPoint);
    }
    
    /** Renders the display object with the help of a support object. Never call this method
     *  directly, except from within another render method.
     *  @param support Provides utility functions for rendering.
     *  @param parentAlpha The accumulated alpha value from the object's parent up to the stage. */
    public function render(support:RenderSupport, parentAlpha:Float):Void
    {
        throw new AbstractMethodError();
    }
    
    /** Indicates if an object occupies any visible area. (Which is the case when its 'alpha', 
     *  'scaleX' and 'scaleY' values are not zero, and its 'visible' property is enabled.) */
    public var hasVisibleArea(get, never):Bool;
    private function get_hasVisibleArea():Bool
    {
        return mAlpha != 0.0 && mVisible && mScaleX != 0.0 && mScaleY != 0.0;
    }
    
    /** Moves the pivot point to a certain position within the local coordinate system
     *  of the object. If you pass no arguments, it will be centered. */ 
    public function alignPivot(hAlign:String="center", vAlign:String="center"):Void
    {
        var bounds:Rectangle = getBounds(this);
        mOrientationChanged = true;
        
        if (hAlign == HAlign.LEFT)        mPivotX = bounds.x;
        else if (hAlign == HAlign.CENTER) mPivotX = bounds.x + bounds.width / 2.0;
        else if (hAlign == HAlign.RIGHT)  mPivotX = bounds.x + bounds.width; 
        else throw new ArgumentError("Invalid horizontal alignment: " + hAlign);
        
        if (vAlign == VAlign.TOP)         mPivotY = bounds.y;
        else if (vAlign == VAlign.CENTER) mPivotY = bounds.y + bounds.height / 2.0;
        else if (vAlign == VAlign.BOTTOM) mPivotY = bounds.y + bounds.height;
        else throw new ArgumentError("Invalid vertical alignment: " + vAlign);
    }
    
    // internal methods
    
    /** @private */
    public function setParent(value:DisplayObjectContainer):Void 
    {
        // check for a recursion
        var ancestor:DisplayObject = value;
        while (ancestor != this && ancestor != null)
            ancestor = ancestor.mParent;
        
        if (ancestor == this)
            throw new ArgumentError("An object cannot be added as a child to itself or one " +
                                    "of its children (or children's children, etc.)");
        else
            mParent = value; 
    }
    
    // helpers
    
    private function isEquivalent(a:Float, b:Float, epsilon:Float=0.0001):Bool
    {
        return (a - epsilon < b) && (a + epsilon > b);
    }
    
    private function normalizeAngle(angle:Float):Float
    {
        // move to equivalent value in range [0 deg, 360 deg] without a loop
        angle = angle % TWO_PI;

        // move to [-180 deg, +180 deg]
        if (angle < -Math.PI) angle += TWO_PI;
        if (angle >  Math.PI) angle -= TWO_PI;

        return angle;
    }
    
    // stage event handling
    
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
    
    public override function addEventListener(type:String, listener:Dynamic):Void
    {
        if (type == Event.ENTER_FRAME && !hasEventListener(type))
        {
            addEventListener(Event.ADDED_TO_STAGE, addEnterFrameListenerToStage);
            addEventListener(Event.REMOVED_FROM_STAGE, removeEnterFrameListenerFromStage);
            if (this.stage != null) addEnterFrameListenerToStage();
        }
        
        super.addEventListener(type, listener);
    }
    
    public override function removeEventListener(type:String, listener:Dynamic):Void
    {
        super.removeEventListener(type, listener);
        
        if (type == Event.ENTER_FRAME && !hasEventListener(type))
        {
            removeEventListener(Event.ADDED_TO_STAGE, addEnterFrameListenerToStage);
            removeEventListener(Event.REMOVED_FROM_STAGE, removeEnterFrameListenerFromStage);
            removeEnterFrameListenerFromStage();
        }
    }
    
    public override function removeEventListeners(type:String=null):Void
    {
        super.removeEventListeners(type);
        
        if (type == null || type == Event.ENTER_FRAME)
        {
            removeEventListener(Event.ADDED_TO_STAGE, addEnterFrameListenerToStage);
            removeEventListener(Event.REMOVED_FROM_STAGE, removeEnterFrameListenerFromStage);
            removeEnterFrameListenerFromStage();
        }
    }
    
    private function addEnterFrameListenerToStage(e:Event = null):Void
    {
        Starling.current.stage.addEnterFrameListener(this);
    }
    
    private function removeEnterFrameListenerFromStage(e:Event = null):Void
    {
        Starling.current.stage.removeEnterFrameListener(this);
    }
    
    // properties
 
    /** The transformation matrix of the object relative to its parent.
     * 
     *  <p>If you assign a custom transformation matrix, Starling will try to figure out  
     *  suitable values for <code>x, y, scaleX, scaleY,</code> and <code>rotation</code>.
     *  However, if the matrix was created in a different way, this might not be possible. 
     *  In that case, Starling will apply the matrix, but not update the corresponding 
     *  properties.</p>
     * 
     *  <p>CAUTION: not a copy, but the actual object!</p> */
    public var transformationMatrix(get, set):Matrix;
    private function get_transformationMatrix():Matrix
    {
        if (mOrientationChanged)
        {
            mOrientationChanged = false;
            
            if (mSkewX == 0.0 && mSkewY == 0.0)
            {
                // optimization: no skewing / rotation simplifies the matrix math
                
                if (mRotation == 0.0)
                {
                    mTransformationMatrix.setTo(mScaleX, 0.0, 0.0, mScaleY, 
                        mX - mPivotX * mScaleX, mY - mPivotY * mScaleY);
                }
                else
                {
                    var cos:Float = Math.cos(mRotation);
                    var sin:Float = Math.sin(mRotation);
                    var a:Float   = mScaleX *  cos;
                    var b:Float   = mScaleX *  sin;
                    var c:Float   = mScaleY * -sin;
                    var d:Float   = mScaleY *  cos;
                    var tx:Float  = mX - mPivotX * a - mPivotY * c;
                    var ty:Float  = mY - mPivotX * b - mPivotY * d;
                    
                    mTransformationMatrix.setTo(a, b, c, d, tx, ty);
                }
            }
            else
            {
                mTransformationMatrix.identity();
                mTransformationMatrix.scale(mScaleX, mScaleY);
                MatrixUtil.skew(mTransformationMatrix, mSkewX, mSkewY);
                mTransformationMatrix.rotate(mRotation);
                mTransformationMatrix.translate(mX, mY);
                
                if (mPivotX != 0.0 || mPivotY != 0.0)
                {
                    // prepend pivot transformation
                    mTransformationMatrix.tx = mX - mTransformationMatrix.a * mPivotX
                                                  - mTransformationMatrix.c * mPivotY;
                    mTransformationMatrix.ty = mY - mTransformationMatrix.b * mPivotX 
                                                  - mTransformationMatrix.d * mPivotY;
                }
            }
        }
        
        return mTransformationMatrix; 
    }
    
    private function set_transformationMatrix(matrix:Matrix):Matrix
    {
        var PI_Q:Float = Math.PI / 4.0;

        mOrientationChanged = false;
        mTransformationMatrix.copyFrom(matrix);
        mPivotX = mPivotY = 0;
        
        mX = matrix.tx;
        mY = matrix.ty;
        
        mSkewX = Math.atan(-matrix.c / matrix.d);
        mSkewY = Math.atan( matrix.b / matrix.a);

        // NaN check ("isNaN" causes allocation)
        if (mSkewX != mSkewX) mSkewX = 0.0;
        if (mSkewY != mSkewY) mSkewY = 0.0;

        mScaleY = (mSkewX > -PI_Q && mSkewX < PI_Q) ?  matrix.d / Math.cos(mSkewX)
                                                    : -matrix.c / Math.sin(mSkewX);
        mScaleX = (mSkewY > -PI_Q && mSkewY < PI_Q) ?  matrix.a / Math.cos(mSkewY)
                                                    :  matrix.b / Math.sin(mSkewY);

        if (isEquivalent(mSkewX, mSkewY))
        {
            mRotation = mSkewX;
            mSkewX = mSkewY = 0;
        }
        else
        {
            mRotation = 0;
        }
        return mTransformationMatrix;
    }
    
    /** Indicates if the mouse cursor should transform into a hand while it's over the sprite. 
     *  @default false */
    public var useHandCursor(get, set):Bool;
    private function get_useHandCursor():Bool { return mUseHandCursor; }
    private function set_useHandCursor(value:Bool):Bool
    {
        if (value == mUseHandCursor) return mUseHandCursor;
        mUseHandCursor = value;
        
        if (mUseHandCursor)
            addEventListener(TouchEvent.TOUCH, onTouch);
        else
            removeEventListener(TouchEvent.TOUCH, onTouch);
        return mUseHandCursor;
    }
    
    private function onTouch(event:TouchEvent):Void
    {
        event.interactsWith(this);
        //Mouse.cursor = event.interactsWith(this) ? MouseCursor.BUTTON : MouseCursor.AUTO;
    }
    
    /** The bounds of the object relative to the local coordinates of the parent. */
    public var bounds(get, never):Rectangle;
    private function get_bounds():Rectangle
    {
        return getBounds(mParent);
    }
    
    /** The width of the object in pixels. */
    public var width(get, set):Float;
    private function get_width():Float { return getBounds(mParent, sHelperRect).width; }
    private function set_width(value:Float):Float
    {
        // this method calls 'this.scaleX' instead of changing mScaleX directly.
        // that way, subclasses reacting on size changes need to override only the scaleX method.
        
        scaleX = 1.0;
        var actualWidth:Float = width;
        if (actualWidth != 0.0) scaleX = value / actualWidth;
        return getBounds(mParent, sHelperRect).width;
    }
    
    /** The height of the object in pixels. */
    public var height(get, set):Float;
    private function get_height():Float { return getBounds(mParent, sHelperRect).height; }
    private function set_height(value:Float):Float
    {
        scaleY = 1.0;
        var actualHeight:Float = height;
        if (actualHeight != 0.0) scaleY = value / actualHeight;
        return getBounds(mParent, sHelperRect).height;
    }
    
    /** The x coordinate of the object relative to the local coordinates of the parent. */
    public var x(get, set):Float;
    private function get_x():Float { return mX; }
    private function set_x(value:Float):Float 
    { 
        if (mX != value)
        {
            mX = value;
            mOrientationChanged = true;
        }
        return mX;
    }
    
    /** The y coordinate of the object relative to the local coordinates of the parent. */
    public var y(get, set):Float;
    private function get_y():Float { return mY; }
    private function set_y(value:Float):Float 
    {
        if (mY != value)
        {
            mY = value;
            mOrientationChanged = true;
        }
        return mY;
    }
    
    /** The x coordinate of the object's origin in its own coordinate space (default: 0). */
    public var pivotX(get, set):Float;
    private function get_pivotX():Float { return mPivotX; }
    private function set_pivotX(value:Float):Float 
    {
        if (mPivotX != value)
        {
            mPivotX = value;
            mOrientationChanged = true;
        }
        return mPivotX;
    }
    
    /** The y coordinate of the object's origin in its own coordinate space (default: 0). */
    public var pivotY(get, set):Float;
    private function get_pivotY():Float { return mPivotY; }
    private function set_pivotY(value:Float):Float 
    { 
        if (mPivotY != value)
        {
            mPivotY = value;
            mOrientationChanged = true;
        }
        return mPivotY;
    }
    
    /** The horizontal scale factor. '1' means no scale, negative values flip the object. */
    public var scaleX(get, set):Float;
    private function get_scaleX():Float { return mScaleX; }
    private function set_scaleX(value:Float):Float 
    { 
        if (mScaleX != value)
        {
            mScaleX = value;
            mOrientationChanged = true;
        }
        return mScaleX;
    }
    
    /** The vertical scale factor. '1' means no scale, negative values flip the object. */
    public var scaleY(get, set):Float;
    private function get_scaleY():Float { return mScaleY; }
    private function set_scaleY(value:Float):Float 
    { 
        if (mScaleY != value)
        {
            mScaleY = value;
            mOrientationChanged = true;
        }
        return mScaleY;
    }
    
    /** The horizontal skew angle in radians. */
    public var skewX(get, set):Float;
    private function get_skewX():Float { return mSkewX; }
    private function set_skewX(value:Float):Float 
    {
        value = normalizeAngle(value);
        
        if (mSkewX != value)
        {
            mSkewX = value;
            mOrientationChanged = true;
        }
        return mSkewX;
    }
    
    /** The vertical skew angle in radians. */
    public var skewY(get, set):Float;
    private function get_skewY():Float { return mSkewY; }
    private function set_skewY(value:Float):Float 
    {
        value = normalizeAngle(value);
        
        if (mSkewY != value)
        {
            mSkewY = value;
            mOrientationChanged = true;
        }
        return mSkewY;
    }
    
    /** The rotation of the object in radians. (In Starling, all angles are measured 
     *  in radians.) */
    public var rotation(get, set):Float;
    private function get_rotation():Float { return mRotation; }
    private function set_rotation(value:Float):Float 
    {
        value = normalizeAngle(value);

        if (mRotation != value)
        {            
            mRotation = value;
            mOrientationChanged = true;
        }
        return mRotation;
    }
    
    /** The opacity of the object. 0 = transparent, 1 = opaque. */
    public var alpha(get, set):Float;
    private function get_alpha():Float { return mAlpha; }
    private function set_alpha(value:Float):Float 
    { 
        mAlpha = value < 0.0 ? 0.0 : (value > 1.0 ? 1.0 : value); 
        return mAlpha;
    }
    
    /** The visibility of the object. An invisible object will be untouchable. */
    public var visible(get, set):Bool;
    private function get_visible():Bool { return mVisible; }
    private function set_visible(value:Bool):Bool { return mVisible = value; }
    
    /** Indicates if this object (and its children) will receive touch events. */
    public var touchable(get, set):Bool;
    private function get_touchable():Bool { return mTouchable; }
    private function set_touchable(value:Bool):Bool { return mTouchable = value; }
    
    /** The blend mode determines how the object is blended with the objects underneath. 
     *   @default auto
     *   @see starling.display.BlendMode */ 
    public var blendMode(get, set):String;
    private function get_blendMode():String { return mBlendMode; }
    private function set_blendMode(value:String):String { return mBlendMode = value; }
    
    /** The name of the display object (default: null). Used by 'getChildByName()' of 
     *  display object containers. */
    public var name(get, set):String;
    private function get_name():String { return mName; }
    private function set_name(value:String):String { return mName = value; }
    
    /** The filter that is attached to the display object. The starling.filters
     *  package contains several classes that define specific filters you can use. 
     *  Beware that you should NOT use the same filter on more than one object (for 
     *  performance reasons). Furthermore, when you set this property to 'null' or
     *  assign a different filter, the previous filter is NOT disposed automatically
     *  (since you might want to reuse it). */
    public var filter(get, set):FragmentFilter;
    private function get_filter():FragmentFilter { return mFilter; }
    private function set_filter(value:FragmentFilter):FragmentFilter { return mFilter = value; }
    
    /** The display object container that contains this display object. */
    public var parent(get, never):DisplayObjectContainer;
    private function get_parent():DisplayObjectContainer { return mParent; }
    
    /** The topmost object in the display tree the object is part of. */
    public var base(get, never):DisplayObject;
    private function get_base():DisplayObject
    {
        var currentObject:DisplayObject = this;
        while (currentObject.mParent != null) currentObject = currentObject.mParent;
        return currentObject;
    }
    
    /** The root object the display object is connected to (i.e. an instance of the class 
     *  that was passed to the Starling constructor), or null if the object is not connected
     *  to the stage. */
    public var root(get, never):DisplayObject;
    private function get_root():DisplayObject
    {
        var currentObject:DisplayObject = this;
        while (currentObject.mParent != null)
        {
            if (Std.is(currentObject.mParent, Stage)) return currentObject;
            else currentObject = currentObject.parent;
        }
        
        return null;
    }
    
    /** The stage the display object is connected to, or null if it is not connected 
     *  to the stage. */
    public var stage(get ,never):Stage;
    private function get_stage():Stage {return Std.is(this.base, Stage) ? cast(this.base, Stage) : null; }
}

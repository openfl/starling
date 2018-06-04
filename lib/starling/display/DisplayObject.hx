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

@:jsRequire("starling/display/DisplayObject", "default")

extern class DisplayObject extends EventDispatcher
{
    /** Disposes all resources of the display object. 
      * GPU buffers are released, event listeners are removed, filters and masks are disposed. */
    public function dispose():Void;
    
    /** Removes the object from its parent, if it has one, and optionally disposes it. */
    public function removeFromParent(dispose:Bool=false):Void;
    
    /** Creates a matrix that represents the transformation from the local coordinate system 
     * to another. If you pass an <code>out</code>-matrix, the result will be stored in this matrix
     * instead of creating a new object. */ 
    public function getTransformationMatrix(targetSpace:DisplayObject, 
                                            out:Matrix=null):Matrix;
    
    /** Returns a rectangle that completely encloses the object as it appears in another 
     * coordinate system. If you pass an <code>out</code>-rectangle, the result will be stored in this 
     * rectangle instead of creating a new object. */ 
    public function getBounds(targetSpace:DisplayObject, out:Rectangle=null):Rectangle;
    
    /** Returns the object that is found topmost beneath a point in local coordinates, or nil
     *  if the test fails. Untouchable and invisible objects will cause the test to fail. */
    public function hitTest(localPoint:Point):DisplayObject;

    /** Checks if a certain point is inside the display object's mask. If there is no mask,
     * this method always returns <code>true</code> (because having no mask is equivalent
     * to having one that's infinitely big). */
    public function hitTestMask(localPoint:Point):Bool;

    /** Transforms a point from the local coordinate system to global (stage) coordinates.
     * If you pass an <code>out</code>-point, the result will be stored in this point instead of 
     * creating a new object. */
    public function localToGlobal(localPoint:Point, out:Point=null):Point;
    
    /** Transforms a point from global (stage) coordinates to the local coordinate system.
     * If you pass an <code>out</code>-point, the result will be stored in this point instead of 
     * creating a new object. */
    public function globalToLocal(globalPoint:Point, out:Point=null):Point;
    
    /** Renders the display object with the help of a painter object. Never call this method
     *  directly, except from within another render method.
     *
     *  @param painter Captures the current render state and provides utility functions
     *                 for rendering.
     */
    public function render(painter:Painter):Void;
    
    /** Moves the pivot point to a certain position within the local coordinate system
     * of the object. If you pass no arguments, it will be centered. */ 
    public function alignPivot(horizontalAlign:String="center",
                               verticalAlign:String="center"):Void;

    /** Draws the object into a BitmapData object.
     * 
     *  <p>This is achieved by drawing the object into the back buffer and then copying the
     *  pixels of the back buffer into a texture. This also means that the returned bitmap
     *  data cannot be bigger than the current viewPort.</p>
     *
     *  @param out   If you pass null, the object will be created for you.
     *               If you pass a BitmapData object, it should have the size of the
     *               object bounds, multiplied by the current contentScaleFactor.
     *  @param color The RGB color value with which the bitmap will be initialized.
     *  @param alpha The alpha value with which the bitmap will be initialized.
     */
    public function drawToBitmapData(out:BitmapData=null,
                                       color:UInt=0x0, alpha:Float=0.0):BitmapData;

    // 3D transformation

    /** Creates a matrix that represents the transformation from the local coordinate system
     * to another. This method supports three dimensional objects created via 'Sprite3D'.
     * If you pass an <code>out</code>-matrix, the result will be stored in this matrix
     * instead of creating a new object. */
    public function getTransformationMatrix3D(targetSpace:DisplayObject,
                                                out:Matrix3D=null):Matrix3D;

    /** Transforms a 3D point from the local coordinate system to global (stage) coordinates.
     * This is achieved by projecting the 3D point onto the (2D) view plane.
     *
     * <p>If you pass an <code>out</code>-point, the result will be stored in this point instead of
     * creating a new object.</p> */
    public function local3DToGlobal(localPoint:Vector3D, out:Point=null):Point;

    /** Transforms a point from global (stage) coordinates to the 3D local coordinate system.
     * If you pass an <code>out</code>-vector, the result will be stored in this point instead of
     * creating a new object. */
    public function globalToLocal3D(globalPoint:Point, out:Vector3D=null):Vector3D;

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
    public function setRequiresRedraw():Void;

    /** Indicates if the object needs to be redrawn in the upcoming frame, i.e. if it has
     *  changed its location relative to the stage or some other aspect of its appearance
     *  since it was last rendered. */
    public var requiresRedraw(get, never):Bool;
    private function get_requiresRedraw():Bool;

    // stage event handling

    /** @private */
    public override function dispatchEvent(event:Event):Void;
    
    // enter frame event optimization
    
    // To avoid looping through the complete display tree each frame to find out who's
    // listening to ENTER_FRAME events, we manage a list of them manually in the Stage class.
    // We need to take care that (a) it must be dispatched only when the object is
    // part of the stage, (b) it must not cause memory leaks when the user forgets to call
    // dispose and (c) there might be multiple listeners for this event.
    
    /** @inheritDoc */
    public override function addEventListener(type:String, listener:Function):Void;
    
    /** @inheritDoc */
    public override function removeEventListener(type:String, listener:Function):Void;
    
    /** @inheritDoc */
    public override function removeEventListeners(type:String=null):Void;
    
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
    @:keep private function get_transformationMatrix():Matrix;

    private function set_transformationMatrix(matrix:Matrix):Matrix;
    
    /** The 3D transformation matrix of the object relative to its parent.
     *
     * <p>For 2D objects, this property returns just a 3D version of the 2D transformation
     * matrix. Only the 'Sprite3D' class supports real 3D transformations.</p>
     *
     * <p>CAUTION: not a copy, but the actual object!</p> */
    public var transformationMatrix3D(get, never):Matrix3D;
    private function get_transformationMatrix3D():Matrix3D;

    /** Indicates if this object or any of its parents is a 'Sprite3D' object. */
    public var is3D(get, never):Bool;
    private function get_is3D():Bool;

    /** Indicates if the mouse cursor should transform into a hand while it's over the sprite. 
     * @default false */
    public var useHandCursor(get, set):Bool;
    private function get_useHandCursor():Bool;
    private function set_useHandCursor(value:Bool):Bool;
    
    /** The bounds of the object relative to the local coordinates of the parent. */
    public var bounds(get, never):Rectangle;
    private function get_bounds():Rectangle;
    
    /** The width of the object in pixels.
     * Note that for objects in a 3D space (connected to a Sprite3D), this value might not
     * be accurate until the object is part of the display list. */
    public var width(get, set):Float;
    private function get_width():Float;
    private function set_width(value:Float):Float;
    
    /** The height of the object in pixels.
     * Note that for objects in a 3D space (connected to a Sprite3D), this value might not
     * be accurate until the object is part of the display list. */
    public var height(get, set):Float;
    private function get_height():Float;
    private function set_height(value:Float):Float;
    
    /** The x coordinate of the object relative to the local coordinates of the parent. */
    public var x(get, set):Float;
    private function get_x():Float;
    private function set_x(value:Float):Float;
    
    /** The y coordinate of the object relative to the local coordinates of the parent. */
    public var y(get, set):Float;
    private function get_y():Float;
    private function set_y(value:Float):Float;
    
    /** The x coordinate of the object's origin in its own coordinate space (default: 0). */
    public var pivotX(get, set):Float;
    private function get_pivotX():Float;
    private function set_pivotX(value:Float):Float;
    
    /** The y coordinate of the object's origin in its own coordinate space (default: 0). */
    public var pivotY(get, set):Float;
    private function get_pivotY():Float;
    private function set_pivotY(value:Float):Float;
    
    /** The horizontal scale factor. '1' means no scale, negative values flip the object.
     * @default 1 */
    public var scaleX(get, set):Float;
    private function get_scaleX():Float;
    private function set_scaleX(value:Float):Float;
    
    /** The vertical scale factor. '1' means no scale, negative values flip the object.
     * @default 1 */
    public var scaleY(get, set):Float;
    private function get_scaleY():Float;
    private function set_scaleY(value:Float):Float;

    /** Sets both 'scaleX' and 'scaleY' to the same value. The getter simply returns the
     * value of 'scaleX' (even if the scaling values are different). @default 1 */
    public var scale(get, set):Float;
    private function get_scale():Float;
    private function set_scale(value:Float):Float;
    
    /** The horizontal skew angle in radians. */
    public var skewX(get, set):Float;
    private function get_skewX():Float;
    private function set_skewX(value:Float):Float;
    
    /** The vertical skew angle in radians. */
    public var skewY(get, set):Float;
    private function get_skewY():Float;
    private function set_skewY(value:Float):Float;
    
    /** The rotation of the object in radians. (In Starling, all angles are measured 
     * in radians.) */
    public var rotation(get, set):Float;
    private function get_rotation():Float;
    private function set_rotation(value:Float):Float;
    
    /** The opacity of the object. 0 = transparent, 1 = opaque. @default 1 */
    public var alpha(get, set):Float;
    private function get_alpha():Float;
    private function set_alpha(value:Float):Float;
    
    /** The visibility of the object. An invisible object will be untouchable. */
    public var visible(get, set):Bool;
    private function get_visible():Bool;
    private function set_visible(value:Bool):Bool;
    
    /** Indicates if this object (and its children) will receive touch events. */
    public var touchable(get, set):Bool;
    private function get_touchable():Bool;
    private function set_touchable(value:Bool):Bool;
    
    /** The blend mode determines how the object is blended with the objects underneath. 
     * @default auto
     * @see starling.display.BlendMode */ 
    public var blendMode(get, set):String;
    private function get_blendMode():String;
    private function set_blendMode(value:String):String;
    
    /** The name of the display object (default: null). Used by 'getChildByName()' of 
     * display object containers. */
    public var name(get, set):String;
    private function get_name():String;
    private function set_name(value:String):String;
    
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
    private function get_filter():FragmentFilter;
    private function set_filter(value:FragmentFilter):FragmentFilter;

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
    private function get_mask():DisplayObject;
    private function set_mask(value:DisplayObject):DisplayObject;
    
    /** Indicates if the masked region of this object is set to be inverted.*/
    public var maskInverted(get, set):Bool;
    private function get_maskInverted():Bool;
    private function set_maskInverted(value:Bool):Bool;

    /** The display object container that contains this display object. */
    public var parent(get, never):DisplayObjectContainer;
    private function get_parent():DisplayObjectContainer;
    
    /** The topmost object in the display tree the object is part of. */
    public var base(get, never):DisplayObject;
    private function get_base():DisplayObject;
    
    /** The root object the display object is connected to (i.e. an instance of the class 
     * that was passed to the Starling constructor), or null if the object is not connected
     * to the stage. */
    public var root(get, never):DisplayObject;
    private function get_root():DisplayObject;
    
    /** The stage the display object is connected to, or null if it is not connected 
     * to the stage. */
    public var stage(get, never):Stage;
    private function get_stage():Stage;
}
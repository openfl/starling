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

import openfl.errors.IllegalOperationError;
import openfl.geom.Matrix;
import openfl.geom.Matrix3D;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.geom.Vector3D;
import openfl.Vector;

import starling.core.Starling;
import starling.events.EnterFrameEvent;
import starling.events.Event;
import starling.filters.FragmentFilter;
import starling.utils.MatrixUtil;
import starling.utils.RectangleUtil;

/** Dispatched when the Flash container is resized. */
@:meta(Event(name="resize", type="starling.events.ResizeEvent"))

/** A Stage represents the root of the display tree.  
 *  Only objects that are direct or indirect children of the stage will be rendered.
 * 
 *  <p>This class represents the Starling version of the stage. Don't confuse it with its 
 *  Flash equivalent: while the latter contains objects of the type 
 *  <code>flash.display.DisplayObject</code>, the Starling stage contains only objects of the
 *  type <code>starling.display.DisplayObject</code>. Those classes are not compatible, and 
 *  you cannot exchange one type with the other.</p>
 * 
 *  <p>A stage object is created automatically by the <code>Starling</code> class. Don't
 *  create a Stage instance manually.</p>
 * 
 *  <strong>Keyboard Events</strong>
 * 
 *  <p>In Starling, keyboard events are only dispatched at the stage. Add an event listener
 *  directly to the stage to be notified of keyboard events.</p>
 * 
 *  <strong>Resize Events</strong>
 * 
 *  <p>When the Flash player is resized, the stage dispatches a <code>ResizeEvent</code>. The 
 *  event contains properties containing the updated width and height of the Flash player.</p>
 *
 *  @see starling.events.KeyboardEvent
 *  @see starling.events.ResizeEvent  
 * 
 */
class Stage extends DisplayObjectContainer
{
    @:noCompletion private var __width:Int;
    @:noCompletion private var __height:Int;
    @:noCompletion private var __color:UInt;
    @:noCompletion private var __fieldOfView:Float;
    @:noCompletion private var __projectionOffset:Point;
    @:noCompletion private var __cameraPosition:Vector3D;
    @:noCompletion private var __enterFrameEvent:EnterFrameEvent;
    @:noCompletion private var __enterFrameListeners:Vector<DisplayObject>;

    /** Helper objects. */
    private static var sMatrix:Matrix = new Matrix();
    private static var sMatrix3D:Matrix3D = new Matrix3D();

    #if commonjs
    private static function __init__ () {
        
        untyped Object.defineProperties (Stage.prototype, {
            "color": { get: untyped __js__ ("function () { return this.get_color (); }"), set: untyped __js__ ("function (v) { return this.set_color (v); }") },
            "stageWidth": { get: untyped __js__ ("function () { return this.get_stageWidth (); }"), set: untyped __js__ ("function (v) { return this.set_stageWidth (v); }") },
            "stageHeight": { get: untyped __js__ ("function () { return this.get_stageHeight (); }"), set: untyped __js__ ("function (v) { return this.set_stageHeight (v); }") },
            "starling": { get: untyped __js__ ("function () { return this.get_starling (); }"), set: untyped __js__ ("function (v) { return this.set_starling (v); }") },
            "focalLength": { get: untyped __js__ ("function () { return this.get_focalLength (); }"), set: untyped __js__ ("function (v) { return this.set_focalLength (v); }") },
            "fieldOfView": { get: untyped __js__ ("function () { return this.get_fieldOfView (); }"), set: untyped __js__ ("function (v) { return this.set_fieldOfView (v); }") },
            "projectionOffset": { get: untyped __js__ ("function () { return this.get_projectionOffset (); }"), set: untyped __js__ ("function (v) { return this.set_projectionOffset (v); }") },
            "cameraPosition": { get: untyped __js__ ("function () { return this.get_cameraPosition (); }") },
        });
        
    }
    #end

    /** @private */
    private function new(width:Int, height:Int, color:UInt=0)
    {
        super();

        __width = width;
        __height = height;
        __color = color;
        __fieldOfView = 1.0;
        __projectionOffset = new Point();
        __cameraPosition = new Vector3D();
        __enterFrameEvent = new EnterFrameEvent(Event.ENTER_FRAME, 0.0);
        __enterFrameListeners = new Vector<DisplayObject>();
    }
    
    /** @inheritDoc */
    public function advanceTime(passedTime:Float):Void
    {
        __enterFrameEvent.reset(Event.ENTER_FRAME, false, passedTime);
        broadcastEvent(__enterFrameEvent);
    }

    /** Returns the object that is found topmost beneath a point in stage coordinates, or  
     * the stage itself if nothing else is found. */
    public override function hitTest(localPoint:Point):DisplayObject
    {
        if (!visible || !touchable) return null;
        
        // locations outside of the stage area shouldn't be accepted
        if (localPoint.x < 0 || localPoint.x > __width ||
            localPoint.y < 0 || localPoint.y > __height)
            return null;
        
        // if nothing else is hit, the stage returns itself as target
        var target:DisplayObject = super.hitTest(localPoint);
        return target != null ? target : this;
    }
    
    /** Returns the stage bounds (i.e. not the bounds of its contents, but the rectangle
     *  spawned up by 'stageWidth' and 'stageHeight') in another coordinate system. */
    public function getStageBounds(targetSpace:DisplayObject, out:Rectangle=null):Rectangle
    {
        if (out == null) out = new Rectangle();

        out.setTo(0, 0, __width, __height);
        getTransformationMatrix(targetSpace, sMatrix);

        return RectangleUtil.getBounds(out, sMatrix, out);
    }
    
    /** Returns the bounds of the screen (or application window, on Desktop) relative to
     *  a certain coordinate system. In most cases, that's identical to the stage bounds;
     *  however, this changes if the viewPort is customized. */
    public function getScreenBounds(targetSpace:DisplayObject, out:Rectangle=null):Rectangle
    {
        var target:Starling = this.starling;
        if (target == null) return getStageBounds(targetSpace, out);
        if (out == null) out = new Rectangle();

        var nativeStage:Dynamic = target.nativeStage;
        var viewPort:Rectangle = target.viewPort;
        var scaleX:Float = __width  / viewPort.width;
        var scaleY:Float = __height / viewPort.height;
        var x:Float = -viewPort.x * scaleX;
        var y:Float = -viewPort.y * scaleY;

        out.setTo(x, y, nativeStage.stageWidth * scaleX, nativeStage.stageHeight * scaleY);
        getTransformationMatrix(targetSpace, sMatrix);

        return RectangleUtil.getBounds(out, sMatrix, out);
    }

    // camera positioning

    /** Returns the position of the camera within the local coordinate system of a certain
     * display object. If you do not pass a space, the method returns the global position.
     * To change the position of the camera, you can modify the properties 'fieldOfView',
     * 'focalDistance' and 'projectionOffset'.
     */
    public function getCameraPosition(space:DisplayObject=null, out:Vector3D=null):Vector3D
    {
        getTransformationMatrix3D(space, sMatrix3D);

        return MatrixUtil.transformCoords3D(sMatrix3D,
            __width / 2 + __projectionOffset.x, __height / 2 + __projectionOffset.y,
           -focalLength, out);
    }

    // enter frame event optimization
    
    /** @private */
    @:allow(starling) private function addEnterFrameListener(listener:DisplayObject):Void
    {
        var index:Int = __enterFrameListeners.indexOf(listener);
        if (index < 0)  __enterFrameListeners[__enterFrameListeners.length] = listener;
    }
    
    /** @private */
    @:allow(starling) private function removeEnterFrameListener(listener:DisplayObject):Void
    {
        var index:Int = __enterFrameListeners.indexOf(listener);
        if (index >= 0) __enterFrameListeners.removeAt(index); 
    }
    
    /** @private */
    @:allow(starling) private override function __getChildEventListeners(object:DisplayObject, eventType:String, 
                                                                         listeners:Vector<DisplayObject>):Void
    {
        if (eventType == Event.ENTER_FRAME && object == this)
        {
            var length:Int = __enterFrameListeners.length;
            for (i in 0...length)
                listeners[listeners.length] = __enterFrameListeners[i]; // avoiding 'push' 
        }
        else
            super.__getChildEventListeners(object, eventType, listeners);
    }
    
    // properties
    
    /** @private */
    private override function set_width(value:Float):Float 
    { 
        throw new IllegalOperationError("Cannot set width of stage");
        return 0;
    }
    
    /** @private */
    private override function set_height(value:Float):Float
    {
        throw new IllegalOperationError("Cannot set height of stage");
        return 0;
    }
    
    /** @private */
    private override function set_x(value:Float):Float
    {
        throw new IllegalOperationError("Cannot set x-coordinate of stage");
        return 0;
    }
    
    /** @private */
    private override function set_y(value:Float):Float
    {
        throw new IllegalOperationError("Cannot set y-coordinate of stage");
        return 0;
    }
    
    /** @private */
    private override function set_scaleX(value:Float):Float
    {
        throw new IllegalOperationError("Cannot scale stage");
        return 0;
    }

    /** @private */
    private override function set_scaleY(value:Float):Float
    {
        throw new IllegalOperationError("Cannot scale stage");
        return 0;
    }
    
    /** @private */
    private override function set_rotation(value:Float):Float
    {
        throw new IllegalOperationError("Cannot rotate stage");
        return 0;
    }
    
    /** @private */
    private override function set_skewX(value:Float):Float
    {
        throw new IllegalOperationError("Cannot skew stage");
        return 0;
    }
    
    /** @private */
    private override function set_skewY(value:Float):Float
    {
        throw new IllegalOperationError("Cannot skew stage");
        return 0;
    }
    
    /** @private */
    private override function set_filter(value:FragmentFilter):FragmentFilter
    {
        throw new IllegalOperationError("Cannot add filter to stage. Add it to 'root' instead!");
        return null;
    }
    
    /** The background color of the stage. */
    public var color(get, set):UInt;
    private function get_color():UInt { return __color; }
    private function set_color(value:UInt):UInt
    {
        if (__color != value)
        {
            __color = value;
            setRequiresRedraw();
        }
        return value;
    }
    
    /** The width of the stage coordinate system. Change it to scale its contents relative
     * to the <code>viewPort</code> property of the Starling object. */ 
    public var stageWidth(get, set):Int;
    private function get_stageWidth():Int { return __width; }
    private function set_stageWidth(value:Int):Int
    {
        if (__width != value)
        {
            __width = value;
            setRequiresRedraw();
        }
        return value;
    }
    
    /** The height of the stage coordinate system. Change it to scale its contents relative
     * to the <code>viewPort</code> property of the Starling object. */
    public var stageHeight(get, set):Int;
    private function get_stageHeight():Int { return __height; }
    private function set_stageHeight(value:Int):Int
    {
        if (__height != value)
        {
            __height = value;
            setRequiresRedraw();
        }
        return value;
    }

    /** The Starling instance this stage belongs to. */
    public var starling(get, never):Starling;
    private function get_starling():Starling
    {
        var instances:Vector<Starling> = Starling.all;
        var numInstances:Int = instances.length;

        for (i in 0...numInstances)
            if (instances[i].stage == this) return instances[i];

        return null;
    }

    /** The distance between the stage and the camera. Changing this value will update the
     * field of view accordingly. */
    public var focalLength(get, set):Float;
    private function get_focalLength():Float
    {
        return __width / (2 * Math.tan(__fieldOfView/2));
    }

    private function set_focalLength(value:Float):Float
    {
        __fieldOfView = 2 * Math.atan(stageWidth / (2*value));
        setRequiresRedraw();
        return value;
    }

    /** Specifies an angle (radian, between zero and PI) for the field of view. This value
     * determines how strong the perspective transformation and distortion apply to a Sprite3D
     * object.
     *
     * <p>A value close to zero will look similar to an orthographic projection; a value
     * close to PI results in a fisheye lens effect. If the field of view is set to 0 or PI,
     * nothing is seen on the screen.</p>
     *
     * @default 1.0
     */
    public var fieldOfView(get, set):Float;
    private function get_fieldOfView():Float { return __fieldOfView; }
    private function set_fieldOfView(value:Float):Float
    {
        __fieldOfView = value;
        setRequiresRedraw();
        return value;
    }

    /** A vector that moves the camera away from its default position in the center of the
     * stage. Use this property to change the center of projection, i.e. the vanishing
     * point for 3D display objects. <p>CAUTION: not a copy, but the actual object!</p>
     */
    public var projectionOffset(get, set):Point;
    private function get_projectionOffset():Point { return __projectionOffset; }
    private function set_projectionOffset(value:Point):Point
    {
        __projectionOffset.setTo(value.x, value.y);
        setRequiresRedraw();
        return value;
    }

    /** The global position of the camera. This property can only be used to find out the
     * current position, but not to modify it. For that, use the 'projectionOffset',
     * 'fieldOfView' and 'focalLength' properties. If you need the camera position in
     * a certain coordinate space, use 'getCameraPosition' instead.
     *
     * <p>CAUTION: not a copy, but the actual object!</p>
     */
    public var cameraPosition(get, never):Vector3D;
    private function get_cameraPosition():Vector3D
    {
        return getCameraPosition(null, __cameraPosition);
    }
}
// =================================================================================================
//
//	Starling Framework
//	Copyright Gamua GmbH. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

package starling.events;

import openfl.errors.Error;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.utils.Object;
import openfl.Lib;
import openfl.Vector;

import starling.core.Starling;
import starling.display.DisplayObject;
import starling.display.Stage;
import starling.utils.MathUtil;
import starling.utils.Pool;

/** The TouchProcessor is used to convert mouse and touch events of the conventional
 *  Flash stage to Starling's TouchEvents.
 *  
 *  <p>The Starling instance listens to mouse and touch events on the native stage. The
 *  attributes of those events are enqueued (right as they are happening) in the
 *  TouchProcessor.</p>
 *  
 *  <p>Once per frame, the "advanceTime" method is called. It analyzes the touch queue and
 *  figures out which touches are active at that moment; the properties of all touch objects
 *  are updated accordingly.</p>
 *  
 *  <p>Once the list of touches has been finalized, the "processTouches" method is called
 *  (that might happen several times in one "advanceTime" execution; no information is
 *  discarded). It's responsible for dispatching the actual touch events to the Starling
 *  display tree.</p>
 *  
 *  <strong>Subclassing TouchProcessor</strong>
 *  
 *  <p>You can extend the TouchProcessor if you need to have more control over touch and
 *  mouse input. For example, you could filter the touches by overriding the "processTouches"
 *  method, throwing away any touches you're not interested in and passing the rest to the
 *  super implementation.</p>
 *  
 *  <p>To use your custom TouchProcessor, assign it to the "Starling.touchProcessor"
 *  property.</p>
 *  
 *  <p>Note that you should not dispatch TouchEvents yourself, since they are
 *  much more complex to handle than conventional events (e.g. it must be made sure that an
 *  object receives a TouchEvent only once, even if it's manipulated with several fingers).
 *  Always use the base implementation of "processTouches" to let them be dispatched. That
 *  said: you can always dispatch your own custom events, of course.</p>
 */
class TouchProcessor
{
    @:noCompletion private var __stage:Stage;
    @:noCompletion private var __root:DisplayObject;
    @:noCompletion private var __elapsedTime:Float;
    @:noCompletion private var __lastTaps:Vector<Touch>;
    @:noCompletion private var __shiftDown:Bool = false;
    @:noCompletion private var __ctrlDown:Bool  = false;
    @:noCompletion private var __multitapTime:Float = 0.3;
    @:noCompletion private var __multitapDistance:Float = 25;
    @:noCompletion private var __touchEvent:TouchEvent;
    @:noCompletion private var __isProcessing:Bool;
    @:noCompletion private var __cancelRequested:Bool;

    @:noCompletion private var __touchMarker:TouchMarker;
    @:noCompletion private var __simulateMultitouch:Bool;
    @:noCompletion private var __occlusionTest:Float->Float->Bool;

    // system gesture detection
    @:noCompletion private var __discardSystemGestures:Bool;
    @:noCompletion private var __systemGestureTouchID:Int = -1;
    @:noCompletion private var __systemGestureMargins:Array<Float> = [15, 15, 15, 0];
    
    /** A vector of arrays with the arguments that were passed to the "enqueue"
     * method (the oldest being at the end of the vector). */
    @:noCompletion private var __queue:Vector<TouchData>;
    
    /** The list of all currently active touches. */
    @:noCompletion private var __currentTouches:Vector<Touch>;
    
    /** Helper objects. */
    private static var sUpdatedTouches:Vector<Touch> = new Vector<Touch>();
    private static var sHoveringTouchData:Array<Object> = new Array<Object>();
    private static var sHelperPoint:Point = new Point();
    
    private static inline var TOP:Int = 0;
    private static inline var BOTTOM:Int = 1;
    private static inline var LEFT:Int = 2;
    private static inline var RIGHT:Int = 3;
    
    #if commonjs
    private static function __init__ () {
        
        untyped global.Object.defineProperties (TouchProcessor.prototype, {
            "simulateMultitouch": { get: untyped __js__ ("function () { return this.get_simulateMultitouch (); }"), set: untyped __js__ ("function (v) { return this.set_simulateMultitouch (v); }") },
            "multitapTime": { get: untyped __js__ ("function () { return this.get_multitapTime (); }"), set: untyped __js__ ("function (v) { return this.set_multitapTime (v); }") },
            "multitapDistance": { get: untyped __js__ ("function () { return this.get_multitapDistance (); }"), set: untyped __js__ ("function (v) { return this.set_multitapDistance (v); }") },
            "root": { get: untyped __js__ ("function () { return this.get_root (); }"), set: untyped __js__ ("function (v) { return this.set_root (v); }") },
            "stage": { get: untyped __js__ ("function () { return this.get_stage (); }") },
            "numCurrentTouches": { get: untyped __js__ ("function () { return this.get_numCurrentTouches (); }") },
            "occlusionTest": { get: untyped __js__ ("function () { return this.get_occlusionTest (); }"), set: untyped __js__ ("function (v) { return this.set_occlusionTest (v); }") },
            "discardSystemGestures": { get: untyped __js__ ("function () { return this.get_discardSystemGestures (); }"), set: untyped __js__ ("function (v) { return this.set_discardSystemGestures (v); }") },
        });
        
    }
    #end
    
    /** Creates a new TouchProcessor that will dispatch events to the given stage. */
    public function new(stage:Stage)
    {
        __root = __stage = stage;
        __elapsedTime = 0.0;
        __currentTouches = new Vector<Touch>();
        __queue = new Vector<TouchData>();
        __lastTaps = new Vector<Touch>();
        __touchEvent = new TouchEvent(TouchEvent.TOUCH);

        __stage.addEventListener(KeyboardEvent.KEY_DOWN, onKey);
        __stage.addEventListener(KeyboardEvent.KEY_UP,   onKey);
        monitorInterruptions(true);
    }

    /** Removes all event handlers on the stage and releases any acquired resources. */
    public function dispose():Void
    {
        monitorInterruptions(false);
        __stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKey);
        __stage.removeEventListener(KeyboardEvent.KEY_UP,   onKey);
        if (__touchMarker != null) __touchMarker.dispose();
    }
    
    /** Analyzes the current touch queue and processes the list of current touches, emptying
     * the queue while doing so. This method is called by Starling once per frame. */
    public function advanceTime(passedTime:Float):Void
    {
        if (__isProcessing) return;
        else __isProcessing = true;

        var i:Int;
        var touch:Touch;
        var numIterations:Int = 0;
        var touchData:TouchData;
        
        __elapsedTime += passedTime;
        sUpdatedTouches.length = 0;
        
        // remove old taps
        if (__lastTaps.length > 0)
        {
            var i:Int = __lastTaps.length - 1;
            while (i >= 0)
            {
                if (__elapsedTime - __lastTaps[i].timestamp > __multitapTime)
                    __lastTaps.removeAt(i);
                --i;
            }
        }
        
        while (__queue.length > 0 || numIterations == 0)
        {
            ++numIterations; // we need to enter this loop at least once (for HOVER updates)

            // Set touches that were new or moving to phase 'stationary'.
            for (touch in __currentTouches)
                if (touch.phase == TouchPhase.BEGAN || touch.phase == TouchPhase.MOVED)
                    touch.phase = TouchPhase.STATIONARY;

            // analyze new touches, but each ID only once
            while (__queue.length > 0 &&
                  !containsTouchWithID(sUpdatedTouches, __queue[__queue.length-1].id))
            {
                touchData = __queue.pop();
                touch = createOrUpdateTouch(touchData);
                sUpdatedTouches[sUpdatedTouches.length] = touch; // avoiding 'push'
                TouchData.toPool(touchData);
            }

            // Find any hovering touches that did not move.
            // If the target of such a touch changed, add it to the list of updated touches.
            i = __currentTouches.length-1;
            while (i>=0)
            {
                touch = __currentTouches[i];
                if (touch.phase == TouchPhase.HOVER && !containsTouchWithID(sUpdatedTouches, touch.id))
                {
                    sHelperPoint.setTo(touch.globalX, touch.globalY);
                    if (touch.target != __root.hitTest(sHelperPoint))
                        sUpdatedTouches[sUpdatedTouches.length] = touch;
                }
                --i;
            }

            // process the current set of touches (i.e. dispatch touch events)
            processTouches(sUpdatedTouches, __shiftDown, __ctrlDown);

            // remove ended touches
            i = __currentTouches.length-1;
            while (i>=0)
            {
                if (__currentTouches[i].phase == TouchPhase.ENDED)
                    __currentTouches.removeAt(i);
                --i;
            }

            sUpdatedTouches.length = 0;
        }
        
        __isProcessing = false;
        if (__cancelRequested) cancelTouches();
    }
    
    /** Dispatches TouchEvents to the display objects that are affected by the list of
     * given touches. Called internally by "advanceTime". To calculate updated targets,
     * the method will call "hitTest" on the "root" object.
     * 
     * @param touches    a list of all touches that have changed just now.
     * @param shiftDown  indicates if the shift key was down when the touches occurred.
     * @param ctrlDown   indicates if the ctrl or cmd key was down when the touches occurred.
     */
    private function processTouches(touches:Vector<Touch>,
                                    shiftDown:Bool, ctrlDown:Bool):Void
    {
        var touch:Touch;
        #if haxe4
        sHoveringTouchData.resize(0);
        #else
        sHoveringTouchData.splice(0, sHoveringTouchData.length);
        #end

        // the same touch event will be dispatched to all targets;
        // the 'dispatch' method makes sure each bubble target is visited only once.
        __touchEvent.resetTo(TouchEvent.TOUCH, __currentTouches, shiftDown, ctrlDown);

        // hit test our updated touches
        for (touch in touches)
        {
            // hovering touches need special handling (see below)
            if (touch.phase == TouchPhase.HOVER && touch.target != null)
                sHoveringTouchData[sHoveringTouchData.length] = {
                    touch: touch,
                    target: touch.target,
                    bubbleChain: touch.bubbleChain
                }; // avoiding 'push'
            
            if (touch.phase == TouchPhase.HOVER || touch.phase == TouchPhase.BEGAN)
            {
                sHelperPoint.setTo(touch.globalX, touch.globalY);
                
                // If an occlusion test is supplied and turns out positive, the touch
                // isn't supposed to happen. In this case, the target is set to null.

                if (__occlusionTest != null && __occlusionTest(touch.globalX, touch.globalY))
                    touch.target = null;
                else
                    touch.target = __root.hitTest(sHelperPoint);
            }
        }
        
        // if the target of a hovering touch changed, we dispatch the event to the previous
        // target to notify it that it's no longer being hovered over.
        for (touchData in sHoveringTouchData)
            if (cast(Reflect.field(touchData, "touch"), Touch).target != Reflect.field(touchData, "target"))
                __touchEvent.dispatch(Reflect.field(touchData, "bubbleChain"));
        
        // dispatch events for the rest of our updated touches
        for (touch in touches)
            touch.dispatchEvent(__touchEvent);

        // clean up any references
        __touchEvent.resetTo(TouchEvent.TOUCH);
    }
    
    private function checkForSystemGesture(touchID:Int, phase:String,
                                            globalX:Float, globalY:Float):Bool
    {
        if (!__discardSystemGestures || phase == TouchPhase.HOVER)
            return false;

        if (__systemGestureTouchID == touchID)
        {
            if (phase == TouchPhase.ENDED)
                __systemGestureTouchID = -1;

            return true;
        }
        else if (__systemGestureTouchID >= 0)
        {
            return false; // there can always only be one system gesture active
        }
        else if (phase == TouchPhase.BEGAN) // also: _systemGestureTouchID < 0
        {
            var isGesture:Bool;
            var screenBounds:Rectangle = __stage.getScreenBounds(__stage, Pool.getRectangle());

            isGesture =
                globalX < screenBounds.left   + __systemGestureMargins[LEFT]  ||
                globalX > screenBounds.right  - __systemGestureMargins[RIGHT] ||
                globalY < screenBounds.top    + __systemGestureMargins[TOP]   ||
                globalY > screenBounds.bottom - __systemGestureMargins[BOTTOM];

            Pool.putRectangle(screenBounds);

            if (isGesture) __systemGestureTouchID = touchID;
            return isGesture;
        }
        else return false;
    }

    /** Enqueues a new touch or mouse event with the given properties. */
    public function enqueue(touchID:Int, phase:String, globalX:Float, globalY:Float,
                            pressure:Float=1.0, width:Float=1.0, height:Float=1.0):Void
    {
        if (checkForSystemGesture(touchID, phase, globalX, globalY))
            return;

        queue_unshift(touchID, phase, globalX, globalY, pressure, width, height);
        
        // multitouch simulation (only with mouse)
        if (__ctrlDown && __touchMarker != null && touchID == 0)
        {
            __touchMarker.moveMarker(globalX, globalY, __shiftDown);
            queue_unshift(1, phase, __touchMarker.mockX, __touchMarker.mockY);
        }
    }
    
    private function queue_unshift(touchID:Int, phase:String, globalX:Float, globalY:Float,
                                    pressure:Float=1.0, width:Float=1.0, height:Float=1.0):Void
    {
        __queue.unshift(TouchData.fromPool(touchID, phase, globalX, globalY, pressure, width, height));
    }
    
    /** Enqueues an artificial touch that represents the mouse leaving the stage.
     * 
     * <p>On OS X, we get mouse events from outside the stage; on Windows, we do not.
     * This method enqueues an artificial hover point that is just outside the stage.
     * That way, objects listening for HOVERs over them will get notified everywhere.</p>
     */
    public function enqueueMouseLeftStage():Void
    {
        var mouse:Touch = getCurrentTouch(0);
        if (mouse == null || mouse.phase != TouchPhase.HOVER) return;
        
        var offset:Int = 1;
        var exitX:Float = mouse.globalX;
        var exitY:Float = mouse.globalY;
        var distLeft:Float = mouse.globalX;
        var distRight:Float = __stage.stageWidth - distLeft;
        var distTop:Float = mouse.globalY;
        var distBottom:Float = __stage.stageHeight - distTop;
        var minDist:Float = MathUtil.minValues([distLeft, distRight, distTop, distBottom]);
        
        // the new hover point should be just outside the stage, near the point where
        // the mouse point was last to be seen.
        
        if (minDist == distLeft)       exitX = -offset;
        else if (minDist == distRight) exitX = __stage.stageWidth + offset;
        else if (minDist == distTop)   exitY = -offset;
        else                           exitY = __stage.stageHeight + offset;
        
        enqueue(0, TouchPhase.HOVER, exitX, exitY);
    }

    /** Force-end all current touches. Changes the phase of all touches to 'ENDED' and
     * immediately dispatches a new TouchEvent (if touches are present). Called automatically
     * when the app receives a 'DEACTIVATE' event. */
    public function cancelTouches():Void
    {
        // This method could be called from within a touch event handler. In that case,
        // we wait until the current 'advanceTime' method is finished before we do anything.

        if (__isProcessing) { __cancelRequested = true; return; }
        else __cancelRequested = false;
        
        if (__currentTouches.length > 0)
        {
            // abort touches
            for (touch in __currentTouches)
            {
                if (touch.phase == TouchPhase.BEGAN || touch.phase == TouchPhase.MOVED ||
                    touch.phase == TouchPhase.STATIONARY)
                {
                    touch.phase = TouchPhase.ENDED;
                    touch.cancelled = true;
                }
            }

            // dispatch events
            processTouches(__currentTouches, __shiftDown, __ctrlDown);
        }

        // purge touches
        __currentTouches.length = 0;
        
        while (__queue.length > 0)
            TouchData.toPool(__queue.pop());
    }
    
    private function createOrUpdateTouch(touchData:TouchData):Touch
    {
        var touch:Touch = getCurrentTouch(touchData.id);
        
        if (touch == null)
        {
            touch = new Touch(touchData.id);
            addCurrentTouch(touch);
        }

        touch.update(__elapsedTime, touchData.phase, touchData.globalX, touchData.globalY,
            touchData.pressure, touchData.width, touchData.height);

        if (touchData.phase == TouchPhase.BEGAN)
            updateTapCount(touch);

        return touch;
    }
    
    private function updateTapCount(touch:Touch):Void
    {
        var nearbyTap:Touch = null;
        var minSqDist:Float = __multitapDistance * __multitapDistance;
        
        for (tap in __lastTaps)
        {
            var sqDist:Float = Math.pow(tap.globalX - touch.globalX, 2) +
                               Math.pow(tap.globalY - touch.globalY, 2);
            if (sqDist <= minSqDist)
            {
                nearbyTap = tap;
                break;
            }
        }
        
        if (nearbyTap != null)
        {
            touch.tapCount = nearbyTap.tapCount + 1;
            __lastTaps.removeAt(__lastTaps.indexOf(nearbyTap));
        }
        else
        {
            touch.tapCount = 1;
        }
        
        __lastTaps[__lastTaps.length] = touch.clone(); // avoiding 'push'
    }
    
    private function addCurrentTouch(touch:Touch):Void
    {
        var i:Int = __currentTouches.length - 1;
        while (i >= 0)
        {
            if (__currentTouches[i].id == touch.id)
                __currentTouches.removeAt(i);
            --i;
        }

        __currentTouches[__currentTouches.length] = touch; // avoiding 'push'
    }
    
    private function getCurrentTouch(touchID:Int):Touch
    {
        for (touch in __currentTouches)
            if (touch.id == touchID) return touch;
        
        return null;
    }
    
    private function containsTouchWithID(touches:Vector<Touch>, touchID:Int):Bool
    {
        for (touch in touches)
            if (touch.id == touchID) return true;
        
        return false;
    }
    
    /** Configures the margins within which, when a touch is starting, it's considered to be
     *  a system gesture (in points). Note that you also need to enable 'ignoreSystemGestures'.
     */
    public function setSystemGestureMargins(topMargin:Float=10, bottomMargin:Float=10,
                                            leftMargin:Float=0, rightMargin:Float=0):Void
    {
        __systemGestureMargins[TOP] = topMargin;
        __systemGestureMargins[BOTTOM] = bottomMargin;
        __systemGestureMargins[LEFT] = leftMargin;
        __systemGestureMargins[RIGHT] = rightMargin;
    }
    
    /** Indicates if it multitouch simulation should be activated. When the user presses
     * ctrl/cmd (and optionally shift), he'll see a second touch curser that mimics the first.
     * That's an easy way to develop and test multitouch when there's only a mouse available.
     */
    public var simulateMultitouch(get, set):Bool;
    private function get_simulateMultitouch():Bool { return __simulateMultitouch; }
    private function set_simulateMultitouch(value:Bool):Bool
    { 
        if (simulateMultitouch == value) return value; // no change

        __simulateMultitouch = value;
        var target:Starling = Starling.current;

        var createTouchMarker:Void->Void = null;
        createTouchMarker = function():Void
        {
            target.removeEventListener(Event.CONTEXT3D_CREATE, createTouchMarker);

            if (__touchMarker == null)
            {
                __touchMarker = new TouchMarker();
                __touchMarker.visible = false;
                __stage.addChild(__touchMarker);
            }
        }

        if (value && __touchMarker == null)
        {
            if (Starling.current.contextValid)
                createTouchMarker();
            else
                target.addEventListener(Event.CONTEXT3D_CREATE, createTouchMarker);
        }
        else if (!value && __touchMarker != null)
        {
            __touchMarker.removeFromParent(true);
            __touchMarker = null;
        }
        return value;
    }
    
    /** The time period (in seconds) in which two touches must occur to be recognized as
     * a multitap gesture. */
    public var multitapTime(get, set):Float;
    private function get_multitapTime():Float { return __multitapTime; }
    private function set_multitapTime(value:Float):Float { return __multitapTime = value; }
    
    /** The distance (in points) describing how close two touches must be to each other to
     * be recognized as a multitap gesture. */
    public var multitapDistance(get, set):Float;
    private function get_multitapDistance():Float { return __multitapDistance; }
    private function set_multitapDistance(value:Float):Float { return __multitapDistance = value; }

    /** The base object that will be used for hit testing. Per default, this reference points
     * to the stage; however, you can limit touch processing to certain parts of your game
     * by assigning a different object. */
    public var root(get, set):DisplayObject;
    private function get_root():DisplayObject { return __root; }
    private function set_root(value:DisplayObject):DisplayObject { return __root = value; }
    
    /** The stage object to which the touch objects are (per default) dispatched. */
    public var stage(get, never):Stage;
    private function get_stage():Stage { return __stage; }
    
    /** Returns the number of fingers / touch points that are currently on the stage. */
    public var numCurrentTouches(get, never):Int;
    private function get_numCurrentTouches():Int { return __currentTouches.length; }

     /** If this callback returns <code>false</code>, the corresponding touch will have its
     *  target set to <code>null</code>, which will prevent the original target from being
     *  notified of the touch. In other words: the touch is being blocked. Callback format:
     *  <pre>function(stageX:Number, stageY:Number):Boolean;</pre>
     *  @default null
     */
    public var occlusionTest(get, set):Float->Float->Bool;
    private function set_occlusionTest(value:Float->Float->Bool):Float->Float->Bool { return __occlusionTest = value; }
    private function get_occlusionTest():Float->Float->Bool { return __occlusionTest; }

    /** When enabled, all touches that start very close to the window edges are discarded.
     *  On mobile, such touches often indicate swipes that are meant to open OS menus.
     *  Per default, margins of 10 points at the very top and bottom of the screen are checked.
     *  Call 'setSystemGestureMargins()' to adapt the margins in each direction.
     *  @default true on mobile, false on desktop */
    public var discardSystemGestures(get, set):Bool;
    private function get_discardSystemGestures():Bool { return __discardSystemGestures; }
    private function set_discardSystemGestures(value:Bool):Bool
    {
        if (__discardSystemGestures != value)
        {
            __discardSystemGestures = value;
            __systemGestureTouchID = -1;
        }
        return value;
    }

    // keyboard handling
    
    private function onKey(event:KeyboardEvent):Void
    {
        if (event.keyCode == 17 || event.keyCode == 15) // ctrl or cmd key
        {
            var wasCtrlDown:Bool = __ctrlDown;
            __ctrlDown = event.type == KeyboardEvent.KEY_DOWN;
            
            if (__touchMarker != null && wasCtrlDown != __ctrlDown)
            {
                __touchMarker.visible = __ctrlDown;
                __touchMarker.moveCenter(__stage.stageWidth/2, __stage.stageHeight/2);
                
                var mouseTouch:Touch = getCurrentTouch(0);
                var mockedTouch:Touch = getCurrentTouch(1);
                
                if (mouseTouch != null)
                    __touchMarker.moveMarker(mouseTouch.globalX, mouseTouch.globalY);
                
                if (wasCtrlDown && mockedTouch != null && mockedTouch.phase != TouchPhase.ENDED)
                {
                    // end active touch ...
                    queue_unshift(1, TouchPhase.ENDED, mockedTouch.globalX, mockedTouch.globalY);
                }
                else if (__ctrlDown && mouseTouch != null)
                {
                    // ... or start new one
                    if (mouseTouch.phase == TouchPhase.HOVER || mouseTouch.phase == TouchPhase.ENDED)
                        queue_unshift(1, TouchPhase.HOVER, __touchMarker.mockX, __touchMarker.mockY);
                    else
                        queue_unshift(1, TouchPhase.BEGAN, __touchMarker.mockX, __touchMarker.mockY);
                }
            }
        }
        else if (event.keyCode == 16) // shift key
        {
            __shiftDown = event.type == KeyboardEvent.KEY_DOWN;
        }
    }

    // interruption handling
    
    private function monitorInterruptions(enable:Bool):Void
    {
        // if the application moves into the background or is interrupted (e.g. through
        // an incoming phone call), we need to abort all touches.
        
        try
        {
            //var nativeAppClass:Object = getDefinitionByName("flash.desktop::NativeApplication");
            //var nativeApp:Object = nativeAppClass["nativeApplication"];
            
            if (enable)
                Lib.current.stage.addEventListener("deactivate", onInterruption, false, 0, true);
            else
                Lib.current.stage.removeEventListener("deactivate", onInterruption);
        }
        catch (e:Dynamic) {} // we're not running in AIR
    }
    
    private function onInterruption(event:Dynamic):Void
    {
        cancelTouches();
    }
}
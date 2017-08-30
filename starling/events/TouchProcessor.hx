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
import openfl.Lib;
import openfl.Vector;

import starling.core.Starling;
import starling.display.DisplayObject;
import starling.display.Stage;
import starling.utils.MathUtil;

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
    private var __stage:Stage;
    private var __root:DisplayObject;
    private var __elapsedTime:Float;
    private var __lastTaps:Vector<Touch>;
    private var __shiftDown:Bool = false;
    private var __ctrlDown:Bool  = false;
    private var __multitapTime:Float = 0.3;
    private var __multitapDistance:Float = 25;
    private var __touchEvent:TouchEvent;

    private var __touchMarker:TouchMarker;
    private var __simulateMultitouch:Bool;
    
    /** A vector of arrays with the arguments that were passed to the "enqueue"
     * method (the oldest being at the end of the vector). */
    private var __queue:Vector<Array<Dynamic>>;
    
    /** The list of all currently active touches. */
    private var __currentTouches:Vector<Touch>;
    
    /** Helper objects. */
    private static var sUpdatedTouches:Vector<Touch> = new Vector<Touch>();
    private static var sHoveringTouchData:Vector<Dynamic> = new Vector<Dynamic>();
    private static var sHelperPoint:Point = new Point();
    
    /** Creates a new TouchProcessor that will dispatch events to the given stage. */
    public function new(stage:Stage)
    {
        __root = __stage = stage;
        __elapsedTime = 0.0;
        __currentTouches = new Vector<Touch>();
        __queue = new Vector<Array<Dynamic>>();
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
        var i:Int;
        var touch:Touch;
        
        __elapsedTime += passedTime;
        sUpdatedTouches.length = 0;
        
        // remove old taps
        if (__lastTaps.length > 0)
        {
            var i:Int = __lastTaps.length - 1;
            while (i >= 0)
            {
                if (__elapsedTime - __lastTaps[i].timestamp > __multitapTime)
                    __lastTaps.splice(i, 1);
                --i;
            }
        }
        
        while (__queue.length > 0)
        {
            // Set touches that were new or moving to phase 'stationary'.
            for (touch in __currentTouches)
                if (touch.phase == TouchPhase.BEGAN || touch.phase == TouchPhase.MOVED)
                    touch.phase = TouchPhase.STATIONARY;

            // analyze new touches, but each ID only once
            while (__queue.length > 0 &&
                  !containsTouchWithID(sUpdatedTouches, __queue[__queue.length-1][0]))
            {
                var touchArgs:Array<Dynamic> = __queue.pop();
                touch = createOrUpdateTouch(
                            touchArgs[0], touchArgs[1], touchArgs[2], touchArgs[3],
                            touchArgs[4], touchArgs[5], touchArgs[6]);
                
                sUpdatedTouches[sUpdatedTouches.length] = touch; // avoiding 'push'
            }

            // process the current set of touches (i.e. dispatch touch events)
            processTouches(sUpdatedTouches, __shiftDown, __ctrlDown);

            // remove ended touches
            var i:Int = __currentTouches.length - 1;
            while (i >= 0)
            {
                if (__currentTouches[i].phase == TouchPhase.ENDED)
                    __currentTouches.removeAt(i);
                --i;
            }

            sUpdatedTouches.length = 0;
        }
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
        sHoveringTouchData.length = 0;

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
                touch.target = __root.hitTest(sHelperPoint);
            }
        }
        
        // if the target of a hovering touch changed, we dispatch the event to the previous
        // target to notify it that it's no longer being hovered over.
        for (touchData in sHoveringTouchData)
            if (cast (touchData.touch, Touch).target != touchData.target)
                __touchEvent.dispatch(touchData.bubbleChain);
        
        // dispatch events for the rest of our updated touches
        for (touch in touches)
            touch.dispatchEvent(__touchEvent);

        // clean up any references
        __touchEvent.resetTo(TouchEvent.TOUCH);
    }
    
    /** Enqueues a new touch our mouse event with the given properties. */
    public function enqueue(touchID:Int, phase:String, globalX:Float, globalY:Float,
                            pressure:Float=1.0, width:Float=1.0, height:Float=1.0):Void
    {
        __queue.unshift([touchID, phase, globalX, globalY, pressure, width, height]);
        
        // multitouch simulation (only with mouse)
        if (__ctrlDown && __touchMarker != null && touchID == 0) 
        {
            __touchMarker.moveMarker(globalX, globalY, __shiftDown);
            __queue.unshift([1, phase, __touchMarker.mockX, __touchMarker.mockY]);
        }
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
        __queue.length = 0;
    }
    
    private function createOrUpdateTouch(touchID:Int, phase:String,
                                         globalX:Float, globalY:Float,
                                         pressure:Float=1.0,
                                         width:Float=1.0, height:Float=1.0):Touch
    {
        var touch:Touch = getCurrentTouch(touchID);
        
        if (touch == null)
        {
            touch = new Touch(touchID);
            addCurrentTouch(touch);
        }
        
        touch.globalX = globalX;
        touch.globalY = globalY;
        touch.phase = phase;
        touch.timestamp = __elapsedTime;
        touch.pressure = pressure;
        touch.width  = width;
        touch.height = height;

        if (phase == TouchPhase.BEGAN)
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
    public var nu__currentTouches(get, never):Int;
    private function get_nu__currentTouches():Int { return __currentTouches.length; }

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
                    __queue.unshift([1, TouchPhase.ENDED, mockedTouch.globalX, mockedTouch.globalY]);
                }
                else if (__ctrlDown && mouseTouch != null)
                {
                    // ... or start new one
                    if (mouseTouch.phase == TouchPhase.HOVER || mouseTouch.phase == TouchPhase.ENDED)
                        __queue.unshift([1, TouchPhase.HOVER, __touchMarker.mockX, __touchMarker.mockY]);
                    else
                        __queue.unshift([1, TouchPhase.BEGAN, __touchMarker.mockX, __touchMarker.mockY]);
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
            if (enable)
                Lib.current.stage.addEventListener("deactivate", onInterruption, false, 0, true);
            else
                Lib.current.stage.removeEventListener("deactivate", onInterruption);
        }
        catch (e:Error) {} // we're not running in AIR
    }
    
    private function onInterruption(event:Dynamic):Void
    {
        cancelTouches();
    }
}
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
import openfl.utils.Object;
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

@:jsRequire("starling/events/TouchProcessor", "default")

extern class TouchProcessor
{
    /** Creates a new TouchProcessor that will dispatch events to the given stage. */
    public function new(stage:Stage);

    /** Removes all event handlers on the stage and releases any acquired resources. */
    public function dispose():Void;
    
    /** Analyzes the current touch queue and processes the list of current touches, emptying
     * the queue while doing so. This method is called by Starling once per frame. */
    public function advanceTime(passedTime:Float):Void;
    
    /** Enqueues a new touch our mouse event with the given properties. */
    public function enqueue(touchID:Int, phase:String, globalX:Float, globalY:Float,
                            pressure:Float=1.0, width:Float=1.0, height:Float=1.0):Void;
    
    /** Enqueues an artificial touch that represents the mouse leaving the stage.
     * 
     * <p>On OS X, we get mouse events from outside the stage; on Windows, we do not.
     * This method enqueues an artificial hover point that is just outside the stage.
     * That way, objects listening for HOVERs over them will get notified everywhere.</p>
     */
    public function enqueueMouseLeftStage():Void;

    /** Force-end all current touches. Changes the phase of all touches to 'ENDED' and
     * immediately dispatches a new TouchEvent (if touches are present). Called automatically
     * when the app receives a 'DEACTIVATE' event. */
    public function cancelTouches():Void;
    
    /** Indicates if it multitouch simulation should be activated. When the user presses
     * ctrl/cmd (and optionally shift), he'll see a second touch curser that mimics the first.
     * That's an easy way to develop and test multitouch when there's only a mouse available.
     */
    public var simulateMultitouch(get, set):Bool;
    private function get_simulateMultitouch():Bool;
    private function set_simulateMultitouch(value:Bool):Bool;
    
    /** The time period (in seconds) in which two touches must occur to be recognized as
     * a multitap gesture. */
    public var multitapTime(get, set):Float;
    private function get_multitapTime():Float;
    private function set_multitapTime(value:Float):Float;
    
    /** The distance (in points) describing how close two touches must be to each other to
     * be recognized as a multitap gesture. */
    public var multitapDistance(get, set):Float;
    private function get_multitapDistance():Float;
    private function set_multitapDistance(value:Float):Float;

    /** The base object that will be used for hit testing. Per default, this reference points
     * to the stage; however, you can limit touch processing to certain parts of your game
     * by assigning a different object. */
    public var root(get, set):DisplayObject;
    private function get_root():DisplayObject;
    private function set_root(value:DisplayObject):DisplayObject;
    
    /** The stage object to which the touch objects are (per default) dispatched. */
    public var stage(get, never):Stage;
    private function get_stage():Stage;
    
    /** Returns the number of fingers / touch points that are currently on the stage. */
    public var numCurrentTouches(get, never):Int;
    private function get_numCurrentTouches():Int;
}
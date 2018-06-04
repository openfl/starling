// =================================================================================================
//
//	Starling Framework
//	Copyright Gamua GmbH. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

package starling.animation;

import haxe.Constraints.Function;
import openfl.Vector;

/** The Juggler takes objects that implement IAnimatable (like Tweens) and executes them.
 * 
 *  <p>A juggler is a simple object. It does no more than saving a list of objects implementing 
 *  "IAnimatable" and advancing their time if it is told to do so (by calling its own 
 *  "advanceTime"-method). When an animation is completed, it throws it away.</p>
 *  
 *  <p>There is a default juggler available at the Starling class:</p>
 *  
 *  <pre>
 *  var juggler:Juggler = Starling.juggler;
 *  </pre>
 *  
 *  <p>You can create juggler objects yourself, just as well. That way, you can group 
 *  your game into logical components that handle their animations independently. All you have
 *  to do is call the "advanceTime" method on your custom juggler once per frame.</p>
 *  
 *  <p>Another handy feature of the juggler is the "delayCall"-method. Use it to 
 *  execute a function at a later time. Different to conventional approaches, the method
 *  will only be called when the juggler is advanced, giving you perfect control over the 
 *  call.</p>
 *  
 *  <pre>
 *  juggler.delayCall(object.removeFromParent, 1.0);
 *  juggler.delayCall(object.addChild, 2.0, theChild);
 *  juggler.delayCall(function():Void { rotation += 0.1; }, 3.0);
 *  </pre>
 * 
 *  @see Tween
 *  @see DelayedCall 
 */

@:jsRequire("starling/animation/Juggler", "default")

extern class Juggler implements IAnimatable
{
    /** Create an empty juggler. */
    public function new();

    /** Adds an object to the juggler.
     *
     *  @return Unique numeric identifier for the animation. This identifier may be used
     *          to remove the object via <code>removeByID()</code>.
     */
    public function add(object:IAnimatable):UInt;

    public function addWithID(object:IAnimatable, objectID:UInt):UInt;
    
    /** Determines if an object has been added to the juggler. */
    public function contains(object:IAnimatable):Bool;
    
    /** Removes an object from the juggler.
     *
     *  @return The (now meaningless) unique numeric identifier for the animation, or zero
     *          if the object was not found.
     */
    public function remove(object:IAnimatable):UInt;

    /** Removes an object from the juggler, identified by the unique numeric identifier you
     *  received when adding it.
     *
     *  <p>It's not uncommon that an animatable object is added to a juggler repeatedly,
     *  e.g. when using an object-pool. Thus, when using the <code>remove</code> method,
     *  you might accidentally remove an object that has changed its context. By using
     *  <code>removeByID</code> instead, you can be sure to avoid that, since the objectID
     *  will always be unique.</p>
     *
     *  @return if successful, the passed objectID; if the object was not found, zero.
     */
    public function removeByID(objectID:UInt):UInt;
    
    /** Removes all tweens with a certain target. */
    public function removeTweens(target:Dynamic):Void;

    /** Removes all delayed and repeated calls with a certain callback. */
    public function removeDelayedCalls(callback:Function):Void;
    
    /** Figures out if the juggler contains one or more tweens with a certain target. */
    public function containsTweens(target:Dynamic):Bool;

    /** Figures out if the juggler contains one or more delayed calls with a certain callback. */
    public function containsDelayedCalls(callback:Function):Bool;

    /** Removes all objects at once. */
    public function purge():Void;
    
    /** Delays the execution of a function until <code>delay</code> seconds have passed.
     *  This method provides a convenient alternative for creating and adding a DelayedCall
     *  manually.
     *
     *  @return Unique numeric identifier for the delayed call. This identifier may be used
     *          to remove the object via <code>removeByID()</code>.
     */
    public function delayCall(call:Function, delay:Float, args:Array<Dynamic> = null):UInt;

    /** Runs a function at a specified interval (in seconds). A 'repeatCount' of zero
     *  means that it runs indefinitely.
     *
     *  @return Unique numeric identifier for the delayed call. This identifier may be used
     *          to remove the object via <code>removeByID()</code>.
     */
    public function repeatCall(call:Function, interval:Float, repeatCount:Int=0, args:Array<Dynamic> = null):UInt;
    
    /** Utilizes a tween to animate the target object over <code>time</code> seconds. Internally,
     *  this method uses a tween instance (taken from an object pool) that is added to the
     *  juggler right away. This method provides a convenient alternative for creating 
     *  and adding a tween manually.
     *  
     *  <p>Fill 'properties' with key-value pairs that describe both the 
     *  tween and the animation target. Here is an example:</p>
     *  
     *  <pre>
     *  juggler.tween(object, 2.0, {
     *      transition: Transitions.EASE_IN_OUT,
     *      delay: 20, // -> tween.delay = 20
     *      x: 50      // -> tween.animate("x", 50)
     *  });
     *  </pre> 
     *
     *  <p>To cancel the tween, call 'Juggler.removeTweens' with the same target, or pass
     *  the returned 'IAnimatable' instance to 'Juggler.remove()'. Do not use the returned
     *  IAnimatable otherwise; it is taken from a pool and will be reused.</p>
     *
     *  <p>Note that some property types may be animated in a special way:</p>
     *  <ul>
     *    <li>If the property contains the string <code>color</code> or <code>Color</code>,
     *        it will be treated as an unsigned integer with a color value
     *        (e.g. <code>0xff0000</code> for red). Each color channel will be animated
     *        individually.</li>
     *    <li>The same happens if you append the string <code>#rgb</code> to the name.</li>
     *    <li>If you append <code>#rad</code>, the property is treated as an angle in radians,
     *        making sure it always uses the shortest possible arc for the rotation.</li>
     *    <li>The string <code>#deg</code> does the same for angles in degrees.</li>
     *  </ul>
     */
    public function tween(target:Dynamic, time:Float, properties:Dynamic):UInt;
    
    /** Advances all objects by a certain time (in seconds). */
    public function advanceTime(time:Float):Void;

    /** The total life time of the juggler (in seconds). */
    public var elapsedTime(get, never):Float;
    private function get_elapsedTime():Float;

    /** The scale at which the time is passing. This can be used for slow motion or time laps
     *  effects. Values below '1' will make all animations run slower, values above '1' faster.
     *  @default 1.0 */
    public var timeScale(get, set):Float;
    private function get_timeScale():Float;
    private function set_timeScale(value:Float):Float;

    /** The actual vector that contains all objects that are currently being animated. */
    private var objects(get, never):Vector<IAnimatable>;
    private function get_objects():Vector<IAnimatable>;
}

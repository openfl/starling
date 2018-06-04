package starling.animation;


import haxe.Constraints.Function;
import starling.events.EventDispatcher;


/** A DelayedCall allows you to execute a method after a certain time has passed. Since it 
 *  implements the IAnimatable interface, it can be added to a juggler. In most cases, you 
 *  do not have to use this class directly; the juggler class contains a method to delay
 *  calls directly. 
 * 
 *  <p>DelayedCall dispatches an Event of type 'Event.REMOVE_FROM_JUGGLER' when it is finished,
 *  so that the juggler automatically removes it when its no longer needed.</p>
 * 
 *  @see Juggler
 */

@:jsRequire("starling/animation/DelayedCall", "default")

extern class DelayedCall extends EventDispatcher implements IAnimatable
{
    /** Creates a delayed call. */
    public function new(callback:Function, delay:Float, args:Array<Dynamic>=null);
    
    /** Resets the delayed call to its default values, which is useful for pooling. */
    public function reset(callback:Function, delay:Float, args:Array<Dynamic>=null):DelayedCall;
    
    /** @inheritDoc */
    public function advanceTime(time:Float):Void;

    /** Advances the delayed call so that it is executed right away. If 'repeatCount' is
      * anything else than '1', this method will complete only the current iteration. */
    public function complete():Void;
    
    /** Indicates if enough time has passed, and the call has already been executed. */
    public var isComplete(get, never):Bool;
    private function get_isComplete():Bool;
    
    /** The time for which calls will be delayed (in seconds). */
    public var totalTime(get, never):Float;
    private function get_totalTime():Float;
    
    /** The time that has already passed (in seconds). */
    public var currentTime(get, never):Float;
    private function get_currentTime():Float;
    
    /** The number of times the call will be repeated. 
     * Set to '0' to repeat indefinitely. @default 1 */
    public var repeatCount(get, set):Int;
    private function get_repeatCount():Int;
    private function set_repeatCount(value:Int):Int;
    
    /** The callback that will be executed when the time is up. */
    public var callback(get, never):Function;
    private function get_callback():Function;

    /** The arguments that the callback will be executed with.
        *  Beware: not a copy, but the actual object! */
    public var arguments(get, never):Array<Dynamic>;
    private function get_arguments():Array<Dynamic>;
}
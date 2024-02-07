// =================================================================================================
//
//	Starling Framework
//	Copyright Gamua GmbH. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

package starling.utils;
import haxe.Constraints.Function;
import openfl.errors.ArgumentError;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.ui.Mouse;
import openfl.ui.MouseCursor;
import starling.display.ButtonState;
import starling.display.DisplayObject;
import starling.events.Event;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;

/** A utility class that can help with creating button-like display objects.
 *
 *  <p>When reacting to touch input, taps can easily be recognized through standard touch
 *  events via <code>TouchPhase.ENDED</code>. However, you often want a more elaborate kind of
 *  input handling, like that provide by Starling's <em>Button</em> class and its
 *  <em>TRIGGERED</em> event. It allows users to cancel a tap by moving the finger away from
 *  the object, for example; and it supports changing its appearance depending on its state.</p>
 *
 *  <p>Here is an example: a class that extends <em>TextField</em> and uses
 *  <em>ButtonBehavior</em> to add TRIGGER events and state-based coloring.</p>
 *
 *  <listing>
 *  public class TextButton extends TextField
 *  {
 *      private var _behavior:ButtonBehavior;
 *      private var _tint:uint = 0xffaaff;
 *      
 *      public function TextButton(width:int, height:int, text:String="",
 *                                 format:TextFormat=null, options:TextOptions=null)
 *      {
 *          super(width, height, text, format, options);
 *          _behavior = new ButtonBehavior(this, onStateChange);
 *      }
 *      
 *      private function onStateChange(state:String):void
 *      {
 *          if (state == ButtonState.DOWN) format.color = _tint;
 *          else format.color = 0xffffff;
 *      }
 *      
 *      public override function hitTest(localPoint:Point):DisplayObject
 *      {
 *          return _behavior.hitTest(localPoint);
 *      }
 *  }</listing>
 *
 *  <p>Instances of this class will now dispatch <em>Event.TRIGGERED</em> events (just like
 *  conventional buttons) and they will change their color when being touched.</p>
 */
class ButtonBehavior
{
    // 'minHitAreaSize' defaults to 44 points, as recommended by Apple Human Interface Guidelines.
	// -> https://developer.apple.com/ios/human-interface-guidelines/visual-design/adaptivity-and-layout/

	@:noCompletion private var __state:String;
	@:noCompletion private var __target:DisplayObject;
	@:noCompletion private var __triggerBounds:Rectangle;
	@:noCompletion private var __minHitAreaSize:Float;
	@:noCompletion private var __abortDistance:Float;
	@:noCompletion private var __onStateChange:Function;
	@:noCompletion private var __useHandCursor:Bool;
	@:noCompletion private var __enabled:Bool;

	private static var sBounds:Rectangle = new Rectangle();
	
	#if commonjs
    private static function __init__ () {
        
        untyped Object.defineProperties (ButtonBehavior.prototype, {
            "state": { get: untyped __js__ ("function () { return this.get_state (); }"), set: untyped __js__ ("function (v) { return this.set_state (v); }") },
            "target": { get: untyped __js__ ("function () { return this.get_target (); }") },
            "onStateChange": { get: untyped __js__ ("function () { return this.get_onStateChange (); }"), set: untyped __js__ ("function (v) { return this.set_onStateChange (v); }") },
            "useHandCursor": { get: untyped __js__ ("function () { return this.get_useHandCursor (); }"), set: untyped __js__ ("function (v) { return this.set_useHandCursor (v); }") },
            "enabled": { get: untyped __js__ ("function () { return this.get_enabled (); }"), set: untyped __js__ ("function (v) { return this.set_enabled (v); }") },
			"minHitAreaSize": { get: untyped __js__ ("function () { return this.get_minHitAreaSize (); }"), set: untyped __js__ ("function (v) { return this.set_minHitAreaSize (v); }") },
			"abortDistance": { get: untyped __js__ ("function () { return this.get_abortDistance (); }"), set: untyped __js__ ("function (v) { return this.set_abortDistance (v); }") },
        });
        
    }
    #end

	/** Create a new ButtonBehavior.
	 *
	 * @param target           The object on which to listen for touch events.
	 * @param onStateChange    This callback will be executed whenever the button's state ought
	 *                         to change. <code>function(state:String):void</code>
	 * @param minHitAreaSize   If the display area of 'target' is smaller than a square of this
	 *                         size, its hit area will be extended accordingly.
	 * @param abortDistance    The distance you can move away your finger before triggering
	 *                         is aborted.
	 */
	public function new(target:DisplayObject, onStateChange:Function,
								   minHitAreaSize:Float = 44, abortDistance:Float = 50)
	{
		if (target == null) throw new ArgumentError("target cannot be null");
		if (onStateChange == null) throw new ArgumentError("onStateChange cannot be null");

		__target = target;
		__target.addEventListener(TouchEvent.TOUCH, onTouch);
		__onStateChange = onStateChange;
		__minHitAreaSize = minHitAreaSize;
		__abortDistance = abortDistance;
		__triggerBounds = new Rectangle();
		__state = ButtonState.UP;
		__useHandCursor = true;
		__enabled = true;
	}

	private function onTouch(event:TouchEvent):Void
	{
		Mouse.cursor = (__useHandCursor && __enabled && event.interactsWith(__target)) ?
			MouseCursor.BUTTON : MouseCursor.AUTO;

		var touch:Touch = event.getTouch(__target);
		var isWithinBounds:Bool;

		if (!__enabled)
		{
			// do nothing
		}
		else if (touch == null)
		{
			state = ButtonState.UP;
		}
		else if (touch.phase == TouchPhase.HOVER)
		{
			state = ButtonState.OVER;
		}
		else if (touch.phase == TouchPhase.BEGAN && __state != ButtonState.DOWN)
		{
			__triggerBounds = __target.getBounds(__target.stage, __triggerBounds);
			__triggerBounds.inflate(__abortDistance, __abortDistance);

			state = ButtonState.DOWN;
		}
		else if (touch.phase == TouchPhase.MOVED)
		{
			isWithinBounds = __triggerBounds.contains(touch.globalX, touch.globalY);

			if (__state == ButtonState.DOWN && !isWithinBounds)
			{
				// reset button when finger is moved too far away ...
				state = ButtonState.UP;
			}
			else if (__state == ButtonState.UP && isWithinBounds)
			{
				// ... and reactivate when the finger moves back into the bounds.
				state = ButtonState.DOWN;
			}
		}
		else if (touch.phase == TouchPhase.ENDED && __state == ButtonState.DOWN)
		{
			state = ButtonState.UP;
			if (!touch.cancelled) __target.dispatchEventWith(Event.TRIGGERED, true);
		}
	}

	/** Forward your target's <code>hitTests</code> to this method to make sure that the hit
	 *  area is extended to <code>minHitAreaSize</code>. */
	public function hitTest(localPoint:Point):DisplayObject
	{
		if (!__target.visible || !__target.touchable || !__target.hitTestMask(localPoint))
			return null;

		__target.getBounds(__target, sBounds);

		if (sBounds.width < __minHitAreaSize)
			sBounds.inflate((__minHitAreaSize - sBounds.width) / 2, 0);
		if (sBounds.height < __minHitAreaSize)
			sBounds.inflate(0, (__minHitAreaSize - sBounds.height) / 2);

		if (sBounds.containsPoint(localPoint)) return __target;
		else return null;
	}

	/** The current state of the button. The corresponding strings are found
	 *  in the ButtonState class. */
	public var state(get, set):String;
	private function get_state():String { return __state; }
	private function set_state(value:String):String
	{
		if (__state != value)
		{
			if (ButtonState.isValid(value))
			{
				__state = value;
				Execute.execute(__onStateChange, [value]);
			}
			else throw new ArgumentError("Invalid button state: " + value);
		}
		return value;
	}

	/** The target on which this behavior operates. */
	public var target(get, never):DisplayObject;
	public function get_target():DisplayObject { return __target; }

	/** The callback that is executed whenever the state changes.
	 *  Format: <code>function(state:String):void</code>
	 */
	public var onStateChange(get, set):Function;
	public function get_onStateChange():Function { return __onStateChange; }
	public function set_onStateChange(value:Function):Function { return __onStateChange = value; }

	/** Indicates if the mouse cursor should transform into a hand while it's over the button.
	 *  @default true */
	public var useHandCursor(get, set):Bool;
	public function get_useHandCursor():Bool { return __useHandCursor; }
	public function set_useHandCursor(value:Bool):Bool { return __useHandCursor = value; }

	/** Indicates if the button can be triggered. */
	public var enabled(get, set):Bool;
	public function get_enabled():Bool { return __enabled; }
	public function set_enabled(value:Bool):Bool
	{
		if (__enabled != value)
		{
			__enabled = value;
			state = value ? ButtonState.UP : ButtonState.DISABLED;
		}
		return __enabled;
	}

	/** The target's hit area will be extended to have at least this width / height. 
	 *  Note that for this to work, you need to forward your hit tests to this class. */
	public var minHitAreaSize(get, set):Float;
	public function get_minHitAreaSize():Float { return __minHitAreaSize; }
	public function set_minHitAreaSize(value:Float):Float { return __minHitAreaSize = value; }

	/** The distance you can move away your finger before triggering is aborted. */
	public var abortDistance(get, set):Float;
	public function get_abortDistance():Float { return __abortDistance; }
	public function set_abortDistance(value:Float):Float { return __abortDistance = value; }
}
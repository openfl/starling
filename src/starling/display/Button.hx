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

import openfl.errors.ArgumentError;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.ui.Mouse;
import openfl.ui.MouseCursor;
import starling.utils.ButtonBehavior;
import starling.utils.SystemUtil;

import starling.events.Event;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.styles.MeshStyle;
import starling.text.TextField;
import starling.text.TextFormat;
import starling.textures.Texture;

/** Dispatched when the user triggers the button. Bubbles. */
@:meta(Event(name="triggered", type="starling.events.Event"))

/** A simple button composed of an image and, optionally, text.
 *  
 *  <p>You can use different textures for various states of the button. If you're providing
 *  only an up state, the button is simply scaled a little when it is touched.</p>
 *
 *  <p>In addition, you can overlay text on the button. To customize the text, you can use
 *  properties equivalent to those of the TextField class. Move the text to a certain position
 *  by updating the <code>textBounds</code> property.</p>
 *  
 *  <p>To react on touches on a button, there is special <code>Event.TRIGGERED</code> event.
 *  Use this event instead of normal touch events. That way, users can cancel button
 *  activation by moving the mouse/finger away from the button before releasing.</p>
 */
class Button extends DisplayObjectContainer
{
    private var __upState:Texture;
    private var __downState:Texture;
    private var __overState:Texture;
    private var __disabledState:Texture;
    
    private var __contents:Sprite;
    private var __body:Image;
    private var __textField:TextField;
    private var __textBounds:Rectangle;
    private var __overlay:Sprite;
    
	private var __behavior:ButtonBehavior;
    private var __scaleWhenDown:Float;
    private var __scaleWhenOver:Float;
    private var __alphaWhenDown:Float;
    private var __alphaWhenDisabled:Float;
    
    #if commonjs
    private static function __init__ () {
        
        untyped Object.defineProperties (Button.prototype, {
            "scaleWhenDown": { get: untyped __js__ ("function () { return this.get_scaleWhenDown (); }"), set: untyped __js__ ("function (v) { return this.set_scaleWhenDown (v); }") },
            "scaleWhenOver": { get: untyped __js__ ("function () { return this.get_scaleWhenOver (); }"), set: untyped __js__ ("function (v) { return this.set_scaleWhenOver (v); }") },
            "alphaWhenDown": { get: untyped __js__ ("function () { return this.get_alphaWhenDown (); }"), set: untyped __js__ ("function (v) { return this.set_alphaWhenDown (v); }") },
            "alphaWhenDisabled": { get: untyped __js__ ("function () { return this.get_alphaWhenDisabled (); }"), set: untyped __js__ ("function (v) { return this.set_alphaWhenDisabled (v); }") },
            "text": { get: untyped __js__ ("function () { return this.get_text (); }"), set: untyped __js__ ("function (v) { return this.set_text (v); }") },
            "textFormat": { get: untyped __js__ ("function () { return this.get_textFormat (); }"), set: untyped __js__ ("function (v) { return this.set_textFormat (v); }") },
            "textStyle": { get: untyped __js__ ("function () { return this.get_textStyle (); }"), set: untyped __js__ ("function (v) { return this.set_textStyle (v); }") },
            "style": { get: untyped __js__ ("function () { return this.get_style (); }"), set: untyped __js__ ("function (v) { return this.set_style (v); }") },
            "upState": { get: untyped __js__ ("function () { return this.get_upState (); }"), set: untyped __js__ ("function (v) { return this.set_upState (v); }") },
            "downState": { get: untyped __js__ ("function () { return this.get_downState (); }"), set: untyped __js__ ("function (v) { return this.set_downState (v); }") },
            "overState": { get: untyped __js__ ("function () { return this.get_overState (); }"), set: untyped __js__ ("function (v) { return this.set_overState (v); }") },
            "disabledState": { get: untyped __js__ ("function () { return this.get_disabledState (); }"), set: untyped __js__ ("function (v) { return this.set_disabledState (v); }") },
            "textBounds": { get: untyped __js__ ("function () { return this.get_textBounds (); }"), set: untyped __js__ ("function (v) { return this.set_textBounds (v); }") },
            "color": { get: untyped __js__ ("function () { return this.get_color (); }"), set: untyped __js__ ("function (v) { return this.set_color (v); }") },
            "textureSmoothing": { get: untyped __js__ ("function () { return this.get_textureSmoothing (); }"), set: untyped __js__ ("function (v) { return this.set_textureSmoothing (v); }") },
            "overlay": { get: untyped __js__ ("function () { return this.get_overlay (); }") },
            "pixelSnapping": { get: untyped __js__ ("function () { return this.get_pixelSnapping (); }"), set: untyped __js__ ("function (v) { return this.set_pixelSnapping (v); }") },
            "scale9Grid": { get: untyped __js__ ("function () { return this.get_scale9Grid (); }"), set: untyped __js__ ("function (v) { return this.set_scale9Grid (v); }") },
			"minHitAreaSize": { get: untyped __js__ ("function () { return this.get_minHitAreaSize (); }"), set: untyped __js__ ("function (v) { return this.set_minHitAreaSize (v); }") },
			"abortDistance": { get: untyped __js__ ("function () { return this.get_abortDistance (); }"), set: untyped __js__ ("function (v) { return this.set_abortDistance (v); }") },
        });
        
    }
    #end
    
    /** Creates a button with a set of state-textures and (optionally) some text.
     * Any state that is left 'null' will display the up-state texture. Beware that all
     * state textures should have the same dimensions. */
    public function new(upState:Texture, text:String="", downState:Texture=null,
                        overState:Texture=null, disabledState:Texture=null)
    {
        super();
        
        if (upState == null) throw new ArgumentError("Texture 'upState' cannot be null");
        
        __upState = upState;
        __downState = downState;
        __overState = overState;
        __disabledState = disabledState;

        __behavior = new ButtonBehavior(this, onStateChange, SystemUtil.isDesktop ? 16 : 44);
        __body = new Image(upState);
        __body.pixelSnapping = true;
        __scaleWhenDown = downState != null? 1.0 : 0.9;
        __scaleWhenOver = __alphaWhenDown = 1.0;
        __alphaWhenDisabled = disabledState != null ? 1.0: 0.5;
        __textBounds = new Rectangle(0, 0, __body.width, __body.height);
        
        __contents = new Sprite();
        __contents.addChild(__body);
        addChild(__contents);
        
        __setStateTexture(upState);
        
        this.touchGroup = true;
        this.text = text;
    }
    
    /** @inheritDoc */
    public override function dispose():Void
    {
        // text field might be disconnected from parent, so we have to dispose it manually
        if (__textField != null)
            __textField.dispose();
        
        super.dispose();
    }
	
	private function onStateChange(state:String):Void
	{
		__contents.x = __contents.y = 0;
		__contents.scaleX = __contents.scaleY = __contents.alpha = 1.0;

		switch (state)
		{
			case ButtonState.DOWN:
				__setStateTexture(__downState);
				__setContentScale(__scaleWhenDown);
				__contents.alpha = __alphaWhenDown;
				
			case ButtonState.UP:
				__setStateTexture(__upState);
				
			case ButtonState.OVER:
				__setStateTexture(__overState);
				__setContentScale(__scaleWhenOver);
				
			case ButtonState.DISABLED:
				__setStateTexture(__disabledState);
				__contents.alpha = __alphaWhenDisabled;
				
		}
	}

	/** @private */
	public override function hitTest(localPoint:Point):DisplayObject
	{
		return __behavior.hitTest(localPoint);
	}
    
    /** Readjusts the dimensions of the button according to its current state texture.
     * Call this method to synchronize button and texture size after assigning a texture
     * with a different size. Per default, this method also resets the bounds of the
     * button's text. */
    public function readjustSize(resetTextBounds:Bool=true):Void
    {
        var prevWidth:Float = __body.width;
        var prevHeight:Float = __body.height;

        __body.readjustSize();

        var scaleX:Float = __body.width  / prevWidth;
        var scaleY:Float = __body.height / prevHeight;

        __textBounds.x *= scaleX;
        __textBounds.y *= scaleY;
        __textBounds.width *= scaleX;
        __textBounds.height *= scaleY;

        if (__textField != null) __createTextField();
    }

    private function __createTextField():Void
    {
        if (__textField == null)
        {
            __textField = new TextField(Std.int(__textBounds.width), Std.int(__textBounds.height));
            __textField.pixelSnapping = __body.pixelSnapping;
            __textField.touchable = false;
            __textField.autoScale = true;
            __textField.batchable = true;
        }
        
        __textField.width  = __textBounds.width;
        __textField.height = __textBounds.height;
        __textField.x = __textBounds.x;
        __textField.y = __textBounds.y;
    }
    
    /** The current state of the button. The corresponding strings are found
     * in the ButtonState class. */
    public var state(get, set):String;
    private function get_state():String { return __behavior.state; }
    private function set_state(value:String):String { return __behavior.state = value; }
    
    private function __setContentScale(scale:Float):Void
    {
        __contents.scaleX = __contents.scaleY = scale;
        __contents.x = (1.0 - scale) / 2.0 * __body.width;
        __contents.y = (1.0 - scale) / 2.0 * __body.height;
    }

    private function __setStateTexture(texture:Texture):Void
    {
        __body.texture = texture != null ? texture : __upState;
        
        if (__body.pivotX != 0 || __body.pivotY != 0)
        {
            // The texture might force a custom pivot point on the image. We better use
            // this pivot point on the button itself, because that's easier to access.
            // (Plus, it simplifies internal object placement.)

            pivotX = __body.pivotX;
            pivotY = __body.pivotY;

            __body.pivotX = 0;
            __body.pivotY = 0;
        }
    }

    /** The scale factor of the button on touch. Per default, a button without a down state
     * texture will be made slightly smaller, while a button with a down state texture
     * remains unscaled. */
    public var scaleWhenDown(get, set):Float;
    private function get_scaleWhenDown():Float { return __scaleWhenDown; }
    private function set_scaleWhenDown(value:Float):Float { return __scaleWhenDown = value; }

    /** The scale factor of the button while the mouse cursor hovers over it. @default 1.0 */
    public var scaleWhenOver(get, set):Float;
    private function get_scaleWhenOver():Float { return __scaleWhenOver; }
    private function set_scaleWhenOver(value:Float):Float { return __scaleWhenOver = value; }

    /** The alpha value of the button on touch. @default 1.0 */
    public var alphaWhenDown(get, set):Float;
    private function get_alphaWhenDown():Float { return __alphaWhenDown; }
    private function set_alphaWhenDown(value:Float):Float { return __alphaWhenDown = value; }

    /** The alpha value of the button when it is disabled. @default 0.5 */
    public var alphaWhenDisabled(get, set):Float;
    private function get_alphaWhenDisabled():Float { return __alphaWhenDisabled; }
    private function set_alphaWhenDisabled(value:Float):Float { return __alphaWhenDisabled = value; }
    
    /** Indicates if the button can be triggered. */
    public var enabled(get, set):Bool;
    private function get_enabled():Bool { return __behavior.enabled; }
    private function set_enabled(value:Bool):Bool { return __behavior.enabled = value; }
    
    /** The text that is displayed on the button. */
    public var text(get, set):String;
    private function get_text():String { return __textField != null ? __textField.text : ""; }
    private function set_text(value:String):String
    {
        if (value.length == 0)
        {
            if (__textField != null)
            {
                __textField.text = value;
                __textField.removeFromParent();
            }
        }
        else
        {
            __createTextField();
            __textField.text = value;
            
            if (__textField.parent == null)
                __contents.addChild(__textField);
        }
        return value;
    }

    /** The format of the button's TextField. */
    public var textFormat(get, set):TextFormat;
    private function get_textFormat():TextFormat
    {
        if (__textField == null) __createTextField();
        return __textField.format;
    }

    private function set_textFormat(value:TextFormat):TextFormat
    {
        if (__textField == null) __createTextField();
        return __textField.format = value;
    }

    /** The style that is used to render the button's TextField. */
    public var textStyle(get, set):MeshStyle;
    private function get_textStyle():MeshStyle
    {
        if (__textField == null) __createTextField();
        return __textField.style;
    }

    private function set_textStyle(value:MeshStyle):MeshStyle
    {
        if (__textField == null) __createTextField();
        return __textField.style = value;
    }

    /** The style that is used to render the button.
     *  Note that a style instance may only be used on one mesh at a time. */
    public var style(get, set):MeshStyle;
    private function get_style():MeshStyle { return __body.style; }
    private function set_style(value:MeshStyle):MeshStyle { return __body.style = value; }
    
    /** The texture that is displayed when the button is not being touched. */
    public var upState(get, set):Texture;
    private function get_upState():Texture { return __upState; }
    private function set_upState(value:Texture):Texture
    {
        if (value == null)
            throw new ArgumentError("Texture 'upState' cannot be null");

        if (__upState != value)
        {
            __upState = value;
			var state:String = __behavior.state;
			
            if (state == ButtonState.UP ||
               (state == ButtonState.DISABLED && __disabledState == null) ||
               (state == ButtonState.DOWN && __downState == null) ||
               (state == ButtonState.OVER && __overState == null))
            {
                __setStateTexture(value);
            }
        }
        return value;
    }
    
    /** The texture that is displayed while the button is touched. */
    public var downState(get, set):Texture;
    private function get_downState():Texture { return __downState; }
    private function set_downState(value:Texture):Texture
    {
        if (__downState != value)
        {
            __downState = value;
            if (state == ButtonState.DOWN) __setStateTexture(value);
        }
        return value;
    }

    /** The texture that is displayed while mouse hovers over the button. */
    public var overState(get, set):Texture;
    private function get_overState():Texture { return __overState; }
    private function set_overState(value:Texture):Texture
    {
        if (__overState != value)
        {
            __overState = value;
            if (state == ButtonState.OVER) __setStateTexture(value);
        }
        return value;
    }

    /** The texture that is displayed when the button is disabled. */
    public var disabledState(get, set):Texture;
    private function get_disabledState():Texture { return __disabledState; }
    private function set_disabledState(value:Texture):Texture
    {
        if (__disabledState != value)
        {
            __disabledState = value;
            if (state == ButtonState.DISABLED) __setStateTexture(value);
        }
        return value;
    }
    
    /** The bounds of the textfield on the button. Allows moving the text to a custom position. */
    public var textBounds(get, set):Rectangle;
    private function get_textBounds():Rectangle { return __textBounds.clone(); }
    private function set_textBounds(value:Rectangle):Rectangle
    {
        __textBounds.copyFrom(value);
        __createTextField();
        return value;
    }
    
    /** The color of the button's state image. Just like every image object, each pixel's
     * color is multiplied with this value. @default white */
    public var color(get, set):UInt;
    private function get_color():UInt { return __body.color; }
    private function set_color(value:UInt):UInt { return __body.color = value; }

    /** The smoothing type used for the button's state image. */
    public var textureSmoothing(get, set):String;
    private function get_textureSmoothing():String { return __body.textureSmoothing; }
    private function set_textureSmoothing(value:String):String { return __body.textureSmoothing = value; }

    /** The overlay sprite is displayed on top of the button contents. It scales with the
     * button when pressed. Use it to add additional objects to the button (e.g. an icon). */
    public var overlay(get, never):Sprite;
    private function get_overlay():Sprite
    {
        if (__overlay == null)
            __overlay = new Sprite();

        __contents.addChild(__overlay); // make sure it's always on top
        return __overlay;
    }

    /** Indicates if the mouse cursor should transform into a hand while it's over the button. 
     * @default true */
    private override function get_useHandCursor():Bool { return __behavior.useHandCursor; }
    private override function set_useHandCursor(value:Bool):Bool { return __behavior.useHandCursor = value; }
    
    /** Controls whether or not the instance snaps to the nearest pixel. This can prevent the
     *  object from looking blurry when it's not exactly aligned with the pixels of the screen.
     *  @default true */
    public var pixelSnapping(get, set):Bool;
    private function get_pixelSnapping():Bool { return __body.pixelSnapping; }
    private function set_pixelSnapping(value:Bool):Bool
    {
        __body.pixelSnapping = value;
        if (__textField != null) __textField.pixelSnapping = value;
        return value;
    }

    /** @private */
    override private function set_width(value:Float):Float
    {
        // The Button might use a Scale9Grid ->
        // we must update the body width/height manually for the grid to scale properly.

        var newWidth:Float = value / (this.scaleX != 0 ? this.scaleX : 1.0);
        var scale:Float = newWidth / (__body.width != 0 ? __body.width : 1.0);

        __body.width = newWidth;
        __textBounds.x *= scale;
        __textBounds.width *= scale;

        if (__textField != null) __textField.width = newWidth;
        
        return value;
    }

    /** @private */
    override private function set_height(value:Float):Float
    {
        var newHeight:Float = value /  (this.scaleY != 0 ? this.scaleY : 1.0);
        var scale:Float = newHeight / (__body.height != 0 ? __body.height : 1.0);

        __body.height = newHeight;
        __textBounds.y *= scale;
        __textBounds.height *= scale;

        if (__textField != null) __textField.height = newHeight;
        
        return value;
    }

    /** The current scaling grid used for the button's state image. Use this property to create
     *  buttons that resize in a smart way, i.e. with the four corners keeping the same size
     *  and only stretching the center area.
     *
     *  @see Image#scale9Grid
     *  @default null
     */
    public var scale9Grid(get, set):Rectangle;
    private function get_scale9Grid():Rectangle { return __body.scale9Grid; }
    private function set_scale9Grid(value:Rectangle):Rectangle { return __body.scale9Grid = value; }
	
	/** The button's hit area will be extended to have at least this width / height.
	 *  @default on Desktop: 16, on mobile: 44 */
	public var minHitAreaSize(get, set):Float;
	public function get_minHitAreaSize():Float { return __behavior.minHitAreaSize; }
	public function set_minHitAreaSize(value:Float):Float { return __behavior.minHitAreaSize = value; }

	/** The distance you can move away your finger before triggering is aborted.
	 *  @default 50 */
	public var abortDistance(get, set):Float;
	public function get_abortDistance():Float { return __behavior.abortDistance; }
	public function set_abortDistance(value:Float):Float { return __behavior.abortDistance = value; }
}
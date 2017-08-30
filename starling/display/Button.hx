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
import openfl.geom.Rectangle;
import openfl.ui.Mouse;
import openfl.ui.MouseCursor;

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
    private static inline var MAX_DRAG_DIST:Float = 50;
    
    private var __upState:Texture;
    private var __downState:Texture;
    private var __overState:Texture;
    private var __disabledState:Texture;
    
    private var __contents:Sprite;
    private var __body:Image;
    private var __textField:TextField;
    private var __textBounds:Rectangle;
    private var __overlay:Sprite;
    
    private var __scaleWhenDown:Float;
    private var __scaleWhenOver:Float;
    private var __alphaWhenDown:Float;
    private var __alphaWhenDisabled:Float;
    //private var __useHandCursor:Bool;
    private var __enabled:Bool;
    private var __state:String;
    private var __triggerBounds:Rectangle;

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

        __state = ButtonState.UP;
        __body = new Image(upState);
        __scaleWhenDown = downState != null? 1.0 : 0.9;
        __scaleWhenOver = __alphaWhenDown = 1.0;
        __alphaWhenDisabled = disabledState != null ? 1.0: 0.5;
        __enabled = true;
        __useHandCursor = true;
        __textBounds = new Rectangle(0, 0, __body.width, __body.height);
        __triggerBounds = new Rectangle();
        
        __contents = new Sprite();
        __contents.addChild(__body);
        addChild(__contents);
        addEventListener(TouchEvent.TOUCH, __onTouch);
        
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
    
    private override function __onTouch(event:TouchEvent):Void
    {
        Mouse.cursor = (__useHandCursor && __enabled && event.interactsWith(this)) ?
            MouseCursor.BUTTON : MouseCursor.AUTO;
        
        var touch:Touch = event.getTouch(this);
        var isWithinBounds:Bool;

        if (!__enabled)
        {
            return;
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
            __triggerBounds = getBounds(stage, __triggerBounds);
            __triggerBounds.inflate(MAX_DRAG_DIST, MAX_DRAG_DIST);

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
            if (!touch.cancelled) dispatchEventWith(Event.TRIGGERED, true);
        }
    }
    
    /** The current state of the button. The corresponding strings are found
     * in the ButtonState class. */
    public var state(get, set):String;
    private function get_state():String { return __state; }
    private function set_state(value:String):String
    {
        __state = value;
        __contents.x = __contents.y = 0;
        __contents.scaleX = __contents.scaleY = __contents.alpha = 1.0;

        switch (__state)
        {
            case ButtonState.DOWN:
                __setStateTexture(__downState);
                __contents.alpha = __alphaWhenDown;
                __contents.scaleX = __contents.scaleY = __scaleWhenDown;
                __contents.x = (1.0 - __scaleWhenDown) / 2.0 * __body.width;
                __contents.y = (1.0 - __scaleWhenDown) / 2.0 * __body.height;
            case ButtonState.UP:
                __setStateTexture(__upState);
            case ButtonState.OVER:
                __setStateTexture(__overState);
                __contents.scaleX = __contents.scaleY = __scaleWhenOver;
                __contents.x = (1.0 - __scaleWhenOver) / 2.0 * __body.width;
                __contents.y = (1.0 - __scaleWhenOver) / 2.0 * __body.height;
            case ButtonState.DISABLED:
                __setStateTexture(__disabledState);
                __contents.alpha = __alphaWhenDisabled;
            default:
                throw new ArgumentError("Invalid button state: " + __state);
        }
        
        return value;
    }

    private function __setStateTexture(texture:Texture):Void
    {
        __body.texture = texture != null ? texture : __upState;
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
    private function get_enabled():Bool { return __enabled; }
    private function set_enabled(value:Bool):Bool
    {
        if (__enabled != value)
        {
            __enabled = value;
            state = value ? ButtonState.UP : ButtonState.DISABLED;
        }
        return value;
    }
    
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
            if ( __state == ButtonState.UP ||
                (__state == ButtonState.DISABLED && __disabledState == null) ||
                (__state == ButtonState.DOWN && __downState == null) ||
                (__state == ButtonState.OVER && __overState == null))
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
            if (__state == ButtonState.DOWN) __setStateTexture(value);
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
            if (__state == ButtonState.OVER) __setStateTexture(value);
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
            if (__state == ButtonState.DISABLED) __setStateTexture(value);
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
    private override function get_useHandCursor():Bool { return __useHandCursor; }
    private override function set_useHandCursor(value:Bool):Bool { return __useHandCursor = value; }
    
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
}
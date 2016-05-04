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
import flash.geom.Rectangle;
import flash.ui.Mouse;
import openfl.errors.ArgumentError;
#if flash
import flash.ui.MouseCursor;
#end
import starling.utils.MathUtil;

import starling.events.Event;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.styles.MeshStyle;
import starling.text.TextField;
import starling.text.TextFormat;
import starling.textures.Texture;

/** Dispatched when the user triggers the button. Bubbles. */
//[Event(name="triggered", type="starling.events.Event")]

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
    inline private static var MAX_DRAG_DIST:Float = 50;
    
    private var _upState:Texture;
    private var _downState:Texture;
    private var _overState:Texture;
    private var _disabledState:Texture;
    
    private var _contents:Sprite;
    private var _body:Image;
    private var _textField:TextField;
    private var _textBounds:Rectangle;
    private var _overlay:Sprite;
    
    private var _scaleWhenDown:Float;
    private var _scaleWhenOver:Float;
    private var _alphaWhenDown:Float;
    private var _alphaWhenDisabled:Float;
    #if 0
    private var _useHandCursor:Bool;
    #end
    private var _enabled:Bool;
    private var _state:String;
    private var _triggerBounds:Rectangle;

    /** Creates a button with a set of state-textures and (optionally) some text.
     *  Any state that is left 'null' will display the up-state texture. Beware that all
     *  state textures should have the same dimensions. */
    public function new(upState:Texture, text:String="", downState:Texture=null,
                           overState:Texture=null, disabledState:Texture=null)
    {
        super();
        if (upState == null) throw new ArgumentError("Texture 'upState' cannot be null");
        
        _upState = upState;
        _downState = downState;
        _overState = overState;
        _disabledState = disabledState;

        _state = ButtonState.UP;
        _body = new Image(upState);
        _body.pixelSnapping = true;
        _scaleWhenDown = downState != null ? 1.0 : 0.9;
        _scaleWhenOver = _alphaWhenDown = 1.0;
        _alphaWhenDisabled = disabledState != null ? 1.0: 0.5;
        _enabled = true;
        _useHandCursor = true;
        _textBounds = new Rectangle(0, 0, _body.width, _body.height);
        _triggerBounds = new Rectangle();
        
        _contents = new Sprite();
        _contents.addChild(_body);
        addChild(_contents);
        addEventListener(TouchEvent.TOUCH, onTouch);
        
        this.touchGroup = true;
        this.text = text;
    }
    
    /** @inheritDoc */
    public override function dispose():Void
    {
        // text field might be disconnected from parent, so we have to dispose it manually
        if (_textField != null)
            _textField.dispose();
        
        super.dispose();
    }
    
    /** Readjusts the dimensions of the button according to its current state texture.
     *  Call this method to synchronize button and texture size after assigning a texture
     *  with a different size. */
    public function readjustSize():Void
    {
        var prevWidth:Float = _body.width;
        var prevHeight:Float = _body.height;

        _body.readjustSize();

        var scaleX:Float = _body.width  / prevWidth;
        var scaleY:Float = _body.height / prevHeight;

        _textBounds.x *= scaleX;
        _textBounds.y *= scaleY;
        _textBounds.width *= scaleX;
        _textBounds.height *= scaleY;

        if (_textField != null) createTextField();
    }

    private function createTextField():Void
    {
        if (_textField == null)
        {
            _textField = new TextField(Std.int(_textBounds.width), Std.int(_textBounds.height));
            _textField.pixelSnapping = _body.pixelSnapping;
            _textField.touchable = false;
            _textField.autoScale = true;
            _textField.batchable = true;
        }
        
        _textField.width  = _textBounds.width;
        _textField.height = _textBounds.height;
        _textField.x = _textBounds.x;
        _textField.y = _textBounds.y;
    }
    
    private override function onTouch(event:TouchEvent):Void
    {
        #if flash
        Mouse.cursor = (_useHandCursor && _enabled && event.interactsWith(this)) ?
            MouseCursor.BUTTON : MouseCursor.AUTO;
        #else
        #end
        
        var touch:Touch = event.getTouch(this);
        var isWithinBounds:Bool;

        if (!_enabled)
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
        else if (touch.phase == TouchPhase.BEGAN && _state != ButtonState.DOWN)
        {
            _triggerBounds = getBounds(stage, _triggerBounds);
            _triggerBounds.inflate(MAX_DRAG_DIST, MAX_DRAG_DIST);

            state = ButtonState.DOWN;
        }
        else if (touch.phase == TouchPhase.MOVED)
        {
            isWithinBounds = _triggerBounds.contains(touch.globalX, touch.globalY);

            if (_state == ButtonState.DOWN && !isWithinBounds)
            {
                // reset button when finger is moved too far away ...
                state = ButtonState.UP;
            }
            else if (_state == ButtonState.UP && isWithinBounds)
            {
                // ... and reactivate when the finger moves back into the bounds.
                state = ButtonState.DOWN;
            }
        }
        else if (touch.phase == TouchPhase.ENDED && _state == ButtonState.DOWN)
        {
            state = ButtonState.UP;
            if (!touch.cancelled) dispatchEventWith(Event.TRIGGERED, true);
        }
    }
    
    /** The current state of the button. The corresponding strings are found
     *  in the ButtonState class. */
    public var state(get, set):String;
    @:noCompletion private function get_state():String { return _state; }
    @:noCompletion private function set_state(value:String):String
    {
        _state = value;
        _contents.x = _contents.y = 0;
        _contents.scaleX = _contents.scaleY = _contents.alpha = 1.0;

        switch (_state)
        {
            case ButtonState.DOWN:
                setStateTexture(_downState);
                _contents.alpha = _alphaWhenDown;
                _contents.scaleX = _contents.scaleY = _scaleWhenDown;
                _contents.x = (1.0 - _scaleWhenDown) / 2.0 * _body.width;
                _contents.y = (1.0 - _scaleWhenDown) / 2.0 * _body.height;
                //break;
            case ButtonState.UP:
                setStateTexture(_upState);
                //break;
            case ButtonState.OVER:
                setStateTexture(_overState);
                _contents.scaleX = _contents.scaleY = _scaleWhenOver;
                _contents.x = (1.0 - _scaleWhenOver) / 2.0 * _body.width;
                _contents.y = (1.0 - _scaleWhenOver) / 2.0 * _body.height;
                //break;
            case ButtonState.DISABLED:
                setStateTexture(_disabledState);
                _contents.alpha = _alphaWhenDisabled;
                //break;
            default:
                throw new ArgumentError("Invalid button state: " + _state);
        }
        return value;
    }

    private function setStateTexture(texture:Texture):Void
    {
        _body.texture = texture != null ? texture : _upState;
    }

    /** The scale factor of the button on touch. Per default, a button without a down state
     *  texture will be made slightly smaller, while a button with a down state texture
     *  remains unscaled. */
    public var scaleWhenDown(get, set):Float;
    @:noCompletion private function get_scaleWhenDown():Float { return _scaleWhenDown; }
    @:noCompletion private function set_scaleWhenDown(value:Float):Float { return _scaleWhenDown = value; }

    /** The scale factor of the button while the mouse cursor hovers over it. @default 1.0 */
    public var scaleWhenOver(get, set):Float;
    @:noCompletion private function get_scaleWhenOver():Float { return _scaleWhenOver; }
    @:noCompletion private function set_scaleWhenOver(value:Float):Float { return _scaleWhenOver = value; }

    /** The alpha value of the button on touch. @default 1.0 */
    public var alphaWhenDown(get, set):Float;
    @:noCompletion private function get_alphaWhenDown():Float { return _alphaWhenDown; }
    @:noCompletion private function set_alphaWhenDown(value:Float):Float { return _alphaWhenDown = value; }

    /** The alpha value of the button when it is disabled. @default 0.5 */
    public var alphaWhenDisabled(get, set):Float;
    @:noCompletion private function get_alphaWhenDisabled():Float { return _alphaWhenDisabled; }
    @:noCompletion private function set_alphaWhenDisabled(value:Float):Float { return _alphaWhenDisabled = value; }
    
    /** Indicates if the button can be triggered. */
    public var enabled(get, set):Bool;
    @:noCompletion private function get_enabled():Bool { return _enabled; }
    @:noCompletion private function set_enabled(value:Bool):Bool
    {
        if (_enabled != value)
        {
            _enabled = value;
            state = value ? ButtonState.UP : ButtonState.DISABLED;
        }
        return value;
    }
    
    /** The text that is displayed on the button. */
    public var text(get, set):String;
    @:noCompletion private function get_text():String { return _textField != null ? _textField.text : ""; }
    @:noCompletion private function set_text(value:String):String
    {
        if (value.length == 0)
        {
            if (_textField != null)
            {
                _textField.text = value;
                _textField.removeFromParent();
            }
        }
        else
        {
            createTextField();
            _textField.text = value;
            
            if (_textField.parent == null)
                _contents.addChild(_textField);
        }
        return value;
    }

    /** The format of the button's TextField. */
    public var textFormat(get, set):TextFormat;
    @:noCompletion private function get_textFormat():TextFormat
    {
        if (_textField == null) createTextField();
        return _textField.format;
    }

    @:noCompletion private function set_textFormat(value:TextFormat):TextFormat
    {
        if (_textField == null) createTextField();
        return _textField.format = value;
    }

    /** The style that is used to render the button's TextField. */
    public var textStyle(get, set):MeshStyle;
    @:noCompletion private function get_textStyle():MeshStyle
    {
        if (_textField == null) createTextField();
        return _textField.style;
    }

    @:noCompletion private function set_textStyle(value:MeshStyle):MeshStyle
    {
        if (_textField == null) createTextField();
        _textField.style = value;
        return value;
    }

    /** The style that is used to render the Button. */
    public var style(get, set):MeshStyle;
    @:noCompletion private function get_style():MeshStyle { return _body.style; }
    @:noCompletion private function set_style(value:MeshStyle):MeshStyle { return _body.style = value; }

    /** The texture that is displayed when the button is not being touched. */
    public var upState(get, set):Texture;
    @:noCompletion private function get_upState():Texture { return _upState; }
    @:noCompletion private function set_upState(value:Texture):Texture
    {
        if (value == null)
            throw new ArgumentError("Texture 'upState' cannot be null");

        if (_upState != value)
        {
            _upState = value;
            if ( _state == ButtonState.UP ||
                (_state == ButtonState.DISABLED && _disabledState == null) ||
                (_state == ButtonState.DOWN && _downState == null) ||
                (_state == ButtonState.OVER && _overState == null))
            {
                setStateTexture(value);
            }
        }
        return value;
    }
    
    /** The texture that is displayed while the button is touched. */
    public var downState(get, set):Texture;
    @:noCompletion private function get_downState():Texture { return _downState; }
    @:noCompletion private function set_downState(value:Texture):Texture
    {
        if (_downState != value)
        {
            _downState = value;
            if (_state == ButtonState.DOWN) setStateTexture(value);
        }
        return value;
    }

    /** The texture that is displayed while mouse hovers over the button. */
    public var overState(get, set):Texture;
    @:noCompletion private function get_overState():Texture { return _overState; }
    @:noCompletion private function set_overState(value:Texture):Texture
    {
        if (_overState != value)
        {
            _overState = value;
            if (_state == ButtonState.OVER) setStateTexture(value);
        }
        return value;
    }

    /** The texture that is displayed when the button is disabled. */
    public var disabledState(get, set):Texture;
    @:noCompletion private function get_disabledState():Texture { return _disabledState; }
    @:noCompletion private function set_disabledState(value:Texture):Texture
    {
        if (_disabledState != value)
        {
            _disabledState = value;
            if (_state == ButtonState.DISABLED) setStateTexture(value);
        }
        return value;
    }
    
    /** The bounds of the button's TextField. Allows moving the text to a custom position.
     *  CAUTION: not a copy, but the actual object! Text will only update on re-assignment.
     */
    public var textBounds(get, set):Rectangle;
    @:noCompletion private function get_textBounds():Rectangle { return _textBounds; }
    @:noCompletion private function set_textBounds(value:Rectangle):Rectangle
    {
        _textBounds.copyFrom(value);
        createTextField();
        return value;
    }
    
    /** The color of the button's state image. Just like every image object, each pixel's
     *  color is multiplied with this value. @default white */
    public var color(get, set):UInt;
    @:noCompletion private function get_color():UInt { return _body.color; }
    @:noCompletion private function set_color(value:UInt):UInt { return _body.color = value; }

    /** The smoothing type used for the button's state image. */
    public var textureSmoothing(get, set):String;
    @:noCompletion private function get_textureSmoothing():String { return _body.textureSmoothing; }
    @:noCompletion private function set_textureSmoothing(value:String):String { return _body.textureSmoothing = value; }

    /** The overlay sprite is displayed on top of the button contents. It scales with the
     *  button when pressed. Use it to add additional objects to the button (e.g. an icon). */
    public var overlay(get, never):Sprite;
    public function get_overlay():Sprite
    {
        if (_overlay == null)
            _overlay = new Sprite();

        _contents.addChild(_overlay); // make sure it's always on top
        return _overlay;
    }

    /** Indicates if the mouse cursor should transform into a hand while it's over the button. 
     *  @default true */
    @:noCompletion private override function get_useHandCursor():Bool { return _useHandCursor; }
    @:noCompletion private override function set_useHandCursor(value:Bool):Bool { return _useHandCursor = value; }

    /** Controls whether or not the instance snaps to the nearest pixel. This can prevent the
     *  object from looking blurry when it's not exactly aligned with the pixels of the screen.
     *  @default true */
    public var pixelSnapping(get, set):Bool;
    @:noCompletion private function get_pixelSnapping():Bool { return _body.pixelSnapping; }
    @:noCompletion private function set_pixelSnapping(value:Bool):Bool
    {
        _body.pixelSnapping = value;
        if (_textField != null) _textField.pixelSnapping = value;
        return value;
    }

    /** @private */
    @:noCompletion override private function set_width(value:Float):Float
    {
        // The Button might use a Scale9Grid ->
        // we must update the body width/height manually for the grid to scale properly.

        var newWidth:Float = value / MathUtil.logicalOr(this.scaleX, 1.0);
        var scale:Float = newWidth / MathUtil.logicalOr(_body.width, 1.0);

        _body.width = newWidth;
        _textBounds.x *= scale;
        _textBounds.width *= scale;

        if (_textField != null) _textField.width = newWidth;
        return value;
    }

    /** @private */
    @:noCompletion override private function set_height(value:Float):Float
    {
        var newHeight:Float = value /  MathUtil.logicalOr(this.scaleY, 1.0);
        var scale:Float = newHeight / MathUtil.logicalOr(_body.height, 1.0);

        _body.height = newHeight;
        _textBounds.y *= scale;
        _textBounds.height *= scale;

        if (_textField != null) _textField.height = newHeight;
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
    @:noCompletion private function get_scale9Grid():Rectangle { return _body.scale9Grid; }
    @:noCompletion private function set_scale9Grid(value:Rectangle):Rectangle { return _body.scale9Grid = value; }
}
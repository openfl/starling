// =================================================================================================
//
//	Starling Framework
//	Copyright Gamua GmbH. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

package starling.display
{
import flash.geom.Rectangle;
import flash.ui.Mouse;
import flash.ui.MouseCursor;

import starling.events.Event;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.text.TextField;
import starling.textures.Texture;
import starling.utils.HAlign;
import starling.utils.VAlign;

/** Dispatched when the user triggers the button. Bubbles. */
[Event(name="triggered", type="starling.events.Event")]

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
public class Button extends DisplayObjectContainer
{
    private static const MAX_DRAG_DIST:Float = 50;
    
    private var mUpState:Texture;
    private var mDownState:Texture;
    private var mOverState:Texture;
    private var mDisabledState:Texture;
    
    private var mContents:Sprite;
    private var mBody:Image;
    private var mTextField:TextField;
    private var mTextBounds:Rectangle;
    private var mOverlay:Sprite;
    
    private var mScaleWhenDown:Float;
    private var mScaleWhenOver:Float;
    private var mAlphaWhenDown:Float;
    private var mAlphaWhenDisabled:Float;
    private var mUseHandCursor:Bool;
    private var mEnabled:Bool;
    private var mState:String;
    private var mTriggerBounds:Rectangle;

    /** Creates a button with a set of state-textures and (optionally) some text.
     *  Any state that is left 'null' will display the up-state texture. Beware that all
     *  state textures should have the same dimensions. */
    public function Button(upState:Texture, text:String="", downState:Texture=null,
                           overState:Texture=null, disabledState:Texture=null)
    {
        if (upState == null) throw new ArgumentError("Texture 'upState' cannot be null");
        
        mUpState = upState;
        mDownState = downState;
        mOverState = overState;
        mDisabledState = disabledState;

        mState = ButtonState.UP;
        mBody = new Image(upState);
        mScaleWhenDown = downState ? 1.0 : 0.9;
        mScaleWhenOver = mAlphaWhenDown = 1.0;
        mAlphaWhenDisabled = disabledState ? 1.0: 0.5;
        mEnabled = true;
        mUseHandCursor = true;
        mTextBounds = new Rectangle(0, 0, mBody.width, mBody.height);
        mTriggerBounds = new Rectangle();
        
        mContents = new Sprite();
        mContents.addChild(mBody);
        addChild(mContents);
        addEventListener(TouchEvent.TOUCH, onTouch);
        
        this.touchGroup = true;
        this.text = text;
    }
    
    /** @inheritDoc */
    public override function dispose():Void
    {
        // text field might be disconnected from parent, so we have to dispose it manually
        if (mTextField)
            mTextField.dispose();
        
        super.dispose();
    }
    
    /** Readjusts the dimensions of the button according to its current state texture.
     *  Call this method to synchronize button and texture size after assigning a texture
     *  with a different size. Per default, this method also resets the bounds of the
     *  button's text. */
    public function readjustSize(resetTextBounds:Bool=true):Void
    {
        mBody.readjustSize();

        if (resetTextBounds && mTextField != null)
            textBounds = new Rectangle(0, 0, mBody.width, mBody.height);
    }

    private function createTextField():Void
    {
        if (mTextField == null)
        {
            mTextField = new TextField(mTextBounds.width, mTextBounds.height, "");
            mTextField.vAlign = VAlign.CENTER;
            mTextField.hAlign = HAlign.CENTER;
            mTextField.touchable = false;
            mTextField.autoScale = true;
            mTextField.batchable = true;
        }
        
        mTextField.width  = mTextBounds.width;
        mTextField.height = mTextBounds.height;
        mTextField.x = mTextBounds.x;
        mTextField.y = mTextBounds.y;
    }
    
    private function onTouch(event:TouchEvent):Void
    {
        Mouse.cursor = (mUseHandCursor && mEnabled && event.interactsWith(this)) ?
            MouseCursor.BUTTON : MouseCursor.AUTO;
        
        var touch:Touch = event.getTouch(this);
        var isWithinBounds:Bool;

        if (!mEnabled)
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
        else if (touch.phase == TouchPhase.BEGAN && mState != ButtonState.DOWN)
        {
            mTriggerBounds = getBounds(stage, mTriggerBounds);
            mTriggerBounds.inflate(MAX_DRAG_DIST, MAX_DRAG_DIST);

            state = ButtonState.DOWN;
        }
        else if (touch.phase == TouchPhase.MOVED)
        {
            isWithinBounds = mTriggerBounds.contains(touch.globalX, touch.globalY);

            if (mState == ButtonState.DOWN && !isWithinBounds)
            {
                // reset button when finger is moved too far away ...
                state = ButtonState.UP;
            }
            else if (mState == ButtonState.UP && isWithinBounds)
            {
                // ... and reactivate when the finger moves back into the bounds.
                state = ButtonState.DOWN;
            }
        }
        else if (touch.phase == TouchPhase.ENDED && mState == ButtonState.DOWN)
        {
            state = ButtonState.UP;
            if (!touch.cancelled) dispatchEventWith(Event.TRIGGERED, true);
        }
    }
    
    /** The current state of the button. The corresponding strings are found
     *  in the ButtonState class. */
    public function get state():String { return mState; }
    public function set state(value:String):Void
    {
        mState = value;
        refreshState();
    }

    private function refreshState():Void
    {
        mContents.x = mContents.y = 0;
        mContents.scaleX = mContents.scaleY = mContents.alpha = 1.0;

        switch (mState)
        {
            case ButtonState.DOWN:
                setStateTexture(mDownState);
                mContents.alpha = mAlphaWhenDown;
                mContents.scaleX = mContents.scaleY = mScaleWhenDown;
                mContents.x = (1.0 - mScaleWhenDown) / 2.0 * mBody.width;
                mContents.y = (1.0 - mScaleWhenDown) / 2.0 * mBody.height;
                break;
            case ButtonState.UP:
                setStateTexture(mUpState);
                break;
            case ButtonState.OVER:
                setStateTexture(mOverState);
                mContents.scaleX = mContents.scaleY = mScaleWhenOver;
                mContents.x = (1.0 - mScaleWhenOver) / 2.0 * mBody.width;
                mContents.y = (1.0 - mScaleWhenOver) / 2.0 * mBody.height;
                break;
            case ButtonState.DISABLED:
                setStateTexture(mDisabledState);
                mContents.alpha = mAlphaWhenDisabled;
                break;
            default:
                throw new ArgumentError("Invalid button state: " + mState);
        }
    }

    private function setStateTexture(texture:Texture):Void
    {
        mBody.texture = texture ? texture : mUpState;
    }

    /** The scale factor of the button on touch. Per default, a button without a down state
     *  texture will be made slightly smaller, while a button with a down state texture
     *  remains unscaled. */
    public function get scaleWhenDown():Float { return mScaleWhenDown; }
    public function set scaleWhenDown(value:Float):Void
    {
        mScaleWhenDown = value;
        if (mState == ButtonState.DOWN) refreshState();
    }

    /** The scale factor of the button while the mouse cursor hovers over it. @default 1.0 */
    public function get scaleWhenOver():Float { return mScaleWhenOver; }
    public function set scaleWhenOver(value:Float):Void
    {
        mScaleWhenOver = value;
        if (mState == ButtonState.OVER) refreshState();
    }

    /** The alpha value of the button on touch. @default 1.0 */
    public function get alphaWhenDown():Float { return mAlphaWhenDown; }
    public function set alphaWhenDown(value:Float):Void
    {
        mAlphaWhenDown = value;
        if (mState == ButtonState.DOWN) refreshState();
    }

    /** The alpha value of the button when it is disabled. @default 0.5 */
    public function get alphaWhenDisabled():Float { return mAlphaWhenDisabled; }
    public function set alphaWhenDisabled(value:Float):Void
    {
        mAlphaWhenDisabled = value;
        if (mState == ButtonState.DISABLED) refreshState();
    }
    
    /** Indicates if the button can be triggered. */
    public function get enabled():Bool { return mEnabled; }
    public function set enabled(value:Bool):Void
    {
        if (mEnabled != value)
        {
            mEnabled = value;
            state = value ? ButtonState.UP : ButtonState.DISABLED;
        }
    }
    
    /** The text that is displayed on the button. */
    public function get text():String { return mTextField ? mTextField.text : ""; }
    public function set text(value:String):Void
    {
        if (value.length == 0)
        {
            if (mTextField)
            {
                mTextField.text = value;
                mTextField.removeFromParent();
            }
        }
        else
        {
            createTextField();
            mTextField.text = value;
            
            if (mTextField.parent == null)
                mContents.addChild(mTextField);
        }
    }
    
    /** The name of the font displayed on the button. May be a system font or a registered
     *  bitmap font. */
    public function get fontName():String { return mTextField ? mTextField.fontName : "Verdana"; }
    public function set fontName(value:String):Void
    {
        createTextField();
        mTextField.fontName = value;
    }
    
    /** The size of the font. */
    public function get fontSize():Float { return mTextField ? mTextField.fontSize : 12; }
    public function set fontSize(value:Float):Void
    {
        createTextField();
        mTextField.fontSize = value;
    }
    
    /** The color of the font. */
    public function get fontColor():UInt { return mTextField ? mTextField.color : 0x0; }
    public function set fontColor(value:UInt):Void
    {
        createTextField();
        mTextField.color = value;
    }
    
    /** Indicates if the font should be bold. */
    public function get fontBold():Bool { return mTextField ? mTextField.bold : false; }
    public function set fontBold(value:Bool):Void
    {
        createTextField();
        mTextField.bold = value;
    }
    
    /** The texture that is displayed when the button is not being touched. */
    public function get upState():Texture { return mUpState; }
    public function set upState(value:Texture):Void
    {
        if (value == null)
            throw new ArgumentError("Texture 'upState' cannot be null");

        if (mUpState != value)
        {
            mUpState = value;
            if ( mState == ButtonState.UP ||
                (mState == ButtonState.DISABLED && mDisabledState == null) ||
                (mState == ButtonState.DOWN && mDownState == null) ||
                (mState == ButtonState.OVER && mOverState == null))
            {
                setStateTexture(value);
            }
        }
    }
    
    /** The texture that is displayed while the button is touched. */
    public function get downState():Texture { return mDownState; }
    public function set downState(value:Texture):Void
    {
        if (mDownState != value)
        {
            mDownState = value;
            if (mState == ButtonState.DOWN) setStateTexture(value);
        }
    }

    /** The texture that is displayed while mouse hovers over the button. */
    public function get overState():Texture { return mOverState; }
    public function set overState(value:Texture):Void
    {
        if (mOverState != value)
        {
            mOverState = value;
            if (mState == ButtonState.OVER) setStateTexture(value);
        }
    }

    /** The texture that is displayed when the button is disabled. */
    public function get disabledState():Texture { return mDisabledState; }
    public function set disabledState(value:Texture):Void
    {
        if (mDisabledState != value)
        {
            mDisabledState = value;
            if (mState == ButtonState.DISABLED) setStateTexture(value);
        }
    }
    
    /** The vertical alignment of the text on the button. */
    public function get textVAlign():String
    {
        return mTextField ? mTextField.vAlign : VAlign.CENTER;
    }
    
    public function set textVAlign(value:String):Void
    {
        createTextField();
        mTextField.vAlign = value;
    }
    
    /** The horizontal alignment of the text on the button. */
    public function get textHAlign():String
    {
        return mTextField ? mTextField.hAlign : HAlign.CENTER;
    }
    
    public function set textHAlign(value:String):Void
    {
        createTextField();
        mTextField.hAlign = value;
    }
    
    /** The bounds of the textfield on the button. Allows moving the text to a custom position. */
    public function get textBounds():Rectangle { return mTextBounds.clone(); }
    public function set textBounds(value:Rectangle):Void
    {
        mTextBounds = value.clone();
        createTextField();
    }
    
    /** The color of the button's state image. Just like every image object, each pixel's
     *  color is multiplied with this value. @default white */
    public function get color():UInt { return mBody.color; }
    public function set color(value:UInt):Void { mBody.color = value; }

    /** The smoothing type used for the button's state image. */
    public function get smoothing():String { return mBody.smoothing; }
    public function set smoothing(value:String):Void { mBody.smoothing = value; }

    /** The overlay sprite is displayed on top of the button contents. It scales with the
     *  button when pressed. Use it to add additional objects to the button (e.g. an icon). */
    public function get overlay():Sprite
    {
        if (mOverlay == null)
            mOverlay = new Sprite();

        mContents.addChild(mOverlay); // make sure it's always on top
        return mOverlay;
    }

    /** Indicates if the mouse cursor should transform into a hand while it's over the button. 
     *  @default true */
    public override function get useHandCursor():Bool { return mUseHandCursor; }
    public override function set useHandCursor(value:Bool):Void { mUseHandCursor = value; }
}
}
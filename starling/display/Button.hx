// =================================================================================================
//
//	Starling Framework
//	Copyright 2011 Gamua OG. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

package starling.display;
import flash.geom.Rectangle;
import flash.ui.Mouse;
import openfl.errors.ArgumentError;
//import flash.ui.MouseCursor;

import starling.events.Event;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.text.TextField;
import starling.textures.Texture;
import starling.utils.HAlign;
import starling.utils.VAlign;

/** Dispatched when the user triggers the button. Bubbles. */
//[Event(name="triggered", type="starling.events.Event")]

/** A simple button composed of an image and, optionally, text.
 *  
 *  <p>You can pass a texture for up- and downstate of the button. If you do not provide a down 
 *  state, the button is simply scaled a little when it is touched.
 *  In addition, you can overlay a text on the button. To customize the text, almost the 
 *  same options as those of text fields are provided. In addition, you can move the text to a 
 *  certain position with the help of the <code>textBounds</code> property.</p>
 *  
 *  <p>To react on touches on a button, there is special <code>triggered</code>-event type. Use
 *  this event instead of normal touch events - that way, users can cancel button activation
 *  by moving the mouse/finger away from the button before releasing.</p> 
 */ 
class Button extends DisplayObjectContainer
{
    inline private static var MAX_DRAG_DIST:Float = 50;
    
    private var mUpState:Texture;
    private var mDownState:Texture;
    
    private var mContents:Sprite;
    private var mBackground:Image;
    private var mTextField:TextField;
    private var mTextBounds:Rectangle;
    
    private var mScaleWhenDown:Float;
    private var mAlphaWhenDisabled:Float;
    private var mEnabled:Bool;
    private var mIsDown:Bool;
    
    /** Creates a button with textures for up- and down-state or text. */
    public function new(upState:Texture, text:String="", downState:Texture=null)
    {
        super();
        if (upState == null) throw new ArgumentError("Texture cannot be null");
        
        mUpState = upState;
        mDownState = downState != null ? downState : upState;
        mBackground = new Image(upState);
        mScaleWhenDown = downState != null ? 1.0 : 0.9;
        mAlphaWhenDisabled = 0.5;
        mEnabled = true;
        mIsDown = false;
        mUseHandCursor = true;
        mTextBounds = new Rectangle(0, 0, upState.width, upState.height);            
        
        mContents = new Sprite();
        mContents.addChild(mBackground);
        addChild(mContents);
        addEventListener(TouchEvent.TOUCH, onTouch);
        
        this.touchGroup = true;
        this.text = text;
    }
    
    /** @inheritDoc */
    public override function dispose():Void
    {
        // text field might be disconnected from parent, so we have to dispose it manually
        if (mTextField != null)
            mTextField.dispose();
        
        super.dispose();
    }
    
    private function resetContents():Void
    {
        mIsDown = false;
        mBackground.texture = mUpState;
        mContents.x = mContents.y = 0;
        mContents.scaleX = mContents.scaleY = 1.0;
    }
    
    private function createTextField():Void
    {
        if (mTextField == null)
        {
            mTextField = new TextField(Std.int(mTextBounds.width), Std.int(mTextBounds.height), "");
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
    
    private override function onTouch(event:TouchEvent):Void
    {
        event.interactsWith(this);
        //Mouse.cursor = (mUseHandCursor && mEnabled && event.interactsWith(this)) ? 
        //    MouseCursor.BUTTON : MouseCursor.AUTO;
        
        var touch:Touch = event.getTouch(this);
        if (!mEnabled || touch == null) return;
        
        if (touch.phase == TouchPhase.BEGAN && !mIsDown)
        {
            mBackground.texture = mDownState;
            mContents.scaleX = mContents.scaleY = mScaleWhenDown;
            mContents.x = (1.0 - mScaleWhenDown) / 2.0 * mBackground.width;
            mContents.y = (1.0 - mScaleWhenDown) / 2.0 * mBackground.height;
            mIsDown = true;
        }
        else if (touch.phase == TouchPhase.MOVED && mIsDown)
        {
            // reset button when user dragged too far away after pushing
            var buttonRect:Rectangle = getBounds(stage);
            if (touch.globalX < buttonRect.x - MAX_DRAG_DIST ||
                touch.globalY < buttonRect.y - MAX_DRAG_DIST ||
                touch.globalX > buttonRect.x + buttonRect.width + MAX_DRAG_DIST ||
                touch.globalY > buttonRect.y + buttonRect.height + MAX_DRAG_DIST)
            {
                resetContents();
            }
        }
        else if (touch.phase == TouchPhase.ENDED && mIsDown)
        {
            resetContents();
            dispatchEventWith(Event.TRIGGERED, true);
        }
    }
    
    /** The scale factor of the button on touch. Per default, a button with a down state 
      * texture won't scale. */
    public var scaleWhenDown(get, set):Float;
    public function get_scaleWhenDown():Float { return mScaleWhenDown; }
    public function set_scaleWhenDown(value:Float):Float { return mScaleWhenDown = value; }
    
    /** The alpha value of the button when it is disabled. @default 0.5 */
    public var alphaWhenDisabled(get, set):Float;
    public function get_alphaWhenDisabled():Float { return mAlphaWhenDisabled; }
    public function set_alphaWhenDisabled(value:Float):Float { return mAlphaWhenDisabled = value; }
    
    /** Indicates if the button can be triggered. */
    public var enabled(get, set):Bool;
    public function get_enabled():Bool { return mEnabled; }
    public function set_enabled(value:Bool):Bool
    {
        if (mEnabled != value)
        {
            mEnabled = value;
            mContents.alpha = value ? 1.0 : mAlphaWhenDisabled;
            resetContents();
        }
        return mEnabled;
    }
    
    /** The text that is displayed on the button. */
    public var text(get, set):String;
    public function get_text():String { return mTextField != null ? mTextField.text : ""; }
    public function set_text(value:String):String
    {
        if (value.length == 0)
        {
            if (mTextField != null)
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
        return mTextField != null ? mTextField.text : "";
    }
    
    /** The name of the font displayed on the button. May be a system font or a registered 
      * bitmap font. */
    public var fontName(get, set):String;
    public function get_fontName():String { return mTextField != null ? mTextField.fontName : "Verdana"; }
    public function set_fontName(value:String):String
    {
        createTextField();
        mTextField.fontName = value;
        return mTextField != null ? mTextField.fontName : "Verdana";
    }
    
    /** The size of the font. */
    public var fontSize(get, set):Float;
    public function get_fontSize():Float { return mTextField != null ? mTextField.fontSize : 12; }
    public function set_fontSize(value:Float):Float
    {
        createTextField();
        mTextField.fontSize = value;
        return mTextField != null ? mTextField.fontSize : 12;
    }
    
    /** The color of the font. */
    public var fontColor(get, set):UInt;
    public function get_fontColor():UInt { return mTextField != null ? mTextField.color : 0x0; }
    public function set_fontColor(value:UInt):UInt
    {
        createTextField();
        mTextField.color = value;
        return mTextField != null ? mTextField.color : 0x0;
    }
    
    /** Indicates if the font should be bold. */
    public var fontBold(get, set):Bool;
    public function get_fontBold():Bool { return mTextField != null ? mTextField.bold : false; }
    public function set_fontBold(value:Bool):Bool
    {
        createTextField();
        mTextField.bold = value;
        return fontBold;
    }
    
    /** The texture that is displayed when the button is not being touched. */
    public var upState(get, set):Texture;
    public function get_upState():Texture { return mUpState; }
    public function set_upState(value:Texture):Texture
    {
        if (mUpState != value)
        {
            mUpState = value;
            if (!mIsDown) mBackground.texture = value;
        }
        return mUpState;
    }
    
    /** The texture that is displayed while the button is touched. */
    public var downState(get, set):Texture;
    public function get_downState():Texture { return mDownState; }
    public function set_downState(value:Texture):Texture
    {
        if (mDownState != value)
        {
            mDownState = value;
            if (mIsDown) mBackground.texture = value;
        }
        return mDownState;
    }
    
    /** The vertical alignment of the text on the button. */
    public var textVAlign(get, set):String;
    public function get_textVAlign():String
    {
        return mTextField != null ? mTextField.vAlign : VAlign.CENTER;
    }
    
    public function set_textVAlign(value:String):String
    {
        createTextField();
        mTextField.vAlign = value;
        return mTextField != null ? mTextField.vAlign : VAlign.CENTER;
    }
    
    /** The horizontal alignment of the text on the button. */
    public var textHAlign(get, set):String;
    public function get_textHAlign():String
    {
        return mTextField != null ? mTextField.hAlign : HAlign.CENTER;
    }
    
    public function set_textHAlign(value:String):String
    {
        createTextField();
        mTextField.hAlign = value;
        return mTextField != null ? mTextField.hAlign : HAlign.CENTER;
    }
    
    /** The bounds of the textfield on the button. Allows moving the text to a custom position. */
    public var textBounds(get, set):Rectangle;
    public function get_textBounds():Rectangle { return mTextBounds.clone(); }
    public function set_textBounds(value:Rectangle):Rectangle
    {
        mTextBounds = value.clone();
        createTextField();
        return mTextBounds.clone();
    }
    
    /** Indicates if the mouse cursor should transform into a hand while it's over the button. 
     *  @default true */
    public override function get_useHandCursor():Bool { return mUseHandCursor; }
    public override function set_useHandCursor(value:Bool):Bool { return mUseHandCursor = value; }
}
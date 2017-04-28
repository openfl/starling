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

/** A KeyboardEvent is dispatched in response to user input through a keyboard.
 * 
 *  <p>This is Starling's version of the Flash KeyboardEvent class. It contains the same 
 *  properties as the Flash equivalent.</p> 
 * 
 *  <p>To be notified of keyboard events, add an event listener to any display object that
 *  is part of your display tree. Starling has no concept of a "Focus" like native Flash.</p>
 *  
 *  @see starling.display.Stage
 */
class KeyboardEvent extends Event
{
    /** Event type for a key that was released. */
    public static inline var KEY_UP:String = "keyUp";
    
    /** Event type for a key that was pressed. */
    public static inline var KEY_DOWN:String = "keyDown";
    
    private var mCharCode:UInt;
    private var mKeyCode:UInt;
    private var mKeyLocation:UInt;
    private var mAltKey:Bool;
    private var mCtrlKey:Bool;
    private var mShiftKey:Bool;
    private var __isDefaultPrevented:Bool;
    
    /** Creates a new KeyboardEvent. */
    public function new(type:String, charCode:UInt=0, keyCode:UInt=0, 
                                  keyLocation:UInt=0, ctrlKey:Bool=false, 
                                  altKey:Bool=false, shiftKey:Bool=false)
    {
        super(type, false, keyCode);
        mCharCode = charCode;
        mKeyCode = keyCode;
        mKeyLocation = keyLocation;
        mCtrlKey = ctrlKey;
        mAltKey = altKey;
        mShiftKey = shiftKey;
    }
    
    // prevent default
    
    /** Cancels the keyboard event's default behavior. This will be forwarded to the native
     * flash KeyboardEvent. */
    public function preventDefault():Void
    {
        __isDefaultPrevented = true;
    }
    
    /** Checks whether the preventDefault() method has been called on the event. */
    public function isDefaultPrevented():Bool { return __isDefaultPrevented; }
    
    // properties
    
    /** Contains the character code of the key. */
    public var charCode(get, never):UInt;
    private function get_charCode():UInt { return mCharCode; }
    
    /** The key code of the key. */
    public var keyCode(get, never):UInt;
    private function get_keyCode():UInt { return mKeyCode; }
    
    /** Indicates the location of the key on the keyboard. This is useful for differentiating 
     * keys that appear more than once on a keyboard. @see Keylocation */ 
    public var keyLocation(get, never):UInt;
    private function get_keyLocation():UInt { return mKeyLocation; }
    
    /** Indicates whether the Alt key is active on Windows or Linux; 
     * indicates whether the Option key is active on Mac OS. */
    public var altKey(get, never):Bool;
    private function get_altKey():Bool { return mAltKey; }
    
    /** Indicates whether the Ctrl key is active on Windows or Linux; 
     * indicates whether either the Ctrl or the Command key is active on Mac OS. */
    public var ctrlKey(get, never):Bool;
    private function get_ctrlKey():Bool { return mCtrlKey; }
    
    /** Indicates whether the Shift key modifier is active (true) or inactive (false). */
    public var shiftKey(get, never):Bool;
    private function get_shiftKey():Bool { return mShiftKey; }
}
// =================================================================================================
//
//	Starling Framework
//	Copyright Gamua GmbH. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

package starling.events
{
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
public class KeyboardEvent extends Event
{
    /** Event type for a key that was released. */
    public static const KEY_UP:String = "keyUp";
    
    /** Event type for a key that was pressed. */
    public static const KEY_DOWN:String = "keyDown";
    
    private var _charCode:UInt;
    private var _keyCode:UInt;
    private var _keyLocation:UInt;
    private var _altKey:Bool;
    private var _ctrlKey:Bool;
    private var _shiftKey:Bool;
    private var _isDefaultPrevented:Bool;
    
    /** Creates a new KeyboardEvent. */
    public function KeyboardEvent(type:String, charCode:UInt=0, keyCode:UInt=0, 
                                  keyLocation:UInt=0, ctrlKey:Bool=false, 
                                  altKey:Bool=false, shiftKey:Bool=false)
    {
        super(type, false, keyCode);
        _charCode = charCode;
        _keyCode = keyCode;
        _keyLocation = keyLocation;
        _ctrlKey = ctrlKey;
        _altKey = altKey;
        _shiftKey = shiftKey;
    }
    
    // prevent default
    
    /** Cancels the keyboard event's default behavior. This will be forwarded to the native
     *  flash KeyboardEvent. */
    public function preventDefault():Void
    {
        _isDefaultPrevented = true;
    }
    
    /** Checks whether the preventDefault() method has been called on the event. */
    public function isDefaultPrevented():Bool { return _isDefaultPrevented; }
    
    // properties
    
    /** Contains the character code of the key. */
    public function get charCode():UInt { return _charCode; }
    
    /** The key code of the key. */
    public function get keyCode():UInt { return _keyCode; }
    
    /** Indicates the location of the key on the keyboard. This is useful for differentiating 
     *  keys that appear more than once on a keyboard. @see Keylocation */ 
    public function get keyLocation():UInt { return _keyLocation; }
    
    /** Indicates whether the Alt key is active on Windows or Linux; 
     *  indicates whether the Option key is active on Mac OS. */
    public function get altKey():Bool { return _altKey; }
    
    /** Indicates whether the Ctrl key is active on Windows or Linux; 
     *  indicates whether either the Ctrl or the Command key is active on Mac OS. */
    public function get ctrlKey():Bool { return _ctrlKey; }
    
    /** Indicates whether the Shift key modifier is active (true) or inactive (false). */
    public function get shiftKey():Bool { return _shiftKey; }
}
}
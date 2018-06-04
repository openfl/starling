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

/** A class that provides constant values for the phases of a touch object. 
 *  
 *  <p>A touch moves through at least the following phases in its life:</p>
 *  
 *  <code>BEGAN -> MOVED -> ENDED</code>
 *  
 *  <p>Furthermore, a touch can enter a <code>STATIONARY</code> phase. That phase does not
 *  trigger a touch event itself, and it can only occur in multitouch environments. Picture a 
 *  situation where one finger is moving and the other is stationary. A touch event will
 *  be dispatched only to the object under the <em>moving</em> finger. In the list of touches
 *  of that event, you will find the second touch in the stationary phase.</p>
 *  
 *  <p>Finally, there's the <code>HOVER</code> phase, which is exclusive to mouse input. It is
 *  the equivalent of a <code>MouseOver</code> event in Flash when the mouse button is
 *  <em>not</em> pressed.</p> 
 */

@:jsRequire("starling/events/TouchPhase", "default")

extern class TouchPhase
{
    /** Only available for mouse input: the cursor hovers over an object <em>without</em> a 
     * pressed button. */
    public static var HOVER:String;
    
    /** The finger touched the screen just now, or the mouse button was pressed. */
    public static var BEGAN:String;
    
    /** The finger moves around on the screen, or the mouse is moved while the button is 
     * pressed. */
    public static var MOVED:String;
    
    /** The finger or mouse (with pressed button) has not moved since the last frame. */
    public static var STATIONARY:String;
    
    /** The finger was lifted from the screen or from the mouse button. */
    public static var ENDED:String;
}
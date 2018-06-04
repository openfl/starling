// =================================================================================================
//
//	Starling Framework
//	Copyright Gamua GmbH. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

package starling.text;

/** This class is an enumeration of constant values used in setting the 
 *  autoSize property of the TextField class. */

@:jsRequire("starling/text/TextFieldAutoSize", "default")

extern class TextFieldAutoSize
{
    /** No auto-sizing will happen. */
    public static var NONE:String;
    
    /** The text field will grow/shrink sidewards; no line-breaks will be added.
     * The height of the text field remains unchanged. */ 
    public static var HORIZONTAL:String;
    
    /** The text field will grow/shrink downwards, adding line-breaks when necessary.
     * The width of the text field remains unchanged. */
    public static var VERTICAL:String;
    
    /** The text field will grow to the right and bottom; no line-breaks will be added. */
    public static var BOTH_DIRECTIONS:String;
}
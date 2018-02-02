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
class TextFieldAutoSize
{
    /** No auto-sizing will happen. */
    public static inline var NONE:String = "none";
    
    /** The text field will grow/shrink sidewards; no line-breaks will be added.
     * The height of the text field remains unchanged. */ 
    public static inline var HORIZONTAL:String = "horizontal";
    
    /** The text field will grow/shrink downwards, adding line-breaks when necessary.
     * The width of the text field remains unchanged. */
    public static inline var VERTICAL:String = "vertical";
    
    /** The text field will grow to the right and bottom; no line-breaks will be added. */
    public static inline var BOTH_DIRECTIONS:String = "bothDirections";
}
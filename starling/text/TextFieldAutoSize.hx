// =================================================================================================
//
//	Starling Framework
//	Copyright 2013 Gamua OG. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

package starling.text;
import starling.errors.AbstractClassError;

/** This class is an enumeration of constant values used in setting the 
 *  autoSize property of the TextField class. */ 
class TextFieldAutoSize
{
    /** @private */
    public function TextFieldAutoSize() { throw new AbstractClassError(); }
    
    /** No auto-sizing will happen. */
    inline public static var NONE:String = "none";
    
    /** The text field will grow to the right; no line-breaks will be added.
     *  The height of the text field remains unchanged. */ 
    inline public static var HORIZONTAL:String = "horizontal";
    
    /** The text field will grow to the bottom, adding line-breaks when necessary.
      * The width of the text field remains unchanged. */
    inline public static var VERTICAL:String = "vertical";
    
    /** The text field will grow to the right and bottom; no line-breaks will be added. */
    inline public static var BOTH_DIRECTIONS:String = "bothDirections";
}
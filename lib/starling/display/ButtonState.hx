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

/** A class that provides constant values for the states of the Button class. */

@:jsRequire("starling/display/ButtonState", "default")

extern class ButtonState
{
    /** The button's default state. */
    public static var UP:String;

    /** The button is pressed. */
    public static var DOWN:String;

    /** The mouse hovers over the button. */
    public static var OVER:String;

    /** The button was disabled altogether. */
    public static var DISABLED:String;
}
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
class ButtonState
{
    /** The button's default state. */
    public static inline var UP:String = "up";

    /** The button is pressed. */
    public static inline var DOWN:String = "down";

    /** The mouse hovers over the button. */
    public static inline var OVER:String = "over";

    /** The button was disabled altogether. */
    public static inline var DISABLED:String = "disabled";
	
	/** Indicates whether the given state string is valid. */
	public static function isValid(state:String):Bool
	{
		return state == UP || state == DOWN || state == OVER || state == DISABLED;
	}
}
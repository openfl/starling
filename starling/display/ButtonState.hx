// =================================================================================================
//
//	Starling Framework
//	Copyright 2014 Gamua GmbH. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

package starling.display;
import starling.errors.AbstractClassError;

/** A class that provides constant values for the states of the Button class. */
class ButtonState
{
    /** @private */
    public function new() { throw new AbstractClassError(); }

    /** The button's default state. */
    inline public static var UP:String = "up";

    /** The button is pressed. */
    inline public static var DOWN:String = "down";

    /** The mouse hovers over the button. */
    inline public static var OVER:String = "over";

    /** The button was disabled altogether. */
    inline public static var DISABLED:String = "disabled";
}
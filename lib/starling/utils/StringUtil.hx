// =================================================================================================
//
//	Starling Framework
//	Copyright Gamua GmbH. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

package starling.utils;

/** A utility class with methods related to the String class. */

@:jsRequire("starling/utils/StringUtil", "default")

extern class StringUtil
{
    /** Formats a String in .Net-style, with curly braces ("{0}"). Does not support any
     *  number formatting options yet. */
    public static function format(format:String, args:Array<Dynamic>):String;

    /** Replaces a string's "master string" — the string it was built from —
     *  with a single character to save memory. Find more information about this AS3 oddity
     *  <a href="http://jacksondunstan.com/articles/2260">here</a>.
     *
     *  @param  string The String to clean
     *  @return The input string, but with a master string only one character larger than it.
     *  @author Jackson Dunstan, JacksonDunstan.com
     */
    public static function clean(string:String):String;

    /** Removes all leading white-space and control characters from the given String.
     *
     *  <p>Beware: this method does not make a proper Unicode white-space check,
     *  but simply trims all character codes of '0x20' or below.</p>
     */
    public static function trimStart(string:String):String;

    /** Removes all trailing white-space and control characters from the given String.
     *
     *  <p>Beware: this method does not make a proper Unicode white-space check,
     *  but simply trims all character codes of '0x20' or below.</p>
     */
    public static function trimEnd(string:String):String;

    /** Removes all leading and trailing white-space and control characters from the given
     *  String.
     *
     *  <p>Beware: this method does not make a proper Unicode white-space check,
     *  but simply trims all character codes of '0x20' or below.</p>
     */
    public static function trim(string:String):String;
}
declare namespace starling.utils
{
    /** A utility class with methods related to the String class. */
    export class StringUtil
    {
        /** Formats a String in .Net-style, with curly braces ("{0}"). Does not support any
         *  number formatting options yet. */
        public static format(format:string, args:Array<any>):string;

        /** Replaces a string's "master string" — the string it was built from —
         *  with a single character to save memory. Find more information about this AS3 oddity
         *  <a href="http://jacksondunstan.com/articles/2260">here</a>.
         *
         *  @param  string The String to clean
         *  @return The input string, but with a master string only one character larger than it.
         *  @author Jackson Dunstan, JacksonDunstan.com
         */
        public static clean(string:string):string;

        /** Removes all leading white-space and control characters from the given String.
         *
         *  <p>Beware: this method does not make a proper Unicode white-space check,
         *  but simply trims all character codes of '0x20' or below.</p>
         */
        public static trimStart(string:string):string;

        /** Removes all trailing white-space and control characters from the given String.
         *
         *  <p>Beware: this method does not make a proper Unicode white-space check,
         *  but simply trims all character codes of '0x20' or below.</p>
         */
        public static trimEnd(string:string):string;

        /** Removes all leading and trailing white-space and control characters from the given
         *  String.
         *
         *  <p>Beware: this method does not make a proper Unicode white-space check,
         *  but simply trims all character codes of '0x20' or below.</p>
         */
        public static trim(string:string):string;
    }
}

export default starling.utils.StringUtil;
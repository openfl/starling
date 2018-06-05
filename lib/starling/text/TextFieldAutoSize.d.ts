declare namespace starling.text
{
    /** This class is an enumeration of constant values used in setting the 
     *  autoSize property of the TextField class. */
    export class TextFieldAutoSize
    {
        /** No auto-sizing will happen. */
        public static NONE:string;
        
        /** The text field will grow/shrink sidewards; no line-breaks will be added.
         * The height of the text field remains unchanged. */ 
        public static HORIZONTAL:string;
        
        /** The text field will grow/shrink downwards, adding line-breaks when necessary.
         * The width of the text field remains unchanged. */
        public static VERTICAL:string;
        
        /** The text field will grow to the right and bottom; no line-breaks will be added. */
        public static BOTH_DIRECTIONS:string;
    }
}

export default starling.text.TextFieldAutoSize;
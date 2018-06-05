declare namespace starling.utils
{
    /** A class that provides constant values for the 'RectangleUtil.fit' method. */
    export class ScaleMode
    {
        /** Specifies that the rectangle is not scaled, but simply centered within the 
         * specified area. */
        public static NONE:string;
        
        /** Specifies that the rectangle fills the specified area without distortion 
         * but possibly with some cropping, while maintaining the original aspect ratio. */
        public static NO_BORDER:string;
        
        /** Specifies that the entire rectangle will be scaled to fit into the specified 
         * area, while maintaining the original aspect ratio. This might leave empty bars at
         * either the top and bottom, or left and right. */
        public static SHOW_ALL:string;
        
        /** Indicates whether the given scale mode string is valid. */
        public static isValid(scaleMode:string):boolean;
    }
}

export default starling.utils.ScaleMode;
package starling.utils;

/** A class that provides constant values for the 'RectangleUtil.fit' method. */
class ScaleMode
{
    /** Specifies that the rectangle is not scaled, but simply centered within the 
     *  specified area. */
    public static inline var NONE:String = "none";
    
    /** Specifies that the rectangle fills the specified area without distortion 
     *  but possibly with some cropping, while maintaining the original aspect ratio. */
    public static inline var NO_BORDER:String = "noBorder";
    
    /** Specifies that the entire rectangle will be scaled to fit into the specified 
     *  area, while maintaining the original aspect ratio. This might leave empty bars at
     *  either the top and bottom, or left and right. */
    public static inline var SHOW_ALL:String = "showAll";
    
    /** Indicates whether the given scale mode string is valid. */
    public static function isValid(scaleMode:String):Bool
    {
        return scaleMode == NONE || scaleMode == NO_BORDER || scaleMode == SHOW_ALL;
    }
}
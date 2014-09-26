package;
class Constants
{
    inline public static var GameWidth:Int  = 320;
    inline public static var GameHeight:Int = 480;
    
    inline public static var CenterX:Int = Std.int(GameWidth / 2);
    inline public static var CenterY:Int = Std.int(GameHeight / 2);
#if html5
    inline public static var DefaultFont:String = "assets/fonts/Ubuntu-R.woff";
#else
    inline public static var DefaultFont:String = "assets/fonts/Ubuntu-R.ttf";
#end
}
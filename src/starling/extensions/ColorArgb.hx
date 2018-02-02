// =================================================================================================
//
//	Starling Framework - Particle System Extension
//	Copyright Gamua GmbH. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

package starling.extensions;

class ColorArgb
{
    public var red:Float;
    public var green:Float;
    public var blue:Float;
    public var alpha:Float;
    
    public static function fromRgb(color:Int):ColorArgb
    {
        var rgb:ColorArgb = new ColorArgb();
        rgb._fromRgb(color);
        return rgb;
    }
    
    public static function fromArgb(color:Int):ColorArgb
    {
        var argb:ColorArgb = new ColorArgb();
        argb._fromArgb(color);
        return argb;
    }
    
    public function new(red:Float = 0, green:Float = 0, blue:Float = 0, alpha:Float = 0)
    {
        this.red = red;
        this.green = green;
        this.blue = blue;
        this.alpha = alpha;
    }
    
    public function toRgb():Int
    {
        var r:Float = red;   if (r < 0.0) r = 0.0; else if (r > 1.0) r = 1.0;
        var g:Float = green; if (g < 0.0) g = 0.0; else if (g > 1.0) g = 1.0;
        var b:Float = blue;  if (b < 0.0) b = 0.0; else if (b > 1.0) b = 1.0;
        
        return Std.int(r * 255) << 16 | Std.int(g * 255) << 8 | Std.int(b * 255);
    }
    
    public function toArgb():Int
    {
        var a:Float = alpha; if (a < 0.0) a = 0.0; else if (a > 1.0) a = 1.0;
        var r:Float = red;   if (r < 0.0) r = 0.0; else if (r > 1.0) r = 1.0;
        var g:Float = green; if (g < 0.0) g = 0.0; else if (g > 1.0) g = 1.0;
        var b:Float = blue;  if (b < 0.0) b = 0.0; else if (b > 1.0) b = 1.0;
        
        return Std.int(Std.int(a * 255) << 24 | Std.int(r * 255) << 16 | Std.int(g * 255) << 8 | Std.int(b * 255));
    }
    
    public function _fromRgb(color:Int):Void
    {
        red = (Std.int(color >> 16) & 0xFF) / 255.0;
        green = (Std.int(color >> 8) & 0xFF) / 255.0;
        blue = (color & 0xFF) / 255.0;
    }
    
    public function _fromArgb(color:Int):Void
    {
        red = (Std.int(color >> 16) & 0xFF) / 255.0;
        green = (Std.int(color >> 8) & 0xFF) / 255.0;
        blue = (color & 0xFF) / 255.0;
        alpha = (Std.int(color >> 24) & 0xFF) / 255.0;
    }
    
    public function copyFrom(argb:ColorArgb):Void
    {
        red = argb.red;
        green = argb.green;
        blue = argb.blue;
        alpha = argb.alpha;
    }
}
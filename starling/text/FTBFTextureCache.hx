package starling.text;
import openfl.display3D.Context3DTextureFormat;
import openfl.display3D.textures.RectangleTexture;
import openfl.geom.Rectangle;
import openfl.utils.UInt8Array;
import starling.core.Starling;
import starling.textures.SubTexture;
import starling.textures.Texture;
import starling.utils.MaxRectsBinPack;

class FTBFTextureCache
{
    public var texture(default, null):Texture;
    private var binPack:MaxRectsBinPack;
    private var charCodes:Array<Int>;
    private var fonts:Array<FTBitmapFont>;

    public function new(width:Int, height:Int)
    {
        texture = Texture.empty(width, height, false, false, false, -1, Context3DTextureFormat.ALPHA, false);
        var tmpImage:UInt8Array = new UInt8Array(width * height);
        var stdTexture:openfl.display3D.textures.Texture = Std.instance(texture.base, openfl.display3D.textures.Texture);
        if (stdTexture != null)
            stdTexture.uploadFromUInt8Array(tmpImage);
        else
            cast(texture.base, RectangleTexture).uploadFromUInt8Array(tmpImage);
        binPack = new MaxRectsBinPack(width + 1, height + 1);
        charCodes = [];
        fonts = [];
    }
    
    public function dispose():Void
    {
        for (i in 0 ... fonts.length)
            fonts[i].removeChar(charCodes[i]);
        charCodes = [];
        fonts = [];
        texture.dispose();
    }

    public function addSubTexture(bitmap:UInt8Array, width:Int, height:Int, font:FTBitmapFont, charCode:Int):SubTexture
    {
        var rect:Rectangle = binPack.quickInsert(width + 1, height + 1);
        if (rect.height == 0)
            return null;
        rect.width -= 1;
        rect.height -= 1;
        var stdTexture:openfl.display3D.textures.Texture = Std.instance (texture.base, openfl.display3D.textures.Texture);
        if (stdTexture != null)
            stdTexture.uploadFromUInt8Array(bitmap, 0, Std.int(rect.x), Std.int(rect.y), width, height);
        else
            cast(texture.base, openfl.display3D.textures.RectangleTexture).uploadFromUInt8Array(bitmap, Std.int(rect.x), Std.int(rect.y), width, height);
        var subTexture:SubTexture = cast Texture.fromTexture(texture, rect);
        fonts.push(font);
        charCodes.push(charCode);
        return subTexture;
    }
}
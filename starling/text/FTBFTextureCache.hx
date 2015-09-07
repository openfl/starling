package starling.text;

#if !flash
import lime.text.Glyph;
import openfl.display3D.Context3DTextureFormat;
import openfl.display3D.textures.RectangleTexture;
import openfl.geom.Rectangle;
import openfl.utils.UInt8Array;
import starling.core.Starling;
import starling.display.Image;
import starling.display.QuadBatch;
import starling.textures.SubTexture;
import starling.textures.Texture;
import starling.textures.TextureSmoothing;
import starling.utils.MaxRectsBinPack;
import starling.utils.IntRect;

class FTBFTextureCache
{
    public var texture(default, null):Texture;
    private var binPack:MaxRectsBinPack;
    private var textRenderers:Map<TextRenderer, Array<Glyph>>;
    public var quadBatch(default, null):QuadBatch;
    public var helperImage(default, null):Image;

    public function new(width:Int, height:Int)
    {
        texture = Texture.empty(width, height, true, false, false, -1, Context3DTextureFormat.ALPHA, false);
        var tmpImage:UInt8Array = new UInt8Array(width * height);
        var stdTexture:openfl.display3D.textures.Texture = Std.instance(texture.base, openfl.display3D.textures.Texture);
        if (stdTexture != null)
            stdTexture.uploadFromUInt8Array(tmpImage);
        else
            cast(texture.base, RectangleTexture).uploadFromUInt8Array(tmpImage);
        binPack = new MaxRectsBinPack(width, height);
        textRenderers = new Map();
        quadBatch = new QuadBatch();
        helperImage = new Image(texture);
    }
    
    public function dispose():Void
    {
        /*for (textRenderer in textRenderers.keys())
        {
            var glyphs:Array<Int> = textRenderers[textRenderer];
            for (glyph in glyphs)
                textRenderer.removeGlyph(glyph);
        }*/
        texture.dispose();
    }

    public function addSubTexture(bitmap:UInt8Array, width:Int, height:Int, textRenderer:TextRenderer, glyph:Glyph):SubTexture
    {
        var _width:Int = (width == binPack.binWidth) ? width : width + 1;
        var _height:Int = (height == binPack.binHeight) ? height : height + 1;
        var rect:IntRect = binPack.quickInsert(_width, _height);
        if (rect.height == 0)
            return null;
        rect.width = width;
        rect.height = height;
        var stdTexture:openfl.display3D.textures.Texture = Std.instance (texture.base, openfl.display3D.textures.Texture);
        if (stdTexture != null)
            stdTexture.uploadFromUInt8Array(bitmap, 0, rect.x, rect.y, width, height);
        else
            cast(texture.base, openfl.display3D.textures.RectangleTexture).uploadFromUInt8Array(bitmap, rect.x, rect.y, width, height);
        var subTexture:SubTexture = cast Texture.fromTexture(texture, rect.toFlashRectangle());
        var glyphs:Array<Glyph> = textRenderers.get(textRenderer);
        if (glyphs == null)
        {
            glyphs = [glyph];
            textRenderers.set(textRenderer, glyphs);
        }
        else
            glyphs.push(glyph);
        return subTexture;
    }
}
#end
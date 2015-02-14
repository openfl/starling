// =================================================================================================
//
//	Starling Framework
//	Copyright 2011 Gamua OG. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

package starling.text;
import lime.graphics.Font.NativeKerningData;
import lime.graphics.Font.NativeFontData;
import lime.graphics.Font.NativeGlyphData;
#if (cpp || neko || nodejs)
import openfl.geom.Rectangle;
import openfl.utils.UInt8Array;
import starling.display.Image;
import starling.textures.SubTexture;
import starling.utils.PowerOfTwo;
import starling.textures.Texture;
import lime.graphics.Font.GlyphRect;
import lime.graphics.ImageBuffer;
import openfl.text.Font;
import starling.core.Starling;
import starling.display.QuadBatch;

class FTBitmapFont extends BitmapFont
{
    inline private static var MIN_TEXTURE_WIDTH:Int = 1024;
    inline private static var MIN_TEXTURE_HEIGHT:Int = 1024;
    
    private var mFont:Font;
    private static var sCaches:Array<FTBFTextureCache> = [];
    private static var sEmptyRect:Rectangle = new Rectangle();
    private static var sHelperChars:Array<BitmapChar> = [];
    
    public function new(font:Font, size:Int)
    {
        super();
        this.mFont = font;
        var fontData:NativeFontData = this.mFont.getFontData();
        mSize = size;
        mLineHeight = (fontData.ascend - fontData.descend) * mSize / fontData.em_size;
        mLeftPadding = 4;
        mRightPadding = 2;
        mBottomPadding = 2;
    }
    
    override public function fillQuadBatch(textField:TextField, width:Float, height:Float, text:String, fontSize:Float = -1, color:UInt = 0xffffff, hAlign:String = "center", vAlign:String = "center", autoScale:Bool = true, kerning:Bool = true):Void 
    {
        addChars(text);
        super.fillQuadBatch(textField, width, height, text, BitmapFont.NATIVE_SIZE, color, hAlign, vAlign, autoScale, kerning);
    }
    
    private function addChars(text:String, result:Array<BitmapChar> = null)
    {
        if (text.length == 0)
            return;
        
        var intFontSize:Int = Std.int(mSize);
        var glyphRects:Map<Int, lime.graphics.Font.GlyphRect> = mFont.glyphs[intFontSize];
        var textToRender:String = "";
        for (i in 0 ... text.length)
        {
            var charCode:Int = StringTools.fastCodeAt(text, i);
            if (charCode == BitmapFont.CHAR_NEWLINE || charCode == BitmapFont.CHAR_CARRIAGE_RETURN)
                continue;
            if (glyphRects == null || (glyphRects != null && !glyphRects.exists(charCode)))
                textToRender += text.charAt(i);
        }
        
        if (textToRender.length != 0)
        {
            var fontData:NativeFontData = mFont.getFontData();
            var createdGlyphs:Array<GlyphRect> = mFont.createImage(intFontSize, textToRender);
            for (i in 0 ... createdGlyphs.length)
            {
                var gr:GlyphRect = createdGlyphs[i];
                var charID:Int = StringTools.fastCodeAt(textToRender, i);
                var cache:FTBFTextureCache = sCaches.length == 0 ? addTextureCache(gr.width, gr.height) : sCaches[sCaches.length - 1];
                var subTexture:SubTexture;
                if (gr.bitmap != null)
                {
					var bitmap:UInt8Array = #if nodejs gr.bitmap.byteView #else new UInt8Array(gr.bitmap) #end;
                    subTexture = cache.addSubTexture(bitmap, gr.width, gr.height, this, charID);
                    if (subTexture == null)
                    {
                        cache = addTextureCache(gr.width, gr.height);
                        subTexture = cache.addSubTexture(bitmap, gr.width, gr.height, this, charID);
                    }
                }
                else
                    subTexture = cast Texture.fromTexture(cache.texture, sEmptyRect);
                var char:BitmapChar = new BitmapChar(charID, subTexture, gr.xOffset,
                    Math.round(fontData.ascend * mSize / fontData.em_size - gr.yOffset),
                    Math.round(gr.advance / 64 / 100));
                addChar(charID, char);
                if (result != null)
                    result[i] = char;
            }
        }
    }
    
    override public function getChar(charID:Int):BitmapChar
    {
        var char:BitmapChar = mChars.get(charID);
        if (char != null)
            return char;
        addChars(String.fromCharCode(charID), sHelperChars);
        return sHelperChars[0];
    }
    
    public function removeChar(charID:Int)
    {
        mChars.remove(charID);
    }
    
    private static function addTextureCache(width:Int, height:Int):FTBFTextureCache
    {
        width = PowerOfTwo.getNextPowerOfTwo(width);
        height = PowerOfTwo.getNextPowerOfTwo(height);
        var cache:FTBFTextureCache = new FTBFTextureCache(MIN_TEXTURE_WIDTH > width ? MIN_TEXTURE_WIDTH : width, MIN_TEXTURE_HEIGHT > height ? MIN_TEXTURE_HEIGHT : height);
        sCaches.push(cache);
        return cache;
    }
    
}
#else
class FTBitmapFont {}
#end
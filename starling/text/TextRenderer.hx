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
import lime.text.GlyphPosition;
import lime.text.TextLayout;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;
import openfl.text.TextLineMetrics;
import starling.display.BlendMode;
import starling.textures.RenderTexture;
import openfl._internal.renderer.TextFieldGraphics;
import starling.core.RenderSupport;
import openfl.geom.Matrix;
#if (cpp || neko || nodejs)
import lime.text.Glyph;
import openfl.geom.Rectangle;
import openfl.utils.UInt8Array;
import starling.display.Image;
import starling.textures.SubTexture;
import starling.utils.PowerOfTwo;
import starling.textures.Texture;
import openfl.text.Font;
import starling.core.Starling;
import starling.display.QuadBatch;

typedef GlyphTextureInfo =
{
    texture:SubTexture,
    x:Int,
    y:Int,
    fontCache:FTBFTextureCache,
}

@:access(openfl.text.TextField)
class TextRenderer
{
    inline private static var MIN_TEXTURE_WIDTH:Int = 1024;
    inline private static var MIN_TEXTURE_HEIGHT:Int = 1024;
    
    private var mFont:Font;
    private var mSize:Int;
    private var mGlyphs:Map<Glyph, GlyphTextureInfo>;
    
    private static var fontCaches(get, never):Array<FTBFTextureCache>;
    private static var sClipRect:Rectangle = new Rectangle();
    private static var sSupport:RenderSupport = null;
    private static var sQuadBatches:Map<QuadBatch, Bool>;
    
    public function new(font:Font, size:Int)
    {
        mFont = font;
        mSize = size;
        mGlyphs = new Map();
    }
    
    public function renderText(textField:openfl.text.TextField, texture:Texture, text:String, format:TextFormat, offsetX:Float, offsetY:Float)
    {
        // based on OpenFL's TextFieldGraphics
        
        var bounds:Rectangle = textField.getBounds(null);
        TextFieldGraphics.update(textField, bounds);
        
        var tlm:TextLineMetrics = textField.getLineMetrics(0);
        
        var info:GlyphTextureInfo;
        var x:Float = offsetX;
        var y:Float = 2 + tlm.ascent + offsetY;
        
        var lines:Array<String> = text.split("\n");
        
        if (textField.__textLayout == null)
            textField.__textLayout = new TextLayout();
        
        var textLayout:TextLayout = textField.__textLayout;
        
        var line_i:Int = 0;
        var oldX:Float = x;
        
        sQuadBatches = new Map();
        for (line in lines)
        {
            tlm = textField.getLineMetrics(line_i);
            
            //x position must be reset every line and recalculated 
            x = oldX;
            
            var align:TextFormatAlign = format.align != null ? format.align : TextFormatAlign.LEFT;
            x += switch (align)
            {
                case LEFT, JUSTIFY: 2;
                case CENTER: ((textField.__width) - tlm.width) / 2;
                case RIGHT:  ((textField.__width) - tlm.width) - 2;
            }
            
            textLayout.text = null;
            textLayout.font = mFont;
            textLayout.size = mSize;
            textLayout.text = line;
            
            var positions:Array<GlyphPosition> = textLayout.positions;
            var unrenderedGlyphs:Array<Glyph> = [];
            for (position in positions)
            {
                if (!mGlyphs.exists(position.glyph))
                {
                    unrenderedGlyphs.push(position.glyph);
                    mGlyphs.set(position.glyph, null);
                }
            }
            if (unrenderedGlyphs.length != 0)
            {
                var images:Array<lime.graphics.Image> = mFont.renderGlyphs(unrenderedGlyphs, mSize);
                for (i in 0 ... images.length)
                {
                    var image:lime.graphics.Image = images[i];
                    var glyph:Glyph = unrenderedGlyphs[i];
                    if (image == null)
                        continue;
                    
                    var caches:Array<FTBFTextureCache> = TextRenderer.fontCaches;
                    var textureWidth:Int = PowerOfTwo.getNextPowerOfTwo(image.width > MIN_TEXTURE_WIDTH ? image.width : MIN_TEXTURE_WIDTH);
                    var textureHeight:Int = PowerOfTwo.getNextPowerOfTwo(image.height > MIN_TEXTURE_HEIGHT ? image.height : MIN_TEXTURE_HEIGHT);
                    if (caches.length == 0)
                        caches.push(new FTBFTextureCache(textureWidth, textureHeight));
                    var cache:FTBFTextureCache = caches[caches.length - 1];
                    var subTexture:SubTexture = cache.addSubTexture(image.buffer.data, image.width, image.height, this, glyph);
                    if (subTexture == null)
                    {
                        cache = new FTBFTextureCache(textureWidth, textureHeight);
                        caches.push(cache);
                        subTexture = cache.addSubTexture(image.buffer.data, image.width, image.height, this, glyph);
                    }
                    mGlyphs.set(glyph, {texture:subTexture, x:Std.int(image.x), y:Std.int(image.y), fontCache:cache});
                }
            }
            
            for (position in positions)
            {
                info = mGlyphs.get(position.glyph);
                
                if (info != null)
                {
                    var helperImage = info.fontCache.helperImage;
                    helperImage.color = format.color;
                    helperImage.texture = info.texture;
                    helperImage.readjustSize();
                    helperImage.x = Math.round(x + position.offset.x + info.x);
                    helperImage.y = Math.round(y + position.offset.y - info.y);
                    
                    var quadBatch:QuadBatch = info.fontCache.quadBatch;
                    quadBatch.addImage(helperImage);
                    sQuadBatches.set(quadBatch, true);
                }
                
                x += position.advance.x;
                y -= position.advance.y;
                
            }
            
            y += tlm.height;    //always add the line height at the end
            line_i++;
            
        }
        
        
        if (sSupport == null)
            sSupport = new RenderSupport();
        
        var rootWidth:Float = texture.root.width;
        var rootHeight:Float = texture.root.height;
        sSupport.setProjectionMatrix(0, 0, rootWidth, rootHeight);
        sClipRect.setTo(0, 0, texture.width, texture.height);
        sSupport.pushClipRect(sClipRect);
        
        sSupport.setRenderTarget(texture);
        sSupport.clear();
        sSupport.blendMode = BlendMode.NONE;
        
        for (quadBatch in sQuadBatches.keys())
        {
            quadBatch.render(sSupport, 1.0);
            quadBatch.reset();
        }
        
        sSupport.finishQuadBatch();
        sSupport.nextFrame();
        sSupport.renderTarget = null;
        sSupport.popClipRect();
    }
    
    private function addChars(text:String, result:Array<BitmapChar> = null)
    {
        var newGlyphs:Array<Glyph> = mFont.getGlyphs(text);
    }
    
    public function removeGlyph(glyph:Glyph)
    {
        mGlyphs.remove(glyph);
    }
    
    private static function addTextureCache(width:Int, height:Int):FTBFTextureCache
    {
        width = PowerOfTwo.getNextPowerOfTwo(width);
        height = PowerOfTwo.getNextPowerOfTwo(height);
        var cache:FTBFTextureCache = new FTBFTextureCache(MIN_TEXTURE_WIDTH > width ? MIN_TEXTURE_WIDTH : width, MIN_TEXTURE_HEIGHT > height ? MIN_TEXTURE_HEIGHT : height);
        fontCaches.push(cache);
        return cache;
    }
    
    @:noCompletion private static function get_fontCaches():Array<FTBFTextureCache>
    {
        var target:Starling = Starling.current;
        var caches:Array<FTBFTextureCache> = target.fontCaches;
        if (caches == null)
        {
            caches = [];
            target.fontCaches = caches;
        }
        
        return caches;
    }
}
#else
class TextRenderer {}
#end
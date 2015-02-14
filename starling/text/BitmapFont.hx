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
import flash.geom.Rectangle;
import openfl.errors.ArgumentError;

import starling.display.Image;
import starling.display.QuadBatch;
import starling.display.Sprite;
import starling.textures.Texture;
import starling.textures.TextureSmoothing;
import starling.utils.HAlign;
import starling.utils.VAlign;

import starling.text.BitmapChar;

/** The BitmapFont class parses bitmap font files and arranges the glyphs 
 *  in the form of a text.
 *
 *  The class parses the XML format as it is used in the 
 *  <a href="http://www.angelcode.com/products/bmfont/">AngelCode Bitmap Font Generator</a> or
 *  the <a href="http://glyphdesigner.71squared.com/">Glyph Designer</a>. 
 *  This is what the file format looks like:
 *
 *  <pre> 
 *  &lt;font&gt;
 *    &lt;info face="BranchingMouse" size="40" /&gt;
 *    &lt;common lineHeight="40" /&gt;
 *    &lt;pages&gt;  &lt;!-- currently, only one page is supported --&gt;
 *      &lt;page id="0" file="texture.png" /&gt;
 *    &lt;/pages&gt;
 *    &lt;chars&gt;
 *      &lt;char id="32" x="60" y="29" width="1" height="1" xoffset="0" yoffset="27" xadvance="8" /&gt;
 *      &lt;char id="33" x="155" y="144" width="9" height="21" xoffset="0" yoffset="6" xadvance="9" /&gt;
 *    &lt;/chars&gt;
 *    &lt;kernings&gt; &lt;!-- Kerning is optional --&gt;
 *      &lt;kerning first="83" second="83" amount="-4"/&gt;
 *    &lt;/kernings&gt;
 *  &lt;/font&gt;
 *  </pre>
 *  
 *  Pass an instance of this class to the method <code>registerBitmapFont</code> of the
 *  TextField class. Then, set the <code>fontName</code> property of the text field to the 
 *  <code>name</code> value of the bitmap font. This will make the text field use the bitmap
 *  font.  
 */ 
class BitmapFont
{
    /** Use this constant for the <code>fontSize</code> property of the TextField class to 
     *  render the bitmap font in exactly the size it was created. */ 
    inline public static var NATIVE_SIZE:Int = -1;
    
    /** The font name of the embedded minimal bitmap font. Use this e.g. for debug output. */
    inline public static var MINI:String = "mini";
    
    inline private static var CHAR_SPACE:Int           = 32;
    inline private static var CHAR_TAB:Int             =  9;
    inline private static var CHAR_NEWLINE:Int         = 10;
    inline private static var CHAR_CARRIAGE_RETURN:Int = 13;
    
    private var mTexture:Texture;
    private var mChars:Map<Int, BitmapChar>;
    private var mName:String;
    private var mSize:Float;
    private var mLineHeight:Float;
    private var mBaseline:Float;
    private var mOffsetX:Float;
    private var mOffsetY:Float;
    private var mHelperImage:Image;
    private var mLeftPadding:Float;
    private var mRightPadding:Float;
    private var mCharLocationPool:Array<CharLocation>;
    
    /** Creates a bitmap font by parsing an XML file and uses the specified texture. 
     *  If you don't pass any data, the "mini" font will be created. */
    public function new(texture:Texture=null, fontXml:Xml=null)
    {
        // if no texture is passed in, we create the minimal, embedded font
        /*if (texture == null && fontXml == null)
        {
            texture = MiniBitmapFont.texture;
            fontXml = MiniBitmapFont.xml;
        }*/
        
        mName = "unknown";
        mLineHeight = mSize = mBaseline = 14;
        mLeftPadding = mRightPadding = 0;
        mOffsetX = mOffsetY = 0.0;
        mTexture = texture;
        mChars = new Map<Int, BitmapChar>();
        mHelperImage = texture != null ? new Image(texture) : null;
        mCharLocationPool = new Array<CharLocation>();
        
        if (fontXml != null) parseFontXml(fontXml);
    }
    
    /** Disposes the texture of the bitmap font! */
    public function dispose():Void
    {
        if (mTexture != null)
            mTexture.dispose();
    }
    
    private function parseFontXml(fontXml:Xml):Void
    {
        var scale:Float = mTexture.scale;
        var frame:Rectangle = mTexture.frame;
        var frameX:Float = frame != null ? frame.x : 0;
        var frameY:Float = frame != null ? frame.y : 0;

        var info:Xml = fontXml.elementsNamed("info").next();
        var common:Xml = fontXml.elementsNamed("common").next();
        mName = info.get("face");
        mSize = Std.parseFloat(info.get("size")) / scale;
        mLineHeight = Std.parseFloat(common.get("lineHeight")) / scale;
        mBaseline = Std.parseFloat(common.get("base")) / scale;
        
        if (info.get("smooth") == "0")
            smoothing = TextureSmoothing.NONE;
        
        if (mSize <= 0)
        {
            trace("[Starling] Warning: invalid font size in '" + mName + "' font.");
            mSize = (mSize == 0.0 ? 16.0 : mSize * -1.0);
        }
        
        var chars:Xml = fontXml.elementsNamed("chars").next();
        for(charElement in chars.elementsNamed("char"))
        {
            var id:Int = Std.parseInt(charElement.get("id"));
            var xOffset:Float = Std.parseFloat(charElement.get("xoffset")) / scale;
            var yOffset:Float = Std.parseFloat(charElement.get("yoffset")) / scale;
            var xAdvance:Float = Std.parseFloat(charElement.get("xadvance")) / scale;
            
            var region:Rectangle = new Rectangle();
            region.x = Std.parseFloat(charElement.get("x")) / scale + frameX;
            region.y = Std.parseFloat(charElement.get("y")) / scale + frameY;
            region.width  = Std.parseFloat(charElement.get("width")) / scale;
            region.height = Std.parseFloat(charElement.get("height")) / scale;
            
            var texture:Texture = Texture.fromTexture(mTexture, region);
            var bitmapChar:BitmapChar = new BitmapChar(id, texture, xOffset, yOffset, xAdvance); 
            addChar(id, bitmapChar);
        }
        var kernings:Xml = fontXml.elementsNamed("kernings").next();
        for(kerningElement in kernings.elementsNamed("kerning"))
        {
            var first:Int = Std.parseInt(kerningElement.get("first"));
            var second:Int = Std.parseInt(kerningElement.get("second"));
            var amount:Float = Std.parseFloat(kerningElement.get("amount")) / scale;
            if (mChars.exists(second)) getChar(second).addKerning(first, amount);
        }
    }
    
    /** Returns a single bitmap char with a certain character ID. */
    public function getChar(charID:Int):BitmapChar
    {
        return mChars[charID];   
    }
    
    /** Adds a bitmap char with a certain character ID. */
    public function addChar(charID:Int, bitmapChar:BitmapChar):Void
    {
        mChars[charID] = bitmapChar;
    }
    
    /** Creates a sprite that contains a certain text, made up by one image per char. */
    public function createSprite(width:Float, height:Float, text:String,
                                 fontSize:Float=-1, color:UInt=0xffffff, 
                                 hAlign:String="center", vAlign:String="center",      
                                 autoScale:Bool=true, 
                                 kerning:Bool=true):Sprite
    {
        var charLocations:Array<CharLocation> = arrangeChars(width, height, text, fontSize, 
                                                               hAlign, vAlign, autoScale, kerning);
        var numChars:Int = charLocations.length;
        var sprite:Sprite = new Sprite();
        
        //for (var i:Int=0; i<numChars; ++i)
        for (i in 0 ... numChars)
        {
            var charLocation:CharLocation = charLocations[i];
            var char:Image = charLocation.char.createImage();
            char.x = charLocation.x;
            char.y = charLocation.y;
            char.scaleX = char.scaleY = charLocation.scale;
            char.color = color;
            sprite.addChild(char);
        }
        
        return sprite;
    }
    
    /** Draws text into a QuadBatch. */
    public function fillQuadBatch(textField:TextField, width:Float, height:Float, text:String,
                                  fontSize:Float=-1, color:UInt=0xffffff, 
                                  hAlign:String="center", vAlign:String="center",      
                                  autoScale:Bool=true, 
                                  kerning:Bool=true):Void
    {
        var charLocations:Array<CharLocation> = arrangeChars(width, height, text, fontSize, 
                                                               hAlign, vAlign, autoScale, kerning);
        var numChars:Int = charLocations.length;
        if (numChars == 0)
            return;
        if (mHelperImage == null)
            mHelperImage = new Image(charLocations[0].char.texture);
        mHelperImage.color = color;
        
        if (numChars > 8192)
            throw new ArgumentError("Bitmap Font text is limited to 8192 characters.");
        
        var textureIndexMap:Map<Texture, Int> = new Map();
        var nextTextureIndex:Int = 0;

        for (i in 0 ... numChars)
        {
            var charLocation:CharLocation = charLocations[i];
            mHelperImage.texture = charLocation.char.texture;
            mHelperImage.readjustSize();
            mHelperImage.x = charLocation.x;
            mHelperImage.y = charLocation.y;
            mHelperImage.scaleX = mHelperImage.scaleY = charLocation.scale;
            
            var idx:Null<Int> = textureIndexMap[mHelperImage.texture.root];
            if (idx == null)
                idx = textureIndexMap[mHelperImage.texture.root] = nextTextureIndex++;
            var quadBatch:QuadBatch = textField.getQuadBatch(idx);
            quadBatch.addImage(mHelperImage);
        }
    }
    
    /** Arranges the characters of a text inside a rectangle, adhering to the given settings. 
     *  Returns a Vector of CharLocations. */
    private function arrangeChars(width:Float, height:Float, text:String, fontSize:Float=-1,
                                  hAlign:String="center", vAlign:String="center",
                                  autoScale:Bool=true, kerning:Bool=true):Array<CharLocation>
    {
        if (text == null || text.length == 0) return new Array<CharLocation>();
        if (fontSize < 0) fontSize *= -mSize;
        
        var lines:Array<Array<CharLocation>> = [];
        var finished:Bool = false;
        var charLocation:CharLocation;
        var numChars:Int;
        var containerWidth:Float = 0.0;
        var containerHeight:Float = 0.0;
        var scale:Float = 0.0;

        var currentX:Float = 0;
        var currentY:Float = 0;
        while (!finished)
        {
            lines = [];
            scale = fontSize / mSize;
            containerWidth  = width / scale;
            containerHeight = height / scale;
            
            if (mLineHeight <= containerHeight)
            {
                var lastWhiteSpace:Int = -1;
                var lastCharID:Int = -1;
                var currentLine:Array<CharLocation> = new Array<CharLocation>();
                
                numChars = text.length;
                var i:Int = 0;
                while(i < numChars)
                {
                    var lineFull:Bool = false;
                    var charID:Int = text.charCodeAt(i);
                    var char:BitmapChar = getChar(charID);
                    
                    if (charID == CHAR_NEWLINE || charID == CHAR_CARRIAGE_RETURN)
                    {
                        lineFull = true;
                    }
                    else if (char == null)
                    {
                        trace("[Starling] Missing character: " + charID);
                    }
                    else
                    {
                        if (charID == CHAR_SPACE || charID == CHAR_TAB)
                            lastWhiteSpace = i;
                        
                        if (kerning)
                            currentX += char.getKerning(lastCharID);
                        
                        charLocation = mCharLocationPool.length != 0 ?
                            mCharLocationPool.pop() : new CharLocation(char);
                        
                        charLocation.char = char;
                        charLocation.x = currentX + char.xOffset;
                        charLocation.y = currentY + char.yOffset;
                        currentLine.push(charLocation);
                        
                        currentX += char.xAdvance;
                        lastCharID = charID;
                        
                        if (((mLeftPadding + mRightPadding) / scale) + charLocation.x + char.width > containerWidth)
                        {
                            // when autoscaling, we must not split a word in half -> restart
                            if (autoScale && lastWhiteSpace == -1)
                                break;

                            // remove characters and add them again to next line
                            var numCharsToRemove:Int = lastWhiteSpace == -1 ? 1 : i - lastWhiteSpace;
                            var removeIndex:Int = currentLine.length - numCharsToRemove;
                            
                            currentLine.splice(removeIndex, numCharsToRemove);
                            
                            if (currentLine.length == 0)
                                break;
                            
                            i -= numCharsToRemove;
                            lineFull = true;
                        }
                    }
                    
                    if (i == numChars - 1)
                    {
                        lines.push(currentLine);
                        finished = true;
                    }
                    else if (lineFull)
                    {
                        lines.push(currentLine);
                        
                        if (lastWhiteSpace == i)
                            currentLine.pop();
                        
                        if (currentY + 2*mLineHeight <= containerHeight)
                        {
                            currentLine = new Array<CharLocation>();
                            currentX = 0;
                            currentY += mLineHeight;
                            lastWhiteSpace = -1;
                            lastCharID = -1;
                        }
                        else
                        {
                            break;
                        }
                    }
                ++i;
                } // for each char
            } // if (mLineHeight <= containerHeight)
            
            if (autoScale && !finished && fontSize > 3)
                fontSize -= 1;
            else
                finished = true; 
        } // while (!finished)
        
        var finalLocations:Array<CharLocation> = new Array<CharLocation>();
        var numLines:Int = lines.length;
        var bottom:Float = currentY + mLineHeight;
        var yOffset:Int = 0;
        
        if (vAlign == VAlign.BOTTOM)      yOffset =  Std.int(containerHeight - bottom);
        else if (vAlign == VAlign.CENTER) yOffset = Std.int((containerHeight - bottom) / 2);
        
        for (lineID in 0 ... numLines)
        {
            var line:Array<CharLocation> = lines[lineID];
            numChars = line.length;
            
            if (numChars == 0) continue;
            
            var xOffset:Int = 0;
            var lastLocation:CharLocation = line[line.length-1];
            var right:Float = lastLocation.x - lastLocation.char.xOffset 
                                              + lastLocation.char.xAdvance;
            
            if (hAlign == HAlign.RIGHT)       xOffset =  Std.int(containerWidth - right - mRightPadding);
            else if (hAlign == HAlign.CENTER) xOffset = Std.int((containerWidth - right) / 2);
            
            if (xOffset < (mLeftPadding / scale)) xOffset = Std.int(mLeftPadding / scale);
            
            for (c in 0 ... numChars)
            {
                charLocation = line[c];
                charLocation.x = scale * (charLocation.x + xOffset + mOffsetX);
                charLocation.y = scale * (charLocation.y + yOffset + mOffsetY);
                charLocation.scale = scale;
                
                if (charLocation.char.width > 0 && charLocation.char.height > 0)
                    finalLocations.push(charLocation);
                
                // return to pool for next call to "arrangeChars"
                mCharLocationPool.push(charLocation);
            }
        }
        
        return finalLocations;
    }
    
    /** The name of the font as it was parsed from the font file. */
    public var name(get, never):String;
    private function get_name():String { return mName; }
    
    /** The native size of the font. */
    public var size(get, never):Float;
    private function get_size():Float { return mSize; }
    
    /** The height of one line in points. */
    public var lineHeight(get, never):Float;
    private function get_lineHeight():Float { return mLineHeight; }
    private function set_lineHeight(value:Float):Void { mLineHeight = value; }
    
    /** The smoothing filter that is used for the texture. */ 
    public var smoothing(get, set):String;
    private function get_smoothing():String { return mHelperImage.smoothing; }
    private function set_smoothing(value:String):String { return mHelperImage.smoothing = value; } 
    
    /** The baseline of the font. This property does not affect text rendering;
     *  it's just an information that may be useful for exact text placement. */
    public var baseline(get, set):Float;
    private function get_baseline():Float { return mBaseline; }
    private function set_baseline(value:Float):Float { return mBaseline = value; }
    
    /** An offset that moves any generated text along the x-axis (in points).
     *  Useful to make up for incorrect font data. @default 0. */ 
    public var offsetX(get, set):Float;
    private function get_offsetX():Float { return mOffsetX; }
    private function set_offsetX(value:Float):Float { return mOffsetX = value; }
    
    /** An offset that moves any generated text along the y-axis (in points).
     *  Useful to make up for incorrect font data. @default 0. */
    public var offsetY(get, set):Float;
    private function get_offsetY():Float { return mOffsetY; }
    private function set_offsetY(value:Float):Float { return mOffsetY = value; }
}

class CharLocation
{
public var char:BitmapChar;
public var scale:Float;
public var x:Float;
public var y:Float;

public function new(char:BitmapChar)
{
    this.char = char;
}
}
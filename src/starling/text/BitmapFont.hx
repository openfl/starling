// =================================================================================================
//
//	Starling Framework
//	Copyright Gamua GmbH. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

package starling.text;

import openfl.errors.ArgumentError;
import openfl.geom.Rectangle;

import openfl.Vector;

import starling.display.Image;
import starling.display.MeshBatch;
import starling.display.Sprite;
import starling.styles.DistanceFieldStyle;
import starling.styles.MeshStyle;
import starling.textures.Texture;
import starling.textures.TextureSmoothing;
import starling.utils.Align;
import starling.utils.StringUtil;
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
class BitmapFont implements ITextCompositor
{
    /** Use this constant for the <code>fontSize</code> property of the TextField class to 
     * render the bitmap font in exactly the size it was created. */ 
    public static inline var NATIVE_SIZE:Int = -1;
    
    /** The font name of the embedded minimal bitmap font. Use this e.g. for debug output. */
    public static inline var MINI:String = "mini";
    
    private static inline var CHAR_MISSING:Int         =  0;
    private static inline var CHAR_TAB:Int             =  9;
    private static inline var CHAR_NEWLINE:Int         = 10;
    private static inline var CHAR_CARRIAGE_RETURN:Int = 13;
    private static inline var CHAR_SPACE:Int           = 32;
    
    @:noCompletion private var __texture:Texture;
    @:noCompletion private var __chars:Map<Int, BitmapChar>;
    @:noCompletion private var __name:String;
    @:noCompletion private var __size:Float;
    @:noCompletion private var __lineHeight:Float;
    @:noCompletion private var __baseline:Float;
    @:noCompletion private var __offsetX:Float;
    @:noCompletion private var __offsetY:Float;
    @:noCompletion private var __padding:Float;
    @:noCompletion private var __helperImage:Image;
    @:noCompletion private var __type:String;
    @:noCompletion private var __distanceFieldSpread:Float;

    // helper objects
    private static var sLines:Array<Vector<BitmapCharLocation>> = [];
    private static var sDefaultOptions:TextOptions = new TextOptions();
    
    #if commonjs
    private static function __init__ () {
        
        untyped Object.defineProperties (BitmapFont.prototype, {
            "name": { get: untyped __js__ ("function () { return this.get_name (); }") },
            "size": { get: untyped __js__ ("function () { return this.get_size (); }") },
            "lineHeight": { get: untyped __js__ ("function () { return this.get_lineHeight (); }") },
            "smoothing": { get: untyped __js__ ("function () { return this.get_smoothing (); }"), set: untyped __js__ ("function (v) { return this.set_smoothing (v); }") },
            "baseline": { get: untyped __js__ ("function () { return this.get_baseline (); }"), set: untyped __js__ ("function (v) { return this.set_baseline (v); }") },
            "offsetX": { get: untyped __js__ ("function () { return this.get_offsetX (); }"), set: untyped __js__ ("function (v) { return this.set_offsetX (v); }") },
            "offsetY": { get: untyped __js__ ("function () { return this.get_offsetY (); }"), set: untyped __js__ ("function (v) { return this.set_offsetY (v); }") },
            "padding": { get: untyped __js__ ("function () { return this.get_padding (); }"), set: untyped __js__ ("function (v) { return this.set_padding (v); }") },
            "type": { get: untyped __js__ ("function () { return this.get_type (); }"), set: untyped __js__ ("function (v) { return this.set_type (v); }") },
            "distanceFieldSpread": { get: untyped __js__ ("function () { return this.get_distanceFieldSpread (); }"), set: untyped __js__ ("function (v) { return this.set_distanceFieldSpread (v); }") },
        });
        
    }
    #end
    
    /** Creates a bitmap font from the given texture and font data.
     *  If you don't pass any data, the "mini" font will be created.
     *
     * @param texture  The texture containing all the glyphs.
     * @param fontData Typically an XML file in the standard AngelCode format. Override the
     *                 the 'parseFontData' method to add support for additional formats.
     */
    public function new(texture:Texture=null, fontData:Dynamic=null)
    {
        // if no texture is passed in, we create the minimal, embedded font
        if (texture == null && fontData == null)
        {
            texture = MiniBitmapFont.texture;
            fontData = MiniBitmapFont.xml;
        }
        else if (texture != null && fontData == null)
        {
            throw new ArgumentError("Set both of the 'texture' and 'fontData' arguments to valid objects or leave both of them null.");
        }
        
        __name = "unknown";
        __lineHeight = __size = __baseline = 14;
        __offsetX = __offsetY = __padding = 0.0;
        __texture = texture;
        __chars = new Map<Int, BitmapChar>();
        __helperImage = new Image(texture);
        __type = BitmapFontType.STANDARD;
        __distanceFieldSpread = 0.0;
        
        addChar(CHAR_MISSING, new BitmapChar(CHAR_MISSING, null, 0, 0, 0));
        parseFontData(fontData);
    }
    
    /** Disposes the texture of the bitmap font! */
    public function dispose():Void
    {
        if (__texture != null)
            __texture.dispose();
    }
    
    /** Parses the data that's passed as second argument to the constructor.
     *  Override this method to support different file formats. */
    private function parseFontData(data:Dynamic):Void
    {
        try
        {
            var fontXml:Xml = null;
            if(#if (haxe_ver < 4.2) Std.is #else Std.isOfType #end(data, String))
                fontXml = Xml.parse(data).firstElement();
            else if(#if (haxe_ver < 4.2) Std.is #else Std.isOfType #end(data, Xml))
                fontXml = cast data;
                
            parseFontXml(fontXml);
        }
        catch (error:Dynamic)
        {
            throw new ArgumentError("BitmapFont only supports XML data");
        }	
    }
    
    private function parseFontXml(fontXml:Xml):Void
    {
        var scale:Float = __texture.scale;
        var frame:Rectangle = __texture.frame;
        var frameX:Float = frame != null ? frame.x : 0;
        var frameY:Float = frame != null ? frame.y : 0;

        var info:Xml = null;
        var infoIterator:Iterator<Xml> = fontXml.elementsNamed("info");
        if (infoIterator.hasNext())
        {
            info = infoIterator.next();
        }
        if (info == null)
        {
            fontXml = fontXml.firstElement();
            infoIterator = fontXml.elementsNamed("info");
            if (infoIterator.hasNext())
            {
                info = infoIterator.next();
            }
        }

        var common:Xml = null;
        var commonIterator:Iterator<Xml> = fontXml.elementsNamed("common");
        if (commonIterator.hasNext())
        {
            common = commonIterator.next();
        }
        __name = info != null ? info.get("face") : "";
        __size = info != null ? Std.parseFloat(info.get("size")) / scale : Math.NaN;
        __lineHeight = common != null ? Std.parseFloat(common.get("lineHeight")) / scale : Math.NaN;
        __baseline = common != null ? Std.parseFloat(common.get("base")) / scale : Math.NaN;
        
        if (info != null && info.get("smooth") == "0")
        {
            smoothing = TextureSmoothing.NONE;
        }
        
        if (__size <= 0)
        {
            trace("[Starling] Warning: invalid font size in '" + __name + "' font.");
            __size = (__size == 0.0 ? 16.0 : __size * -1.0);
        }
        
        var distanceField:Xml = null;
        var distanceFieldIterator:Iterator<Xml> = fontXml.elementsNamed("distanceField");
        if (distanceFieldIterator.hasNext())
        {
            distanceField = distanceFieldIterator.next();
        }
        if (distanceField != null && distanceField.exists("distanceRange") && distanceField.exists("fieldType"))
        {
            __distanceFieldSpread = Std.parseFloat(distanceField.get("distanceRange"));
            __type = distanceField.get("fieldType") == "msdf" ?
                BitmapFontType.MULTI_CHANNEL_DISTANCE_FIELD : BitmapFontType.DISTANCE_FIELD;
        }
        else
        {
            __distanceFieldSpread = 0.0;
            __type = BitmapFontType.STANDARD;
        }
        
        var chars:Xml = null;
        var charsIterator:Iterator<Xml> = fontXml.elementsNamed("chars");
        if (charsIterator.hasNext())
        {
            chars = charsIterator.next();
        }
        if (chars != null)
        {
            for (charElement in chars.elementsNamed("char"))
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
                
                var texture:Texture = Texture.fromTexture(__texture, region);
                var bitmapChar:BitmapChar = new BitmapChar(id, texture, xOffset, yOffset, xAdvance); 
                addChar(id, bitmapChar);
            }
        }
        
        var kernings:Xml = null;
        var kerningsIterator:Iterator<Xml> = fontXml.elementsNamed("kernings");
        if (kerningsIterator.hasNext())
        {
            kernings = kerningsIterator.next();
        }
        if (kernings != null)
        {
            for (kerningElement in kernings.elementsNamed("kerning"))
            {
                var first:Int = Std.parseInt(kerningElement.get("first"));
                var second:Int = Std.parseInt(kerningElement.get("second"));
                var amount:Float = Std.parseFloat(kerningElement.get("amount")) / scale;
                if (__chars.exists(second)) getChar(second).addKerning(first, amount);
            }
        }
    }
    
    /** Returns a single bitmap char with a certain character ID. */
    public function getChar(charID:Int):BitmapChar
    {
        return __chars[charID];
    }
    
    /** Adds a bitmap char with a certain character ID. */
    public function addChar(charID:Int, bitmapChar:BitmapChar):Void
    {
        __chars[charID] = bitmapChar;
    }
    
    /** Returns a vector containing all the character IDs that are contained in this font. */
    public function getCharIDs(result:Vector<Int>=null):Vector<Int>
    {
        if (result == null) result = new Vector<Int>();

        for (key in __chars.keys())
            result[result.length] = key;

        return result;
    }

    /** Checks whether a provided string can be displayed with the font. */
    public function hasChars(text:String):Bool
    {
        if (text == null) return true;

        var charID:Int;
        var numChars:Int = text.length;

        for (i in 0...numChars)
        {
            charID = text.charCodeAt(i);

            if (charID != CHAR_SPACE && charID != CHAR_TAB && charID != CHAR_NEWLINE &&
                charID != CHAR_CARRIAGE_RETURN && getChar(charID) == null)
            {
                return false;
            }
        }

        return true;
    }

    /** Creates a sprite that contains a certain text, made up by one image per char. */
    public function createSprite(width:Float, height:Float, text:String,
                                 format:TextFormat, options:TextOptions=null):Sprite
    {
        var charLocations:Vector<BitmapCharLocation> = arrangeChars(width, height, text, format, options);
        var numChars:Int = charLocations.length;
        var sprite:Sprite = new Sprite();
        
        for (i in 0...numChars)
        {
            var charLocation:BitmapCharLocation = charLocations[i];
            var char:Image = charLocation.char.createImage();
            char.x = charLocation.x;
            char.y = charLocation.y;
            char.scale = charLocation.scale;
            char.color = format.color;
            char.textureSmoothing = smoothing;
            sprite.addChild(char);
        }
        
        BitmapCharLocation.rechargePool();
        return sprite;
    }
    
    /** Draws text into a QuadBatch. */
    public function fillMeshBatch(meshBatch:MeshBatch, width:Float, height:Float, text:String,
                                  format:TextFormat, options:TextOptions=null):Void
    {
        var charLocations:Vector<BitmapCharLocation> = arrangeChars(
                width, height, text, format, options);
        var numChars:Int = charLocations.length;
        __helperImage.color = format.color;
        
        for (i in 0...numChars)
        {
            var charLocation:BitmapCharLocation = charLocations[i];
            __helperImage.texture = charLocation.char.texture;
            __helperImage.readjustSize();
            __helperImage.x = charLocation.x;
            __helperImage.y = charLocation.y;
            __helperImage.scale = charLocation.scale;
            meshBatch.addMeshAt(__helperImage);
        }

        BitmapCharLocation.rechargePool();
    }

    /** @inheritDoc */
    public function clearMeshBatch(meshBatch:MeshBatch):Void
    {
        meshBatch.clear();
    }
    
    
    /** @inheritDoc */
    public function getDefaultMeshStyle(previousStyle:MeshStyle,
                                        format:TextFormat, options:TextOptions):MeshStyle
    {
        if (__type == BitmapFontType.STANDARD) return null;
        else // -> distance field font
        {
            var dfStyle:DistanceFieldStyle;
            var fontSize:Float = format.size < 0 ? format.size * -__size : format.size;
            dfStyle = #if (haxe_ver < 4.2) Std.is #else Std.isOfType #end(previousStyle, DistanceFieldStyle) ? cast previousStyle : new DistanceFieldStyle();
            dfStyle.multiChannel = (__type == BitmapFontType.MULTI_CHANNEL_DISTANCE_FIELD);
            dfStyle.softness = __size / (fontSize * __distanceFieldSpread);
            return dfStyle;
        }
    }
    
    
    /** Arranges the characters of text inside a rectangle, adhering to the given settings.
     *  Returns a Vector of BitmapCharLocations.
     *
     *  <p>BEWARE: This method uses an object pool for the returned vector and all
     *  (returned and temporary) BitmapCharLocation instances. Do not save any references and
     *  always call <code>BitmapCharLocation.rechargePool()</code> when you are done processing.
     *  </p>
     */
    public function arrangeChars(width:Float, height:Float, text:String,
                                  format:TextFormat, options:TextOptions):Vector<BitmapCharLocation>
    {
        if (text == null || text.length == 0) return BitmapCharLocation.vectorFromPool();
        if (options == null) options = sDefaultOptions;

        var kerning:Bool = format.kerning;
        var leading:Float = format.leading;
        var spacing:Float = format.letterSpacing;
        var hAlign:String = format.horizontalAlign;
        var vAlign:String = format.verticalAlign;
        var fontSize:Float = format.size;
        var autoScale:Bool = options.autoScale;
        var wordWrap:Bool = options.wordWrap;

        var finished:Bool = false;
        var charLocation:BitmapCharLocation;
        var numChars:Int;
        var containerWidth:Float = 0;
        var containerHeight:Float = 0;
        var scale:Float = 0;
        var i:Int, j:Int;

        if (fontSize < 0) fontSize *= -__size;
        
        var currentY:Float = 0;
        
        while (!finished)
        {
            sLines.splice(0, sLines.length);
            scale = fontSize / __size;
            containerWidth  = (width  - 2 * __padding) / scale;
            containerHeight = (height - 2 * __padding) / scale;
            
            if (__size <= containerHeight)
            {
                var lastWhiteSpace:Int = -1;
                var lastCharID:Int = -1;
                var currentLine:Vector<BitmapCharLocation> = BitmapCharLocation.vectorFromPool();
                var currentX:Float = 0;
                currentY = 0;
                
                numChars = text.length;
                var i:Int = 0;
                while (i < numChars)
                {
                    var lineFull:Bool = false;
                    var charID:Int = text.charCodeAt(i);
                    var char:BitmapChar = getChar(charID);
                    
                    if (charID == CHAR_NEWLINE || charID == CHAR_CARRIAGE_RETURN)
                    {
                        lineFull = true;
                    }
                    else
                    {
                        if (char == null)
                        {
                            trace(StringUtil.format(
                                "[Starling] Character '{0}' (id: {1}) not found in '{2}'",
                                [text.charAt(i), charID, name]));

                            charID = CHAR_MISSING;
                            char = getChar(CHAR_MISSING);
                        }

                        if (charID == CHAR_SPACE || charID == CHAR_TAB)
                            lastWhiteSpace = i;
                        
                        if (kerning)
                            currentX += char.getKerning(lastCharID);
                        
                        charLocation = BitmapCharLocation.instanceFromPool(char);
                        charLocation.index = i;
                        charLocation.x = currentX + char.xOffset;
                        charLocation.y = currentY + char.yOffset;
                        currentLine[currentLine.length] = charLocation; // push
                        
                        currentX += char.xAdvance + spacing;
                        lastCharID = charID;
                        
                        if (charLocation.x + char.width > containerWidth)
                        {
                            if (wordWrap)
                            {
                                // when autoscaling, we must not split a word in half -> restart
                                if (autoScale && lastWhiteSpace == -1)
                                    break;

                                // remove characters and add them again to next line
                                var numCharsToRemove:Int = lastWhiteSpace == -1 ? 1 : i - lastWhiteSpace;

                                for (j in 0...numCharsToRemove) // faster than 'splice'
                                    currentLine.pop();

                                if (currentLine.length == 0)
                                    break;

                                i -= numCharsToRemove;
                            }
                            else
                            {
                                if (autoScale) break;
                                currentLine.pop();

                                // continue with next line, if there is one
                                while (i < numChars - 1 && text.charCodeAt(i) != CHAR_NEWLINE)
                                    ++i;
                            }

                            lineFull = true;
                        }
                    }
                    
                    if (i == numChars - 1)
                    {
                        sLines[sLines.length] = currentLine; // push
                        finished = true;
                    }
                    else if (lineFull)
                    {
                        sLines[sLines.length] = currentLine; // push
                        
                        if (lastWhiteSpace == i)
                            currentLine.pop();
                        
                        if (currentY + __lineHeight + leading + __size <= containerHeight)
                        {
                            currentLine = BitmapCharLocation.vectorFromPool();
                            currentX = 0;
                            currentY += __lineHeight + leading;
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
            } // if (__lineHeight <= containerHeight)
            
            if (autoScale && !finished && fontSize > 3)
                fontSize -= 1;
            else
                finished = true; 
        } // while (!finished)
        
        var finalLocations:Vector<BitmapCharLocation> = BitmapCharLocation.vectorFromPool();
        var numLines:Int = sLines.length;
        var bottom:Float = currentY + __lineHeight;
        var yOffset:Int = 0;
        
        if (vAlign == Align.BOTTOM)      yOffset = Std.int(containerHeight - bottom);
        else if (vAlign == Align.CENTER) yOffset = Std.int((containerHeight - bottom) / 2);
        
        for (lineID in 0...numLines)
        {
            var line:Vector<BitmapCharLocation> = sLines[lineID];
            numChars = line.length;
            
            if (numChars == 0) continue;
            
            var xOffset:Int = 0;
            var lastLocation:BitmapCharLocation = line[line.length-1];
            var right:Float = lastLocation.x - lastLocation.char.xOffset 
                                              + lastLocation.char.xAdvance;
            
            if (hAlign == Align.RIGHT)       xOffset = Std.int(containerWidth - right);
            else if (hAlign == Align.CENTER) xOffset = Std.int((containerWidth - right) / 2);
            
            for (c in 0...numChars)
            {
                charLocation = line[c];
                charLocation.x = scale * (charLocation.x + xOffset + __padding);
                charLocation.y = scale * (charLocation.y + yOffset + __padding);
                charLocation.scale = scale;
                
                if (charLocation.char.width > 0 && charLocation.char.height > 0)
                    finalLocations[finalLocations.length] = charLocation;
            }
        }
        
        return finalLocations;
    }
    
    /** The name of the font as it was parsed from the font file. */
    public var name(get, never):String;
    private function get_name():String { return __name; }
    
    /** The native size of the font. */
    public var size(get, never):Float;
    private function get_size():Float { return __size; }
        
    /** The type of the bitmap font. @see starling.text.BitmapFontType @default standard */
    public var type(get, set):String;
    public function get_type():String { return __type; }
    public function set_type(value:String):String { return __type = value; }

    /** If the font uses a distance field texture, this property returns its spread (i.e.
     *  the width of the blurred edge in points). */
    public var distanceFieldSpread(get, set):Float;
    public function get_distanceFieldSpread():Float { return __distanceFieldSpread; }
    public function set_distanceFieldSpread(value:Float):Float { return __distanceFieldSpread = value; }
    
    /** The height of one line in points. */
    public var lineHeight(get, never):Float;
    private function get_lineHeight():Float { return __lineHeight; }
    private function set_lineHeight(value:Float):Void { __lineHeight = value; }
    
    /** The smoothing filter that is used for the texture. */ 
    public var smoothing(get, set):String;
    private function get_smoothing():String { return __helperImage.textureSmoothing; }
    private function set_smoothing(value:String):String { return __helperImage.textureSmoothing = value; } 
    
    /** The baseline of the font. This property does not affect text rendering;
     * it's just an information that may be useful for exact text placement. */
    public var baseline(get, set):Float;
    private function get_baseline():Float { return __baseline; }
    private function set_baseline(value:Float):Float { return __baseline = value; }
    
    /** An offset that moves any generated text along the x-axis (in points).
     * Useful to make up for incorrect font data. @default 0. */ 
    public var offsetX(get, set):Float;
    private function get_offsetX():Float { return __offsetX; }
    private function set_offsetX(value:Float):Float { return __offsetX = value; }
    
    /** An offset that moves any generated text along the y-axis (in points).
     * Useful to make up for incorrect font data. @default 0. */
    public var offsetY(get, set):Float;
    private function get_offsetY():Float { return __offsetY; }
    private function set_offsetY(value:Float):Float { return __offsetY = value; }

    /** The width of a "gutter" around the composed text area, in points.
     *  This can be used to bring the output more in line with standard TrueType rendering:
     *  Flash always draws them with 2 pixels of padding. @default 0.0 */
    public var padding(get, set):Float;
    private function get_padding():Float { return __padding; }
    private function set_padding(value:Float):Float { return __padding = value; }

    /** The underlying texture that contains all the chars. */
    private function get_texture():Texture { return __texture; }
}
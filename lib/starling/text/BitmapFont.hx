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

@:jsRequire("starling/text/BitmapFont", "default")

extern class BitmapFont implements ITextCompositor
{
    /** Use this constant for the <code>fontSize</code> property of the TextField class to 
     * render the bitmap font in exactly the size it was created. */ 
    public static var NATIVE_SIZE:Int;
    
    /** The font name of the embedded minimal bitmap font. Use this e.g. for debug output. */
    public static var MINI:String;
    
    /** Creates a bitmap font from the given texture and font data.
     *  If you don't pass any data, the "mini" font will be created.
     *
     * @param texture  The texture containing all the glyphs.
     * @param fontData Typically an XML file in the standard AngelCode format. Override the
     *                 the 'parseFontData' method to add support for additional formats.
     */
    public function new(texture:Texture=null, fontData:Dynamic=null);
    
    /** Disposes the texture of the bitmap font! */
    public function dispose():Void;
    
    /** Returns a single bitmap char with a certain character ID. */
    public function getChar(charID:Int):BitmapChar;
    
    /** Adds a bitmap char with a certain character ID. */
    public function addChar(charID:Int, bitmapChar:BitmapChar):Void;
    
    /** Returns a vector containing all the character IDs that are contained in this font. */
    public function getCharIDs(result:Vector<Int>=null):Vector<Int>;

    /** Checks whether a provided string can be displayed with the font. */
    public function hasChars(text:String):Bool;

    /** Creates a sprite that contains a certain text, made up by one image per char. */
    public function createSprite(width:Float, height:Float, text:String,
                                 format:TextFormat, options:TextOptions=null):Sprite;
    
    /** Draws text into a QuadBatch. */
    public function fillMeshBatch(meshBatch:MeshBatch, width:Float, height:Float, text:String,
                                  format:TextFormat, options:TextOptions=null):Void;

    /** @inheritDoc */
    public function clearMeshBatch(meshBatch:MeshBatch):Void;
    
    /** @inheritDoc */
    public function getDefaultMeshStyle(previousStyle:MeshStyle,
                                        format:TextFormat, options:TextOptions):MeshStyle;
    
    /** Arranges the characters of text inside a rectangle, adhering to the given settings.
     *  Returns a Vector of BitmapCharLocations.
     *
     *  <p>BEWARE: This method uses an object pool for the returned vector and all
     *  (returned and temporary) BitmapCharLocation instances. Do not save any references and
     *  always call <code>BitmapCharLocation.rechargePool()</code> when you are done processing.
     *  </p>
     */
    public function arrangeChars(width:Float, height:Float, text:String,
                                  format:TextFormat, options:TextOptions):Vector<BitmapCharLocation>;
    
    /** The name of the font as it was parsed from the font file. */
    public var name(get, never):String;
    private function get_name():String;
    
    /** The native size of the font. */
    public var size(get, never):Float;
    private function get_size():Float;
        
    /** The type of the bitmap font. @see starling.text.BitmapFontType @default standard */
    public var type(get, set):String;
    public function get_type():String;
    public function set_type(value:String):String;

    /** If the font uses a distance field texture, this property returns its spread (i.e.
     *  the width of the blurred edge in points). */
    public var distanceFieldSpread(get, set):Float;
    public function get_distanceFieldSpread():Float;
    public function set_distanceFieldSpread(value:Float):Float;
    
    /** The height of one line in points. */
    public var lineHeight(get, never):Float;
    private function get_lineHeight():Float;
    private function set_lineHeight(value:Float):Void;
    
    /** The smoothing filter that is used for the texture. */ 
    public var smoothing(get, set):String;
    private function get_smoothing():String;
    private function set_smoothing(value:String):String;
    
    /** The baseline of the font. This property does not affect text rendering;
     * it's just an information that may be useful for exact text placement. */
    public var baseline(get, set):Float;
    private function get_baseline():Float;
    private function set_baseline(value:Float):Float;
    
    /** An offset that moves any generated text along the x-axis (in points).
     * Useful to make up for incorrect font data. @default 0. */ 
    public var offsetX(get, set):Float;
    private function get_offsetX():Float;
    private function set_offsetX(value:Float):Float;
    
    /** An offset that moves any generated text along the y-axis (in points).
     * Useful to make up for incorrect font data. @default 0. */
    public var offsetY(get, set):Float;
    private function get_offsetY():Float;
    private function set_offsetY(value:Float):Float;

    /** The width of a "gutter" around the composed text area, in points.
     *  This can be used to bring the output more in line with standard TrueType rendering:
     *  Flash always draws them with 2 pixels of padding. @default 0.0 */
    public var padding(get, set):Float;
    private function get_padding():Float;
    private function set_padding(value:Float):Float;

    /** The underlying texture that contains all the chars. */
    private function get_texture():Texture;
}
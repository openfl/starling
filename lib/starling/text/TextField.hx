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

import openfl.display3D.Context3DTextureFormat;
import openfl.errors.ArgumentError;
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.geom.Rectangle;
#if flash
import flash.text.StyleSheet;
#end
import openfl.utils.Dictionary;

import starling.core.Starling;
import starling.display.DisplayObject;
import starling.display.DisplayObjectContainer;
import starling.display.MeshBatch;
import starling.display.Quad;
import starling.display.Sprite;
import starling.events.Event;
import starling.rendering.Painter;
import starling.styles.MeshStyle;
import starling.utils.RectangleUtil;
import starling.utils.SystemUtil;

/** A TextField displays text, using either standard true type fonts, custom bitmap fonts,
 *  or a custom text representation.
 *  
 *  <p>Access the <code>format</code> property to modify the appearance of the text, like the
 *  font name and size, a color, the horizontal and vertical alignment, etc. The border property
 *  is useful during development, because it lets you see the bounds of the TextField.</p>
 *  
 *  <p>There are several types of fonts that can be displayed:</p>
 *  
 *  <ul>
 *    <li>Standard TrueType fonts. This renders the text just like a conventional Flash
 *        TextField. It is recommended to embed the font, since you cannot be sure which fonts
 *        are available on the client system, and since this enhances rendering quality. 
 *        Simply pass the font name to the corresponding property.</li>
 *    <li>Bitmap fonts. If you need speed or fancy font effects, use a bitmap font instead. 
 *        That is a font that has its glyphs rendered to a texture atlas. To use it, first 
 *        register the font with the method <code>registerBitmapFont</code>, and then pass 
 *        the font name to the corresponding property of the text field.</li>
 *    <li>Custom text compositors. Any class implementing the <code>ITextCompositor</code>
 *        interface can be used to render text. If the two standard options are not sufficient
 *        for your needs, such a compositor might do the trick.</li>
 *  </ul>
 *    
 *  <p>For bitmap fonts, we recommend one of the following tools:</p>
 * 
 *  <ul>
 *    <li>Windows: <a href="http://www.angelcode.com/products/bmfont">Bitmap Font Generator</a>
 *        from Angel Code (free). Export the font data as an XML file and the texture as a png
 *        with white characters on a transparent background (32 bit).</li>
 *    <li>Mac OS: <a href="http://glyphdesigner.71squared.com">Glyph Designer</a> from 
 *        71squared or <a href="http://http://www.bmglyph.com">bmGlyph</a> (both commercial). 
 *        They support Starling natively.</li>
 *    <li>Cross-Platform: <a href="http://kvazars.com/littera/">Littera</a> or
 *        <a href="http://renderhjs.net/shoebox/">ShoeBox</a> are great tools, as well.
 *        Both are free to use and were built with Adobe AIR.</li>
 *  </ul>
 *
 *  <p>When using a bitmap font, the 'color' property is used to tint the font texture. This
 *  works by multiplying the RGB values of that property with those of the texture's pixel.
 *  If your font contains just a single color, export it in plain white and change the 'color'
 *  property to any value you like (it defaults to zero, which means black). If your font
 *  contains multiple colors, change the 'color' property to <code>Color.WHITE</code> to get
 *  the intended result.</p>
 *
 *  <strong>Batching of TextFields</strong>
 *
 *  <p>Normally, TextFields will require exactly one draw call. For TrueType fonts, you cannot
 *  avoid that; bitmap fonts, however, may be batched if you enable the "batchable" property.
 *  This makes sense if you have several TextFields with short texts that are rendered one
 *  after the other (e.g. subsequent children of the same sprite), or if your bitmap font
 *  texture is in your main texture atlas.</p>
 *
 *  <p>The recommendation is to activate "batchable" if it reduces your draw calls (use the
 *  StatsDisplay to check this) AND if the text fields contain no more than about 15-20
 *  characters. For longer texts, the batching would take up more CPU time than what is saved
 *  by avoiding the draw calls.</p>
 */

@:jsRequire("starling/text/TextField", "default")

extern class TextField extends DisplayObjectContainer
{
    /** Create a new text field with the given properties. */
    public function new(width:Int, height:Int, text:String="", format:TextFormat=null);
    
    /** Disposes the underlying texture data. */
    public override function dispose():Void;
    
    /** @inheritDoc */
    public override function render(painter:Painter):Void;

    /** Forces the text to be recomposed before rendering it in the upcoming frame. Any changes
     *  of the TextField itself will automatically trigger recomposition; changes in its
     *  parents or the viewport, however, need to be processed manually. For example, you
     *  might want to force recomposition to fix blurring caused by a scale factor change.
     */
    public function setRequiresRecomposition():Void;

    // properties

    private var isHorizontalAutoSize(get, never):Bool;
    private function get_isHorizontalAutoSize():Bool;

    private var isVerticalAutoSize(get, never):Bool;
    private function get_isVerticalAutoSize():Bool;

    /** Returns the bounds of the text within the text field. */
    public var textBounds(get, never):Rectangle;
    private function get_textBounds():Rectangle;
    
    /** @inheritDoc */
    public override function getBounds(targetSpace:DisplayObject, out:Rectangle=null):Rectangle;
    
    /** Returns the bounds of the text within the text field in the given coordinate space. */
    public function getTextBounds(targetSpace:DisplayObject, out:Rectangle=null):Rectangle;
    
    /** @inheritDoc */
    public override function hitTest(localPoint:Point):DisplayObject;

    /** @inheritDoc */
    private override function set_width(value:Float):Float;
    
    /** @inheritDoc */
    private override function set_height(value:Float):Float;
    
    /** The displayed text. */
    public var text(get, set):String;
    private function get_text():String;
    private function set_text(value:String):String;

    /** The format describes how the text will be rendered, describing the font name and size,
     *  color, alignment, etc.
     *
     *  <p>Note that you can edit the font properties directly; there's no need to reassign
     *  the format for the changes to show up.</p>
     *
     *  <listing>
     *  var textField:TextField = new TextField(100, 30, "Hello Starling");
     *  textField.format.font = "Arial";
     *  textField.format.color = Color.RED;</listing>
     *
     *  @default Verdana, 12 pt, black, centered
     */
    public var format(get, set):TextFormat;
    private function get_format():TextFormat;
    private function set_format(value:TextFormat):TextFormat;

    /** The options that describe how the letters of a text should be assembled.
     *  This class basically collects all the TextField's properties that are needed
     *  during text composition. Since an instance of 'TextOptions' is passed to the
     *  constructor, you can pass custom options to the compositor. */
    private var options(get, never):TextOptions;
    private function get_options():TextOptions;

    /** Draws a border around the edges of the text field. Useful for visual debugging.
     *  @default false */
    public var border(get, set):Bool;
    public function get_border():Bool;
    public function set_border(value:Bool):Bool;
    
    /** Indicates whether the font size is automatically reduced if the complete text does
     *  not fit into the TextField. @default false */
    public var autoScale(get, set):Bool;
    private function get_autoScale():Bool;
    private function set_autoScale(value:Bool):Bool;

    /** Specifies the type of auto-sizing the TextField will do.
     *  Note that any auto-sizing will implicitly deactivate all auto-scaling.
     *  @default none */
    public var autoSize(get, set):String;
    private function get_autoSize():String;
    private function set_autoSize(value:String):String;

    /** Indicates if the text should be wrapped at word boundaries if it does not fit into
     *  the TextField otherwise. @default true */
    public var wordWrap(get, set):Bool;
    private function get_wordWrap():Bool;
    private function set_wordWrap(value:Bool):Bool;

    /** Indicates if TextField should be batched on rendering.
     *
     *  <p>This works only with bitmap fonts, and it makes sense only for TextFields with no
     *  more than 10-15 characters. Otherwise, the CPU costs will exceed any gains you get
     *  from avoiding the additional draw call.</p>
     *
     *  @default false
     */
    public var batchable(get, set):Bool;
    private function get_batchable():Bool;
    private function set_batchable(value:Bool):Bool;

    /** Indicates if text should be interpreted as HTML code. For a description
     *  of the supported HTML subset, refer to the classic Flash 'TextField' documentation.
     *  Clickable hyperlinks and images are not supported. Only works for
     *  TrueType fonts! @default false */
    public var isHtmlText(get, set):Bool;
    private function get_isHtmlText():Bool;
    private function set_isHtmlText(value:Bool):Bool;

    #if flash
    /** An optional style sheet to be used for HTML text. For more information on style
     *  sheets, please refer to the StyleSheet class in the ActionScript 3 API reference.
     *  @default null */
    public var styleSheet(get, set):StyleSheet;
    private function get_styleSheet():StyleSheet;
    private function set_styleSheet(value:StyleSheet):StyleSheet;
    #end

    /** Controls whether or not the instance snaps to the nearest pixel. This can prevent the
     *  object from looking blurry when it's not exactly aligned with the pixels of the screen.
     *  @default true */
    public var pixelSnapping(get, set):Bool;
    private function get_pixelSnapping():Bool;
    private function set_pixelSnapping(value:Bool):Bool;

    /** The mesh style that is used to render the text.
     *  Note that a style instance may only be used on one mesh at a time. */
    public var style(get, set):MeshStyle;
    private function get_style():MeshStyle;
    private function set_style(value:MeshStyle):MeshStyle;

    /** The Context3D texture format that is used for rendering of all TrueType texts.
     *  The default provides a good compromise between quality and memory consumption;
     *  use <pre>Context3DTextureFormat.BGRA</pre> for the highest quality.
     *
     *  @default Context3DTextureFormat.BGRA_PACKED */
    public static var defaultTextureFormat(get, set):String;
    private static function get_defaultTextureFormat():String;
    private static function set_defaultTextureFormat(value:String):String;

    /** The default compositor used to arrange the letters of the text.
     *  If a specific compositor was registered for a font, it takes precedence.
     *
     *  @default TrueTypeCompositor
     */
    public static var defaultCompositor(get, set):ITextCompositor;
    private static function get_defaultCompositor():ITextCompositor;
    private static function set_defaultCompositor(value:ITextCompositor):ITextCompositor;

    /** Updates the list of embedded fonts. Call this method when you loaded a TrueType font
     *  at runtime so that Starling can recognize it as such. */
    public static function updateEmbeddedFonts():Void;

    // compositor registration

    /** Makes a text compositor (like a <code>BitmapFont</code>) available to any TextField in
     *  the current stage3D context. The font is identified by its <code>name</code> (not
     *  case sensitive). */
    public static function registerCompositor(compositor:ITextCompositor, name:String):Void;

    /** Unregisters the text compositor and, optionally, disposes it. */
    public static function unregisterCompositor(name:String, dispose:Bool=true):Void;

    /** Returns a registered text compositor (or null, if the font has not been registered).
     *  The name is not case sensitive. */
    public static function getCompositor(name:String):ITextCompositor;

    /** Makes a bitmap font available at any TextField in the current stage3D context.
     *  The font is identified by its <code>name</code> (not case sensitive).
     *  Per default, the <code>name</code> property of the bitmap font will be used, but you
     *  can pass a custom name, as well. @return the name of the font. */
    @:deprecated("replaced by `registerCompositor`")
    public static function registerBitmapFont(bitmapFont:BitmapFont, name:String=null):String;

    /** Unregisters the bitmap font and, optionally, disposes it. */
    @:deprecated("replaced by `unregisterCompositor`")
    public static function unregisterBitmapFont(name:String, dispose:Bool=true):Void;

    /** Returns a registered bitmap font compositor (or null, if no compositor has been
     *  registered with that name, or if it's not a bitmap font). The name is not case
     *  sensitive. */
    public static function getBitmapFont(name:String):BitmapFont;
}
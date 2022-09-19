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
class TextField extends DisplayObjectContainer
{
    // the name of the "sharedData" container with the registered compositors
    private static inline var COMPOSITOR_DATA_NAME:String = "starling.display.TextField.compositors";

    private var _text:String;
    private var _options:TextOptions;
    private var _format:TextFormat;
    private var _textBounds:Rectangle;
    private var _hitArea:Rectangle;
    private var _compositor:ITextCompositor;
    private var _requiresRecomposition:Bool;
    private var _border:DisplayObjectContainer;
    private var _meshBatch:MeshBatch;
    private var _customStyle:MeshStyle;
    private var _defaultStyle:MeshStyle;
    private var _recomposing:Bool;

    // helper objects
    private static var sMatrix:Matrix = new Matrix();
    private static var sDefaultCompositor:ITextCompositor = new TrueTypeCompositor();
    private static var sDefaultTextureFormat:String = Context3DTextureFormat.BGRA_PACKED;

    #if commonjs
    private static function __init__ () {
        
        untyped Object.defineProperties (TextField.prototype, {
            "isHorizontalAutoSize": { get: untyped __js__ ("function () { return this.get_isHorizontalAutoSize (); }") },
            "isVerticalAutoSize": { get: untyped __js__ ("function () { return this.get_isVerticalAutoSize (); }") },
            "textBounds": { get: untyped __js__ ("function () { return this.get_textBounds (); }") },
            "text": { get: untyped __js__ ("function () { return this.get_text (); }"), set: untyped __js__ ("function (v) { return this.set_text (v); }") },
            "format": { get: untyped __js__ ("function () { return this.get_format (); }"), set: untyped __js__ ("function (v) { return this.set_format (v); }") },
            "options": { get: untyped __js__ ("function () { return this.get_options (); }") },
            "border": { get: untyped __js__ ("function () { return this.get_border (); }"), set: untyped __js__ ("function (v) { return this.set_border (v); }") },
            "autoScale": { get: untyped __js__ ("function () { return this.get_autoScale (); }"), set: untyped __js__ ("function (v) { return this.set_autoScale (v); }") },
            "autoSize": { get: untyped __js__ ("function () { return this.get_autoSize (); }"), set: untyped __js__ ("function (v) { return this.set_autoSize (v); }") },
            "wordWrap": { get: untyped __js__ ("function () { return this.get_wordWrap (); }"), set: untyped __js__ ("function (v) { return this.set_wordWrap (v); }") },
            "batchable": { get: untyped __js__ ("function () { return this.get_batchable (); }"), set: untyped __js__ ("function (v) { return this.set_batchable (v); }") },
            "isHtmlText": { get: untyped __js__ ("function () { return this.get_isHtmlText (); }"), set: untyped __js__ ("function (v) { return this.set_isHtmlText (v); }") },
            "styleSheet": { get: untyped __js__ ("function () { return this.get_styleSheet (); }"), set: untyped __js__ ("function (v) { return this.set_styleSheet (v); }") },
            "pixelSnapping": { get: untyped __js__ ("function () { return this.get_pixelSnapping (); }"), set: untyped __js__ ("function (v) { return this.set_pixelSnapping (v); }") },
            "style": { get: untyped __js__ ("function () { return this.get_style (); }"), set: untyped __js__ ("function (v) { return this.set_style (v); }") },
            "defaultTextureFormat": { get: untyped __js__ ("function () { return this.get_defaultTextureFormat (); }"), set: untyped __js__ ("function (v) { return this.set_defaultTextureFormat (v); }") },
            "defaultCompositor": { get: untyped __js__ ("function () { return this.get_defaultCompositor (); }") },
        });
        
    }
    #end

    /** Create a new text field with the given properties. */
    public function new(width:Int, height:Int, text:String="", format:TextFormat=null, options:TextOptions=null)
    {
        super();

        _text = text != null ? text : "";
        _hitArea = new Rectangle(0, 0, width, height);
        _requiresRecomposition = true;
        _compositor = sDefaultCompositor;

        _format = format != null ? format.clone() : new TextFormat();
        _format.addEventListener(Event.CHANGE, setRequiresRecomposition);

        _options = options != null ? options.clone() : new TextOptions();
        _options.addEventListener(Event.CHANGE, setRequiresRecomposition);

        _meshBatch = new MeshBatch();
        _meshBatch.touchable = false;
        _meshBatch.pixelSnapping = true;
        addChild(_meshBatch);
    }
    
    /** Disposes the underlying texture data. */
    public override function dispose():Void
    {
        _format.removeEventListener(Event.CHANGE, setRequiresRecomposition);
        _options.removeEventListener(Event.CHANGE, setRequiresRecomposition);
        _compositor.clearMeshBatch(_meshBatch);

        super.dispose();
    }
    
    /** @inheritDoc */
    public override function render(painter:Painter):Void
    {
        if (_requiresRecomposition) recompose();
        super.render(painter);
    }

    /** Forces the text contents to be composed right away.
     *  Normally, it will only do so lazily, i.e. before being rendered. */
    private function recompose():Void
    {
        if (_requiresRecomposition)
        {
            _recomposing = true;
            _compositor.clearMeshBatch(_meshBatch);

            var fontName:String = _format.font;
            var compositor:ITextCompositor = getCompositor(fontName);

            if (compositor == null && fontName == BitmapFont.MINI)
            {
                compositor = new BitmapFont();
                registerCompositor(compositor, fontName);
            }

            _compositor = compositor != null ? compositor : sDefaultCompositor;

            updateText();
            updateBorder();

            _requiresRecomposition = false;
            _recomposing = false;
        }
    }

    // font and border rendering
    
    private function updateText():Void
    {
        var width:Float  = _hitArea.width;
        var height:Float = _hitArea.height;

        // Horizontal autoSize does not work for HTML text, since it supports custom alignment.
        // What should we do if one line is aligned to the left, another to the right?

        if (isHorizontalAutoSize && !_options.isHtmlText) width = 100000;
        if (isVerticalAutoSize) height = 100000;

        _meshBatch.x = _meshBatch.y = 0;
        _options.textureScale = Starling.current.contentScaleFactor;
        _compositor.fillMeshBatch(_meshBatch, width, height, _text, _format, _options);

        if (_customStyle != null) _meshBatch.style = _customStyle;
        else
        {
            _defaultStyle = _compositor.getDefaultMeshStyle(_defaultStyle, _format, _options);
            if (_defaultStyle != null) _meshBatch.style = _defaultStyle;
        }
        
        if (_options.autoSize != TextFieldAutoSize.NONE)
        {
            _textBounds = _meshBatch.getBounds(_meshBatch, _textBounds);

            if (isHorizontalAutoSize)
            {
                _meshBatch.x = _textBounds.x = -_textBounds.x;
                _hitArea.width = _textBounds.width;
                _textBounds.x = 0;
            }

            if (isVerticalAutoSize)
            {
                _meshBatch.y = _textBounds.y = -_textBounds.y;
                _hitArea.height = _textBounds.height;
                _textBounds.y = 0;
            }
        }
        else
        {
            // hit area doesn't change, and text bounds can be created on demand
            _textBounds = null;
        }
    }

    private function updateBorder():Void
    {
        if (_border == null) return;
        
        var width:Float  = _hitArea.width;
        var height:Float = _hitArea.height;
        
        var topLine:Quad    = cast _border.getChildAt(0);
        var rightLine:Quad  = cast _border.getChildAt(1);
        var bottomLine:Quad = cast _border.getChildAt(2);
        var leftLine:Quad   = cast _border.getChildAt(3);
        
        topLine.width    = width; topLine.height    = 1;
        bottomLine.width = width; bottomLine.height = 1;
        leftLine.width   = 1;     leftLine.height   = height;
        rightLine.width  = 1;     rightLine.height  = height;
        rightLine.x  = width  - 1;
        bottomLine.y = height - 1;
        topLine.color = rightLine.color = bottomLine.color = leftLine.color = _format.color;
    }

    /** Forces the text to be recomposed before rendering it in the upcoming frame. Any changes
     *  of the TextField itself will automatically trigger recomposition; changes in its
     *  parents or the viewport, however, need to be processed manually. For example, you
     *  might want to force recomposition to fix blurring caused by a scale factor change.
     */
    public function setRequiresRecomposition():Void
    {
        if (!_recomposing)
        {
            _requiresRecomposition = true;
            setRequiresRedraw();
        }
    }

    // properties

    private var isHorizontalAutoSize(get, never):Bool;
    private function get_isHorizontalAutoSize():Bool
    {
        return _options.autoSize == TextFieldAutoSize.HORIZONTAL ||
               _options.autoSize == TextFieldAutoSize.BOTH_DIRECTIONS;
    }

    private var isVerticalAutoSize(get, never):Bool;
    private function get_isVerticalAutoSize():Bool
    {
        return _options.autoSize == TextFieldAutoSize.VERTICAL ||
               _options.autoSize == TextFieldAutoSize.BOTH_DIRECTIONS;
    }

    /** Returns the bounds of the text within the text field. */
    public var textBounds(get, never):Rectangle;
    private function get_textBounds():Rectangle
    {
        return getTextBounds(this);
    }
    
    /** @inheritDoc */
    public override function getBounds(targetSpace:DisplayObject, out:Rectangle=null):Rectangle
    {
        if (_requiresRecomposition) recompose();
        getTransformationMatrix(targetSpace, sMatrix);
        return RectangleUtil.getBounds(_hitArea, sMatrix, out);
    }
    
    /** Returns the bounds of the text within the text field in the given coordinate space. */
    public function getTextBounds(targetSpace:DisplayObject, out:Rectangle=null):Rectangle
    {
        if (_requiresRecomposition) recompose();
        if (_textBounds == null) _textBounds = _meshBatch.getBounds(this);
        getTransformationMatrix(targetSpace, sMatrix);
        return RectangleUtil.getBounds(_textBounds, sMatrix, out);
    }
    
    /** @inheritDoc */
    public override function hitTest(localPoint:Point):DisplayObject
    {
        if (!visible || !touchable || !hitTestMask(localPoint)) return null;
        else if (_hitArea.containsPoint(localPoint)) return this;
        else return null;
    }

    /** @inheritDoc */
    private override function set_width(value:Float):Float
    {
        // different to ordinary display objects, changing the size of the text field should 
        // not change the scaling, but make the texture bigger/smaller, while the size 
        // of the text/font stays the same (this applies to the height, as well).

        _hitArea.width = value / (scaleX != 0 ? scaleX : 1.0);
        setRequiresRecomposition();
        return value;
    }
    
    /** @inheritDoc */
    private override function set_height(value:Float):Float
    {
        _hitArea.height = value / (scaleY != 0 ? scaleY : 1.0);
        setRequiresRecomposition();
        return value;
    }
    
    /** The displayed text. */
    public var text(get, set):String;
    private function get_text():String { return _text; }
    private function set_text(value:String):String
    {
        if (value == null) value = "";
        if (_text != value)
        {
            _text = value;
            setRequiresRecomposition();
        }
        return value;
    }

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
    private function get_format():TextFormat { return _format; }
    private function set_format(value:TextFormat):TextFormat
    {
        if (value == null) throw new ArgumentError("format cannot be null");
        _format.copyFrom(value);
        return value;
    }

    /** The options that describe how the letters of a text should be assembled.
     *  This class basically collects all the TextField's properties that are needed
     *  during text composition. Since an instance of 'TextOptions' is passed to the
     *  constructor, you can pass custom options to the compositor. */
    private var options(get, never):TextOptions;
    private function get_options():TextOptions { return _options; }

    /** Draws a border around the edges of the text field. Useful for visual debugging.
     *  @default false */
    public var border(get, set):Bool;
    public function get_border():Bool { return _border != null; }
    public function set_border(value:Bool):Bool
    {
        if (value && _border == null)
        {                
            _border = new Sprite();
            addChild(_border);
            
            for (i in 0...4)
                _border.addChild(new Quad(1.0, 1.0));
            
            updateBorder();
        }
        else if (!value && _border != null)
        {
            _border.removeFromParent(true);
            _border = null;
        }
        return value;
    }
    
    /** Indicates whether the font size is automatically reduced if the complete text does
     *  not fit into the TextField. @default false */
    public var autoScale(get, set):Bool;
    private function get_autoScale():Bool { return _options.autoScale; }
    private function set_autoScale(value:Bool):Bool { return _options.autoScale = value; }

    /** Specifies the type of auto-sizing the TextField will do.
     *  Note that any auto-sizing will implicitly deactivate all auto-scaling.
     *  @default none */
    public var autoSize(get, set):String;
    private function get_autoSize():String { return _options.autoSize; }
    private function set_autoSize(value:String):String { return _options.autoSize = value; }

    /** Indicates if the text should be wrapped at word boundaries if it does not fit into
     *  the TextField otherwise. @default true */
    public var wordWrap(get, set):Bool;
    private function get_wordWrap():Bool { return _options.wordWrap; }
    private function set_wordWrap(value:Bool):Bool { return _options.wordWrap = value; }

    /** Indicates if TextField should be batched on rendering.
     *
     *  <p>This works only with bitmap fonts, and it makes sense only for TextFields with no
     *  more than 10-15 characters. Otherwise, the CPU costs will exceed any gains you get
     *  from avoiding the additional draw call.</p>
     *
     *  @default false
     */
    public var batchable(get, set):Bool;
    private function get_batchable():Bool { return _meshBatch.batchable; }
    private function set_batchable(value:Bool):Bool
    {
        return _meshBatch.batchable = value;
    }

    /** Indicates if text should be interpreted as HTML code. For a description
     *  of the supported HTML subset, refer to the classic Flash 'TextField' documentation.
     *  Clickable hyperlinks and images are not supported. Only works for
     *  TrueType fonts! @default false */
    public var isHtmlText(get, set):Bool;
    private function get_isHtmlText():Bool { return _options.isHtmlText; }
    private function set_isHtmlText(value:Bool):Bool { return _options.isHtmlText = value; }

    #if flash
    /** An optional style sheet to be used for HTML text. For more information on style
     *  sheets, please refer to the StyleSheet class in the ActionScript 3 API reference.
     *  @default null */
    public var styleSheet(get, set):StyleSheet;
    private function get_styleSheet():StyleSheet { return _options.styleSheet; }
    private function set_styleSheet(value:StyleSheet):StyleSheet { return _options.styleSheet = value; }
    #end
	
	/** The padding (in points) that's added to the sides of text that's rendered to a Bitmap.
	 *  If your text is truncated on the sides (which may happen if the font returns incorrect
	 *  bounds), padding can make up for that. Value must be positive. @default 0.0 */
	public var padding(get, set):Float;
	private function get_padding():Float { return _options.padding; }
	private function set_padding(value:Float):Float { return _options.padding = value; }

    /** Controls whether or not the instance snaps to the nearest pixel. This can prevent the
     *  object from looking blurry when it's not exactly aligned with the pixels of the screen.
     *  @default true */
    public var pixelSnapping(get, set):Bool;
    private function get_pixelSnapping():Bool { return _meshBatch.pixelSnapping; }
    private function set_pixelSnapping(value:Bool):Bool { return _meshBatch.pixelSnapping = value; }

    /** The mesh style that is used to render the text.
     *  Note that a style instance may only be used on one mesh at a time. */
    public var style(get, set):MeshStyle;
    private function get_style():MeshStyle 
    {
        if (_requiresRecomposition) recompose(); // might change style!
            return _meshBatch.style;
    }
    private function set_style(value:MeshStyle):MeshStyle
    {
        _customStyle = value;
        setRequiresRecomposition();
        return value;
    }

    /** The Context3D texture format that is used for rendering of all TrueType texts.
     *  The default provides a good compromise between quality and memory consumption;
     *  use <pre>Context3DTextureFormat.BGRA</pre> for the highest quality.
     *
     *  @default Context3DTextureFormat.BGRA_PACKED */
    public static var defaultTextureFormat(get, set):String;
    private static function get_defaultTextureFormat():String { return sDefaultTextureFormat; }
    private static function set_defaultTextureFormat(value:String):String
    {
        return sDefaultTextureFormat = value;
    }

    /** The default compositor used to arrange the letters of the text.
     *  If a specific compositor was registered for a font, it takes precedence.
     *
     *  @default TrueTypeCompositor
     */
    public static var defaultCompositor(get, set):ITextCompositor;
    private static function get_defaultCompositor():ITextCompositor { return sDefaultCompositor; }
    private static function set_defaultCompositor(value:ITextCompositor):ITextCompositor
    {
        return sDefaultCompositor = value;
    }

    /** Updates the list of embedded fonts. Call this method when you loaded a TrueType font
     *  at runtime so that Starling can recognize it as such. */
    public static function updateEmbeddedFonts():Void
    {
        SystemUtil.updateEmbeddedFonts();
    }

    // compositor registration

    /** Makes a text compositor (like a <code>BitmapFont</code>) available to any TextField in
     *  the current stage3D context. The font is identified by its <code>name</code> (not
     *  case sensitive). */
    public static function registerCompositor(compositor:ITextCompositor, name:String):Void
    {
        if (name == null) throw new ArgumentError("name must not be null");
        TextField.compositors[convertToLowerCase(name)] = compositor;
    }

    /** Unregisters the text compositor and, optionally, disposes it. */
    public static function unregisterCompositor(name:String, dispose:Bool=true):Void
    {
        name = convertToLowerCase(name);
        var compositors = TextField.compositors;
        
        if (dispose && compositors.exists(name))
            compositors[name].dispose();

        compositors.remove(name);
    }

    /** Returns a registered text compositor (or null, if the font has not been registered).
     *  The name is not case sensitive. */
    public static function getCompositor(name:String):ITextCompositor
    {
        return compositors[convertToLowerCase(name)];
    }

    /** Makes a bitmap font available at any TextField in the current stage3D context.
     *  The font is identified by its <code>name</code> (not case sensitive).
     *  Per default, the <code>name</code> property of the bitmap font will be used, but you
     *  can pass a custom name, as well. @return the name of the font. */
    @:deprecated("replaced by `registerCompositor`")
    public static function registerBitmapFont(bitmapFont:BitmapFont, name:String=null):String
    {
        if (name == null) name = bitmapFont.name;
        registerCompositor(bitmapFont, name);
        return name;
    }

    /** Unregisters the bitmap font and, optionally, disposes it. */
    @:deprecated("replaced by `unregisterCompositor`")
    public static function unregisterBitmapFont(name:String, dispose:Bool=true):Void
    {
        unregisterCompositor(name, dispose);
    }

    /** Returns a registered bitmap font compositor (or null, if no compositor has been
     *  registered with that name, or if it's not a bitmap font). The name is not case
     *  sensitive. */
    public static function getBitmapFont(name:String):BitmapFont
    {
        return cast(getCompositor(name), BitmapFont);
    }
    
    /** Stores the currently available text compositors. Since compositors will only work
     *  in one Stage3D context, they are saved in Starling's 'contextData' property. */
    private static var compositors(get, never):Map<String, ITextCompositor>;
    private static function get_compositors():Map<String, ITextCompositor>
    {
        var compositors:Map<String, ITextCompositor> = Starling.current.painter.sharedData[COMPOSITOR_DATA_NAME];
        
        if (compositors == null)
        {
            compositors = new Map();
            Starling.current.painter.sharedData[COMPOSITOR_DATA_NAME] = compositors;
        }
        
        return compositors;
    }

    // optimization for 'toLowerCase' calls

    private static var sStringCache:Map<String, String> = new Map<String, String>();

    private static function convertToLowerCase(string:String):String
    {
        var result:String = sStringCache[string];
        if (result == null)
        {
            result = string.toLowerCase();
            sStringCache[string] = result;
        }
        return result;
    }
}
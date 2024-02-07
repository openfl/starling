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
import openfl.text.TextFormat;

import starling.events.Event;
import starling.events.EventDispatcher;
import starling.utils.Align;

/** Dispatched when any property of the instance changes. */
@:meta(Event(name="change", type="starling.events.Event"))

/** The TextFormat class represents character formatting information. It is used by the
 *  TextField and BitmapFont classes to characterize the way the glyphs will be rendered.
 *
 *  <p>Note that not all properties are used by all font renderers: bitmap fonts ignore
 *  the "bold", "italic", and "underline" values.</p>
 */
class TextFormat extends EventDispatcher
{
    @:noCompletion private var __font:String;
    @:noCompletion private var __size:Float;
    @:noCompletion private var __color:UInt;
    @:noCompletion private var __bold:Bool;
    @:noCompletion private var __italic:Bool;
    @:noCompletion private var __underline:Bool;
    @:noCompletion private var __horizontalAlign:String;
    @:noCompletion private var __verticalAlign:String;
    @:noCompletion private var __kerning:Bool;
    @:noCompletion private var __leading:Float;
    @:noCompletion private var __letterSpacing:Float;

    #if commonjs
    private static function __init__ () {
        
        untyped Object.defineProperties (TextFormat.prototype, {
            "font": { get: untyped __js__ ("function () { return this.get_font (); }"), set: untyped __js__ ("function (v) { return this.set_font (v); }") },
            "size": { get: untyped __js__ ("function () { return this.get_size (); }"), set: untyped __js__ ("function (v) { return this.set_size (v); }") },
            "color": { get: untyped __js__ ("function () { return this.get_color (); }"), set: untyped __js__ ("function (v) { return this.set_color (v); }") },
            "bold": { get: untyped __js__ ("function () { return this.get_bold (); }"), set: untyped __js__ ("function (v) { return this.set_bold (v); }") },
            "italic": { get: untyped __js__ ("function () { return this.get_italic (); }"), set: untyped __js__ ("function (v) { return this.set_italic (v); }") },
            "underline": { get: untyped __js__ ("function () { return this.get_underline (); }"), set: untyped __js__ ("function (v) { return this.set_underline (v); }") },
            "horizontalAlign": { get: untyped __js__ ("function () { return this.get_horizontalAlign (); }"), set: untyped __js__ ("function (v) { return this.set_horizontalAlign (v); }") },
            "verticalAlign": { get: untyped __js__ ("function () { return this.get_verticalAlign (); }"), set: untyped __js__ ("function (v) { return this.set_verticalAlign (v); }") },
            "kerning": { get: untyped __js__ ("function () { return this.get_kerning (); }"), set: untyped __js__ ("function (v) { return this.set_kerning (v); }") },
            "leading": { get: untyped __js__ ("function () { return this.get_leading (); }"), set: untyped __js__ ("function (v) { return this.set_leading (v); }") },
            "letterSpacing": { get: untyped __js__ ("function () { return this.get_letterSpacing (); }"), set: untyped __js__ ("function (v) { return this.set_letterSpacing (v); }") },
        });
        
    }
    #end

    /** Creates a new TextFormat instance with the given properties. */
    public function new(font:String="Verdana", size:Float=12, color:UInt=0x0,
                        horizontalAlign:String="center", verticalAlign:String="center")
    {
        super();
        
        __font = font;
        __size = size;
        __color = color;
        __horizontalAlign = horizontalAlign;
        __verticalAlign = verticalAlign;
        __kerning = true;
        __letterSpacing = __leading = 0.0;
    }

    /** Copies all properties from another TextFormat instance. */
    public function copyFrom(format:starling.text.TextFormat):Void
    {
        __font = format.__font;
        __size = format.__size;
        __color = format.__color;
        __bold = format.__bold;
        __italic = format.__italic;
        __underline = format.__underline;
        __horizontalAlign = format.__horizontalAlign;
        __verticalAlign = format.__verticalAlign;
        __kerning = format.__kerning;
        __leading = format.__leading;
        __letterSpacing = format.__letterSpacing;

        dispatchEventWith(Event.CHANGE);
    }

    /** Creates a clone of this instance. */
    public function clone():starling.text.TextFormat
    {
        var clone:starling.text.TextFormat = new starling.text.TextFormat();
        clone.copyFrom(this);
        return clone;
    }

    /** Sets the most common properties at once. */
    public function setTo(font:String="Verdana", size:Float=12, color:UInt=0x0,
                          horizontalAlign:String="center", verticalAlign:String="center"):Void
    {
        __font = font;
        __size = size;
        __color = color;
        __horizontalAlign = horizontalAlign;
        __verticalAlign = verticalAlign;

        dispatchEventWith(Event.CHANGE);
    }

    /** Converts the Starling TextFormat instance to a Flash TextFormat. */
    public function toNativeFormat(out:openfl.text.TextFormat=null):openfl.text.TextFormat
    {
        if (out == null) out = new openfl.text.TextFormat();

        out.font = __font;
        out.size = Std.int(__size);
        out.color = __color;
        out.bold = __bold;
        out.italic = __italic;
        out.underline = __underline;
        out.align = __horizontalAlign;
        out.kerning = __kerning;
        out.leading = Std.int(__leading);
        out.letterSpacing = __letterSpacing;

        return out;
    }

    /** The name of the font. TrueType fonts will be looked up from embedded fonts and
     *  system fonts; bitmap fonts must be registered at the TextField class first.
     *  Beware: If you loaded an embedded font at runtime, you must call
     *  <code>TextField.updateEmbeddedFonts()</code> for Starling to recognize it.
     */
    public var font(get, set):String;
    private function get_font():String { return __font; }
    private function set_font(value:String):String
    {
        if (value != __font)
        {
            __font = value;
            dispatchEventWith(Event.CHANGE);
        }
        return value;
    }

    /** The size of the font. For bitmap fonts, use <code>BitmapFont.NATIVE_SIZE</code> for
     *  the original size. */
    public var size(get, set):Float;
    private function get_size():Float { return __size; }
    private function set_size(value:Float):Float
    {
        if (value != __size)
        {
            __size = value;
            dispatchEventWith(Event.CHANGE);
        }
        return value;
    }

    /** The color of the text. Note that bitmap fonts should be exported in plain white so
     *  that tinting works correctly. If your bitmap font contains colors, set this property
     *  to <code>Color.WHITE</code> to get the desired result. @default black */
    public var color(get, set):UInt;
    private function get_color():UInt { return __color; }
    private function set_color(value:UInt):UInt
    {
        if (value != __color)
        {
            __color = value;
            dispatchEventWith(Event.CHANGE);
        }
        return value;
    }

    /** Indicates whether the text is bold. @default false */
    public var bold(get, set):Bool;
    private function get_bold():Bool { return __bold; }
    private function set_bold(value:Bool):Bool
    {
        if (value != __bold)
        {
            __bold = value;
            dispatchEventWith(Event.CHANGE);
        }
        return value;
    }

    /** Indicates whether the text is italicized. @default false */
    public var italic(get, set):Bool;
    private function get_italic():Bool { return __italic; }
    private function set_italic(value:Bool):Bool
    {
        if (value != __italic)
        {
            __italic = value;
            dispatchEventWith(Event.CHANGE);
        }
        return value;
    }

    /** Indicates whether the text is underlined. @default false */
    public var underline(get, set):Bool;
    private function get_underline():Bool { return __underline; }
    private function set_underline(value:Bool):Bool
    {
        if (value != __underline)
        {
            __underline = value;
            dispatchEventWith(Event.CHANGE);
        }
        return value;
    }

    /** The horizontal alignment of the text. @default center
     *  @see starling.utils.Align */
    public var horizontalAlign(get, set):String;
    private function get_horizontalAlign():String { return __horizontalAlign; }
    private function set_horizontalAlign(value:String):String
    {
        if (!Align.isValidHorizontal(value))
            throw new ArgumentError("Invalid horizontal alignment");

        if (value != __horizontalAlign)
        {
            __horizontalAlign = value;
            dispatchEventWith(Event.CHANGE);
        }
        return value;
    }

    /** The vertical alignment of the text. @default center
     *  @see starling.utils.Align */
    public var verticalAlign(get, set):String;
    private function get_verticalAlign():String { return __verticalAlign; }
    private function set_verticalAlign(value:String):String
    {
        if (!Align.isValidVertical(value))
            throw new ArgumentError("Invalid vertical alignment");

        if (value != __verticalAlign)
        {
            __verticalAlign = value;
            dispatchEventWith(Event.CHANGE);
        }
        return value;
    }

    /** Indicates whether kerning is enabled. Kerning adjusts the pixels between certain
     *  character pairs to improve readability. @default true */
    public var kerning(get, set):Bool;
    private function get_kerning():Bool { return __kerning; }
    private function set_kerning(value:Bool):Bool
    {
        if (value != __kerning)
        {
            __kerning = value;
            dispatchEventWith(Event.CHANGE);
        }
        return value;
    }

    /** The amount of vertical space (called 'leading') between lines. @default 0 */
    public var leading(get, set):Float;
    private function get_leading():Float { return __leading; }
    private function set_leading(value:Float):Float
    {
        if (value != __leading)
        {
            __leading = value;
            dispatchEventWith(Event.CHANGE);
        }
        return value;
    }
    
    /** A number representing the amount of space that is uniformly distributed between all characters. @default 0 */
    public var letterSpacing(get, set):Float;
    private function get_letterSpacing():Float { return __letterSpacing; }
    private function set_letterSpacing(value:Float):Float
    {
        if (value != __letterSpacing)
        {
            __letterSpacing = value;
            dispatchEventWith(Event.CHANGE);
        }
        return value;
    }
}
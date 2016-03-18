// =================================================================================================
//
//	Starling Framework
//	Copyright Gamua GmbH. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

package starling.text
{
import flash.text.TextFormat;

import starling.events.Event;
import starling.events.EventDispatcher;
import starling.utils.Align;

/** Dispatched when any property of the instance changes. */
[Event(name="change", type="starling.events.Event")]

/** The TextFormat class represents character formatting information. It is used by the
 *  TextField and BitmapFont classes to characterize the way the glyphs will be rendered.
 *
 *  <p>Note that not all properties are used by all font renderers: bitmap fonts ignore
 *  the "bold", "italic", and "underline" values.</p>
 */
public class TextFormat extends EventDispatcher
{
    private var _font:String;
    private var _size:Float;
    private var _color:UInt;
    private var _bold:Bool;
    private var _italic:Bool;
    private var _underline:Bool;
    private var _horizontalAlign:String;
    private var _verticalAlign:String;
    private var _kerning:Bool;
    private var _leading:Float;

    /** Creates a new TextFormat instance with the given properties. */
    public function TextFormat(font:String="Verdana", size:Float=12, color:UInt=0x0,
                               horizontalAlign:String="center", verticalAlign:String="center")
    {
        _font = font;
        _size = size;
        _color = color;
        _horizontalAlign = horizontalAlign;
        _verticalAlign = verticalAlign;
        _kerning = true;
        _leading = 0.0;
    }

    /** Copies all properties from another TextFormat instance. */
    public function copyFrom(format:starling.text.TextFormat):Void
    {
        _font = format._font;
        _size = format._size;
        _color = format._color;
        _bold = format._bold;
        _italic = format._italic;
        _underline = format._underline;
        _horizontalAlign = format._horizontalAlign;
        _verticalAlign = format._verticalAlign;
        _kerning = format._kerning;
        _leading = format._leading;

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
        _font = font;
        _size = size;
        _color = color;
        _horizontalAlign = horizontalAlign;
        _verticalAlign = verticalAlign;

        dispatchEventWith(Event.CHANGE);
    }

    /** Converts the Starling TextFormat instance to a Flash TextFormat. */
    public function toNativeFormat(out:flash.text.TextFormat=null):flash.text.TextFormat
    {
        if (out == null) out = new flash.text.TextFormat();

        out.font = _font;
        out.size = _size;
        out.color = _color;
        out.bold = _bold;
        out.italic = _italic;
        out.underline = _underline;
        out.align = _horizontalAlign;
        out.kerning = _kerning;
        out.leading = _leading;

        return out;
    }

    /** The name of the font. TrueType fonts will be looked up from embedded fonts and
     *  system fonts; bitmap fonts must be registered at the TextField class first. */
    public function get font():String { return _font; }
    public function set font(value:String):Void
    {
        if (value != _font)
        {
            _font = value;
            dispatchEventWith(Event.CHANGE);
        }
    }

    /** The size of the font. For bitmap fonts, use <code>BitmapFont.NATIVE_SIZE</code> for
     *  the original size. */
    public function get size():Float { return _size; }
    public function set size(value:Float):Void
    {
        if (value != _size)
        {
            _size = value;
            dispatchEventWith(Event.CHANGE);
        }
    }

    /** The color of the text. Note that bitmap fonts should be exported in plain white so
     *  that tinting works correctly. If your bitmap font contains colors, set this property
     *  to <code>Color.WHITE</code> to get the desired result. @default black */
    public function get color():UInt { return _color; }
    public function set color(value:UInt):Void
    {
        if (value != _color)
        {
            _color = value;
            dispatchEventWith(Event.CHANGE);
        }
    }

    /** Indicates whether the text is bold. @default false */
    public function get bold():Bool { return _bold; }
    public function set bold(value:Bool):Void
    {
        if (value != _bold)
        {
            _bold = value;
            dispatchEventWith(Event.CHANGE);
        }
    }

    /** Indicates whether the text is italicized. @default false */
    public function get italic():Bool { return _italic; }
    public function set italic(value:Bool):Void
    {
        if (value != _italic)
        {
            _italic = value;
            dispatchEventWith(Event.CHANGE);
        }
    }

    /** Indicates whether the text is underlined. @default false */
    public function get underline():Bool { return _underline; }
    public function set underline(value:Bool):Void
    {
        if (value != _underline)
        {
            _underline = value;
            dispatchEventWith(Event.CHANGE);
        }
    }

    /** The horizontal alignment of the text. @default center
     *  @see starling.utils.Align */
    public function get horizontalAlign():String { return _horizontalAlign; }
    public function set horizontalAlign(value:String):Void
    {
        if (!Align.isValidHorizontal(value))
            throw new ArgumentError("Invalid horizontal alignment");

        if (value != _horizontalAlign)
        {
            _horizontalAlign = value;
            dispatchEventWith(Event.CHANGE);
        }
    }

    /** The vertical alignment of the text. @default center
     *  @see starling.utils.Align */
    public function get verticalAlign():String { return _verticalAlign; }
    public function set verticalAlign(value:String):Void
    {
        if (!Align.isValidVertical(value))
            throw new ArgumentError("Invalid vertical alignment");

        if (value != _verticalAlign)
        {
            _verticalAlign = value;
            dispatchEventWith(Event.CHANGE);
        }
    }

    /** Indicates whether kerning is enabled. Kerning adjusts the pixels between certain
     *  character pairs to improve readability. @default true */
    public function get kerning():Bool { return _kerning; }
    public function set kerning(value:Bool):Void
    {
        if (value != _kerning)
        {
            _kerning = value;
            dispatchEventWith(Event.CHANGE);
        }
    }

    /** The amount of vertical space (called 'leading') between lines. @default 0 */
    public function get leading():Float { return _leading; }
    public function set leading(value:Float):Void
    {
        if (value != _leading)
        {
            _leading = value;
            dispatchEventWith(Event.CHANGE);
        }
    }
}
}

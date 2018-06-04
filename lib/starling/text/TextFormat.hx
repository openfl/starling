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

@:jsRequire("starling/text/TextFormat", "default")

extern class TextFormat extends EventDispatcher
{
    /** Creates a new TextFormat instance with the given properties. */
    public function new(font:String="Verdana", size:Float=12, color:UInt=0x0,
                        horizontalAlign:String="center", verticalAlign:String="center");

    /** Copies all properties from another TextFormat instance. */
    public function copyFrom(format:starling.text.TextFormat):Void;

    /** Creates a clone of this instance. */
    public function clone():starling.text.TextFormat;

    /** Sets the most common properties at once. */
    public function setTo(font:String="Verdana", size:Float=12, color:UInt=0x0,
                          horizontalAlign:String="center", verticalAlign:String="center"):Void;

    /** Converts the Starling TextFormat instance to a Flash TextFormat. */
    public function toNativeFormat(out:flash.text.TextFormat=null):flash.text.TextFormat;

    /** The name of the font. TrueType fonts will be looked up from embedded fonts and
     *  system fonts; bitmap fonts must be registered at the TextField class first.
     *  Beware: If you loaded an embedded font at runtime, you must call
     *  <code>TextField.updateEmbeddedFonts()</code> for Starling to recognize it.
     */
    public var font(get, set):String;
    private function get_font():String;
    private function set_font(value:String):String;

    /** The size of the font. For bitmap fonts, use <code>BitmapFont.NATIVE_SIZE</code> for
     *  the original size. */
    public var size(get, set):Float;
    private function get_size():Float;
    private function set_size(value:Float):Float;

    /** The color of the text. Note that bitmap fonts should be exported in plain white so
     *  that tinting works correctly. If your bitmap font contains colors, set this property
     *  to <code>Color.WHITE</code> to get the desired result. @default black */
    public var color(get, set):UInt;
    private function get_color():UInt;
    private function set_color(value:UInt):UInt;

    /** Indicates whether the text is bold. @default false */
    public var bold(get, set):Bool;
    private function get_bold():Bool;
    private function set_bold(value:Bool):Bool;

    /** Indicates whether the text is italicized. @default false */
    public var italic(get, set):Bool;
    private function get_italic():Bool;
    private function set_italic(value:Bool):Bool;

    /** Indicates whether the text is underlined. @default false */
    public var underline(get, set):Bool;
    private function get_underline():Bool;
    private function set_underline(value:Bool):Bool;

    /** The horizontal alignment of the text. @default center
     *  @see starling.utils.Align */
    public var horizontalAlign(get, set):String;
    private function get_horizontalAlign():String;
    private function set_horizontalAlign(value:String):String;

    /** The vertical alignment of the text. @default center
     *  @see starling.utils.Align */
    public var verticalAlign(get, set):String;
    private function get_verticalAlign():String;
    private function set_verticalAlign(value:String):String;

    /** Indicates whether kerning is enabled. Kerning adjusts the pixels between certain
     *  character pairs to improve readability. @default true */
    public var kerning(get, set):Bool;
    private function get_kerning():Bool;
    private function set_kerning(value:Bool):Bool;

    /** The amount of vertical space (called 'leading') between lines. @default 0 */
    public var leading(get, set):Float;
    private function get_leading():Float;
    private function set_leading(value:Float):Float;
    
    /** A number representing the amount of space that is uniformly distributed between all characters. @default 0 */
    public var letterSpacing(get, set):Float;
    private function get_letterSpacing():Float;
    private function set_letterSpacing(value:Float):Float;
}
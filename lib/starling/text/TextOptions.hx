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
#if flash
import flash.text.StyleSheet;
#end

import starling.core.Starling;
import starling.events.Event;
import starling.events.EventDispatcher;

/** Dispatched when any property of the instance changes. */
@:meta(Event(name="change", type="starling.events.Event"))

/** The TextOptions class contains data that describes how the letters of a text should
 *  be assembled on text composition.
 *
 *  <p>Note that not all properties are supported by all text compositors.</p>
 */

@:jsRequire("starling/text/TextOptions", "default")

extern class TextOptions extends EventDispatcher
{
    /** Creates a new TextOptions instance with the given properties. */
    public function new(wordWrap:Bool=true, autoScale:Bool=false);

    /** Copies all properties from another TextOptions instance. */
    public function copyFrom(options:TextOptions):Void;

    /** Creates a clone of this instance. */
    public function clone():TextOptions;

    /** Indicates if the text should be wrapped at word boundaries if it does not fit into
     *  the TextField otherwise. @default true */
	public var wordWrap(get, set):Bool;
    private function get_wordWrap():Bool;
    private function set_wordWrap(value:Bool):Bool;

    /** Specifies the type of auto-sizing set on the TextField. Custom text compositors may
     *  take this into account, though the basic implementation (done by the TextField itself)
     *  is often sufficient: it passes a very big size to the <code>fillMeshBatch</code>
     *  method and then trims the result to the actually used area. @default none */
	public var autoSize(get, set):String;
    private function get_autoSize():String;
    private function set_autoSize(value:String):String;

    /** Indicates whether the font size is automatically reduced if the complete text does
     *  not fit into the TextField. @default false */
	public var autoScale(get, set):Bool;
    private function get_autoScale():Bool;
    private function set_autoScale(value:Bool):Bool;

    /** Indicates if text should be interpreted as HTML code. For a description
     *  of the supported HTML subset, refer to the classic Flash 'TextField' documentation.
     *  Beware: Only supported for TrueType fonts. @default false */
	public var isHtmlText(get, set):Bool;
    private function get_isHtmlText():Bool;
    private function set_isHtmlText(value:Bool):Bool;

    #if flash
    /** An optional style sheet to be used for HTML text. @default null */
    public var styleSheet(get, set):StyleSheet;
    private function get_styleSheet():StyleSheet;
    private function set_styleSheet(value:StyleSheet):StyleSheet;
    #end

    /** The scale factor of any textures that are created during text composition.
     *  @default Starling.contentScaleFactor */
	public var textureScale(get, set):Float;
    private function get_textureScale():Float;
    private function set_textureScale(value:Float):Float;

    /** The Context3DTextureFormat of any textures that are created during text composition.
     *  @default Context3DTextureFormat.BGRA_PACKED */
	public var textureFormat(get, set):String;
    private function get_textureFormat():String;
    private function set_textureFormat(value:String):String;

    /** The padding (in points) that's added to the sides of text that's rendered to a Bitmap.
     *  If your text is truncated on the sides (which may happen if the font returns incorrect
     *  bounds), padding can make up for that. Value must be positive. @default 0.0 */
    public var padding(get, set):Float;
    private function get_padding():Float;
    private function set_padding(value:Float):Float;
}
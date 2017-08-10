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

import flash.display3D.Context3DTextureFormat;
import flash.text.StyleSheet;

import starling.core.Starling;

/** The TextOptions class contains data that describes how the letters of a text should
 *  be assembled on text composition.
 *
 *  <p>Note that not all properties are supported by all text compositors.</p>
 */
class TextOptions
{
    private var __wordWrap:Bool;
    private var __autoScale:Bool;
    private var __autoSize:String;
    private var __isHtmlText:Bool;
    private var __textureScale:Float;
    private var __textureFormat:String;
    private var __styleSheet:StyleSheet;

    /** Creates a new TextOptions instance with the given properties. */
    public function TextOptions(wordWrap:Bool=true, autoScale:Bool=false)
    {
        __wordWrap = wordWrap;
        __autoScale = autoScale;
        __autoSize = TextFieldAutoSize.NONE;
        __textureScale = Starling.contentScaleFactor;
        __textureFormat = Context3DTextureFormat.BGR_PACKED;
        __isHtmlText = false;
    }

    /** Copies all properties from another TextOptions instance. */
    public function copyFrom(options:TextOptions):Void
    {
        __wordWrap = options.__wordWrap;
        __autoScale = options.__autoScale;
        __autoSize = options.__autoSize;
        __isHtmlText = options.__isHtmlText;
        __textureScale = options.__textureScale;
        __textureFormat = options.__textureFormat;
        __styleSheet = options.__styleSheet;
    }

    /** Creates a clone of this instance. */
    public function clone():TextOptions
    {
        var clone:TextOptions = new TextOptions();
        clone.copyFrom(this);
        return clone;
    }

    /** Indicates if the text should be wrapped at word boundaries if it does not fit into
     *  the TextField otherwise. @default true */
	public var wordWrap(get, set):Bool;
    private function get_wordWrap():Bool { return __wordWrap; }
    private function set_wordWrap(value:Bool):Void { __wordWrap = value; }

    /** Specifies the type of auto-sizing set on the TextField. Custom text compositors may
     *  take this into account, though the basic implementation (done by the TextField itself)
     *  is often sufficient: it passes a very big size to the <code>fillMeshBatch</code>
     *  method and then trims the result to the actually used area. @default none */
	public var autoScale(get, set):Bool;
    private function get_autoSize():String { return __autoSize; }
    private function set_autoSize(value:String):Void { __autoSize = value; }

    /** Indicates whether the font size is automatically reduced if the complete text does
     *  not fit into the TextField. @default false */
	public var autoSize(get, set):String;
    private function get_autoScale():Bool { return __autoScale; }
    private function set_autoScale(value:Bool):Void { __autoScale = value; }

    /** Indicates if text should be interpreted as HTML code. For a description
     *  of the supported HTML subset, refer to the classic Flash 'TextField' documentation.
     *  Beware: Only supported for TrueType fonts. @default false */
	public var isHtmlText(get, set):Bool;
    private function get_isHtmlText():Bool { return __isHtmlText; }
    private function set_isHtmlText(value:Bool):Void { __isHtmlText = value; }

    /** An optional style sheet to be used for HTML text. @default null */
	public var styleSheet(get, set):StyleSheet;
    private function get_styleSheet():StyleSheet { return __styleSheet; }
    private function set_styleSheet(value:StyleSheet):Void { __styleSheet = value; }

    /** The scale factor of any textures that are created during text composition.
     *  @default Starling.contentScaleFactor */
	public var textureScale(get, set):Float;
    private function get_textureScale():Float { return __textureScale; }
    private function set_textureScale(value:Float):Void { __textureScale = value; }

    /** The Context3DTextureFormat of any textures that are created during text composition.
     *  @default Context3DTextureFormat.BGRA_PACKED */
	public var textureFormat(get, set):String;
    private function get_textureFormat():String { return __textureFormat; }
    private function set_textureFormat(value:String):Void { __textureFormat = value; }
}
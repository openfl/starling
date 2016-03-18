/**
 * Created by redge on 16.12.15.
 */
package starling.text
{
import flash.display3D.Context3DTextureFormat;

import starling.core.Starling;

/** The TextOptions class contains data that describes how the letters of a text should
 *  be assembled on text composition.
 *
 *  <p>Note that not all properties are supported by all text compositors.</p>
 */
public class TextOptions
{
    private var _wordWrap:Bool;
    private var _autoScale:Bool;
    private var _isHtmlText:Bool;
    private var _textureScale:Float;
    private var _textureFormat:String;

    /** Creates a new TextOptions instance with the given properties. */
    public function TextOptions(wordWrap:Bool=true, autoScale:Bool=false)
    {
        _wordWrap = wordWrap;
        _autoScale = autoScale;
        _textureScale = Starling.contentScaleFactor;
        _textureFormat = Context3DTextureFormat.BGR_PACKED;
        _isHtmlText = false;
    }

    /** Copies all properties from another TextOptions instance. */
    public function copyFrom(options:TextOptions):Void
    {
        _wordWrap = options._wordWrap;
        _autoScale = options._autoScale;
        _isHtmlText = options._isHtmlText;
        _textureScale = options._textureScale;
        _textureFormat = options._textureFormat;
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
    public function get wordWrap():Bool { return _wordWrap; }
    public function set wordWrap(value:Bool):Void { _wordWrap = value; }

    /** Indicates whether the font size is automatically reduced if the complete text does
     *  not fit into the TextField. @default false */
    public function get autoScale():Bool { return _autoScale; }
    public function set autoScale(value:Bool):Void { _autoScale = value; }

    /** Indicates if text should be interpreted as HTML code. For a description
     *  of the supported HTML subset, refer to the classic Flash 'TextField' documentation.
     *  Beware: Only supported for TrueType fonts. @default false */
    public function get isHtmlText():Bool { return _isHtmlText; }
    public function set isHtmlText(value:Bool):Void { _isHtmlText = value; }

    /** The scale factor of any textures that are created during text composition.
     *  @default Starling.contentScaleFactor */
    public function get textureScale():Float { return _textureScale; }
    public function set textureScale(value:Float):Void { _textureScale = value; }

    /** The Context3DTextureFormat of any textures that are created during text composition.
     *  @default Context3DTextureFormat.BGRA_PACKED */
    public function get textureFormat():String { return _textureFormat; }
    public function set textureFormat(value:String):Void { _textureFormat = value; }
}
}

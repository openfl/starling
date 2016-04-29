/**
 * Created by redge on 16.12.15.
 */
package starling.text;
import flash.display3D.Context3DTextureFormat;

import starling.core.Starling;

/** The TextOptions class contains data that describes how the letters of a text should
 *  be assembled on text composition.
 *
 *  <p>Note that not all properties are supported by all text compositors.</p>
 */
class TextOptions
{
    private var _wordWrap:Bool;
    private var _autoScale:Bool;
    private var _isHtmlText:Bool;
    private var _textureScale:Float;
    private var _textureFormat:Context3DTextureFormat;

    /** Creates a new TextOptions instance with the given properties. */
    public function new(wordWrap:Bool=true, autoScale:Bool=false)
    {
        _wordWrap = wordWrap;
        _autoScale = autoScale;
        _textureScale = Starling.current.contentScaleFactor;
        #if 0
        _textureFormat = Context3DTextureFormat.BGR_PACKED;
        #else
        _textureFormat = Context3DTextureFormat.BGRA;
        #end
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
    public var wordWrap(get, set):Bool;
    @:noCompletion private function get_wordWrap():Bool { return _wordWrap; }
    @:noCompletion private function set_wordWrap(value:Bool):Bool { return _wordWrap = value; }

    /** Indicates whether the font size is automatically reduced if the complete text does
     *  not fit into the TextField. @default false */
    public var autoScale(get, set):Bool;
    @:noCompletion private function get_autoScale():Bool { return _autoScale; }
    @:noCompletion private function set_autoScale(value:Bool):Bool { return _autoScale = value; }

    /** Indicates if text should be interpreted as HTML code. For a description
     *  of the supported HTML subset, refer to the classic Flash 'TextField' documentation.
     *  Beware: Only supported for TrueType fonts. @default false */
    public var isHtmlText(get, set):Bool;
    @:noCompletion private function get_isHtmlText():Bool { return _isHtmlText; }
    @:noCompletion private function set_isHtmlText(value:Bool):Bool { return _isHtmlText = value; }

    /** The scale factor of any textures that are created during text composition.
     *  @default Starling.contentScaleFactor */
    public var textureScale(get, set):Float;
    @:noCompletion private function get_textureScale():Float { return _textureScale; }
    @:noCompletion private function set_textureScale(value:Float):Float { return _textureScale = value; }

    /** The Context3DTextureFormat of any textures that are created during text composition.
     *  @default Context3DTextureFormat.BGRA_PACKED */
    public var textureFormat(get, set):Context3DTextureFormat;
    @:noCompletion private function get_textureFormat():Context3DTextureFormat { return _textureFormat; }
    @:noCompletion private function set_textureFormat(value:Context3DTextureFormat):Context3DTextureFormat { return _textureFormat = value; }
}

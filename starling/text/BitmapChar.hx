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

import starling.display.Image;
import starling.textures.Texture;

/** A BitmapChar contains the information about one char of a bitmap font.
 *  <em>You don't have to use this class directly in most cases. 
 *  The TextField class contains methods that handle bitmap fonts for you.</em>    
 */ 
class BitmapChar
{
    private var _texture:Texture;
    private var _charID:Int;
    private var _xOffset:Float;
    private var _yOffset:Float;
    private var _xAdvance:Float;
    private var _kernings:Map<Int, Float>;
    
    /** Creates a char with a texture and its properties. */
    public function new(id:Int, texture:Texture, 
                               xOffset:Float, yOffset:Float, xAdvance:Float)
    {
        _charID = id;
        _texture = texture;
        _xOffset = xOffset;
        _yOffset = yOffset;
        _xAdvance = xAdvance;
        _kernings = null;
    }
    
    /** Adds kerning information relative to a specific other character ID. */
    public function addKerning(charID:Int, amount:Float):Void
    {
        if (_kernings == null)
            _kernings = new Map();
        
        _kernings[charID] = amount;
    }
    
    /** Retrieve kerning information relative to the given character ID. */
    public function getKerning(charID:Int):Float
    {
        if (_kernings == null || _kernings[charID] == null) return 0.0;
        else return _kernings[charID];
    }
    
    /** Creates an image of the char. */
    public function createImage():Image
    {
        return new Image(_texture);
    }
    
    /** The unicode ID of the char. */
    public var charID(get, never):Int;
    @:noCompletion private function get_charID():Int { return _charID; }
    
    /** The number of points to move the char in x direction on character arrangement. */
    public var xOffset(get, never):Float;
    @:noCompletion private function get_xOffset():Float { return _xOffset; }
    
    /** The number of points to move the char in y direction on character arrangement. */
    public var yOffset(get, never):Float;
    @:noCompletion private function get_yOffset():Float { return _yOffset; }
    
    /** The number of points the cursor has to be moved to the right for the next char. */
    public var xAdvance(get, never):Float;
    @:noCompletion private function get_xAdvance():Float { return _xAdvance; }
    
    /** The texture of the character. */
    public var texture(get, never):Texture;
    @:noCompletion private function get_texture():Texture { return _texture; }
    
    /** The width of the character in points. */
    public var width(get, never):Float;
    @:noCompletion private function get_width():Float { return _texture.width; }
    
    /** The height of the character in points. */
    public var height(get, never):Float;
    @:noCompletion private function get_height():Float { return _texture.height; }
}
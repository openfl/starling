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
    @:noCompletion private var __texture:Texture;
    @:noCompletion private var __charID:Int;
    @:noCompletion private var __xOffset:Float;
    @:noCompletion private var __yOffset:Float;
    @:noCompletion private var __xAdvance:Float;
    @:noCompletion private var __kernings:Map<Int, Float>;
    
    #if commonjs
    private static function __init__ () {
        
        untyped Object.defineProperties (BitmapChar.prototype, {
            "charID": { get: untyped __js__ ("function () { return this.get_charID (); }") },
            "xOffset": { get: untyped __js__ ("function () { return this.get_xOffset (); }") },
            "yOffset": { get: untyped __js__ ("function () { return this.get_yOffset (); }") },
            "xAdvance": { get: untyped __js__ ("function () { return this.get_xAdvance (); }") },
            "texture": { get: untyped __js__ ("function () { return this.get_texture (); }") },
            "width": { get: untyped __js__ ("function () { return this.get_width (); }") },
            "height": { get: untyped __js__ ("function () { return this.get_height (); }") },
        });
        
    }
    #end
    
    /** Creates a char with a texture and its properties. */
    public function new(id:Int, texture:Texture, 
                               xOffset:Float, yOffset:Float, xAdvance:Float)
    {
        __charID = id;
        __texture = texture;
        __xOffset = xOffset;
        __yOffset = yOffset;
        __xAdvance = xAdvance;
        __kernings = null;
    }
    
    /** Adds kerning information relative to a specific other character ID. */
    public function addKerning(charID:Int, amount:Float):Void
    {
        if (__kernings == null)
            __kernings = new Map<Int, Float>();
        
        __kernings[charID] = amount;
    }
    
    /** Retrieve kerning information relative to the given character ID. */
    public function getKerning(charID:Int):Float
    {
        if (__kernings == null || __kernings[charID] == null) return 0.0;
        else return __kernings[charID];
    }
    
    /** Creates an image of the char. */
    public function createImage():Image
    {
        return new Image(__texture);
    }
    
    /** The unicode ID of the char. */
    public var charID(get, never):Int;
    private function get_charID():Int { return __charID; }
    
    /** The number of points to move the char in x direction on character arrangement. */
    public var xOffset(get, never):Float;
    private function get_xOffset():Float { return __xOffset; }
    
    /** The number of points to move the char in y direction on character arrangement. */
    public var yOffset(get, never):Float;
    private function get_yOffset():Float { return __yOffset; }
    
    /** The number of points the cursor has to be moved to the right for the next char. */
    public var xAdvance(get, never):Float;
    private function get_xAdvance():Float { return __xAdvance; }
    
    /** The texture of the character. */
    public var texture(get, never):Texture;
    private function get_texture():Texture { return __texture; }
    
    /** The width of the character in points. */
    public var width(get, never):Float;
    private function get_width():Float { return __texture != null ? __texture.width : 0; }
    
    /** The height of the character in points. */
    public var height(get, never):Float;
    private function get_height():Float { return __texture != null ? __texture.height : 0; }
}
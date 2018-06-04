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

@:jsRequire("starling/text/BitmapChar", "default")

extern class BitmapChar
{
    /** Creates a char with a texture and its properties. */
    public function new(id:Int, texture:Texture, 
                               xOffset:Float, yOffset:Float, xAdvance:Float);
    
    /** Adds kerning information relative to a specific other character ID. */
    public function addKerning(charID:Int, amount:Float):Void;
    
    /** Retrieve kerning information relative to the given character ID. */
    public function getKerning(charID:Int):Float;
    
    /** Creates an image of the char. */
    public function createImage():Image;
    
    /** The unicode ID of the char. */
    public var charID(get, never):Int;
    private function get_charID():Int;
    
    /** The number of points to move the char in x direction on character arrangement. */
    public var xOffset(get, never):Float;
    private function get_xOffset():Float;
    
    /** The number of points to move the char in y direction on character arrangement. */
    public var yOffset(get, never):Float;
    private function get_yOffset():Float;
    
    /** The number of points the cursor has to be moved to the right for the next char. */
    public var xAdvance(get, never):Float;
    private function get_xAdvance():Float;
    
    /** The texture of the character. */
    public var texture(get, never):Texture;
    private function get_texture():Texture;
    
    /** The width of the character in points. */
    public var width(get, never):Float;
    private function get_width():Float;
    
    /** The height of the character in points. */
    public var height(get, never):Float;
    private function get_height():Float;
}
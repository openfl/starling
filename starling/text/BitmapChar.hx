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
import flash.utils.Dictionary;

import starling.display.Image;
import starling.textures.Texture;

/** A BitmapChar contains the information about one char of a bitmap font.  
 *  <em>You don't have to use this class directly in most cases. 
 *  The TextField class contains methods that handle bitmap fonts for you.</em>    
 */ 
public class BitmapChar
{
    private var mTexture:Texture;
    private var mCharID:Int;
    private var mXOffset:Float;
    private var mYOffset:Float;
    private var mXAdvance:Float;
    private var mKernings:Dictionary;
    
    /** Creates a char with a texture and its properties. */
    public function BitmapChar(id:Int, texture:Texture, 
                               xOffset:Float, yOffset:Float, xAdvance:Float)
    {
        mCharID = id;
        mTexture = texture;
        mXOffset = xOffset;
        mYOffset = yOffset;
        mXAdvance = xAdvance;
        mKernings = null;
    }
    
    /** Adds kerning information relative to a specific other character ID. */
    public function addKerning(charID:Int, amount:Float):Void
    {
        if (mKernings == null)
            mKernings = new Dictionary();
        
        mKernings[charID] = amount;
    }
    
    /** Retrieve kerning information relative to the given character ID. */
    public function getKerning(charID:Int):Float
    {
        if (mKernings == null || mKernings[charID] == undefined) return 0.0;
        else return mKernings[charID];
    }
    
    /** Creates an image of the char. */
    public function createImage():Image
    {
        return new Image(mTexture);
    }
    
    /** The unicode ID of the char. */
    public function get charID():Int { return mCharID; }
    
    /** The number of points to move the char in x direction on character arrangement. */
    public function get xOffset():Float { return mXOffset; }
    
    /** The number of points to move the char in y direction on character arrangement. */
    public function get yOffset():Float { return mYOffset; }
    
    /** The number of points the cursor has to be moved to the right for the next char. */
    public function get xAdvance():Float { return mXAdvance; }
    
    /** The texture of the character. */
    public function get texture():Texture { return mTexture; }
    
    /** The width of the character in points. */
    public function get width():Float { return mTexture.width; }
    
    /** The height of the character in points. */
    public function get height():Float { return mTexture.height; }
}
}
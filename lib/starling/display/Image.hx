// =================================================================================================
//
//	Starling Framework
//	Copyright Gamua GmbH. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

package starling.display;

import openfl.geom.Rectangle;
import openfl.Vector;

import starling.rendering.IndexData;
import starling.rendering.VertexData;
import starling.textures.Texture;
import starling.utils.MathUtil;
import starling.utils.Padding;
import starling.utils.Pool;
import starling.utils.RectangleUtil;
import starling.utils.Execute;

/** An Image is a quad with a texture mapped onto it.
 *
 *  <p>Typically, the Image class will act as an equivalent of Flash's Bitmap class. Instead
 *  of BitmapData, Starling uses textures to represent the pixels of an image. To display a
 *  texture, you have to map it onto a quad - and that's what the Image class is for.</p>
 *
 *  <p>While the base class <code>Quad</code> already supports textures, the <code>Image</code>
 *  class adds some additional functionality.</p>
 *
 *  <p>First of all, it provides a convenient constructor that will automatically synchronize
 *  the size of the image with the displayed texture.</p>
 *
 *  <p>Furthermore, it adds support for a "Scale9" grid. This splits up the image into
 *  nine regions, the corners of which will always maintain their original size.
 *  The center region stretches in both directions to fill the remaining space; the side
 *  regions will stretch accordingly in either horizontal or vertical direction.</p>
 *
 *  <p>Finally, you can repeat a texture horizontally and vertically within the image's region,
 *  just like the tiles of a wallpaper. Use the <code>tileGrid</code> property to do that.</p>
 *
 *  @see starling.textures.Texture
 *  @see Quad
 */

@:jsRequire("starling/display/Image", "default")

extern class Image extends Quad
{
    /** Creates an image with a texture mapped onto it. */
    public function new(texture:Texture);

    /** The current scaling grid that is in effect. If set to null, the image is scaled just
     *  like any other display object; assigning a rectangle will divide the image into a grid
     *  of nine regions, based on the center rectangle. The four corners of this grid will
     *  always maintain their original size; the other regions will stretch (horizontally,
     *  vertically, or both) to fill the complete area.
     *
     *  <p>Notes:</p>
     *
     *  <ul>
     *  <li>Assigning a Scale9 rectangle will change the number of vertices to a maximum of 16
     *  (less if possible) and all vertices will be colored like vertex 0 (the top left vertex).
     *  </li>
     *  <li>For Scale3-grid behavior, assign a zero size for all but the center row / column.
     *  This will cause the 'caps' to scale in a way that leaves the aspect ratio intact.</li>
     *  <li>An image can have either a <code>scale9Grid</code> or a <code>tileGrid</code>, but
     *  not both. Assigning one will delete the other.</li>
     *  <li>Changes will only be applied on assignment. To force an update, simply call
     *  <code>image.scale9Grid = image.scale9Grid</code>.</li>
     *  <li>Assignment causes an implicit call to <code>readjustSize()</code>,
     *  and the same will happen when the texture is changed afterwards.</li>
     *  </ul>
     *
     *  @default null
     */
    public var scale9Grid(get, set):Rectangle;
    private function get_scale9Grid():Rectangle;
    private function set_scale9Grid(value:Rectangle):Rectangle;

    /** The current tiling grid that is in effect. If set to null, the image is scaled just
     *  like any other display object; assigning a rectangle will divide the image into a grid
     *  displaying the current texture in each and every cell. The assigned rectangle points
     *  to the bounds of one cell; all other elements will be calculated accordingly. A zero
     *  or negative value for the rectangle's width or height will be replaced with the actual
     *  texture size. Thus, you can make a 2x2 grid simply like this:
     *
     *  <listing>
     *  var image:Image = new Image(texture);
     *  image.tileGrid = new Rectangle();
     *  image.scale = 2;</listing>
     *
     *  <p>Notes:</p>
     *
     *  <ul>
     *  <li>Assigning a tile rectangle will change the number of vertices to whatever is
     *  required by the grid. New vertices will be colored just like vertex 0 (the top left
     *  vertex).</li>
     *  <li>An image can have either a <code>scale9Grid</code> or a <code>tileGrid</code>, but
     *  not both. Assigning one will delete the other.</li>
     *  <li>Changes will only be applied on assignment. To force an update, simply call
     *  <code>image.tileGrid = image.tileGrid</code>.</li>
     *  </ul>
     *
     *  @default null
     */
    public var tileGrid(get, set):Rectangle;
    private function get_tileGrid():Rectangle;
    private function set_tileGrid(value:Rectangle):Rectangle;
    
    // bindings

    /** Injects code that is called by all instances whenever the given texture is assigned or replaced.
     *  The new functions will be executed after any existing ones.
     * 
     *  @param texture    Assignment of this texture instance will lead to the following callback(s) being executed.
     *  @param onAssign   Called when the texture is assigned. Receives one parameter of type 'Image'.
     *  @param onRelease  Called when the texture is replaced. Receives one parameter of type 'Image'. (Optional.)
     */
    public static function automateSetupForTexture(texture:Texture, onAssign:Image->Void, onRelease:Image->Void=null):Void;

    /** Removes all custom setup functions for the given texture, including those created via
     *  'bindScale9GridToTexture' and 'bindPivotPointToTexture'. */
    public static function resetSetupForTexture(texture:Texture):Void;

    /** Removes specific setup functions for the given texture. */
    public static function removeSetupForTexture(texture:Texture, onAssign:Image->Void, onRelease:Image->Void=null):Void;

    /** Binds the given scaling grid to the given texture so that any image which displays the texture will
     *  automatically use the grid. */
    public static function bindScale9GridToTexture(texture:Texture, scale9Grid:Rectangle):Void;
    
    /** Binds the given pivot point to the given texture so that any image which displays the texture will
     *  automatically use the pivot point. */
    public static function bindPivotPointToTexture(texture:Texture, pivotX:Float, pivotY:Float):Void;
}

extern class SetupAutomator
{
    public function new(onAssign:Image->Void, onRelease:Image->Void);

    public function add(onAssign:Image->Void, onRelease:Image->Void):Void;

    public function remove(onAssign:Image->Void, onRelease:Image->Void):Void;

    public function onAssign(image:Image):Void;

    public function onRelease(image:Image):Void;
}
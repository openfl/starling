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
class Image extends Quad
{
    @:noCompletion private var __scale9Grid:Rectangle;
    @:noCompletion private var __tileGrid:Rectangle;

    private static var sAutomators = new Map<Texture, SetupAutomator>();

    // helper objects
    private static var sPadding:Padding = new Padding();
    private static var sBounds:Rectangle = new Rectangle();
    private static var sBasCols:Vector<Float> = new Vector<Float>(3, true);
    private static var sBasRows:Vector<Float> = new Vector<Float>(3, true);
    private static var sPosCols:Vector<Float> = new Vector<Float>(3, true);
    private static var sPosRows:Vector<Float> = new Vector<Float>(3, true);
    private static var sTexCols:Vector<Float> = new Vector<Float>(3, true);
    private static var sTexRows:Vector<Float> = new Vector<Float>(3, true);

    #if commonjs
    private static function __init__ () {
        
        untyped Object.defineProperties (Image.prototype, {
            "scale9Grid": { get: untyped __js__ ("function () { return this.get_scale9Grid (); }"), set: untyped __js__ ("function (v) { return this.set_scale9Grid (v); }") },
            "tileGrid": { get: untyped __js__ ("function () { return this.get_tileGrid (); }"), set: untyped __js__ ("function (v) { return this.set_tileGrid (v); }") },
        });
        
    }
    #end

    /** Creates an image with a texture mapped onto it. */
    public function new(texture:Texture)
    {
        super(100, 100);
        this.texture = texture;
        readjustSize();
    }

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
    private function get_scale9Grid():Rectangle { return __scale9Grid; }
    private function set_scale9Grid(value:Rectangle):Rectangle
    {
        if (value != null)
        {
            if (__scale9Grid == null) __scale9Grid = value.clone();
            else __scale9Grid.copyFrom(value);

            readjustSize();
            __tileGrid = null;
        }
        else __scale9Grid = null;

        __setupVertices();
        
        return value;
    }

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
    private function get_tileGrid():Rectangle { return __tileGrid; }
    private function set_tileGrid(value:Rectangle):Rectangle
    {
        if (value != null)
        {
            if (__tileGrid == null) __tileGrid = value.clone();
            else __tileGrid.copyFrom(value);

            __scale9Grid = null;
        }
        else __tileGrid = null;

        __setupVertices();
        
        return value;
    }

    /** @private */
    override private function __setupVertices():Void
    {
        if (texture != null && __scale9Grid != null) __setupScale9Grid();
        else if (texture != null && __tileGrid != null) __setupTileGrid();
        else super.__setupVertices();
    }

    /** @private */
    override private function set_scaleX(value:Float):Float
    {
        super.scaleX = value;
        if (texture != null && (__scale9Grid != null || __tileGrid != null)) __setupVertices();
        return value;
    }

    /** @private */
    override private function set_scaleY(value:Float):Float
    {
        super.scaleY = value;
        if (texture != null && (__scale9Grid != null || __tileGrid != null)) __setupVertices();
        return value;
    }

    /** @private */
    override private function set_texture(value:Texture):Texture
    {
        if (value != texture)
        {
            var setupAutomator:SetupAutomator = null;
            
            if (texture != null && sAutomators.exists(texture))
            {
                setupAutomator = sAutomators[texture];
                if (setupAutomator.onRelease != null)
                    setupAutomator.onRelease(this);
            }

            super.texture = value;
            
            if (value != null && sAutomators.exists(value))
            {
                setupAutomator = sAutomators[value];
                if (setupAutomator.onAssign != null)
                    setupAutomator.onAssign(this);
            }
            else if (__scale9Grid != null && value != null)
                readjustSize();
        }
        return value;
    }

    // vertex setup

    @:noCompletion private function __setupScale9Grid():Void
    {
        var texture:Texture = this.texture;
        var frame:Rectangle = texture.frame;
        var absScaleX:Float = scaleX > 0 ? scaleX : -scaleX;
        var absScaleY:Float = scaleY > 0 ? scaleY : -scaleY;

        if (absScaleX == 0.0 || absScaleY == 0) return;

        // If top and bottom row / left and right column are empty, this is actually
        // a scale3 grid. In that case, we want the 'caps' to maintain their aspect ratio.

        if (MathUtil.isEquivalent(__scale9Grid.width, texture.frameWidth))
            absScaleY /= absScaleX;
        else if (MathUtil.isEquivalent(__scale9Grid.height, texture.frameHeight))
            absScaleX /= absScaleY;

        var invScaleX:Float = 1.0 / absScaleX;
        var invScaleY:Float = 1.0 / absScaleY;
        var vertexData:VertexData = this.vertexData;
        var indexData:IndexData = this.indexData;
        var prevNumVertices:Int = vertexData.numVertices;
        var numVertices:Int, numQuads:Int;
        var correction:Float;

        // The following rectangles are used to figure everything out.
        // The meaning of each is depicted in this sketch: http://i.imgur.com/KUcv71O.jpg

        var gridCenter:Rectangle = Pool.getRectangle();
        var textureBounds:Rectangle = Pool.getRectangle();
        var pixelBounds:Rectangle = Pool.getRectangle();
        var intersection:Rectangle = Pool.getRectangle();

        gridCenter.copyFrom(__scale9Grid);
        textureBounds.setTo(0, 0, texture.frameWidth, texture.frameHeight);

        if (frame != null) pixelBounds.setTo(-frame.x, -frame.y, texture.width, texture.height);
        else               pixelBounds.copyFrom(textureBounds);

        // calculate 3x3 grid according to texture and scale9 properties,
        // taking special care about the texture frame (headache included)

        RectangleUtil.intersect(gridCenter, pixelBounds, intersection);

        sBasCols[0] = sBasCols[2] = 0;
        sBasRows[0] = sBasRows[2] = 0;
        sBasCols[1] = intersection.width;
        sBasRows[1] = intersection.height;

        if (pixelBounds.x < gridCenter.x)
            sBasCols[0] = gridCenter.x - pixelBounds.x;

        if (pixelBounds.y < gridCenter.y)
            sBasRows[0] = gridCenter.y - pixelBounds.y;

        if (pixelBounds.right > gridCenter.right)
            sBasCols[2] = pixelBounds.right - gridCenter.right;

        if (pixelBounds.bottom > gridCenter.bottom)
            sBasRows[2] = pixelBounds.bottom - gridCenter.bottom;

        // set vertex positions

        if (pixelBounds.x < gridCenter.x)
            sPadding.left = pixelBounds.x * invScaleX;
        else
            sPadding.left = gridCenter.x * invScaleX + pixelBounds.x - gridCenter.x;

        if (pixelBounds.right > gridCenter.right)
            sPadding.right = (textureBounds.width - pixelBounds.right) * invScaleX;
        else
            sPadding.right = (textureBounds.width - gridCenter.right) * invScaleX + gridCenter.right - pixelBounds.right;

        if (pixelBounds.y < gridCenter.y)
            sPadding.top = pixelBounds.y * invScaleY;
        else
            sPadding.top = gridCenter.y * invScaleY + pixelBounds.y - gridCenter.y;

        if (pixelBounds.bottom > gridCenter.bottom)
            sPadding.bottom = (textureBounds.height - pixelBounds.bottom) * invScaleY;
        else
            sPadding.bottom = (textureBounds.height - gridCenter.bottom) * invScaleY + gridCenter.bottom - pixelBounds.bottom;

        sPosCols[0] = sBasCols[0] * invScaleX;
        sPosCols[2] = sBasCols[2] * invScaleX;
        sPosCols[1] = textureBounds.width - sPadding.left - sPadding.right - sPosCols[0] - sPosCols[2];

        sPosRows[0] = sBasRows[0] * invScaleY;
        sPosRows[2] = sBasRows[2] * invScaleY;
        sPosRows[1] = textureBounds.height - sPadding.top - sPadding.bottom - sPosRows[0] - sPosRows[2];

        // if the total width / height becomes smaller than the outer columns / rows,
        // we hide the center column / row and scale the rest normally.

        if (sPosCols[1] <= 0)
        {
            correction = textureBounds.width / (textureBounds.width - gridCenter.width) * absScaleX;
            sPadding.left *= correction;
            sPosCols[0] *= correction;
            sPosCols[1]  = 0.0;
            sPosCols[2] *= correction;
        }

        if (sPosRows[1] <= 0)
        {
            correction = textureBounds.height / (textureBounds.height - gridCenter.height) * absScaleY;
            sPadding.top *= correction;
            sPosRows[0] *= correction;
            sPosRows[1]  = 0.0;
            sPosRows[2] *= correction;
        }

        // now set the texture coordinates

        sTexCols[0] = sBasCols[0] / pixelBounds.width;
        sTexCols[2] = sBasCols[2] / pixelBounds.width;
        sTexCols[1] = 1.0 - sTexCols[0] - sTexCols[2];

        sTexRows[0] = sBasRows[0] / pixelBounds.height;
        sTexRows[2] = sBasRows[2] / pixelBounds.height;
        sTexRows[1] = 1.0 - sTexRows[0] - sTexRows[2];

        numVertices = __setupScale9GridAttributes(
            sPadding.left, sPadding.top, sPosCols, sPosRows, sTexCols, sTexRows);

        // update indices

        numQuads = Std.int(numVertices / 4);
        vertexData.numVertices = numVertices;
        indexData.numIndices = 0;

        for (i in 0...numQuads)
            indexData.addQuad(i*4, i*4 + 1, i*4 + 2, i*4 + 3);

        // if we just switched from a normal to a scale9 image,
        // we need to colorize all vertices just like the first one.

        if (numVertices != prevNumVertices)
        {
            var color:UInt   = prevNumVertices != 0 ? vertexData.getColor(0) : 0xffffff;
            var alpha:Float  = prevNumVertices != 0 ? vertexData.getAlpha(0) : 1.0;
            vertexData.colorize("color", color, alpha);
        }

        Pool.putRectangle(textureBounds);
        Pool.putRectangle(pixelBounds);
        Pool.putRectangle(gridCenter);
        Pool.putRectangle(intersection);

        setRequiresRedraw();
    }

    @:noCompletion private function __setupScale9GridAttributes(startX:Float, startY:Float,
                                                 posCols:Vector<Float>, posRows:Vector<Float>,
                                                 texCols:Vector<Float>, texRows:Vector<Float>):Int
    {
        var posAttr:String = "position";
        var texAttr:String = "texCoords";

        var row:Int, col:Int;
        var colWidthPos:Float, rowHeightPos:Float;
        var colWidthTex:Float, rowHeightTex:Float;
        var vertexData:VertexData = this.vertexData;
        var texture:Texture = this.texture;
        var currentX:Float = startX;
        var currentY:Float = startY;
        var currentU:Float = 0.0;
        var currentV:Float = 0.0;
        var vertexID:Int = 0;

        for (row in 0...3)
        {
            rowHeightPos = posRows[row];
            rowHeightTex = texRows[row];

            if (rowHeightPos > 0)
            {
                for (col in 0...3)
                {
                    colWidthPos = posCols[col];
                    colWidthTex = texCols[col];

                    if (colWidthPos > 0)
                    {
                        vertexData.setPoint(vertexID, posAttr, currentX, currentY);
                        texture.setTexCoords(vertexData, vertexID, texAttr, currentU, currentV);
                        vertexID++;

                        vertexData.setPoint(vertexID, posAttr, currentX + colWidthPos, currentY);
                        texture.setTexCoords(vertexData, vertexID, texAttr, currentU + colWidthTex, currentV);
                        vertexID++;

                        vertexData.setPoint(vertexID, posAttr, currentX, currentY + rowHeightPos);
                        texture.setTexCoords(vertexData, vertexID, texAttr, currentU, currentV + rowHeightTex);
                        vertexID++;

                        vertexData.setPoint(vertexID, posAttr, currentX + colWidthPos, currentY + rowHeightPos);
                        texture.setTexCoords(vertexData, vertexID, texAttr, currentU + colWidthTex, currentV + rowHeightTex);
                        vertexID++;

                        currentX += colWidthPos;
                    }

                    currentU += colWidthTex;
                }

                currentY += rowHeightPos;
            }

            currentX = startX;
            currentU = 0.0;
            currentV += rowHeightTex;
        }

        return vertexID;
    }

    @:noCompletion private function __setupTileGrid():Void
    {
        // calculate the grid of vertices simulating a repeating / tiled texture.
        // again, texture frames make this somewhat more complicated than one would think.

        var texture:Texture = this.texture;
        var frame:Rectangle = texture.frame;
        var vertexData:VertexData = this.vertexData;
        var indexData:IndexData   = this.indexData;
        var bounds:Rectangle = getBounds(this, sBounds);
        var prevNumVertices:Int = vertexData.numVertices;
        var color:UInt   = prevNumVertices != 0 ? vertexData.getColor(0) : 0xffffff;
        var alpha:Float  = prevNumVertices != 0 ? vertexData.getAlpha(0) : 1.0;
        var invScaleX:Float = scaleX > 0 ? 1.0 / scaleX : -1.0 / scaleX;
        var invScaleY:Float = scaleY > 0 ? 1.0 / scaleY : -1.0 / scaleY;
        var frameWidth:Float  = __tileGrid.width  > 0 ? __tileGrid.width  : texture.frameWidth;
        var frameHeight:Float = __tileGrid.height > 0 ? __tileGrid.height : texture.frameHeight;

        frameWidth  *= invScaleX;
        frameHeight *= invScaleY;

        var tileX:Float = frame != null ? -frame.x * (frameWidth  / frame.width)  : 0;
        var tileY:Float = frame != null ? -frame.y * (frameHeight / frame.height) : 0;
        var tileWidth:Float  = texture.width  * (frameWidth  / texture.frameWidth);
        var tileHeight:Float = texture.height * (frameHeight / texture.frameHeight);
        var modX:Float = (__tileGrid.x * invScaleX) % frameWidth;
        var modY:Float = (__tileGrid.y * invScaleY) % frameHeight;

        if (modX < 0) modX += frameWidth;
        if (modY < 0) modY += frameHeight;

        var startX:Float = modX + tileX;
        var startY:Float = modY + tileY;

        if (startX > (frameWidth  - tileWidth))  startX -= frameWidth;
        if (startY > (frameHeight - tileHeight)) startY -= frameHeight;

        var posLeft:Float, posRight:Float, posTop:Float, posBottom:Float;
        var texLeft:Float, texRight:Float, texTop:Float, texBottom:Float;
        var posAttrName:String = "position";
        var texAttrName:String = "texCoords";
        var currentX:Float;
        var currentY:Float = startY;
        var vertexID:Int = 0;

        indexData.numIndices = 0;

        while (currentY < bounds.height)
        {
            currentX = startX;

            while (currentX < bounds.width)
            {
                indexData.addQuad(vertexID, vertexID + 1, vertexID + 2, vertexID + 3);

                posLeft   = currentX < 0 ? 0 : currentX;
                posTop    = currentY < 0 ? 0 : currentY;
                posRight  = currentX + tileWidth  > bounds.width  ? bounds.width  : currentX + tileWidth;
                posBottom = currentY + tileHeight > bounds.height ? bounds.height : currentY + tileHeight;

                vertexData.setPoint(vertexID,     posAttrName, posLeft,  posTop);
                vertexData.setPoint(vertexID + 1, posAttrName, posRight, posTop);
                vertexData.setPoint(vertexID + 2, posAttrName, posLeft,  posBottom);
                vertexData.setPoint(vertexID + 3, posAttrName, posRight, posBottom);

                texLeft   = (posLeft   - currentX) / tileWidth;
                texTop    = (posTop    - currentY) / tileHeight;
                texRight  = (posRight  - currentX) / tileWidth;
                texBottom = (posBottom - currentY) / tileHeight;

                texture.setTexCoords(vertexData, vertexID,     texAttrName, texLeft,  texTop);
                texture.setTexCoords(vertexData, vertexID + 1, texAttrName, texRight, texTop);
                texture.setTexCoords(vertexData, vertexID + 2, texAttrName, texLeft,  texBottom);
                texture.setTexCoords(vertexData, vertexID + 3, texAttrName, texRight, texBottom);

                currentX += frameWidth;
                vertexID += 4;
            }

            currentY += frameHeight;
        }

        // trim to actual size
        vertexData.numVertices = vertexID;

        for (i in prevNumVertices...vertexID)
        {
            vertexData.setColor(i, "color", color);
            vertexData.setAlpha(i, "color", alpha);
        }

        setRequiresRedraw();
    }
    
    // bindings

    /** Injects code that is called by all instances whenever the given texture is assigned or replaced.
     *  The new functions will be executed after any existing ones.
     * 
     *  @param texture    Assignment of this texture instance will lead to the following callback(s) being executed.
     *  @param onAssign   Called when the texture is assigned. Receives one parameter of type 'Image'.
     *  @param onRelease  Called when the texture is replaced. Receives one parameter of type 'Image'. (Optional.)
     */
    public static function automateSetupForTexture(texture:Texture, onAssign:Image->Void, onRelease:Image->Void=null):Void
    {
        var automator:SetupAutomator = sAutomators[texture];
        if (automator != null) automator.add(onAssign, onRelease);
        else sAutomators[texture] = new SetupAutomator(onAssign, onRelease);
    }

    /** Removes all custom setup functions for the given texture, including those created via
     *  'bindScale9GridToTexture' and 'bindPivotPointToTexture'. */
    public static function resetSetupForTexture(texture:Texture):Void
    {
       sAutomators.remove(texture);
    }

    /** Removes specific setup functions for the given texture. */
    public static function removeSetupForTexture(texture:Texture, onAssign:Image->Void, onRelease:Image->Void=null):Void
    {
        var automator:SetupAutomator = sAutomators[texture];
        if (automator != null) automator.remove(onAssign, onRelease);
    }

    /** Binds the given scaling grid to the given texture so that any image which displays the texture will
     *  automatically use the grid. */
    public static function bindScale9GridToTexture(texture:Texture, scale9Grid:Rectangle):Void
    {
        automateSetupForTexture(texture,
            function(image:Image):Void { image.scale9Grid = scale9Grid; },
            function(image:Image):Void { image.scale9Grid = null; });
    }
    
    /** Binds the given pivot point to the given texture so that any image which displays the texture will
     *  automatically use the pivot point. */
    public static function bindPivotPointToTexture(texture:Texture, pivotX:Float, pivotY:Float):Void
    {
        automateSetupForTexture(texture,
            function(image:Image):Void { image.pivotX = pivotX; image.pivotY = pivotY; },
            function(image:Image):Void { image.pivotX = image.pivotY = 0; });
    }
}

class SetupAutomator
{
    private var _onAssign:Array<Image->Void>;
    private var _onRelease:Array<Image->Void>;

    public function new(onAssign:Image->Void, onRelease:Image->Void)
    {
        _onAssign = new Array<Image->Void>();
        _onRelease = new Array<Image->Void>();
        add(onAssign, onRelease);
    }

    public function add(onAssign:Image->Void, onRelease:Image->Void):Void
    {
        if (onAssign != null && _onAssign.indexOf(onAssign) == -1)
            _onAssign[_onAssign.length] = onAssign;

        if (onRelease != null && _onRelease.indexOf(onRelease) == -1)
            _onRelease[_onRelease.length] = onRelease;
    }

    public function remove(onAssign:Image->Void, onRelease:Image->Void):Void
    {
        if (onAssign != null)
            _onAssign.remove(onAssign);

        if (onRelease != null)
            _onRelease.remove(onRelease);
    }

    public function onAssign(image:Image):Void
    {
        var count:Int = _onAssign.length;
        for (i in 0...count)
            Execute.execute(_onAssign[i], [image]);
    }

    public function onRelease(image:Image):Void
    {
        var count:Int = _onRelease.length;
        for (i in 0...count)
            Execute.execute(_onRelease[i], [image]);
    }
}
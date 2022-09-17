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

import openfl.geom.Point;
import openfl.Vector;

import starling.geom.Polygon;
import starling.rendering.IndexData;
import starling.rendering.VertexData;

/** A display object supporting basic vector drawing functionality. In its current state,
 *  the main use of this class is to provide a range of forms that can be used as masks.
 */
class Canvas extends DisplayObjectContainer
{
    private var __polygons:Vector<Polygon>;
    private var __fillColor:UInt;
    private var __fillAlpha:Float;

    /** Creates a new (empty) Canvas. Call one or more of the 'draw' methods to add content. */
    public function new()
    {
        super();

        __polygons  = new Vector<Polygon>();
        __fillColor = 0xffffff;
        __fillAlpha = 1.0;
        touchGroup  = true;
    }

    /** @inheritDoc */
    public override function dispose():Void
    {
        __polygons.length = 0;
        super.dispose();
    }

    /** @inheritDoc */
    public override function hitTest(localPoint:Point):DisplayObject
    {
        if (!visible || !touchable || !hitTestMask(localPoint)) return null;

        // we could also use the standard hit test implementation, but the polygon class can
        // do that much more efficiently (it contains custom implementations for circles, etc).

        var len:Int = __polygons.length;
        for (i in 0...len)
            if (__polygons[i].containsPoint(localPoint)) return this;

        return null;
    }

    /** Draws a circle.
	 *
	 * @param x         x-coordinate of center point
	 * @param y         y-coordinate of center point
	 * @param radius    radius of circle
	 * @param numSides  the number of lines used to draw the circle.
	 *                  If you don't pass anything, Starling will pick a reasonable value.
	 */
    public function drawCircle(x:Float, y:Float, radius:Float, numSides:Int = -1):Void
    {
        __appendPolygon(Polygon.createCircle(x, y, radius, numSides));
    }

    /** Draws an ellipse.
	 *
	 * @param x         x-coordinate of bounding box
	 * @param y         y-coordinate of bounding box
	 * @param width     width of the ellipse
	 * @param height    height of the ellipse
	 * @param numSides  the number of lines used to draw the ellipse.
	 *                  If you don't pass anything, Starling will pick a reasonable value.
	 */
    public function drawEllipse(x:Float, y:Float, width:Float, height:Float, numSides:Int = -1):Void
    {
        var radiusX:Float = width  / 2.0;
        var radiusY:Float = height / 2.0;

        __appendPolygon(Polygon.createEllipse(x + radiusX, y + radiusY, radiusX, radiusY, numSides));
    }

    /** Draws a rectangle. */
    public function drawRectangle(x:Float, y:Float, width:Float, height:Float):Void
    {
        __appendPolygon(Polygon.createRectangle(x, y, width, height));
    }

    /** Draws an arbitrary polygon. */
    public function drawPolygon(polygon:Polygon):Void
    {
        __appendPolygon(polygon);
    }

    /** Specifies a simple one-color fill that subsequent calls to drawing methods
     * (such as <code>drawCircle()</code>) will use. */
    public function beginFill(color:UInt=0xffffff, alpha:Float=1.0):Void
    {
        __fillColor = color;
        __fillAlpha = alpha;
    }

    /** Resets the color to 'white' and alpha to '1'. */
    public function endFill():Void
    {
        __fillColor = 0xffffff;
        __fillAlpha = 1.0;
    }

    /** Removes all existing vertices. */
    public function clear():Void
    {
        removeChildren(0, -1, true);
        __polygons.length = 0;
    }

    private function __appendPolygon(polygon:Polygon):Void
    {
        var vertexData:VertexData = new VertexData();
        var indexData:IndexData = new IndexData(polygon.numTriangles * 3);

        polygon.triangulate(indexData);
        polygon.copyToVertexData(vertexData);

        vertexData.colorize("color", __fillColor, __fillAlpha);

        addChild(new Mesh(vertexData, indexData));
        __polygons[__polygons.length] = polygon;
    }
}
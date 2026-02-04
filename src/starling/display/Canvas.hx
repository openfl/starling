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

import openfl.display.IGraphicsData;
import openfl.display.GraphicsSolidFill;
import openfl.display.GraphicsPath;
import openfl.display.GraphicsPathCommand;
import openfl.display.GraphicsEndFill;
import openfl.geom.Point;
import openfl.Vector;

import starling.geom.Polygon;
import starling.rendering.IndexData;
import starling.rendering.VertexData;
import starling.utils.MathUtil.rad2deg;

/** A display object supporting basic vector drawing functionality. In its current state,
 *  the main use of this class is to provide a range of forms that can be used as masks.
 */
class Canvas extends DisplayObjectContainer
{
    @:noCompletion private var __polygons:Vector<Polygon>;
	@:noCompletion private var __currentPath:Vector<Float>;
    @:noCompletion private var __fillColor:UInt;
    @:noCompletion private var __fillAlpha:Float;

    /** Creates a new (empty) Canvas. Call one or more of the 'draw' methods to add content. */
    public function new()
    {
        super();

        __polygons  = new Vector<Polygon>();
		__currentPath = new Vector<Float>();
        __fillColor = 0xffffff;
        __fillAlpha = 1.0;
        touchGroup  = true;
    }

    /** @inheritDoc */
    public override function dispose():Void
    {
        __polygons.length = 0;
		__currentPath.length = 0;
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
        drawPolygon(Polygon.createCircle(x, y, radius, numSides));
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
        var radiusX:Float = width / 2.0;
        var radiusY:Float = height / 2.0;

        drawPolygon(Polygon.createEllipse(x + radiusX, y + radiusY, radiusX, radiusY, numSides));
    }

    /** Draws a rectangle. */
    public function drawRectangle(x:Float, y:Float, width:Float, height:Float):Void
    {
        drawPolygon(Polygon.createRectangle(x, y, width, height));
    }
	
	public function drawRoundRectangle(x:Float, y:Float, width:Float, height:Float, ellipseWidth:Float, ?ellipseHeight:Float):Void
	{
		if (ellipseHeight == null) ellipseHeight = Math.NaN;
		drawPolygon(Polygon.createRoundRectangle(x, y, width, height, ellipseWidth, ellipseHeight));
	}

    /** Specifies a simple one-color fill that subsequent calls to drawing methods
     * (such as <code>drawCircle()</code>) will use. */
    public function beginFill(color:UInt=0xffffff, alpha:Float=1.0):Void
    {
		closeCurrentPathIfNeeded();
        __fillColor = color;
        __fillAlpha = alpha;
    }

    /** Resets the color to 'white' and alpha to '1'. */
    public function endFill():Void
    {
		closeCurrentPathIfNeeded();
        __fillColor = 0xffffff;
        __fillAlpha = 1.0;
    }

    /** Moves the current drawing position to (x, y).
     *
     * @param x         A Float that indicates the horizontal position relative to the registration point of the parent display object (in pixels).
     * @param y         A Float that indicates the vertical position relative to the registration point of the parent display object (in pixels).
     */
    public function moveTo(x:Float, y:Float):Void
    {
        // If a previous path is still open, close it automatically before starting a new one.
		// This matches Flash's Graphics behavior, where a new MOVE_TO implicitly ends the
		// current sub-path.
		closeCurrentPathIfNeeded();
		
        __currentPath.length = 0;
        __currentPath.push(x);
        __currentPath.push(y);
    }

    /** Draws a line using the current line style from the current drawing position to (x, y); the current drawing position is then set to (x, y).
     *
     * @param x         A Float that indicates the horizontal position relative to the registration point of the parent display object (in pixels).
     * @param y         A Float that indicates the vertical position relative to the registration point of the parent display object (in pixels).
     */
    public function lineTo(x:Float, y:Float):Void
    {
        // TODO: This implementation too simple for strokes, only works for fills
        if (__currentPath.length == 0)
        {
			// Behave like Flash's Graphics: if there's no current point, start at (0, 0).
            __currentPath.push(0);
            __currentPath.push(0);
        }
        __currentPath.push(x);
        __currentPath.push(y);
        __drawPathIfClosed();
    }

    /**  Draws a quadratic Bezier curve using the current line style from the current drawing position to (anchorX, anchorY) and using the control point that (controlX, controlY) specifies.
     *
     * @param controlX        A Float that specifies the horizontal position of the control point relative to the registration point of the parent display object.
     * @param controlY        A Float that specifies the vertical position of the control point relative to the registration point of the parent display object.
     * @param anchorX         A Float that specifies the horizontal position of the next anchor point relative to the registration point of the parent display object.
     * @param anchorY         A Float that specifies the vertical position of the next anchor point relative to the registration point of the parent display object.
     */
    public function curveTo(controlX:Float, controlY:Float, anchorX:Float, anchorY:Float):Void
    {
        if (__currentPath.length == 0)
        {
			// Behave like Flash's Graphics: if there's no current point, start at (0, 0).
            __currentPath.push(0);
            __currentPath.push(0);
        }
        var lastX:Float = __currentPath[__currentPath.length - 2];
        var lastY:Float = __currentPath[__currentPath.length - 1];
        __tesselateCurve(lastX, lastY, controlX, controlY, anchorX, anchorY, __currentPath);
        __drawPathIfClosed();
    }
	
	/** Closes the current path if it contains an unfinished polygon. */
	private function closeCurrentPathIfNeeded():Void
	{
		if (__currentPath.length < 6) // fewer than 3 points -> nothing meaningful to close
			return;
		
		var firstX:Float = __currentPath[0];
		var firstY:Float = __currentPath[1];
		var lastX:Float = __currentPath[__currentPath.length - 2];
		var lastY:Float = __currentPath[__currentPath.length - 1];
		var isClosed:Bool = lastX == firstX && lastY == firstY;
		
		if (!isClosed)
		{
			__currentPath.push(firstX);
			__currentPath.push(firstY);
		}
		
		// Now draw and reset the path ('drawPathIfClosed' clears '_currentPath').
		__drawPathIfClosed();
	}

    /**  Submits a series of IGraphicsData instances for drawing. 
     *
     * @param graphicsData      A Vector containing graphics objects, each of which much implement the flash.display.IGraphicsData interface.
     */
    public function drawGraphicsData(graphicsData:Vector<IGraphicsData>):Void
    {
        var graphicsDataLength:Int = graphicsData.length;
        for (graphPropIndex in 0...graphicsDataLength)
        {
            var graphicsProperties:IGraphicsData = graphicsData[graphPropIndex];

            if (#if (haxe_ver < 4.2) Std.is #else Std.isOfType #end(graphicsProperties, GraphicsSolidFill)) 
                beginFill(cast(graphicsProperties, GraphicsSolidFill).color,
                cast(graphicsProperties, GraphicsSolidFill).alpha);
            else if (#if (haxe_ver < 4.2) Std.is #else Std.isOfType #end(graphicsProperties, GraphicsPath))
            {
                var i:Int = 0;
                var data:Vector<Float> = cast(graphicsProperties, GraphicsPath).data;

                var commandLength:Int = cast(graphicsProperties, GraphicsPath).commands.length;
                for (commandIndex in 0...commandLength)
                {
                    var command:Int = cast(graphicsProperties, GraphicsPath).commands[commandIndex];
                    switch (command)
                    {
                        case GraphicsPathCommand.MOVE_TO:
                            moveTo(data[i], data[i + 1]);
                            i += 2;

                        case GraphicsPathCommand.LINE_TO:
                            lineTo(data[i], data[i + 1]);
                            i += 2;

                        case GraphicsPathCommand.CURVE_TO:
                            curveTo(data[i], data[i + 1], data[i + 2], data[i + 3]);
                            i += 4;

                        default:
                            trace("[Starling] Canvas.drawGraphicsData: Unimplemented Command in Graphics Path of type", command);
                    }
                }
            }
            else if (#if (haxe_ver < 4.2) Std.is #else Std.isOfType #end(graphicsProperties, GraphicsEndFill)) endFill();
            else
                trace("[Starling] Canvas.drawGraphicsData: Unimplemented Graphics Data in input:", graphicsProperties, "at index",
                    graphicsData.indexOf(graphicsProperties));
        }
    }

    /** Removes all existing vertices. */
    public function clear():Void
    {
        removeChildren(0, -1, true);
        __polygons.length = 0;
		__currentPath.length = 0;
    }

    /** Draws an arbitrary polygon. */
    public function drawPolygon(polygon:Polygon):Void
    {
        var vertexData:VertexData = new VertexData();
        var indexData:IndexData = new IndexData(polygon.numTriangles * 3);

        polygon.triangulate(indexData);
        polygon.copyToVertexData(vertexData);

        vertexData.colorize("color", __fillColor, __fillAlpha);

        addChild(new Mesh(vertexData, indexData));
        __polygons[__polygons.length] = polygon;
    }

    /**   Func to tesselate a quadratic Curve using recursion, used in curveTo 
     *    Function converted to Haxe from the library TS AwayJS
     *    https://github.com/awayjs/graphics/blob/19c9c9912d0254934ba54c9b7049d1b898bf97f2/lib/draw/GraphicsFactoryHelper.ts#L376-L468
     */
    @:noCompletion private static function __tesselateCurve(startx:Float, starty:Float, cx:Float, cy:Float, endx:Float, endy:Float, array_out:Vector<Float>,
            iterationCnt:Float = 0):Void
    {
        var maxIterations:Float = 6;
        var minAngle:Float = 1;
        var minLengthSqr:Float = 1;

        // subdivide the curve
        var c1x:Float = (startx + cx) * 0.5; // new controlpoint 1
        var c1y:Float = (starty + cy) * 0.5;
        var c2x:Float = (cx + endx) * 0.5; // new controlpoint 2
        var c2y:Float = (cy + endy) * 0.5;
        var ax:Float = (c1x + c2x) * 0.5; // new middlepoint 1
        var ay:Float = (c1y + c2y) * 0.5;

        // stop tesselation on maxIteration level. Set it to 0 for no tesselation at all.
        if (iterationCnt >= maxIterations)
        {
            array_out.push(ax); 
            array_out.push(ay);
            array_out.push(endx); 
            array_out.push(endy);
            return;
        }

        // calculate length of segment
        // this does not include the crtl-point position
        var diff_x:Float = endx - startx;
        var diff_y:Float = endy - starty;
        var lenSq:Float = diff_x * diff_x + diff_y * diff_y;

        // stop subdividing if the angle or the length is to small
        if (lenSq < minLengthSqr)
        {
            array_out.push(endx); 
            array_out.push(endy);
            return;
        }

        // calculate angle between segments
        var angle_1:Float = rad2deg(Math.atan2(cy - starty, cx - startx));
        var angle_2:Float = rad2deg(Math.atan2(endy - cy, endx - cx));
        var angle_delta:Float = angle_2 - angle_1;

        // make sure angle is in range -180 - 180
        while (angle_delta > 180)
        {
            angle_delta -= 360;
        }
        while (angle_delta < -180)
        {
            angle_delta += 360;
        }

        angle_delta = angle_delta < 0 ? -angle_delta : angle_delta;

        // stop subdividing if the angle or the length is to small
        if (angle_delta <= minAngle)
        {
            array_out.push(endx); 
            array_out.push(endy);
            return;
        }

        iterationCnt++;

        __tesselateCurve(startx, starty, c1x, c1y, ax, ay, array_out, iterationCnt);
        __tesselateCurve(ax, ay, c2x, c2y, endx, endy, array_out, iterationCnt);
    }

    @:noCompletion private function __drawPathIfClosed():Void
    {
		if (__currentPath.length < 4) return; // need at least two points
		
        var lastX:Float = __currentPath[__currentPath.length - 2];
        var lastY:Float = __currentPath[__currentPath.length - 1];

        if (lastX == __currentPath[0] && lastY == __currentPath[1])
		{
			// Create a copy so we can safely clear the path afterwards.
            // Important: Polygon.fromVector() keeps a reference to the passed Vector (for
            // performance / to avoid allocations). If we passed '_currentPath' directly and
            // then cleared/reused it, we'd also modify the polygon's internal coordinates.
			var pathCopy:Vector<Float> = __currentPath.copy();
			__currentPath.length = 0;
			
            drawPolygon(Polygon.fromVector(pathCopy));
			
			// Keep the current position at the end of the closed path.
            // This matches Flash Graphics semantics: subsequent lineTo/curveTo calls continue
            // from the last point (which equals the start point after closing).
			__currentPath.push(lastX);
			__currentPath.push(lastY);
		}
    }
}

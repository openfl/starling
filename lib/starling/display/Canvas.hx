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

@:jsRequire("starling/display/Canvas", "default")

extern class Canvas extends DisplayObjectContainer
{
    /** Creates a new (empty) Canvas. Call one or more of the 'draw' methods to add content. */
    public function new();

    /** @inheritDoc */
    public override function dispose():Void;

    /** @inheritDoc */
    public override function hitTest(localPoint:Point):DisplayObject;

    /** Draws a circle. */
    public function drawCircle(x:Float, y:Float, radius:Float):Void;

    /** Draws an ellipse. */
    public function drawEllipse(x:Float, y:Float, width:Float, height:Float):Void;

    /** Draws a rectangle. */
    public function drawRectangle(x:Float, y:Float, width:Float, height:Float):Void;

    /** Draws an arbitrary polygon. */
    public function drawPolygon(polygon:Polygon):Void;

    /** Specifies a simple one-color fill that subsequent calls to drawing methods
     * (such as <code>drawCircle()</code>) will use. */
    public function beginFill(color:UInt=0xffffff, alpha:Float=1.0):Void;

    /** Resets the color to 'white' and alpha to '1'. */
    public function endFill():Void;

    /** Removes all existing vertices. */
    public function clear():Void;
}
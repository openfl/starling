// =================================================================================================
//
//	Starling Framework
//	Copyright Gamua GmbH. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

package starling.utils;

import openfl.errors.ArgumentError;
import openfl.geom.Matrix;
import openfl.geom.Matrix3D;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.geom.Vector3D;
import openfl.Vector;

/** A utility class containing methods related to the Rectangle class. */

@:jsRequire("starling/utils/RectangleUtil", "default")

extern class RectangleUtil
{
    /** Calculates the intersection between two Rectangles. If the rectangles do not intersect,
     *  this method returns an empty Rectangle object with its properties set to 0. */
    public static function intersect(rect1:Rectangle, rect2:Rectangle, 
                                     out:Rectangle=null):Rectangle;
    
    /** Calculates a rectangle with the same aspect ratio as the given 'rectangle',
     *  centered within 'into'.  
     * 
     *  <p>This method is useful for calculating the optimal viewPort for a certain display 
     *  size. You can use different scale modes to specify how the result should be calculated;
     *  furthermore, you can avoid pixel alignment errors by only allowing whole-number  
     *  multipliers/divisors (e.g. 3, 2, 1, 1/2, 1/3).</p>
     *  
     *  @see starling.utils.ScaleMode
     */
    public static function fit(rectangle:Rectangle, into:Rectangle, 
                               scaleMode:String="showAll", pixelPerfect:Bool=false,
                               out:Rectangle=null):Rectangle;

    /** If the rectangle contains negative values for width or height, all coordinates
     *  are adjusted so that the rectangle describes the same region with positive values. */
    public static function normalize(rect:Rectangle):Void;

    /** Extends the rectangle in all four directions. */
    public static function extend(rect:Rectangle, left:Float=0, right:Float=0,
                                  top:Float=0, bottom:Float=0):Void;

    /** Extends the rectangle in all four directions so that it is exactly on pixel bounds. */
    public static function extendToWholePixels(rect:Rectangle, scaleFactor:Float=1):Void;

    /** Calculates the bounds of a rectangle after transforming it by a matrix.
     *  If you pass an <code>out</code>-rectangle, the result will be stored in this rectangle
     *  instead of creating a new object. */
    public static function getBounds(rectangle:Rectangle, matrix:Matrix,
                                     out:Rectangle=null):Rectangle;

    /** Calculates the bounds of a rectangle projected into the XY-plane of a certain 3D space
     *  as they appear from the given camera position. Note that 'camPos' is expected in the
     *  target coordinate system (the same that the XY-plane lies in).
     *
     *  <p>If you pass an 'out' Rectangle, the result will be stored in this rectangle
     *  instead of creating a new object.</p> */
    public static function getBoundsProjected(rectangle:Rectangle, matrix:Matrix3D,
                                              camPos:Vector3D, out:Rectangle=null):Rectangle;

    /** Returns a vector containing the positions of the four edges of the given rectangle. */
    public static function getPositions(rectangle:Rectangle,
                                        out:Vector<Point>=null):Vector<Point>;

    /** Compares all properties of the given rectangle, returning true only if
     *  they are equal (with the given accuracy 'e'). */
    public static function compare(r1:Rectangle, r2:Rectangle, e:Float=0.0001):Bool;
}
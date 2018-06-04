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

import openfl.geom.Matrix;
import openfl.geom.Matrix3D;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.geom.Vector3D;
import openfl.Vector;

/** A simple object pool supporting the most basic utility objects.
 *
 *  <p>If you want to retrieve an object, but the pool does not contain any more instances,
 *  it will silently create a new one.</p>
 *
 *  <p>It's important that you use the pool in a balanced way, i.e. don't just "get" or "put"
 *  alone! Always make the calls in pairs; whenever you get an object, be sure to put it back
 *  later, and the other way round. Otherwise, the pool will empty or (even worse) grow
 *  in size uncontrolled.</p>
 */

@:jsRequire("starling/utils/Pool", "default")

extern class Pool
{
    /** Retrieves a Point instance from the pool. */
    public static function getPoint(x:Float = 0, y:Float = 0):Point;

    /** Stores a Point instance in the pool.
     *  Don't keep any references to the object after moving it to the pool! */
    public static function putPoint(point:Point):Void;

    /** Retrieves a Vector3D instance from the pool. */
    public static function getPoint3D(x:Float = 0, y:Float = 0, z:Float = 0):Vector3D;

    /** Stores a Vector3D instance in the pool.
     *  Don't keep any references to the object after moving it to the pool! */
    public static function putPoint3D(point:Vector3D):Void;

    /** Retrieves a Matrix instance from the pool. */
    public static function getMatrix(a:Float = 1, b:Float = 0, c:Float = 0, d:Float = 1,
                                     tx:Float = 0, ty:Float = 0):Matrix;

    /** Stores a Matrix instance in the pool.
     *  Don't keep any references to the object after moving it to the pool! */
    public static function putMatrix(matrix:Matrix):Void;

    /** Retrieves a Matrix3D instance from the pool.
     *
     *  @param identity   If enabled, the matrix will be reset to the identity.
     *                    Otherwise, its contents is undefined.
     */
    public static function getMatrix3D(identity:Bool = true):Matrix3D;

    /** Stores a Matrix3D instance in the pool.
     *  Don't keep any references to the object after moving it to the pool! */
    public static function putMatrix3D(matrix:Matrix3D):Void;

    /** Retrieves a Rectangle instance from the pool. */
    public static function getRectangle(x:Float = 0, y:Float = 0,
                                        width:Float = 0, height:Float = 0):Rectangle;

    /** Stores a Rectangle instance in the pool.
     *  Don't keep any references to the object after moving it to the pool! */
    public static function putRectangle(rectangle:Rectangle):Void;
}
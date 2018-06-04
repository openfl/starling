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

import starling.display.DisplayObject;
import starling.display.Stage;
import starling.errors.AbstractClassError;
import starling.rendering.IndexData;
import starling.rendering.VertexData;

/** A utility class that helps with tasks that are common when working with meshes. */

@:jsRequire("starling/utils/MeshUtil", "default")

extern class MeshUtil
{
    /** Determines if a point is inside a mesh that is spawned up by the given
        *  vertex- and index-data. */
    public static function containsPoint(vertexData:VertexData, indexData:IndexData,
                                            point:Point):Bool;

    /** Calculates the bounds of the given vertices in the target coordinate system. */
    public static function calculateBounds(vertexData:VertexData,
                                            sourceSpace:DisplayObject,
                                            targetSpace:DisplayObject,
                                            out:Rectangle=null):Rectangle;
}
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

import openfl.errors.Error;
import openfl.geom.Matrix;
import openfl.geom.Matrix3D;
import openfl.geom.Point;
import openfl.geom.Vector3D;

import starling.events.Event;
import starling.rendering.Painter;
import starling.utils.MathUtil;
import starling.utils.MatrixUtil;
import starling.utils.MathUtil.rad2deg;

/** A container that allows you to position objects in three-dimensional space.
 *
 *  <p>Starling is, at its heart, a 2D engine. However, sometimes, simple 3D effects are
 *  useful for special effects, e.g. for screen transitions or to turn playing cards
 *  realistically. This class makes it possible to create such 3D effects.</p>
 *
 *  <p><strong>Positioning objects in 3D</strong></p>
 *
 *  <p>Just like a normal sprite, you can add and remove children to this container, which
 *  allows you to group several display objects together. In addition to that, Sprite3D
 *  adds some interesting properties:</p>
 *
 *  <ul>
 *    <li>z - Moves the sprite closer to / further away from the camera.</li>
 *    <li>rotationX — Rotates the sprite around the x-axis.</li>
 *    <li>rotationY — Rotates the sprite around the y-axis.</li>
 *    <li>scaleZ - Scales the sprite along the z-axis.</li>
 *    <li>pivotZ - Moves the pivot point along the z-axis.</li>
 *  </ul>
 *
 *  <p>With the help of these properties, you can move a sprite and all its children in the
 *  3D space. By nesting several Sprite3D containers, it's even possible to construct simple
 *  volumetric objects (like a cube).</p>
 *
 *  <p>Note that Starling does not make any z-tests: visibility is solely established by the
 *  order of the children, just as with 2D objects.</p>
 *
 *  <p><strong>Setting up the camera</strong></p>
 *
 *  <p>The camera settings are found directly on the stage. Modify the 'focalLength' or
 *  'fieldOfView' properties to change the distance between stage and camera; use the
 *  'projectionOffset' to move it to a different position.</p>
 *
 *  <p><strong>Limitations</strong></p>
 *
 *  <p>On rendering, each Sprite3D requires its own draw call — except if the object does not
 *  contain any 3D transformations ('z', 'rotationX/Y' and 'pivotZ' are zero). Furthermore,
 *  it interrupts the render cache, i.e. the cache cannot contain objects within different
 *  3D coordinate systems. Flat contents within the Sprite3D will be cached, though.</p>
 *
 */
class Sprite3D extends DisplayObjectContainer
{
    private static inline var E:Float = 0.00001;

    private var __rotationX:Float;
    private var __rotationY:Float;
    private var __scaleZ:Float;
    private var __pivotZ:Float;
    private var __z:Float;

    //private var __transformationMatrix:Matrix;
    //private var __transformationMatrix3D:Matrix3D;
    private var __transformationChanged:Bool;
    private var __is2D:Bool;

    /** Helper objects. */
    private static var sHelperPoint:Vector3D    = new Vector3D();
    private static var sHelperPointAlt:Vector3D = new Vector3D();
    private static var sHelperMatrix:Matrix3D   = new Matrix3D();

    /** Creates an empty Sprite3D. */
    public function new()
    {
        super();

        __scaleZ = 1.0;
        __rotationX = __rotationY = __pivotZ = __z = 0.0;
        __transformationMatrix = new Matrix();
        __transformationMatrix3D = new Matrix3D();
        __is2D = true;   // meaning: this 3D object contains only 2D content
        __setIs3D(true); // meaning: this display object supports 3D transformations

        addEventListener(Event.ADDED, __onAddedChild);
        addEventListener(Event.REMOVED, __onRemovedChild);
    }

    /** @inheritDoc */
    override public function render(painter:Painter):Void
    {
        if (__is2D) super.render(painter);
        else
        {
            painter.finishMeshBatch();
            painter.pushState();
            painter.state.transformModelviewMatrix3D(transformationMatrix3D);

            super.render(painter);

            painter.finishMeshBatch();
            painter.excludeFromCache(this);
            painter.popState();
        }
    }

    /** @inheritDoc */
    override public function hitTest(localPoint:Point):DisplayObject
    {
        if (__is2D) return super.hitTest(localPoint);
        else
        {
            if (!visible || !touchable) return null;

            // We calculate the interception point between the 3D plane that is spawned up
            // by this sprite3D and the straight line between the camera and the hit point.

            sHelperMatrix.copyFrom(transformationMatrix3D);
            sHelperMatrix.invert();

            stage.getCameraPosition(this, sHelperPoint);
            MatrixUtil.transformCoords3D(sHelperMatrix, localPoint.x, localPoint.y, 0, sHelperPointAlt);
            MathUtil.intersectLineWithXYPlane(sHelperPoint, sHelperPointAlt, localPoint);

            return super.hitTest(localPoint);
        }
    }

    /** @private */
    override public function setRequiresRedraw():Void
    {
        __is2D = __z > -E && __z < E &&
                 __rotationX > -E && __rotationX < E &&
                 __rotationY > -E && __rotationY < E &&
                 __pivotZ > -E && __pivotZ < E;

        super.setRequiresRedraw();
    }

    // helpers

    private function __onAddedChild(event:Event):Void
    {
        __recursivelySetIs3D(cast(event.target, DisplayObject), true);
    }

    private function __onRemovedChild(event:Event):Void
    {
        __recursivelySetIs3D(cast(event.target, DisplayObject), false);
    }

    private function __recursivelySetIs3D(object:DisplayObject, value:Bool):Void
    {
        if (Std.is(object, Sprite3D))
            return;

        if (Std.is(object, DisplayObjectContainer))
        {
            var container:DisplayObjectContainer = cast object;
            var numChildren:Int = container.numChildren;

            for (i in 0...numChildren)
                __recursivelySetIs3D(container.getChildAt(i), value);
        }

        object.__setIs3D(value);
    }

    private function __updateMatrices():Void
    {
        var x:Float = this.x;
        var y:Float = this.y;
        var scaleX:Float = this.scaleX;
        var scaleY:Float = this.scaleY;
        var pivotX:Float = this.pivotX;
        var pivotY:Float = this.pivotY;
        var rotationZ:Float = this.rotation;

        __transformationMatrix3D.identity();

        if (scaleX != 1.0 || scaleY != 1.0 || __scaleZ != 1.0)
            __transformationMatrix3D.appendScale(scaleX != 0 ? scaleX : E, scaleY != 0 ? scaleY : E, __scaleZ != 0 ? __scaleZ : E);
        if (__rotationX != 0.0)
            __transformationMatrix3D.appendRotation(rad2deg(__rotationX), Vector3D.X_AXIS);
        if (__rotationY != 0.0)
            __transformationMatrix3D.appendRotation(rad2deg(__rotationY), Vector3D.Y_AXIS);
        if (rotationZ != 0.0)
            __transformationMatrix3D.appendRotation(rad2deg( rotationZ), Vector3D.Z_AXIS);
        if (x != 0.0 || y != 0.0 || __z != 0.0)
            __transformationMatrix3D.appendTranslation(x, y, __z);
        if (pivotX != 0.0 || pivotY != 0.0 || __pivotZ != 0.0)
            __transformationMatrix3D.prependTranslation(-pivotX, -pivotY, -__pivotZ);

        if (__is2D) MatrixUtil.convertTo2D(__transformationMatrix3D, __transformationMatrix);
        else      __transformationMatrix.identity();
    }

    // properties

    /** The 2D transformation matrix of the object relative to its parent — if it can be
     * represented in such a matrix (the values of 'z', 'rotationX/Y', and 'pivotZ' are
     * zero). Otherwise, the identity matrix. CAUTION: not a copy, but the actual object! */
    private override function get_transformationMatrix():Matrix
    {
        if (__transformationChanged)
        {
            __updateMatrices();
            __transformationChanged = false;
        }

        return __transformationMatrix;
    }

    private override function set_transformationMatrix(value:Matrix):Matrix
    {
        super.transformationMatrix = value;
        __rotationX = __rotationY = __pivotZ = __z = 0;
        __transformationChanged = true;
        return value;
    }

    /**  The 3D transformation matrix of the object relative to its parent.
     * CAUTION: not a copy, but the actual object! */
    private override function get_transformationMatrix3D():Matrix3D
    {
        if (__transformationChanged)
        {
            __updateMatrices();
            __transformationChanged = false;
        }

        return __transformationMatrix3D;
    }

    /** @inheritDoc */
    private override function set_x(value:Float):Float
    {
        super.x = value;
        __transformationChanged = true;
        return value;
    }

    /** @inheritDoc */
    private override function set_y(value:Float):Float
    {
        super.y = value;
        __transformationChanged = true;
        return value;
    }

    /** The z coordinate of the object relative to the local coordinates of the parent.
     * The z-axis points away from the camera, i.e. positive z-values will move the object further
     * away from the viewer. */
    @:keep public var z(get, set):Float;
    @:keep private function get_z():Float { return __z; }
    @:keep private function set_z(value:Float):Float
    {
        __z = value;
        __transformationChanged = true;
        setRequiresRedraw();
        return value;
    }

    /** @inheritDoc */
    private override function set_pivotX(value:Float):Float
    {
         super.pivotX = value;
         __transformationChanged = true;
         return value;
    }

    /** @inheritDoc */
    private override function set_pivotY(value:Float):Float
    {
         super.pivotY = value;
         __transformationChanged = true;
         return value;
    }

    /** The z coordinate of the object's origin in its own coordinate space (default: 0). */
    @:keep public var pivotZ(get, set):Float;
    @:keep private function get_pivotZ():Float { return __pivotZ; }
    @:keep private function set_pivotZ(value:Float):Float
    {
        __pivotZ = value;
        __transformationChanged = true;
        setRequiresRedraw();
        return value;
    }

    /** @inheritDoc */
    private override function set_scaleX(value:Float):Float
    {
        super.scaleX = value;
        __transformationChanged = true;
        return value;
    }

    /** @inheritDoc */
    private override function set_scaleY(value:Float):Float
    {
        super.scaleY = value;
        __transformationChanged = true;
        return value;
    }

    /** The depth scale factor. '1' means no scale, negative values flip the object. */
    @:keep public var scaleZ(get, set):Float;
    @:keep private function get_scaleZ():Float { return __scaleZ; }
    @:keep private function set_scaleZ(value:Float):Float
    {
        __scaleZ = value;
        __transformationChanged = true;
        setRequiresRedraw();
        return value;
    }

    /** @private */
    override private function set_scale(value:Float):Float
    {
        return scaleX = scaleY = scaleZ = value;
    }

    /** @private */
    private override function set_skewX(value:Float):Float
    {
        throw new Error("3D objects do not support skewing");

        // super.skewX = value;
        // __orientationChanged = true;
        return value;
    }

    /** @private */
    private override function set_skewY(value:Float):Float
    {
        throw new Error("3D objects do not support skewing");

        // super.skewY = value;
        // __orientationChanged = true;
        return value;
    }

    /** The rotation of the object about the z axis, in radians.
     * (In Starling, all angles are measured in radians.) */
    private override function set_rotation(value:Float):Float
    {
        super.rotation = value;
        __transformationChanged = true;
        return value;
    }

    /** The rotation of the object about the x axis, in radians.
     * (In Starling, all angles are measured in radians.) */
    @:keep public var rotationX(get, set):Float;
    @:keep private function get_rotationX():Float { return __rotationX; }
    @:keep private function set_rotationX(value:Float):Float
    {
        __rotationX = MathUtil.normalizeAngle(value);
        __transformationChanged = true;
        setRequiresRedraw();
        return value;
    }

    /** The rotation of the object about the y axis, in radians.
     * (In Starling, all angles are measured in radians.) */
    @:keep public var rotationY(get, set):Float;
    @:keep private function get_rotationY():Float { return __rotationY; }
    @:keep private function set_rotationY(value:Float):Float
    {
        __rotationY = MathUtil.normalizeAngle(value);
        __transformationChanged = true;
        setRequiresRedraw();
        return value;
    }

    /** The rotation of the object about the z axis, in radians.
     * (In Starling, all angles are measured in radians.) */
    @:keep public var rotationZ(get, set):Float;
    @:keep private function get_rotationZ():Float { return rotation; }
    @:keep private function set_rotationZ(value:Float):Float { return rotation = value; }
}
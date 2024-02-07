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

    @:noCompletion private var __rotationX:Float;
    @:noCompletion private var __rotationY:Float;
    @:noCompletion private var __scaleZ:Float;
    @:noCompletion private var __pivotZ:Float;
    @:noCompletion private var __z:Float;

    /** Helper objects. */
    private static var sHelperPoint:Vector3D    = new Vector3D();
    private static var sHelperPointAlt:Vector3D = new Vector3D();
    private static var sHelperMatrix:Matrix3D   = new Matrix3D();

    #if commonjs
    private static function __init__ () {
        
        untyped Object.defineProperties (Sprite3D.prototype, {
            "z": { get: untyped __js__ ("function () { return this.get_z (); }"), set: untyped __js__ ("function (v) { return this.set_z (v); }") },
            "pivotZ": { get: untyped __js__ ("function () { return this.get_pivotZ (); }"), set: untyped __js__ ("function (v) { return this.set_pivotZ (v); }") },
            "scaleZ": { get: untyped __js__ ("function () { return this.get_scaleZ (); }"), set: untyped __js__ ("function (v) { return this.set_scaleZ (v); }") },
            "rotationX": { get: untyped __js__ ("function () { return this.get_rotationX (); }"), set: untyped __js__ ("function (v) { return this.set_rotationX (v); }") },
            "rotationY": { get: untyped __js__ ("function () { return this.get_rotationY (); }"), set: untyped __js__ ("function (v) { return this.set_rotationY (v); }") },
            "rotationZ": { get: untyped __js__ ("function () { return this.get_rotationZ (); }"), set: untyped __js__ ("function (v) { return this.set_rotationZ (v); }") },
            "isFlat": { get: untyped __js__ ("function () { return this.get_isFlat (); }") },
        });
        
    }
    #end

    /** Creates an empty Sprite3D. */
    public function new()
    {
        super();

        __scaleZ = 1.0;
        __rotationX = __rotationY = __pivotZ = __z = 0.0;
        __setIs3D(true);

        addEventListener(Event.ADDED, __onAddedChild);
        addEventListener(Event.REMOVED, __onRemovedChild);
    }

    /** @inheritDoc */
    override public function render(painter:Painter):Void
    {
        if (isFlat) super.render(painter);
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
        if (isFlat) return super.hitTest(localPoint);
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

    // helpers

    @:noCompletion private function __onAddedChild(event:Event):Void
    {
        __recursivelySetIs3D(cast(event.target, DisplayObject), true);
    }

    @:noCompletion private function __onRemovedChild(event:Event):Void
    {
        __recursivelySetIs3D(cast(event.target, DisplayObject), false);
    }

    @:noCompletion private function __recursivelySetIs3D(object:DisplayObject, value:Bool):Void
    {
        if (#if (haxe_ver < 4.2) Std.is #else Std.isOfType #end(object, Sprite3D))
            return;

        if (#if (haxe_ver < 4.2) Std.is #else Std.isOfType #end(object, DisplayObjectContainer))
        {
            var container:DisplayObjectContainer = cast object;
            var numChildren:Int = container.numChildren;

            for (i in 0...numChildren)
                __recursivelySetIs3D(container.getChildAt(i), value);
        }

        object.__setIs3D(value);
    }

    override private function __updateTransformationMatrices(
        x:Float, y:Float, pivotX:Float, pivotY:Float, scaleX:Float, scaleY:Float,
        skewX:Float, skewY:Float, rotation:Float, out:Matrix, out3D:Matrix3D):Void
    {
        if (isFlat) super.__updateTransformationMatrices(
            x, y, pivotX, pivotY, scaleX, scaleY, skewX, skewY, rotation, out, out3D);
        else __updateTransformationMatrices3D(
            x, y, __z, pivotX, pivotY, __pivotZ, scaleX, scaleY, __scaleZ,
            __rotationX, __rotationY, rotation, out, out3D);
    }

    @:allow(starling) @:noCompletion private function __updateTransformationMatrices3D(
        x:Float, y:Float, z:Float,
        pivotX:Float, pivotY:Float, pivotZ:Float,
        scaleX:Float, scaleY:Float, scaleZ:Float,
        rotationX:Float, rotationY:Float, rotationZ:Float,
        out:Matrix, out3D:Matrix3D):Void
    {
        out.identity();
        out3D.identity();

        if (scaleX != 1.0 || scaleY != 1.0 || scaleZ != 1.0)
            out3D.appendScale(scaleX != 0 ? scaleX : E , scaleY != 0 ? scaleY : E, scaleZ != 0 ? scaleZ : E);
        if (rotationX != 0.0)
            out3D.appendRotation(rad2deg(rotationX), Vector3D.X_AXIS);
        if (rotationY != 0.0)
            out3D.appendRotation(rad2deg(rotationY), Vector3D.Y_AXIS);
        if (rotationZ != 0.0)
            out3D.appendRotation(rad2deg(rotationZ), Vector3D.Z_AXIS);
        if (x != 0.0 || y != 0.0 || z != 0.0)
            out3D.appendTranslation(x, y, z);
        if (pivotX != 0.0 || pivotY != 0.0 || pivotZ != 0.0)
            out3D.prependTranslation(-pivotX, -pivotY, -pivotZ);
    }

    // properties

    private override function set_transformationMatrix(value:Matrix):Matrix
    {
        super.transformationMatrix = value;
        __rotationX = __rotationY = __pivotZ = __z = 0;
        __setTransformationChanged();
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
        __setTransformationChanged();
        return value;
    }

    /** The z coordinate of the object's origin in its own coordinate space (default: 0). */
    @:keep public var pivotZ(get, set):Float;
    @:keep private function get_pivotZ():Float { return __pivotZ; }
    @:keep private function set_pivotZ(value:Float):Float
    {
        __pivotZ = value;
        __setTransformationChanged();
        return value;
    }

    /** The depth scale factor. '1' means no scale, negative values flip the object. */
    @:keep public var scaleZ(get, set):Float;
    @:keep private function get_scaleZ():Float { return __scaleZ; }
    @:keep private function set_scaleZ(value:Float):Float
    {
        __scaleZ = value;
        __setTransformationChanged();
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

    /** The rotation of the object about the x axis, in radians.
     * (In Starling, all angles are measured in radians.) */
    @:keep public var rotationX(get, set):Float;
    @:keep private function get_rotationX():Float { return __rotationX; }
    @:keep private function set_rotationX(value:Float):Float
    {
        __rotationX = MathUtil.normalizeAngle(value);
        __setTransformationChanged();
        return value;
    }

    /** The rotation of the object about the y axis, in radians.
     * (In Starling, all angles are measured in radians.) */
    @:keep public var rotationY(get, set):Float;
    @:keep private function get_rotationY():Float { return __rotationY; }
    @:keep private function set_rotationY(value:Float):Float
    {
        __rotationY = MathUtil.normalizeAngle(value);
        __setTransformationChanged();
        return value;
    }

    /** The rotation of the object about the z axis, in radians.
     * (In Starling, all angles are measured in radians.) */
    @:keep public var rotationZ(get, set):Float;
    @:keep private function get_rotationZ():Float { return rotation; }
    @:keep private function set_rotationZ(value:Float):Float { return rotation = value; }

    /** If <code>true</code>, this 3D object contains only 2D content.
     *  This means that rendering will be just as efficient as for a standard 2D object. */
    public var isFlat(get, never):Bool;
    private function get_isFlat():Bool
    {
        return __z > -E && __z < E &&
                __rotationX > -E && __rotationX < E &&
                __rotationY > -E && __rotationY < E &&
                __pivotZ > -E && __pivotZ < E;
    }
}
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

@:jsRequire("starling/display/Sprite3D", "default")

extern class Sprite3D extends DisplayObjectContainer
{
    /** Creates an empty Sprite3D. */
    public function new();

    /** @inheritDoc */
    override public function render(painter:Painter):Void;

    /** @inheritDoc */
    override public function hitTest(localPoint:Point):DisplayObject;

    /** The z coordinate of the object relative to the local coordinates of the parent.
     * The z-axis points away from the camera, i.e. positive z-values will move the object further
     * away from the viewer. */
    @:keep public var z(get, set):Float;
    @:keep private function get_z():Float;
    @:keep private function set_z(value:Float):Float;

    /** The z coordinate of the object's origin in its own coordinate space (default: 0). */
    @:keep public var pivotZ(get, set):Float;
    @:keep private function get_pivotZ():Float;
    @:keep private function set_pivotZ(value:Float):Float;

    /** The depth scale factor. '1' means no scale, negative values flip the object. */
    @:keep public var scaleZ(get, set):Float;
    @:keep private function get_scaleZ():Float;
    @:keep private function set_scaleZ(value:Float):Float;

    /** @private */
    override private function set_scale(value:Float):Float;

    /** @private */
    private override function set_skewX(value:Float):Float;

    /** @private */
    private override function set_skewY(value:Float):Float;

    /** The rotation of the object about the x axis, in radians.
     * (In Starling, all angles are measured in radians.) */
    @:keep public var rotationX(get, set):Float;
    @:keep private function get_rotationX():Float;
    @:keep private function set_rotationX(value:Float):Float;

    /** The rotation of the object about the y axis, in radians.
     * (In Starling, all angles are measured in radians.) */
    @:keep public var rotationY(get, set):Float;
    @:keep private function get_rotationY():Float;
    @:keep private function set_rotationY(value:Float):Float;

    /** The rotation of the object about the z axis, in radians.
     * (In Starling, all angles are measured in radians.) */
    @:keep public var rotationZ(get, set):Float;
    @:keep private function get_rotationZ():Float;
    @:keep private function set_rotationZ(value:Float):Float;

    /** If <code>true</code>, this 3D object contains only 2D content.
     *  This means that rendering will be just as efficient as for a standard 2D object. */
    public var isFlat(get, never):Bool;
    private function get_isFlat():Bool;
}
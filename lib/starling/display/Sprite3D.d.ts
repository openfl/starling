import DisplayObjectContainer from "./../../starling/display/DisplayObjectContainer";
import MatrixUtil from "./../../starling/utils/MatrixUtil";
import MathUtil from "./../../starling/utils/MathUtil";
import DisplayObject from "./../../starling/display/DisplayObject";
import Vector3D from "openfl/geom/Vector3D";
import Point from "openfl/geom/Point";
import Error from "openfl/errors/Error";
import Matrix3D from "openfl/geom/Matrix3D";
import Painter from "./../rendering/Painter";

declare namespace starling.display
{
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
	export class Sprite3D extends DisplayObjectContainer
	{
		/** Creates an empty Sprite3D. */
		public constructor();
	
		/** @inheritDoc */
		/*override*/ public render(painter:Painter):void;
	
		/** @inheritDoc */
		/*override*/ public hitTest(localPoint:Point):DisplayObject;
	
		/** The z coordinate of the object relative to the local coordinates of the parent.
		 * The z-axis points away from the camera, i.e. positive z-values will move the object further
		 * away from the viewer. */
		public z:number;
		protected get_z():number;
		protected set_z(value:number):number;
	
		/** The z coordinate of the object's origin in its own coordinate space (default: 0). */
		public pivotZ:number;
		protected get_pivotZ():number;
		protected set_pivotZ(value:number):number;
	
		/** The depth scale factor. '1' means no scale, negative values flip the object. */
		public scaleZ:number;
		protected get_scaleZ():number;
		protected set_scaleZ(value:number):number;
	
		/** @protected */
		/*override*/ protected set_scale(value:number):number;
	
		/** @protected */
		protected /*override*/ set_skewX(value:number):number;
	
		/** @protected */
		protected /*override*/ set_skewY(value:number):number;
	
		/** The rotation of the object about the x axis, in radians.
		 * (In Starling, all angles are measured in radians.) */
		public rotationX:number;
		protected get_rotationX():number;
		protected set_rotationX(value:number):number;
	
		/** The rotation of the object about the y axis, in radians.
		 * (In Starling, all angles are measured in radians.) */
		public rotationY:number;
		protected get_rotationY():number;
		protected set_rotationY(value:number):number;
	
		/** The rotation of the object about the z axis, in radians.
		 * (In Starling, all angles are measured in radians.) */
		public rotationZ:number;
		protected get_rotationZ():number;
		protected set_rotationZ(value:number):number;
	
		/** If <code>true</code>, this 3D object contains only 2D content.
		 *  This means that rendering will be just as efficient as for a standard 2D object. */
		public readonly isFlat:boolean;
		protected get_isFlat():boolean;
	}
}

export default starling.display.Sprite3D;
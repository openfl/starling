import DisplayObjectContainer from "./../../starling/display/DisplayObjectContainer";
import Rectangle from "openfl/geom/Rectangle";
import RectangleUtil from "./../../starling/utils/RectangleUtil";
import MatrixUtil from "./../../starling/utils/MatrixUtil";
import IllegalOperationError from "openfl/errors/IllegalOperationError";
import Starling from "./../../starling/core/Starling";
import Matrix from "openfl/geom/Matrix";
import Matrix3D from "openfl/geom/Matrix3D";
import Point from "openfl/geom/Point";
import Vector3D from "openfl/geom/Vector3D";
import EnterFrameEvent from "./../../starling/events/EnterFrameEvent";
import Vector from "openfl/Vector";
import DisplayObject from "./DisplayObject";

declare namespace starling.display
{
	/** Dispatched when the Flash container is resized. */
	// @:meta(Event(name="resize", type="starling.events.ResizeEvent"))
	
	/** A Stage represents the root of the display tree.  
	 *  Only objects that are direct or indirect children of the stage will be rendered.
	 * 
	 *  <p>This class represents the Starling version of the stage. Don't confuse it with its 
	 *  Flash equivalent: while the latter contains objects of the type 
	 *  <code>flash.display.DisplayObject</code>, the Starling stage contains only objects of the
	 *  type <code>starling.display.DisplayObject</code>. Those classes are not compatible, and 
	 *  you cannot exchange one type with the other.</p>
	 * 
	 *  <p>A stage object is created automatically by the <code>Starling</code> class. Don't
	 *  create a Stage instance manually.</p>
	 * 
	 *  <strong>Keyboard Events</strong>
	 * 
	 *  <p>In Starling, keyboard events are only dispatched at the stage. Add an event listener
	 *  directly to the stage to be notified of keyboard events.</p>
	 * 
	 *  <strong>Resize Events</strong>
	 * 
	 *  <p>When the Flash player is resized, the stage dispatches a <code>ResizeEvent</code>. The 
	 *  event contains properties containing the updated width and height of the Flash player.</p>
	 *
	 *  @see starling.events.KeyboardEvent
	 *  @see starling.events.ResizeEvent  
	 * 
	 */
	export class Stage extends DisplayObjectContainer
	{
		/** @inheritDoc */
		public advanceTime(passedTime:number):void;
	
		/** Returns the object that is found topmost beneath a point in stage coordinates, or  
		 * the stage itself if nothing else is found. */
		public /*override*/ hitTest(localPoint:Point):DisplayObject;
		
		/** Returns the stage bounds (i.e. not the bounds of its contents, but the rectangle
		 *  spawned up by 'stageWidth' and 'stageHeight') in another coordinate system. */
		public getStageBounds(targetSpace:DisplayObject, out?:Rectangle):Rectangle;
	
		// camera positioning
	
		/** Returns the position of the camera within the local coordinate system of a certain
		 * display object. If you do not pass a space, the method returns the global position.
		 * To change the position of the camera, you can modify the properties 'fieldOfView',
		 * 'focalDistance' and 'projectionOffset'.
		 */
		public getCameraPosition(space?:DisplayObject, out?:Vector3D):Vector3D;
	
		// properties
		
		/** The background color of the stage. */
		public color:number;
		protected get_color():number;
		protected set_color(value:number):number;
		
		/** The width of the stage coordinate system. Change it to scale its contents relative
		 * to the <code>viewPort</code> property of the Starling object. */ 
		public stageWidth:number;
		protected get_stageWidth():number;
		protected set_stageWidth(value:number):number;
		
		/** The height of the stage coordinate system. Change it to scale its contents relative
		 * to the <code>viewPort</code> property of the Starling object. */
		public stageHeight:number;
		protected get_stageHeight():number;
		protected set_stageHeight(value:number):number;
	
		/** The Starling instance this stage belongs to. */
		public readonly starling:Starling;
		protected get_starling():Starling;
	
		/** The distance between the stage and the camera. Changing this value will update the
		 * field of view accordingly. */
		public focalLength:number;
		protected get_focalLength():number;
	
		protected set_focalLength(value:number):number;
	
		/** Specifies an angle (radian, between zero and PI) for the field of view. This value
		 * determines how strong the perspective transformation and distortion apply to a Sprite3D
		 * object.
		 *
		 * <p>A value close to zero will look similar to an orthographic projection; a value
		 * close to PI results in a fisheye lens effect. If the field of view is set to 0 or PI,
		 * nothing is seen on the screen.</p>
		 *
		 * @default 1.0
		 */
		public fieldOfView:number;
		protected get_fieldOfView():number;
		protected set_fieldOfView(value:number):number;
	
		/** A vector that moves the camera away from its default position in the center of the
		 * stage. Use this property to change the center of projection, i.e. the vanishing
		 * point for 3D display objects. <p>CAUTION: not a copy, but the actual object!</p>
		 */
		public projectionOffset:Point;
		protected get_projectionOffset():Point;
		protected set_projectionOffset(value:Point):Point;
	
		/** The global position of the camera. This property can only be used to find out the
		 * current position, but not to modify it. For that, use the 'projectionOffset',
		 * 'fieldOfView' and 'focalLength' properties. If you need the camera position in
		 * a certain coordinate space, use 'getCameraPosition' instead.
		 *
		 * <p>CAUTION: not a copy, but the actual object!</p>
		 */
		public readonly cameraPosition:Vector3D;
		protected get_cameraPosition():Vector3D;
	}
}

export default starling.display.Stage;
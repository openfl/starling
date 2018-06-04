package starling.display;

import openfl.errors.IllegalOperationError;
import openfl.geom.Matrix;
import openfl.geom.Matrix3D;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.geom.Vector3D;
import openfl.Vector;

import starling.core.Starling;
import starling.events.EnterFrameEvent;
import starling.events.Event;
import starling.filters.FragmentFilter;
import starling.utils.MatrixUtil;
import starling.utils.RectangleUtil;

/** Dispatched when the Flash container is resized. */
@:meta(Event(name="resize", type="starling.events.ResizeEvent"))

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

@:jsRequire("starling/display/Stage", "default")

extern class Stage extends DisplayObjectContainer
{
    /** @inheritDoc */
    public function advanceTime(passedTime:Float):Void;

    /** Returns the object that is found topmost beneath a point in stage coordinates, or  
     * the stage itself if nothing else is found. */
    public override function hitTest(localPoint:Point):DisplayObject;
    
    /** Returns the stage bounds (i.e. not the bounds of its contents, but the rectangle
     *  spawned up by 'stageWidth' and 'stageHeight') in another coordinate system. */
    public function getStageBounds(targetSpace:DisplayObject, out:Rectangle=null):Rectangle;

    // camera positioning

    /** Returns the position of the camera within the local coordinate system of a certain
     * display object. If you do not pass a space, the method returns the global position.
     * To change the position of the camera, you can modify the properties 'fieldOfView',
     * 'focalDistance' and 'projectionOffset'.
     */
    public function getCameraPosition(space:DisplayObject=null, out:Vector3D=null):Vector3D;

    // properties
    
    /** The background color of the stage. */
    public var color(get, set):UInt;
    private function get_color():UInt;
    private function set_color(value:UInt):UInt;
    
    /** The width of the stage coordinate system. Change it to scale its contents relative
     * to the <code>viewPort</code> property of the Starling object. */ 
    public var stageWidth(get, set):Int;
    private function get_stageWidth():Int;
    private function set_stageWidth(value:Int):Int;
    
    /** The height of the stage coordinate system. Change it to scale its contents relative
     * to the <code>viewPort</code> property of the Starling object. */
    public var stageHeight(get, set):Int;
    private function get_stageHeight():Int;
    private function set_stageHeight(value:Int):Int;

    /** The Starling instance this stage belongs to. */
    public var starling(get, never):Starling;
    private function get_starling():Starling;

    /** The distance between the stage and the camera. Changing this value will update the
     * field of view accordingly. */
    public var focalLength(get, set):Float;
    private function get_focalLength():Float;

    private function set_focalLength(value:Float):Float;

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
    public var fieldOfView(get, set):Float;
    private function get_fieldOfView():Float;
    private function set_fieldOfView(value:Float):Float;

    /** A vector that moves the camera away from its default position in the center of the
     * stage. Use this property to change the center of projection, i.e. the vanishing
     * point for 3D display objects. <p>CAUTION: not a copy, but the actual object!</p>
     */
    public var projectionOffset(get, set):Point;
    private function get_projectionOffset():Point;
    private function set_projectionOffset(value:Point):Point;

    /** The global position of the camera. This property can only be used to find out the
     * current position, but not to modify it. For that, use the 'projectionOffset',
     * 'fieldOfView' and 'focalLength' properties. If you need the camera position in
     * a certain coordinate space, use 'getCameraPosition' instead.
     *
     * <p>CAUTION: not a copy, but the actual object!</p>
     */
    public var cameraPosition(get, never):Vector3D;
    private function get_cameraPosition():Vector3D;
}
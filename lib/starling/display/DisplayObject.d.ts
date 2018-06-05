import BitmapData from "openfl/display/BitmapData";
import Matrix from "openfl/geom/Matrix";
import Matrix3D from "openfl/geom/Matrix3D";
import Point from "openfl/geom/Point";
import Rectangle from "openfl/geom/Rectangle";
import Vector3D from "openfl/geom/Vector3D";
import FragmentFilter from "./../filters/FragmentFilter";
import Painter from "./../rendering/Painter";
import DisplayObjectContainer from "./DisplayObjectContainer";
import Stage from "./Stage";

declare namespace starling.display
{
	/** Dispatched when an object is added to a parent. */
	// @:meta(Event(name="added", type="starling.events.Event"))
	
	/** Dispatched when an object is connected to the stage (directly or indirectly). */
	// @:meta(Event(name="addedToStage", type="starling.events.Event"))
	
	/** Dispatched when an object is removed from its parent. */
	// @:meta(Event(name="removed", type="starling.events.Event"))
	
	/** Dispatched when an object is removed from the stage and won't be rendered any longer. */ 
	// @:meta(Event(name="removedFromStage", type="starling.events.Event"))
	
	/** Dispatched once every frame on every object that is connected to the stage. */ 
	// @:meta(Event(name="enterFrame", type="starling.events.EnterFrameEvent"))
	
	/** Dispatched when an object is touched. Bubbles. */
	// @:meta(Event(name="touch", type="starling.events.TouchEvent"))
	
	/** Dispatched when a key on the keyboard is released. */
	// @:meta(Event(name="keyUp", type="starling.events.KeyboardEvent"))
	
	/** Dispatched when a key on the keyboard is pressed. */
	// @:meta(Event(name="keyDown", type="starling.events.KeyboardEvent"))
	
	/**
	 *  The DisplayObject class is the base class for all objects that are rendered on the 
	 *  screen.
	 *  
	 *  <p><strong>The Display Tree</strong></p> 
	 *  
	 *  <p>In Starling, all displayable objects are organized in a display tree. Only objects that
	 *  are part of the display tree will be displayed (rendered).</p> 
	 *   
	 *  <p>The display tree consists of leaf nodes (Image, Quad) that will be rendered directly to
	 *  the screen, and of container nodes (subclasses of "DisplayObjectContainer", like "Sprite").
	 *  A container is simply a display object that has child nodes - which can, again, be either
	 *  leaf nodes or other containers.</p> 
	 *  
	 *  <p>At the base of the display tree, there is the Stage, which is a container, too. To create
	 *  a Starling application, you create a custom Sprite subclass, and Starling will add an
	 *  instance of this class to the stage.</p>
	 *  
	 *  <p>A display object has properties that define its position in relation to its parent
	 *  (x, y), as well as its rotation and scaling factors (scaleX, scaleY). Use the 
	 *  <code>alpha</code> and <code>visible</code> properties to make an object translucent or 
	 *  invisible.</p>
	 *  
	 *  <p>Every display object may be the target of touch events. If you don't want an object to be
	 *  touchable, you can disable the "touchable" property. When it's disabled, neither the object
	 *  nor its children will receive any more touch events.</p>
	 *    
	 *  <strong>Transforming coordinates</strong>
	 *  
	 *  <p>Within the display tree, each object has its own local coordinate system. If you rotate
	 *  a container, you rotate that coordinate system - and thus all the children of the 
	 *  container.</p>
	 *  
	 *  <p>Sometimes you need to know where a certain point lies relative to another coordinate 
	 *  system. That's the purpose of the method <code>getTransformationMatrix</code>. It will  
	 *  create a matrix that represents the transformation of a point in one coordinate system to 
	 *  another.</p> 
	 *  
	 *  <strong>Customization</strong>
	 *  
	 *  <p>DisplayObject is an abstract class, which means you cannot instantiate it directly,
	 *  but have to use one of its many subclasses instead. For leaf nodes, this is typically
	 *  'Mesh' or its subclasses 'Quad' and 'Image'. To customize rendering of these objects,
	 *  you can use fragment filters (via the <code>filter</code>-property on 'DisplayObject')
	 *  or mesh styles (via the <code>style</code>-property on 'Mesh'). Look at the respective
	 *  class documentation for more information.</p>
	 *
	 *  @see DisplayObjectContainer
	 *  @see Sprite
	 *  @see Stage
	 *  @see Mesh
	 *  @see starling.filters.FragmentFilter
	 *  @see starling.styles.MeshStyle
	 */
	export class DisplayObject extends EventDispatcher
	{
		/** Disposes all resources of the display object. 
		  * GPU buffers are released, event listeners are removed, filters and masks are disposed. */
		public dispose():void;
		
		/** Removes the object from its parent, if it has one, and optionally disposes it. */
		public removeFromParent(dispose?:boolean):void;
		
		/** Creates a matrix that represents the transformation from the local coordinate system 
		 * to another. If you pass an <code>out</code>-matrix, the result will be stored in this matrix
		 * instead of creating a new object. */ 
		public getTransformationMatrix(targetSpace:DisplayObject, 
												out?:Matrix):Matrix;
		
		/** Returns a rectangle that completely encloses the object as it appears in another 
		 * coordinate system. If you pass an <code>out</code>-rectangle, the result will be stored in this 
		 * rectangle instead of creating a new object. */ 
		public getBounds(targetSpace:DisplayObject, out?:Rectangle):Rectangle;
		
		/** Returns the object that is found topmost beneath a point in local coordinates, or nil
		 *  if the test fails. Untouchable and invisible objects will cause the test to fail. */
		public hitTest(localPoint:Point):DisplayObject;
	
		/** Checks if a certain point is inside the display object's mask. If there is no mask,
		 * this method always returns <code>true</code> (because having no mask is equivalent
		 * to having one that's infinitely big). */
		public hitTestMask(localPoint:Point):boolean;
	
		/** Transforms a point from the local coordinate system to global (stage) coordinates.
		 * If you pass an <code>out</code>-point, the result will be stored in this point instead of 
		 * creating a new object. */
		public localToGlobal(localPoint:Point, out?:Point):Point;
		
		/** Transforms a point from global (stage) coordinates to the local coordinate system.
		 * If you pass an <code>out</code>-point, the result will be stored in this point instead of 
		 * creating a new object. */
		public globalToLocal(globalPoint:Point, out?:Point):Point;
		
		/** Renders the display object with the help of a painter object. Never call this method
		 *  directly, except from within another render method.
		 *
		 *  @param painter Captures the current render state and provides utility functions
		 *                 for rendering.
		 */
		public render(painter:Painter):void;
		
		/** Moves the pivot point to a certain position within the local coordinate system
		 * of the object. If you pass no arguments, it will be centered. */ 
		public alignPivot(horizontalAlign?:string,
								   verticalAlign?:string):void;
	
		/** Draws the object into a BitmapData object.
		 * 
		 *  <p>This is achieved by drawing the object into the back buffer and then copying the
		 *  pixels of the back buffer into a texture. This also means that the returned bitmap
		 *  data cannot be bigger than the current viewPort.</p>
		 *
		 *  @param out   If you pass null, the object will be created for you.
		 *               If you pass a BitmapData object, it should have the size of the
		 *               object bounds, multiplied by the current contentScaleFactor.
		 *  @param color The RGB color value with which the bitmap will be initialized.
		 *  @param alpha The alpha value with which the bitmap will be initialized.
		 */
		public drawToBitmapData(out?:BitmapData,
										   color?:number, alpha?:number):BitmapData;
	
		// 3D transformation
	
		/** Creates a matrix that represents the transformation from the local coordinate system
		 * to another. This method supports three dimensional objects created via 'Sprite3D'.
		 * If you pass an <code>out</code>-matrix, the result will be stored in this matrix
		 * instead of creating a new object. */
		public getTransformationMatrix3D(targetSpace:DisplayObject,
													out?:Matrix3D):Matrix3D;
	
		/** Transforms a 3D point from the local coordinate system to global (stage) coordinates.
		 * This is achieved by projecting the 3D point onto the (2D) view plane.
		 *
		 * <p>If you pass an <code>out</code>-point, the result will be stored in this point instead of
		 * creating a new object.</p> */
		public local3DToGlobal(localPoint:Vector3D, out?:Point):Point;
	
		/** Transforms a point from global (stage) coordinates to the 3D local coordinate system.
		 * If you pass an <code>out</code>-vector, the result will be stored in this point instead of
		 * creating a new object. */
		public globalToLocal3D(globalPoint:Point, out?:Vector3D):Vector3D;
	
		// render cache
	
		/** Forces the object to be redrawn in the next frame.
		 *  This will prevent the object to be drawn from the render cache.
		 *
		 *  <p>This method is called every time the object changes in any way. When creating
		 *  custom mesh styles or any other custom rendering code, call this method if the object
		 *  needs to be redrawn.</p>
		 *
		 *  <p>If the object needs to be redrawn just because it does not support the render cache,
		 *  call <code>painter.excludeFromCache()</code> in the object's render method instead.
		 *  That way, Starling's <code>skipUnchangedFrames</code> policy won't be disrupted.</p>
		 */
		public setRequiresRedraw():void;
	
		/** Indicates if the object needs to be redrawn in the upcoming frame, i.e. if it has
		 *  changed its location relative to the stage or some other aspect of its appearance
		 *  since it was last rendered. */
		public readonly requiresRedraw:boolean;
		protected get_requiresRedraw():boolean;
	
		// stage event handling
	
		/** @protected */
		public /*override*/ dispatchEvent(event:Event):void;
		
		// enter frame event optimization
		
		// To avoid looping through the complete display tree each frame to find out who's
		// listening to ENTER_FRAME events, we manage a list of them manually in the Stage class.
		// We need to take care that (a) it must be dispatched only when the object is
		// part of the stage, (b) it must not cause memory leaks when the user forgets to call
		// dispose and (c) there might be multiple listeners for this event.
		
		/** @inheritDoc */
		public /*override*/ addEventListener(type:string, listener:Function):void;
		
		/** @inheritDoc */
		public /*override*/ removeEventListener(type:string, listener:Function):void;
		
		/** @inheritDoc */
		public /*override*/ removeEventListeners(type?:string):void;
		
		// properties
	 
		/** The transformation matrix of the object relative to its parent.
		 * 
		 * <p>If you assign a custom transformation matrix, Starling will try to figure out  
		 * suitable values for <code>x, y, scaleX, scaleY,</code> and <code>rotation</code>.
		 * However, if the matrix was created in a different way, this might not be possible. 
		 * In that case, Starling will apply the matrix, but not update the corresponding 
		 * properties.</p>
		 * 
		 * <p>CAUTION: not a copy, but the actual object!</p> */
		public transformationMatrix:Matrix;
		protected get_transformationMatrix():Matrix;
		protected set_transformationMatrix(matrix:Matrix):Matrix;
		
		/** The 3D transformation matrix of the object relative to its parent.
		 *
		 * <p>For 2D objects, this property returns just a 3D version of the 2D transformation
		 * matrix. Only the 'Sprite3D' class supports real 3D transformations.</p>
		 *
		 * <p>CAUTION: not a copy, but the actual object!</p> */
		public readonly transformationMatrix3D:Matrix3D;
		protected get_transformationMatrix3D():Matrix3D;
	
		/** Indicates if this object or any of its parents is a 'Sprite3D' object. */
		public readonly is3D:boolean;
		protected get_is3D():boolean;
	
		/** Indicates if the mouse cursor should transform into a hand while it's over the sprite. 
		 * @default false */
		public useHandCursor:boolean;
		protected get_useHandCursor():boolean;
		protected set_useHandCursor(value:boolean):boolean;
		
		/** The bounds of the object relative to the local coordinates of the parent. */
		public readonly bounds:Rectangle;
		protected get_bounds():Rectangle;
		
		/** The width of the object in pixels.
		 * Note that for objects in a 3D space (connected to a Sprite3D), this value might not
		 * be accurate until the object is part of the display list. */
		public width:number;
		protected get_width():number;
		protected set_width(value:number):number;
		
		/** The height of the object in pixels.
		 * Note that for objects in a 3D space (connected to a Sprite3D), this value might not
		 * be accurate until the object is part of the display list. */
		public height:number;
		protected get_height():number;
		protected set_height(value:number):number;
		
		/** The x coordinate of the object relative to the local coordinates of the parent. */
		public x:number;
		protected get_x():number;
		protected set_x(value:number):number;
		
		/** The y coordinate of the object relative to the local coordinates of the parent. */
		public y:number;
		protected get_y():number;
		protected set_y(value:number):number;
		
		/** The x coordinate of the object's origin in its own coordinate space (default: 0). */
		public pivotX:number;
		protected get_pivotX():number;
		protected set_pivotX(value:number):number;
		
		/** The y coordinate of the object's origin in its own coordinate space (default: 0). */
		public pivotY:number;
		protected get_pivotY():number;
		protected set_pivotY(value:number):number;
		
		/** The horizontal scale factor. '1' means no scale, negative values flip the object.
		 * @default 1 */
		public scaleX:number;
		protected get_scaleX():number;
		protected set_scaleX(value:number):number;
		
		/** The vertical scale factor. '1' means no scale, negative values flip the object.
		 * @default 1 */
		public scaleY:number;
		protected get_scaleY():number;
		protected set_scaleY(value:number):number;
	
		/** Sets both 'scaleX' and 'scaleY' to the same value. The getter simply returns the
		 * value of 'scaleX' (even if the scaling values are different). @default 1 */
		public scale:number;
		protected get_scale():number;
		protected set_scale(value:number):number;
		
		/** The horizontal skew angle in radians. */
		public skewX:number;
		protected get_skewX():number;
		protected set_skewX(value:number):number;
		
		/** The vertical skew angle in radians. */
		public skewY:number;
		protected get_skewY():number;
		protected set_skewY(value:number):number;
		
		/** The rotation of the object in radians. (In Starling, all angles are measured 
		 * in radians.) */
		public rotation:number;
		protected get_rotation():number;
		protected set_rotation(value:number):number;
		
		/** The opacity of the object. 0 = transparent, 1 = opaque. @default 1 */
		public alpha:number;
		protected get_alpha():number;
		protected set_alpha(value:number):number;
		
		/** The visibility of the object. An invisible object will be untouchable. */
		public visible:boolean;
		protected get_visible():boolean;
		protected set_visible(value:boolean):boolean;
		
		/** Indicates if this object (and its children) will receive touch events. */
		public touchable:boolean;
		protected get_touchable():boolean;
		protected set_touchable(value:boolean):boolean;
		
		/** The blend mode determines how the object is blended with the objects underneath. 
		 * @default auto
		 * @see starling.display.BlendMode */ 
		public blendMode:string;
		protected get_blendMode():string;
		protected set_blendMode(value:string):string;
		
		/** The name of the display object (default: null). Used by 'getChildByName()' of 
		 * display object containers. */
		public name:string;
		protected get_name():string;
		protected set_name(value:string):string;
		
		/** The filter that is attached to the display object. The <code>starling.filters</code>
		 *  package contains several classes that define specific filters you can use. To combine
		 *  several filters, assign an instance of the <code>FilterChain</code> class; to remove
		 *  all filters, assign <code>null</code>.
		 *
		 *  <p>Beware that a filter instance may only be used on one object at a time! Furthermore,
		 *  when you remove or replace a filter, it is NOT disposed automatically (since you might
		 *  want to reuse it on a different object).</p>
		 *
		 *  @default null
		 *  @see starling.filters.FragmentFilter
		 *  @see starling.filters.FilterChain
		 */
		public filter:FragmentFilter;
		protected get_filter():FragmentFilter;
		protected set_filter(value:FragmentFilter):FragmentFilter;
	
		/** The display object that acts as a mask for the current object.
		 *  Assign <code>null</code> to remove it.
		 *
		 *  <p>A pixel of the masked display object will only be drawn if it is within one of the
		 *  mask's polygons. Texture pixels and alpha values of the mask are not taken into
		 *  account. The mask object itself is never visible.</p>
		 *
		 *  <p>If the mask is part of the display list, masking will occur at exactly the
		 *  location it occupies on the stage. If it is not, the mask will be placed in the local
		 *  coordinate system of the target object (as if it was one of its children).</p>
		 *
		 *  <p>For rectangular masks, you can use simple quads; for other forms (like circles
		 *  or arbitrary shapes) it is recommended to use a 'Canvas' instance.</p>
		 *
		 *  <p><strong>Note:</strong> a mask will typically cause at least two additional draw
		 *  calls: one to draw the mask to the stencil buffer and one to erase it. However, if the
		 *  mask object is an instance of <code>starling.display.Quad</code> and is aligned
		 *  parallel to the stage axes, rendering will be optimized: instead of using the
		 *  stencil buffer, the object will be clipped using the scissor rectangle. That's
		 *  faster and reduces the number of draw calls, so make use of this when possible.</p>
		 *
		 *  <p><strong>Note:</strong> AIR apps require the <code>depthAndStencil</code> node
		 *  in the application descriptor XMLs to be enabled! Otherwise, stencil masking won't
		 *  work.</p>
		 *
		 *  @see Canvas
		 *  @default null
		 */
		public mask:DisplayObject;
		protected get_mask():DisplayObject;
		protected set_mask(value:DisplayObject):DisplayObject;
		
		/** Indicates if the masked region of this object is set to be inverted.*/
		public maskInverted:boolean;
		protected get_maskInverted():boolean;
		protected set_maskInverted(value:boolean):boolean;
	
		/** The display object container that contains this display object. */
		public readonly parent:DisplayObjectContainer;
		protected get_parent():DisplayObjectContainer;
		
		/** The topmost object in the display tree the object is part of. */
		public readonly base:DisplayObject;
		protected get_base():DisplayObject;
		
		/** The root object the display object is connected to (i.e. an instance of the class 
		 * that was passed to the Starling constructor), or null if the object is not connected
		 * to the stage. */
		public readonly root:DisplayObject;
		protected get_root():DisplayObject;
		
		/** The stage the display object is connected to, or null if it is not connected 
		 * to the stage. */
		public readonly stage:Stage;
		protected get_stage():Stage;
	}
}

export default starling.display.DisplayObject;
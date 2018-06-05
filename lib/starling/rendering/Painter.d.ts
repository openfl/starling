import RenderUtil from "./../../starling/utils/RenderUtil";
import SystemUtil from "./../../starling/utils/SystemUtil";
import RenderState from "./../../starling/rendering/RenderState";
import MatrixUtil from "./../../starling/utils/MatrixUtil";
import IllegalOperationError from "openfl/errors/IllegalOperationError";
import RectangleUtil from "./../../starling/utils/RectangleUtil";
import Pool from "./../../starling/utils/Pool";
import Error from "openfl/errors/Error";
import Quad from "./../../starling/display/Quad";
import MathUtil from "./../../starling/utils/MathUtil";
import BlendMode from "./../../starling/display/BlendMode";
import Matrix from "openfl/geom/Matrix";
import Vector3D from "openfl/geom/Vector3D";
import Matrix3D from "openfl/geom/Matrix3D";
import Rectangle from "openfl/geom/Rectangle";
import MeshSubset from "./../../starling/utils/MeshSubset";
import Vector from "openfl/Vector";
import BatchProcessor from "./../../starling/rendering/BatchProcessor";
import Stage3D from "openfl/display/Stage3D";
import Program from "openfl/display3D/Program";
import BatchToken from "./BatchToken";
import Context3D from "openfl/display3D/Context3D";
import DisplayObject from "./../display/DisplayObject";
import Mesh from "./../display/Mesh";

declare namespace starling.rendering
{
	/** A class that orchestrates rendering of all Starling display objects.
	 *
	 *  <p>A Starling instance contains exactly one 'Painter' instance that should be used for all
	 *  rendering purposes. Each frame, it is passed to the render methods of all rendered display
	 *  objects. To access it outside a render method, call <code>Starling.painter</code>.</p>
	 *
	 *  <p>The painter is responsible for drawing all display objects to the screen. At its
	 *  core, it is a wrapper for many Context3D methods, but that's not all: it also provides
	 *  a convenient state mechanism, supports masking and acts as __iddleman between display
	 *  objects and renderers.</p>
	 *
	 *  <strong>The State Stack</strong>
	 *
	 *  <p>The most important concept of the Painter class is the state stack. A RenderState
	 *  stores a combination of settings that are currently used for rendering, e.g. the current
	 *  projection- and modelview-matrices and context-related settings. It can be accessed
	 *  and manipulated via the <code>state</code> property. Use the methods
	 *  <code>pushState</code> and <code>popState</code> to store a specific state and restore
	 *  it later. That makes it easy to write rendering code that doesn't have any side effects.</p>
	 *
	 *  <listing>
	 *  painter.pushState(); // save a copy of the current state on the stack
	 *  painter.state.renderTarget = renderTexture;
	 *  painter.state.transformModelviewMatrix(object.transformationMatrix);
	 *  painter.state.alpha = 0.5;
	 *  painter.prepareToDraw(); // apply all state settings at the render context
	 *  drawSomething(); // insert Stage3D rendering code here
	 *  painter.popState(); // restores previous state</listing>
	 *
	 *  @see RenderState
	 */
	export class Painter
	{
		/** The value with which the stencil buffer will be cleared,
			*  and the default reference value used for stencil tests. */
		public static DEFAULT_STENCIL_VALUE:number;
	
		// construction
		
		/** Creates a new Painter object. Normally, it's not necessary to create any custom
		 *  painters; instead, use the global painter found on the Starling instance. */
		public constructor(stage3D:Stage3D, sharedContext?:null | boolean);
		
		/** Disposes all mesh batches, programs, and - if it is not being shared -
		 *  the render context. */
		public dispose():void;
	
		// context handling
	
		/** Requests a context3D object from the stage3D object.
		 *  This is called by Starling internally during the initialization process.
		 *  You normally don't need to call this method yourself. (For a detailed description
		 *  of the parameters, look at the documentation of the method with the same name in the
		 *  "RenderUtil" class.)
		 *
		 *  @see starling.utils.RenderUtil
		 */
		public requestContext3D(renderMode:string, profile:any):void;
	
		/** Sets the viewport dimensions and other attributes of the rendering buffer.
		 *  Starling will call this method internally, so most apps won't need to mess with this.
		 *
		 *  <p>Beware: if <code>shareContext</code> is enabled, the method will only update the
		 *  painter's context-related information (like the size of the back buffer), but won't
		 *  make any actual changes to the context.</p>
		 *
		 * @param viewPort                the position and size of the area that should be rendered
		 *                                into, in pixels.
		 * @param contentScaleFactor      only relevant for Desktop (!) HiDPI screens. If you want
		 *                                to support high resolutions, pass the 'contentScaleFactor'
		 *                                of the Flash stage; otherwise, '1.0'.
		 * @param antiAlias               from 0 (none) to 16 (very high quality).
		 * @param enableDepthAndStencil   indicates whether the depth and stencil buffers should
		 *                                be enabled. Note that on AIR, you also have to enable
		 *                                this setting in the app-xml (application descriptor);
		 *                                otherwise, this setting will be silently ignored.
		 * @param supportBrowserZoom      if enabled, zooming a website will adapt the size of
		 *                                the back buffer.
		 */
		public configureBackBuffer(viewPort:Rectangle, contentScaleFactor:number,
											antiAlias:number, enableDepthAndStencil:boolean,
											supportBrowserZoom?:boolean):void;
	
		// program management
	
		/** Registers a program under a certain name.
		 *  If the name was already used, the previous program is overwritten. */
		public registerProgram(name:string, program:Program):void;
	
		/** Deletes the program of a certain name. */
		public deleteProgram(name:string):void;
	
		/** Returns the program registered under a certain name, or null if no program with
		 *  this name has been registered. */
		public getProgram(name:string):Program;
	
		/** Indicates if a program is registered under a certain name. */
		public hasProgram(name:string):boolean;
	
		// state stack
	
		/** Pushes the current render state to a stack from which it can be restored later.
		 *
		 *  <p>If you pass a BatchToken, it will be updated to point to the current location within
		 *  the render cache. That way, you can later reference this location to render a subset of
		 *  the cache.</p>
		 */
		public pushState(token?:BatchToken):void;
	
		/** Modifies the current state with a transformation matrix, alpha factor, and blend mode.
		 *
		 *  @param transformationMatrix Used to transform the current <code>modelviewMatrix</code>.
		 *  @param alphaFactor          Multiplied with the current alpha value.
		 *  @param blendMode            Replaces the current blend mode; except for "auto", which
		 *                              means the current value remains unchanged.
		 */
		public setStateTo(transformationMatrix:Matrix, alphaFactor?:number,
								   blendMode?:string):void;
	
		/** Restores the render state that was last pushed to the stack. If this changes
		 *  blend mode, clipping rectangle, render target or culling, the current batch
		 *  will be drawn right away.
		 *
		 *  <p>If you pass a BatchToken, it will be updated to point to the current location within
		 *  the render cache. That way, you can later reference this location to render a subset of
		 *  the cache.</p>
		 */
		public popState(token?:BatchToken):void;
	
		/** Restores the render state that was last pushed to the stack, but does NOT remove
		 *  it from the stack. */
		public restoreState():void;
	
		/** Updates all properties of the given token so that it describes the current position
		 *  within the render cache. */
		public fillToken(token:BatchToken):void;
	
		// masks
	
		/** Draws a display object into the stencil buffer, incrementing the buffer on each
		 *  used pixel. The stencil reference value is incremented as well; thus, any subsequent
		 *  stencil tests outside of this area will fail.
		 *
		 *  <p>If 'mask' is part of the display list, it will be drawn at its conventional stage
		 *  coordinates. Otherwise, it will be drawn with the current modelview matrix.</p>
		 *
		 *  <p>As an optimization, this method might update the clipping rectangle of the render
		 *  state instead of utilizing the stencil buffer. This is possible when the mask object
		 *  is of type <code>starling.display.Quad</code> and is aligned parallel to the stage
		 *  axes.</p>
		 *
		 *  <p>Note that masking breaks the render cache; the masked object must be redrawn anew
		 *  in the next frame. If you pass <code>maskee</code>, the method will automatically
		 *  call <code>excludeFromCache(maskee)</code> for you.</p>
		 */
		public drawMask(mask:DisplayObject, maskee?:DisplayObject):void;
	
		/** Draws a display object into the stencil buffer, decrementing the
		 *  buffer on each used pixel. This effectively erases the object from the stencil buffer,
		 *  restoring the previous state. The stencil reference value will be decremented.
		 *
		 *  <p>Note: if the mask object meets the requirements of using the clipping rectangle,
		 *  it will be assumed that this erase operation undoes the clipping rectangle change
		 *  caused by the corresponding <code>drawMask()</code> call.</p>
		 */
		public eraseMask(mask:DisplayObject, maskee?:DisplayObject):void;
	
		// mesh rendering
		
		/** Adds a mesh to the current batch of unrendered meshes. If the current batch is not
		 *  compatible with the mesh, all previous meshes are rendered at once and the batch
		 *  is cleared.
		 *
		 *  @param mesh    The mesh to batch.
		 *  @param subset  The range of vertices to be batched. If <code>null</code>, the complete
		 *                 mesh will be used.
		 */
		public batchMesh(mesh:Mesh, subset?:MeshSubset):void;
	
		/** Finishes the current mesh batch and prepares the next one. */
		public finishMeshBatch():void;
		
		/** Indicate how often the internally used batches are being trimmed to save memory.
		 *
		 *  <p>While rendering, the internally used MeshBatches are used in a different way in each
		 *  frame. To save memory, they should be trimmed every once in a while. This method defines
		 *  how often that happens, if at all. (Default: enabled = true, interval = 250)</p>
		 *
		 *  @param enabled   If trimming happens at all. Only disable temporarily!
		 *  @param interval  The number of frames between each trim operation.
		 */
		public enableBatchTrimming(enabled?:boolean, interval?:number):void;
	
		/** Completes all unfinished batches, cleanup procedures. */
		public finishFrame():void;
	
		/** Makes sure that the default context settings Starling relies on will be refreshed
			*  before the next 'draw' operation. This includes blend mode, culling, and depth test. */
		public setupContextDefaults():void;
	
		/** Resets the current state, state stack, batch processor, stencil reference value,
		 *  clipping rectangle, and draw count. Furthermore, depth testing is disabled. */
		public nextFrame():void;
	
		/** Draws all meshes from the render cache between <code>startToken</code> and
		 *  (but not including) <code>endToken</code>. The render cache contains all meshes
		 *  rendered in the previous frame. */
		public drawFromCache(startToken:BatchToken, endToken:BatchToken):void;
	
		/** Prevents the object from being drawn from the render cache in the next frame.
		 *  Different to <code>setRequiresRedraw()</code>, this does not indicate that the object
		 *  has changed in any way, but just that it doesn't support being drawn from cache.
		 *
		 *  <p>Note that when a container is excluded from the render cache, its children will
		 *  still be cached! This just means that batching is interrupted at this object when
		 *  the display tree is traversed.</p>
		 */
		public excludeFromCache(object:DisplayObject):void;
	
		// helper methods
	
		/** Applies all relevant state settings to at the render context. This includes
		 *  blend mode, render target and clipping rectangle. Always call this method before
		 *  <code>context.drawTriangles()</code>.
		 */
		public prepareToDraw():void;
	
		/** Clears the render context with a certain color and alpha value. Since this also
		 *  clears the stencil buffer, the stencil reference value is also reset to '0'. */
		public clear(rgb?:number, alpha?:number):void;
	
		/** Resets the render target to the back buffer and displays its contents. */
		public present():void;
	
		/** Refreshes the values of "backBufferWidth" and "backBufferHeight" from the current
		 *  context dimensions and stores the given "backBufferScaleFactor". This method is
		 *  called by Starling when the browser zoom factor changes (in case "supportBrowserZoom"
		 *  is enabled).
		 */
		public refreshBackBufferSize(scaleFactor:number):void;
	
		// properties
		
		/** Indicates the number of stage3D draw calls. */
		public drawCount:number;
		protected get_drawCount():number;
		protected set_drawCount(value:number):number;
	
		/** The current stencil reference value of the active render target. This value
		 *  is typically incremented when drawing a mask and decrementing when erasing it.
		 *  The painter keeps track of one stencil reference value per render target.
		 *  Only change this value if you know what you're doing!
		 */
		public stencilReferenceValue:number;
		protected get_stencilReferenceValue():number;
		protected set_stencilReferenceValue(value:number):number;
	
		/** Indicates if the render cache is enabled. Normally, this should be left at the default;
		 *  however, some custom rendering logic might require to change this property temporarily.
		 *  Also note that the cache is automatically reactivated each frame, right before the
		 *  render process.
		 *
		 *  @default true
		 */
		public cacheEnabled:boolean;
		protected get_cacheEnabled():boolean;
		protected set_cacheEnabled(value:boolean):boolean;
	
		/** The current render state, containing some of the context settings, projection- and
		 *  modelview-matrix, etc. Always returns the same instance, even after calls to "pushState"
		 *  and "popState".
		 *
		 *  <p>When you change the current RenderState, and this change is not compatible with
		 *  the current render batch, the batch will be concluded right away. Thus, watch out
		 *  for changes of blend mode, clipping rectangle, render target or culling.</p>
		 */
		public readonly state:RenderState;
		protected get_state():RenderState;
	
		/** The Stage3D instance this painter renders into. */
		public readonly stage3D:Stage3D;
		protected get_stage3D():Stage3D;
	
		/** The Context3D instance this painter renders into. */
		public readonly context:Context3D;
		protected get_context():Context3D;
	
		/** Returns the index of the current frame <strong>if</strong> the render cache is enabled;
		 *  otherwise, returns zero. To get the frameID regardless of the render cache, call
		 *  <code>Starling.frameID</code> instead. */
		public frameID:number;
		protected set_frameID(value:number):number;
		protected get_frameID():number;
	
		/** The size (in points) that represents one pixel in the back buffer. */
		public pixelSize:number;
		protected get_pixelSize():number;
		protected set_pixelSize(value:number):number;
	
		/** Indicates if another Starling instance (or another Stage3D framework altogether)
		 *  uses the same render context. @default false */
		public shareContext:boolean;
		protected get_shareContext():boolean;
		protected set_shareContext(value:boolean):boolean;
	
		/** Indicates if Stage3D render methods will report errors. Activate only when needed,
		 *  as this has a negative impact on performance. @default false */
		public enableErrorChecking:boolean;
		protected get_enableErrorChecking():boolean;
		protected set_enableErrorChecking(value:boolean):boolean;
	
		/** Returns the current width of the back buffer. In most cases, this value is in pixels;
		 *  however, if the app is running on an HiDPI display with an activated
		 *  'supportHighResolutions' setting, you have to multiply with 'backBufferPixelsPerPoint'
		 *  for the actual pixel count. Alternatively, use the Context3D-property with the
		 *  same name: it will return the exact pixel values. */
		public readonly backBufferWidth:number;
		protected get_backBufferWidth():number;
	
		/** Returns the current height of the back buffer. In most cases, this value is in pixels;
		 *  however, if the app is running on an HiDPI display with an activated
		 *  'supportHighResolutions' setting, you have to multiply with 'backBufferPixelsPerPoint'
		 *  for the actual pixel count. Alternatively, use the Context3D-property with the
		 *  same name: it will return the exact pixel values. */
		public readonly backBufferHeight:number;
		protected get_backBufferHeight():number;
	
		/** The number of pixels per point returned by the 'backBufferWidth/Height' properties.
		 *  Except for desktop HiDPI displays with an activated 'supportHighResolutions' setting,
		 *  this will always return '1'. */
		public readonly backBufferScaleFactor:number;
		protected get_backBufferScaleFactor():number;
	
		/** Indicates if the Context3D object is currently valid (i.e. it hasn't been lost or
		 *  disposed). */
		public readonly contextValid:boolean;
		protected get_contextValid():boolean;
	
		/** The Context3D profile of the current render context, or <code>null</code>
		 *  if the context has not been created yet. */
		public readonly profile:string;
		protected get_profile():string;
	
		/** A dictionary that can be used to save custom data related to the render context.
		 *  If you need to share data that is bound to the render context (e.g. textures), use
		 *  this dictionary instead of creating a static class variable. That way, the data will
		 *  be available for all Starling instances that use this stage3D / context. */
		public readonly sharedData:Map<string, any>;
		protected get_sharedData():Map<string, any>;
	
		protected readonly programs:Map<string, Program>;
		protected get_programs():Map<string, Program>;
	}
}

export default starling.rendering.Painter;
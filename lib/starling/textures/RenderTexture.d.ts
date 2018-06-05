import SubTexture from "./../../starling/textures/SubTexture";
import Starling from "./../../starling/core/Starling";
import Rectangle from "openfl/geom/Rectangle";
import IllegalOperationError from "openfl/errors/IllegalOperationError";
import Texture from "./../../starling/textures/Texture";
import Image from "./../../starling/display/Image";
import DisplayObject from "./../display/DisplayObject";
import Vector3D from "openfl/geom/Vector3D";
import Matrix from "openfl/geom/Matrix";

declare namespace starling.textures
{
	/** A RenderTexture is a any texture onto which you can draw any display object.
	 * 
	 *  <p>After creating a render texture, just call the <code>draw</code> method to render 
	 *  an object directly onto the texture. The object will be drawn onto the texture at its current
	 *  position, adhering its current rotation, scale and alpha properties.</p> 
	 *  
	 *  <p>Drawing is done very efficiently, as it is happening directly in graphics memory. After 
	 *  you have drawn objects onto the texture, the performance will be just like that of a normal 
	 *  texture — no matter how many objects you have drawn.</p>
	 *  
	 *  <p>If you draw lots of objects at once, it is recommended to bundle the drawing calls in 
	 *  a block via the <code>drawBundled</code> method, like shown below. That will speed it up 
	 *  immensely, allowing you to draw hundreds of objects very quickly.</p>
	 *  
	 * 	<pre>
	 *  renderTexture.drawBundled(function():void
	 *  {
	 *     for (i?:number; i&lt;numDrawings; ++i)
	 *     {
	 *         image.rotation = (2 &#42; Math.PI / numDrawings) &#42; i;
	 *         renderTexture.draw(image);
	 *     }   
	 *  });
	 *  </pre>
	 *  
	 *  <p>To erase parts of a render texture, you can use any display object like a "rubber" by
	 *  setting its blending mode to <code>BlendMode.ERASE</code>. To wipe it completely clean,
	 *  use the <code>clear</code> method.</p>
	 * 
	 *  <strong>Persistence</strong>
	 *
	 *  <p>Older devices may require double buffering to support persistent render textures. Thus,
	 *  you should disable the <code>persistent</code> parameter in the constructor if you only
	 *  need to make one draw operation on the texture. The static <code>useDoubleBuffering</code>
	 *  property allows you to customize if new textures will be created with or without double
	 *  buffering.</p>
	 *
	 *  <strong>Context Loss</strong>
	 *
	 *  <p>Unfortunately, render textures are wiped clean when the render context is lost.
	 *  This means that you need to manually recreate all their contents in such a case.
	 *  One way to do that is by using the <code>root.onRestore</code> callback, like here:</p>
	 *
	 *  <listing>
	 *  renderTexture.root.onRestore = function():void
	 *  {
	 *      quad:Quad = new Quad(100, 100, 0xff00ff);
	 *      renderTexture.clear(); // required on texture restoration
	 *      renderTexture.draw(quad);
	 *  });</listing>
	 *
	 *  <p>For example, a drawing app would need to store information about all draw operations
	 *  when they occur, and then recreate them inside <code>onRestore</code> on a context loss
	 *  (preferably using <code>drawBundled</code> instead).</p>
	 *
	 *  <p>However, there is one problem: when that callback is executed, it's very likely that
	 *  not all of your textures are already available, since they need to be restored, too (and
	 *  that might take a while). You probably loaded your textures with the "AssetManager".
	 *  In that case, you can listen to its <code>TEXTURES_RESTORED</code> event instead:</p>
	 *
	 *  <listing>
	 *  assetManager.addEventListener(Event.TEXTURES_RESTORED, function():void
	 *  {
	 *      brush:Image = new Image(assetManager.getTexture("brush"));
	 *      renderTexture.draw(brush);
	 *  });</listing>
	 *
	 *  <p>[Note that this time, there is no need to call <code>clear</code>, because that's the
	 *  default behavior of <code>onRestore</code>, anyway — and we didn't modify that.]</p>
	 *
	 */
	export class RenderTexture extends SubTexture
	{
		/** Creates a new RenderTexture with a certain size (in points). If the texture is
		 *  persistent, its contents remains intact after each draw call, allowing you to use the
		 *  texture just like a canvas. If it is not, it will be cleared before each draw call.
		 *
		 *  <p>Non-persistent textures can be used more efficiently on older devices; on modern
		 *  hardware, it does not make a difference. For more information, have a look at the
		 *  documentation of the <code>useDoubleBuffering</code> property.</p>
		 */
		public constructor(width:number, height:number, persistent?:boolean,
							scale?:number, format?:string);
		
		/** @inheritDoc */
		public /*override*/ dispose():void;
		
		/** Draws an object into the texture.
		 * 
		 *  @param object       The object to draw.
		 *  @param matrix       If 'matrix' is null, the object will be drawn adhering its 
		 *                      properties for position, scale, and rotation. If it is not null,
		 *                      the object will be drawn in the orientation depicted by the matrix.
		 *  @param alpha        The object's alpha value will be multiplied with this value.
		 *  @param antiAliasing Values range from 0 (no antialiasing) to 4 (best quality).
		 *                      Beginning with AIR 22, this feature is supported on all platforms
		 *                      (except for software rendering mode).
		 *  @param cameraPos    When drawing a 3D object, you can optionally pass in a custom
		 *                      camera position. If left empty, the camera will be placed with
		 *                      its default settings (centered over the texture, fov = 1.0).
		 */
		public draw(object:DisplayObject, matrix?:Matrix, alpha?:number,
							 antiAliasing?:number, cameraPos?:Vector3D):void;
		
		/** Bundles several calls to <code>draw</code> together in a block. This avoids buffer 
		 *  switches and allows you to draw multiple objects into a non-persistent texture.
		 *  Note that the 'antiAliasing' setting provided here overrides those provided in
		 *  individual 'draw' calls.
		 *  
		 *  @param drawingBlock  a callback with the form: <pre>function():void;</pre>
		 *  @param antiAliasing  Values range from 0 (no antialiasing) to 4 (best quality).
		 *                       Beginning with AIR 22, this feature is supported on all platforms
		 *                       (except for software rendering mode).
		 *  @param cameraPos     When drawing a 3D object, you can optionally pass in a custom
		 *                       camera position. If left empty, the camera will be placed with
		 *                       its default settings (centered over the texture, fov = 1.0).
		 */
		public drawBundled(drawingBlock:()=>void, antiAliasing?:number,
									cameraPos?:Vector3D):void;
		
		/** Clears the render texture with a certain color and alpha value. Call without any
		 *  arguments to restore full transparency. */
		public clear(color?:number, alpha?:number):void;
	
		// properties
	
		/** Indicates if the texture is persistent over multiple draw calls. */
		public readonly isPersistent:boolean;
		protected get_isPersistent():boolean;
		
		/** Indicates if new persistent textures should use double buffering. Single buffering
		 *  is faster and requires less memory, but is not supported on all hardware.
		 *
		 *  <p>By default, applications running with the profile "baseline" or "baselineConstrained"
		 *  will use double buffering; all others use just a single buffer. You can override this
		 *  behavior, though, by assigning a different value at runtime.</p>
		 *
		 *  @default true for "baseline" and "baselineConstrained", false otherwise
		 */
		public static useDoubleBuffering:boolean;
		protected static get_useDoubleBuffering():boolean;
		protected static set_useDoubleBuffering(value:boolean):boolean;
	}
}

export default starling.textures.RenderTexture;
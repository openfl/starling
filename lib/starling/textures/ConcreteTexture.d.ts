import Texture from "./../../starling/textures/Texture";
import NotSupportedError from "./../../starling/errors/NotSupportedError";
import AbstractMethodError from "./../../starling/errors/AbstractMethodError";
import Color from "./../../starling/utils/Color";
import Starling from "./../../starling/core/Starling";
import Error from "openfl/errors/Error";

declare namespace starling.textures
{
	/** A ConcreteTexture wraps a Stage3D texture object, storing the properties of the texture
	*  and providing utility methods for data upload, etc.
	*
	*  <p>This class cannot be instantiated directly; create instances using
	*  <code>Texture.fromTextureBase</code> instead. However, that's only necessary when
	*  you need to wrap a <code>TextureBase</code> object in a Starling texture;
	*  the preferred way of creating textures is to use one of the other
	*  <code>Texture.from...</code> factory methods in the <code>Texture</code> class.</p>
	*
	*  @see Texture
	*/
	export class ConcreteTexture extends Texture
	{
		/** Disposes the TextureBase object. */
		public /*override*/ dispose():void;
	
		// texture data upload
	
		/** Uploads a bitmap to the texture. The existing contents will be replaced.
		*  If the size of the bitmap does not match the size of the texture, the bitmap will be
		*  cropped or filled up with transparent pixels.
		*
		*  <p>Pass a callback to attempt asynchronous texture upload.
		*  If the current platform or runtime version does not support asynchronous texture loading,
		*  the callback will still be executed.</p>
		*
		*  <p>This is the expected definition:
		*  <code>function(texture:ConcreteTexture):void;</code>
		*/
		public uploadBitmap(bitmap:Bitmap, async?:(ConcreteTexture)=>void):void;
	
		/** Uploads bitmap data to the texture. The existing contents will be replaced.
		*  If the size of the bitmap does not match the size of the texture, the bitmap will be
		*  cropped or filled up with transparent pixels.
		*
		*  <p>Pass a callback to attempt asynchronous texture upload.
		*  If the current platform or runtime version does not support asynchronous texture loading,
		*  the callback will still be executed.</p>
		*
		*  <p>This is the expected definition:
		*  <code>function(texture:ConcreteTexture):void;</code>
		*/
		public uploadBitmapData(data:BitmapData, async?:(ConcreteTexture)=>void):void;
	
		/** Uploads ATF data from a ByteArray to the texture. Note that the size of the
		*  ATF-encoded data must be exactly the same as the original texture size.
		*  
		*  <p>The 'async' parameter is a callback function.
		*  If it's <code>null</code>, the texture will be decoded synchronously and will be visible right away.
		*  If it's a function, the data will be decoded asynchronously. The texture will remain unchanged until the
		*  upload is complete, at which time the callback will be executed. This is the
		*  expected definition: <code>function(texture:ConcreteTexture):void;</code></p>
		*/
		public uploadAtfData(data:ByteArray, offset?:number, async?:(ConcreteTexture)=>void):void;
	
		/** Specifies a video stream to be rendered within the texture. */
		public attachNetStream(netStream:NetStream, onComplete?:(ConcreteTexture)=>void):void;
	
		// #if flash
		// /** Specifies a video stream from a camera to be rendered within the texture. */
		// public attachCamera(camera:Camera, onComplete?:(ConcreteTexture)=>void):void;
		// #end
	
		/** Clears the texture with a certain color and alpha value. The previous contents of the
		*  texture is wiped out. */
		public clear(color?:number, alpha?:number):void;
	
		// properties
	
		/** Indicates if the base texture was optimized for being used in a render texture. */
		public readonly optimizedForRenderTexture:boolean;
		protected get_optimizedForRenderTexture():boolean;
	
		/** Indicates if the base texture is a standard power-of-two dimensioned texture of type
		*  <code>flash.display3D.textures.Texture</code>. */
		public readonly isPotTexture:boolean;
		protected get_isPotTexture():boolean;
	
		/** The that you provide here will be called after a context loss.
		*  On execution, a new base texture will already have been created; however,
		*  it will be empty. Call one of the "upload..." methods from within the callback
		*  to restore the actual texture data.
		*
		*  <listing>
		*  texture:Texture = Texture.fromBitmap(new EmbeddedBitmap());
		*  texture.root.onRestore = function():void
		*  {
		*      texture.root.uploadFromBitmap(new EmbeddedBitmap());
		*  };</listing>
		*/
		public onRestore:(ConcreteTexture)=>void;
		protected get_onRestore():(ConcreteTexture)=>void;
		protected set_onRestore(value:(ConcreteTexture)=>void):(ConcreteTexture)=>void;
	}
}

export default starling.textures.ConcreteTexture;
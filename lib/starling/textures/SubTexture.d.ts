import Texture from "./../../starling/textures/Texture";
import Rectangle from "openfl/geom/Rectangle";
import Matrix from "openfl/geom/Matrix";

declare namespace starling.textures
{
	/** A SubTexture represents a section of another texture. This is achieved solely by
	 *  manipulation of texture coordinates, making the class very efficient. 
	 *
	 *  <p><em>Note that it is OK to create subtextures of subtextures.</em></p>
	 */
	export class SubTexture extends Texture
	{
		/** Creates a new SubTexture containing the specified region of a parent texture.
		 *
		 *  @param parent     The texture you want to create a SubTexture from.
		 *  @param region     The region of the parent texture that the SubTexture will show
		 *                    (in points). If <code>null</code>, the complete area of the parent.
		 *  @param ownsParent If <code>true</code>, the parent texture will be disposed
		 *                    automatically when the SubTexture is disposed.
		 *  @param frame      If the texture was trimmed, the frame rectangle can be used to restore
		 *                    the trimmed area.
		 *  @param rotated    If true, the SubTexture will show the parent region rotated by
		 *                    90 degrees (CCW).
		 *  @param scaleModifier  The scale factor of the SubTexture will be calculated by
		 *                    multiplying the parent texture's scale factor with this value.
		 */
		public constructor(parent:Texture, region?:Rectangle,
							ownsParent?:boolean, frame?:Rectangle,
							rotated?:boolean, scaleModifier?:number);
	
		/** Disposes the parent texture if this texture owns it. */
		public /*override*/ dispose():void;
	
		/** The texture which the SubTexture is based on. */
		public readonly parent:Texture;
		protected get_parent():Texture;
		
		/** Indicates if the parent texture is disposed when this object is disposed. */
		public readonly ownsParent:boolean;
		protected get_ownsParent():boolean;
		
		/** If true, the SubTexture will show the parent region rotated by 90 degrees (CCW). */
		public readonly rotated:boolean;
		protected get_rotated():boolean;
	
		/** The region of the parent texture that the SubTexture is showing (in points).
		 *
		 *  <p>CAUTION: not a copy, but the actual object! Do not modify!</p> */
		public readonly region:Rectangle;
		protected get_region():Rectangle;
	}
}

export default starling.textures.SubTexture;
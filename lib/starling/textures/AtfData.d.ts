import ArgumentError from "openfl/errors/ArgumentError";
import Error from "openfl/errors/Error";

declare namespace starling.textures
{
	/** A parser for the ATF data format. */
	export class AtfData
	{
		/** Create a new instance by parsing the given byte array. */
		public constructor(data:ByteArray);
	
		/** Checks the first 3 bytes of the data for the 'ATF' signature. */
		public static isAtfData(data:ByteArray):boolean;
	
		/** The texture format. @see flash.display3D.textures.Context3DTextureFormat */
		public readonly format:string;
		protected get_format():string;
	
		/** The width of the texture in pixels. */
		public readonly width:number;
		protected get_width():number;
	
		/** The height of the texture in pixels. */
		public readonly height:number;
		protected get_height():number;
	
		/** The number of encoded textures. '1' means that there are no mip maps. */
		public readonly numTextures:number;
		protected get_numTextures():number;
	
		/** Indicates if the ATF data encodes a cube map. Not supported by Starling! */
		public readonly isCubeMap:boolean;
		protected get_isCubeMap():boolean;
	
		/** The actual byte data, including header. */
		public readonly data:ByteArray;
		protected get_data():ByteArray;
	}
}

export default starling.textures.AtfData;
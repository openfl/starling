import Capabilities from "openfl/system/Capabilities";
import Error from "openfl/errors/Error";
import Context3D from "openfl/display3D/Context3D";
import Font from "openfl/text/Font";

declare namespace starling.utils
{
	/** A utility class with methods related to the current platform and runtime. */
	export class SystemUtil
	{
		/** Initializes the <code>ACTIVATE/DEACTIVATE</code> event handlers on the native
			* application. This method is automatically called by the Starling constructor. */
		public static initialize():void;
	
		/** Executes the given with its arguments the next time the application is active.
			* (If it <em>is</em> active already, the call will be executed right away.) */
		public static executeWhenApplicationIsActive(call:Function, args?:Array<any>):void;
	
		/** Indicates if the application is currently active. On Desktop, this means that it has
			* the focus; on mobile, that it is in the foreground. In the Flash Plugin, always
			* returns true. */
		public static readonly isApplicationActive:boolean;
		protected static get_isApplicationActive():boolean;
	
		/** Indicates if the code is executed in an Adobe AIR runtime (true)
			* or Flash plugin/projector (false). */
		public static readonly isAIR:boolean;
		protected static get_isAIR():boolean;
		
		/** Returns the Flash Player/AIR version string. The format of the version number is:
			*  <em>majorVersion,minorVersion,buildNumber,internalBuildNumber</em>. */
		public static readonly version:string;
		protected static get_version():string;
	
		/** Returns the three-letter platform string of the current system. These are
			* the most common platforms: <code>WIN, MAC, LNX, IOS, AND, QNX</code>. Except for the
			* last one, which indicates "Blackberry", all should be self-explanatory. */
		public static platform:string;
		protected static get_platform():string;
		protected static set_platform(value:string):string;
	
		/** Returns the value of the 'initialWindow.depthAndStencil' node of the application
			* descriptor, if this in an AIR app; otherwise always <code>true</code>. */
		public static readonly supportsDepthAndStencil:boolean;
		protected static get_supportsDepthAndStencil():boolean;
	
		/** Indicates if Context3D supports video textures. At the time of this writing,
			* video textures are only supported on Windows, OS X and iOS, and only in AIR
			* applications (not the Flash Player). */
		public static readonly supportsVideoTexture:boolean;
		protected static get_supportsVideoTexture():boolean;
	
		// embedded fonts
	
		/** Updates the list of embedded fonts. To be called when a font is loaded at runtime. */
		public static updateEmbeddedFonts():void;
	
		/** Figures out if an embedded font with the specified style is available.
			*  The fonts are enumerated only once; if you load a font at runtime, be sure to call
			*  'updateEmbeddedFonts' before calling this method.
			*
			*  @param fontName  the name of the font
			*  @param bold      indicates if the font has a bold style
			*  @param italic    indicates if the font has an italic style
			*  @param fontType  the type of the font (one of the constants defined in the FontType class)
			*/
		public static isEmbeddedFont(fontName:string, bold?:boolean, italic?:boolean,
												fontType?:string):boolean;
	
		// convenience methods
	
		/** Indicates if the code is executed on an iOS device, based on the <code>platform</code>
			*  string. */
		public static readonly isIOS:boolean;
		protected static get_isIOS():boolean;
	
		/** Indicates if the code is executed on an Android device, based on the
			*  <code>platform</code> string. */
		public static readonly isAndroid:boolean;
		protected static get_isAndroid():boolean;
	
		/** Indicates if the code is executed on a Macintosh, based on the <code>platform</code>
			*  string. */
		public static readonly isMac:boolean;
		protected static get_isMac():boolean;
	
		/** Indicates if the code is executed on Windows, based on the <code>platform</code>
			*  string. */
		public static readonly isWindows:boolean;
		protected static get_isWindows():boolean;
	
		/** Indicates if the code is executed on a Desktop computer with Windows, macOS or Linux
			*  operating system. If the method returns 'false', it's probably a mobile device
			*  or a Smart TV. */
		public static readonly isDesktop:boolean;
		protected static get_isDesktop():boolean;
	}
}

export default starling.utils.SystemUtil;
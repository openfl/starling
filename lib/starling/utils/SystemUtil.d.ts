import HxOverrides from "./../../HxOverrides";
import openfl_system_Capabilities from "openfl/system/Capabilities";
import openfl_Lib from "openfl/Lib";
import js__$Boot_HaxeError from "./../../js/_Boot/HaxeError";
import js_Boot from "./../../js/Boot";
import openfl_errors_Error from "openfl/errors/Error";
import Reflect from "./../../Reflect";
import haxe_Log from "./../../haxe/Log";
import openfl_display3D_Context3D from "openfl/display3D/Context3D";
import openfl_text_Font from "openfl/text/Font";
import openfl_text__$FontStyle_FontStyle_$Impl_$ from "./../../openfl/text/_FontStyle/FontStyle_Impl_";
import openfl_text__$FontType_FontType_$Impl_$ from "./../../openfl/text/_FontType/FontType_Impl_";

declare namespace starling.utils {

export class SystemUtil {

	static sInitialized:any;
	static sApplicationActive:any;
	static sWaitingCalls:any;
	static sPlatform:any;
	static sVersion:any;
	static sAIR:any;
	static sEmbeddedFonts:any;
	static sSupportsDepthAndStencil:any;
	static initialize():any;
	static onActivate(event:any):any;
	static onDeactivate(event:any):any;
	static executeWhenApplicationIsActive(call:any, args:any):any;
	static isApplicationActive:any;
	static get_isApplicationActive():any;
	static isAIR:any;
	static get_isAIR():any;
	static version:any;
	static get_version():any;
	static platform:any;
	static get_platform():any;
	static set_platform(value:any):any;
	static supportsDepthAndStencil:any;
	static get_supportsDepthAndStencil():any;
	static supportsVideoTexture:any;
	static get_supportsVideoTexture():any;
	static updateEmbeddedFonts():any;
	static isEmbeddedFont(fontName:any, bold?:any, italic?:any, fontType?:any):any;
	static isIOS:any;
	static get_isIOS():any;
	static isAndroid:any;
	static get_isAndroid():any;
	static isMac:any;
	static get_isMac():any;
	static isWindows:any;
	static get_isWindows():any;
	static isDesktop:any;
	static get_isDesktop():any;


}

}

export default starling.utils.SystemUtil;
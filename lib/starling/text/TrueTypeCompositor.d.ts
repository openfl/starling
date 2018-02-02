import starling_text_ITextCompositor from "./../../starling/text/ITextCompositor";
import starling_textures_Texture from "./../../starling/textures/Texture";
import openfl_display3D__$Context3DTextureFormat_Context3DTextureFormat_$Impl_$ from "./../../openfl/display3D/_Context3DTextureFormat/Context3DTextureFormat_Impl_";
import Std from "./../../Std";
import starling_utils_SystemUtil from "./../../starling/utils/SystemUtil";
import starling_utils_MathUtil from "./../../starling/utils/MathUtil";
import starling_text_BitmapDataEx from "./../../starling/text/BitmapDataEx";
import openfl_geom_Matrix from "openfl/geom/Matrix";
import starling_display_Quad from "./../../starling/display/Quad";
import openfl_text_TextField from "openfl/text/TextField";
import openfl_text_TextFormat from "openfl/text/TextFormat";

declare namespace starling.text {

export class TrueTypeCompositor {

	constructor();
	dispose():any;
	fillMeshBatch(meshBatch:any, width:any, height:any, text:any, format:any, options?:any):any;
	clearMeshBatch(meshBatch:any):any;
	renderText(width:any, height:any, text:any, format:any, options:any):any;
	autoScaleNativeTextField(textField:any, text:any, isHtmlText:any):any;
	static sHelperMatrix:any;
	static sHelperQuad:any;
	static sNativeTextField:any;
	static sNativeFormat:any;


}

}

export default starling.text.TrueTypeCompositor;
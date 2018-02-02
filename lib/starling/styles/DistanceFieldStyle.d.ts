import starling_styles_MeshStyle from "./../../starling/styles/MeshStyle";
import Std from "./../../Std";
import starling_styles_DistanceFieldEffect from "./../../starling/styles/DistanceFieldEffect";
import starling_utils_Color from "./../../starling/utils/Color";
import starling_utils_MathUtil from "./../../starling/utils/MathUtil";
import js_Boot from "./../../js/Boot";
import _$UInt_UInt_$Impl_$ from "./../../_UInt/UInt_Impl_";

declare namespace starling.styles {

export class DistanceFieldStyle extends starling_styles_MeshStyle {

	constructor(softness?:any, threshold?:any);
	_mode:any;
	_multiChannel:any;
	_threshold:any;
	_alpha:any;
	_softness:any;
	_outerThreshold:any;
	_outerAlphaEnd:any;
	_shadowOffsetX:any;
	_shadowOffsetY:any;
	_outerColor:any;
	_outerAlphaStart:any;
	copyFrom(meshStyle:any):any;
	createEffect():any;
	get_vertexFormat():any;
	onTargetAssigned(target:any):any;
	updateVertices():any;
	batchVertexData(targetStyle:any, targetVertexID?:any, matrix?:any, vertexID?:any, numVertices?:any):any;
	updateEffect(effect:any, state:any):any;
	canBatchWith(meshStyle:any):any;
	setupBasic():any;
	setupOutline(width?:any, color?:any, alpha?:any):any;
	setupGlow(blur?:any, color?:any, alpha?:any):any;
	setupDropShadow(blur?:any, offsetX?:any, offsetY?:any, color?:any, alpha?:any):any;
	mode:any;
	get_mode():any;
	set_mode(value:any):any;
	multiChannel:any;
	get_multiChannel():any;
	set_multiChannel(value:any):any;
	threshold:any;
	get_threshold():any;
	set_threshold(value:any):any;
	softness:any;
	get_softness():any;
	set_softness(value:any):any;
	alpha:any;
	get_alpha():any;
	set_alpha(value:any):any;
	outerThreshold:any;
	get_outerThreshold():any;
	set_outerThreshold(value:any):any;
	outerAlphaStart:any;
	get_outerAlphaStart():any;
	set_outerAlphaStart(value:any):any;
	outerAlphaEnd:any;
	get_outerAlphaEnd():any;
	set_outerAlphaEnd(value:any):any;
	outerColor:any;
	get_outerColor():any;
	set_outerColor(value:any):any;
	shadowOffsetX:any;
	get_shadowOffsetX():any;
	set_shadowOffsetX(value:any):any;
	shadowOffsetY:any;
	get_shadowOffsetY():any;
	set_shadowOffsetY(value:any):any;
	static VERTEX_FORMAT:any;
	static MODE_BASIC:any;
	static MODE_OUTLINE:any;
	static MODE_GLOW:any;
	static MODE_SHADOW:any;


}

}

export default starling.styles.DistanceFieldStyle;
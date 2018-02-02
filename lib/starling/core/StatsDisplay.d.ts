import starling_display_Sprite from "./../../starling/display/Sprite";
import js_Boot from "./../../js/Boot";
import starling_events_EnterFrameEvent from "./../../starling/events/EnterFrameEvent";
import openfl_system_System from "openfl/system/System";
import Reflect from "./../../Reflect";
import starling_core_Starling from "./../../starling/core/Starling";
import starling_utils_MathUtil from "./../../starling/utils/MathUtil";
import Std from "./../../Std";
import starling_text_TextField from "./../../starling/text/TextField";
import starling_display_Quad from "./../../starling/display/Quad";
import starling_styles_MeshStyle from "./../../starling/styles/MeshStyle";

declare namespace starling.core {

export class StatsDisplay extends starling_display_Sprite {

	constructor();
	__background:any;
	__labels:any;
	__values:any;
	__frameCount:any;
	__totalTime:any;
	__fps:any;
	__memory:any;
	__gpuMemory:any;
	__drawCount:any;
	__skipCount:any;
	onAddedToStage(e:any):any;
	onRemovedFromStage(e:any):any;
	onEnterFrame(e:any):any;
	update():any;
	markFrameAsSkipped():any;
	render(painter:any):any;
	supportsGpuMem:any;
	get_supportsGpuMem():any;
	drawCount:any;
	get_drawCount():any;
	set_drawCount(value:any):any;
	fps:any;
	get_fps():any;
	set_fps(value:any):any;
	memory:any;
	get_memory():any;
	set_memory(value:any):any;
	gpuMemory:any;
	get_gpuMemory():any;
	set_gpuMemory(value:any):any;
	static UPDATE_INTERVAL:any;
	static B_TO_MB:any;


}

}

export default starling.core.StatsDisplay;
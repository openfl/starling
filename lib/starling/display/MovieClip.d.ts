import starling_animation_IAnimatable from "./../../starling/animation/IAnimatable";
import starling_display_Image from "./../../starling/display/Image";
import js__$Boot_HaxeError from "./../../js/_Boot/HaxeError";
import openfl_errors_ArgumentError from "openfl/errors/ArgumentError";
import openfl_Vector from "openfl/Vector";
import starling_display__$MovieClip_MovieClipFrame from "./../../starling/display/_MovieClip/MovieClipFrame";
import openfl_errors_IllegalOperationError from "openfl/errors/IllegalOperationError";

declare namespace starling.display {

export class MovieClip extends starling_display_Image {

	constructor(textures:any, fps?:any);
	__frames:any;
	__defaultFrameDuration:any;
	__currentTime:any;
	__currentFrameID:any;
	__loop:any;
	__playing:any;
	__muted:any;
	__wasStopped:any;
	__soundTransform:any;
	init(textures:any, fps:any):any;
	addFrame(texture:any, sound?:any, duration?:any):any;
	addFrameAt(frameID:any, texture:any, sound?:any, duration?:any):any;
	removeFrameAt(frameID:any):any;
	getFrameTexture(frameID:any):any;
	setFrameTexture(frameID:any, texture:any):any;
	getFrameSound(frameID:any):any;
	setFrameSound(frameID:any, sound:any):any;
	getFrameAction(frameID:any):any;
	setFrameAction(frameID:any, action:any):any;
	getFrameDuration(frameID:any):any;
	setFrameDuration(frameID:any, duration:any):any;
	reverseFrames():any;
	play():any;
	pause():any;
	stop():any;
	updateStartTimes():any;
	advanceTime(passedTime:any):any;
	numFrames:any;
	get_numFrames():any;
	totalTime:any;
	get_totalTime():any;
	currentTime:any;
	get_currentTime():any;
	set_currentTime(value:any):any;
	loop:any;
	get_loop():any;
	set_loop(value:any):any;
	muted:any;
	get_muted():any;
	set_muted(value:any):any;
	soundTransform:any;
	get_soundTransform():any;
	set_soundTransform(value:any):any;
	currentFrame:any;
	get_currentFrame():any;
	set_currentFrame(value:any):any;
	fps:any;
	get_fps():any;
	set_fps(value:any):any;
	isPlaying:any;
	get_isPlaying():any;
	isComplete:any;
	get_isComplete():any;


}

}

export default starling.display.MovieClip;
package starling.display;

import starling.animation.IAnimatable;
import starling.display.Image;

@:jsRequire("starling/display/MovieClip", "default")

extern class MovieClip extends starling.display.Image implements Dynamic {

	function new(textures:Dynamic, ?fps:Dynamic);
	var __frames:Dynamic;
	var __defaultFrameDuration:Dynamic;
	var __currentTime:Dynamic;
	var __currentFrameID:Dynamic;
	var __loop:Dynamic;
	var __playing:Dynamic;
	var __muted:Dynamic;
	var __wasStopped:Dynamic;
	var __soundTransform:Dynamic;
	function init(textures:Dynamic, fps:Dynamic):Dynamic;
	function addFrame(texture:Dynamic, ?sound:Dynamic, ?duration:Dynamic):Dynamic;
	function addFrameAt(frameID:Dynamic, texture:Dynamic, ?sound:Dynamic, ?duration:Dynamic):Dynamic;
	function removeFrameAt(frameID:Dynamic):Dynamic;
	function getFrameTexture(frameID:Dynamic):Dynamic;
	function setFrameTexture(frameID:Dynamic, texture:Dynamic):Dynamic;
	function getFrameSound(frameID:Dynamic):Dynamic;
	function setFrameSound(frameID:Dynamic, sound:Dynamic):Dynamic;
	function getFrameAction(frameID:Dynamic):Dynamic;
	function setFrameAction(frameID:Dynamic, action:Dynamic):Dynamic;
	function getFrameDuration(frameID:Dynamic):Dynamic;
	function setFrameDuration(frameID:Dynamic, duration:Dynamic):Dynamic;
	function reverseFrames():Dynamic;
	function play():Dynamic;
	function pause():Dynamic;
	function stop():Dynamic;
	function updateStartTimes():Dynamic;
	function advanceTime(passedTime:Dynamic):Dynamic;
	var numFrames:Dynamic;
	function get_numFrames():Dynamic;
	var totalTime:Dynamic;
	function get_totalTime():Dynamic;
	var currentTime:Dynamic;
	function get_currentTime():Dynamic;
	function set_currentTime(value:Dynamic):Dynamic;
	var loop:Dynamic;
	function get_loop():Dynamic;
	function set_loop(value:Dynamic):Dynamic;
	var muted:Dynamic;
	function get_muted():Dynamic;
	function set_muted(value:Dynamic):Dynamic;
	var soundTransform:Dynamic;
	function get_soundTransform():Dynamic;
	function set_soundTransform(value:Dynamic):Dynamic;
	var currentFrame:Dynamic;
	function get_currentFrame():Dynamic;
	function set_currentFrame(value:Dynamic):Dynamic;
	var fps:Dynamic;
	function get_fps():Dynamic;
	function set_fps(value:Dynamic):Dynamic;
	var isPlaying:Dynamic;
	function get_isPlaying():Dynamic;
	var isComplete:Dynamic;
	function get_isComplete():Dynamic;


}
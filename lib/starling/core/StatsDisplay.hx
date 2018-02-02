package starling.core;

import starling.display.Sprite;
import js.Boot;
import starling.events.EnterFrameEvent;
import Reflect;
import starling.core.Starling;
import starling.utils.MathUtil;
import Std;
import starling.text.TextField;
import starling.display.Quad;
import starling.styles.MeshStyle;

@:jsRequire("starling/core/StatsDisplay", "default")

extern class StatsDisplay extends starling.display.Sprite implements Dynamic {

	function new();
	var __background:Dynamic;
	var __labels:Dynamic;
	var __values:Dynamic;
	var __frameCount:Dynamic;
	var __totalTime:Dynamic;
	var __fps:Dynamic;
	var __memory:Dynamic;
	var __gpuMemory:Dynamic;
	var __drawCount:Dynamic;
	var __skipCount:Dynamic;
	function onAddedToStage(e:Dynamic):Dynamic;
	function onRemovedFromStage(e:Dynamic):Dynamic;
	function onEnterFrame(e:Dynamic):Dynamic;
	function update():Dynamic;
	function markFrameAsSkipped():Dynamic;
	override function render(painter:Dynamic):Dynamic;
	var supportsGpuMem:Dynamic;
	function get_supportsGpuMem():Dynamic;
	var drawCount:Dynamic;
	function get_drawCount():Dynamic;
	function set_drawCount(value:Dynamic):Dynamic;
	var fps:Dynamic;
	function get_fps():Dynamic;
	function set_fps(value:Dynamic):Dynamic;
	var memory:Dynamic;
	function get_memory():Dynamic;
	function set_memory(value:Dynamic):Dynamic;
	var gpuMemory:Dynamic;
	function get_gpuMemory():Dynamic;
	function set_gpuMemory(value:Dynamic):Dynamic;
	static var UPDATE_INTERVAL:Dynamic;
	static var B_TO_MB:Dynamic;


}
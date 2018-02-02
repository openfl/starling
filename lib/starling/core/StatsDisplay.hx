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

extern class StatsDisplay extends starling.display.Sprite {
	var drawCount(get,set) : Int;
	var fps(get,set) : Float;
	var gpuMemory(get,set) : Float;
	var memory(get,set) : Float;
	function new() : Void;
	function markFrameAsSkipped() : Void;
	function update() : Void;
}
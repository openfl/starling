package starling.rendering;

import starling.utils.StringUtil;

@:jsRequire("starling/rendering/BatchToken", "default")

extern class BatchToken implements Dynamic {

	function new(?batchID:Dynamic, ?vertexID:Dynamic, ?indexID:Dynamic);
	var batchID:Dynamic;
	var vertexID:Dynamic;
	var indexID:Dynamic;
	function copyFrom(token:Dynamic):Dynamic;
	function setTo(?batchID:Dynamic, ?vertexID:Dynamic, ?indexID:Dynamic):Dynamic;
	function reset():Dynamic;
	function equals(other:Dynamic):Dynamic;
	function toString():Dynamic;


}
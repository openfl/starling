package starling.filters;



@:jsRequire("starling/filters/IFilterHelper", "default")

extern class IFilterHelper implements Dynamic {

	
	function get_targetBounds():Dynamic;
	function get_target():Dynamic;
	function getTexture(?resolution:Dynamic):Dynamic;
	function putTexture(texture:Dynamic):Dynamic;
	var targetBounds:Dynamic;
	var target:Dynamic;


}
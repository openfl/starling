package starling.utils;



@:jsRequire("starling/utils/Pool", "default")

extern class Pool implements Dynamic {

	function new();
	static var sPoints:Dynamic;
	static var sPoints3D:Dynamic;
	static var sMatrices:Dynamic;
	static var sMatrices3D:Dynamic;
	static var sRectangles:Dynamic;
	static function getPoint(?x:Dynamic, ?y:Dynamic):Dynamic;
	static function putPoint(point:Dynamic):Dynamic;
	static function getPoint3D(?x:Dynamic, ?y:Dynamic, ?z:Dynamic):Dynamic;
	static function putPoint3D(point:Dynamic):Dynamic;
	static function getMatrix(?a:Dynamic, ?b:Dynamic, ?c:Dynamic, ?d:Dynamic, ?tx:Dynamic, ?ty:Dynamic):Dynamic;
	static function putMatrix(matrix:Dynamic):Dynamic;
	static function getMatrix3D(?identity:Dynamic):Dynamic;
	static function putMatrix3D(matrix:Dynamic):Dynamic;
	static function getRectangle(?x:Dynamic, ?y:Dynamic, ?width:Dynamic, ?height:Dynamic):Dynamic;
	static function putRectangle(rectangle:Dynamic):Dynamic;


}
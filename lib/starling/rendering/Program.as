package starling.rendering {

	import openfl.display3D.Context3D;
	import openfl.utils.ByteArray;
	import starling.core.Starling;
	import starling.errors.MissingContextError;

	/**
	 * @externs
	 */
	public class Program {
		public function Program(vertexShader:openfl.utils.ByteArray, fragmentShader:openfl.utils.ByteArray):void {}
		public function activate(context:openfl.display3D.Context3D = null):void {}
		public function dispose():void {}
		public static function fromSource(vertexShader:String, fragmentShader:String, agalVersion:uint = 0):Program { return null; }
	}

}
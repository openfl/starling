package starling.filters {

	import openfl.geom.Rectangle;
	import starling.display.DisplayObject;
	import starling.textures.Texture;

	/**
	 * @externs
	 */
	public interface IFilterHelper {
		function get target():starling.display.DisplayObject;
		function get targetBounds():openfl.geom.Rectangle;
		function getTexture(resolution:Number = 0):starling.textures.Texture;
		function putTexture(texture:starling.textures.Texture):void;
	}

}
package starling.filters {

	import openfl.geom.Point;
	import starling.filters.FragmentFilter;
	// import starling.filters.CompositeEffect;
	import starling.rendering.Effect;

	/**
	 * @externs
	 */
	public class CompositeFilter extends FragmentFilter {
		public function get compositeEffect():starling.rendering.Effect { return null; } //CompositeEffect;
		public function CompositeFilter():void {}
		public function getAlphaAt(layerID:int):Number { return 0; }
		public function getColorAt(layerID:int):uint { return 0; }
		public function getOffsetAt(layerID:int, out:openfl.geom.Point = null):openfl.geom.Point { return null; }
		public function setAlphaAt(layerID:int, alpha:Number):void {}
		public function setColorAt(layerID:int, color:uint, replace:Boolean = false):void {}
		public function setOffsetAt(layerID:int, x:Number, y:Number):void {}
	}

}
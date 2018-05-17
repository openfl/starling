package starling.filters {

	import starling.filters.FragmentFilter;
	// import starling.filters.ColorMatrixEffect;
	import starling.rendering.Effect;
	import starling.utils.Color;
	import openfl.Vector;

	/**
	 * @externs
	 */
	public class ColorMatrixFilter extends FragmentFilter {
		public function get colorEffect():starling.rendering.Effect { return null; } //ColorMatrixEffect;
		public var matrix:openfl.Vector;
		public function ColorMatrixFilter(matrix:openfl.Vector = null):void {}
		public function adjustBrightness(value:Number):void {}
		public function adjustContrast(value:Number):void {}
		public function adjustHue(value:Number):void {}
		public function adjustSaturation(sat:Number):void {}
		public function concat(matrix:openfl.Vector):void {}
		public function concatValues(m0:Number, m1:Number, m2:Number, m3:Number, m4:Number, m5:Number, m6:Number, m7:Number, m8:Number, m9:Number, m10:Number, m11:Number, m12:Number, m13:Number, m14:Number, m15:Number, m16:Number, m17:Number, m18:Number, m19:Number):void {}
		public function invert():void {}
		public function reset():void {}
		public function tint(color:uint, amount:Number = 0):void {}
	}

}
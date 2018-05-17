package starling.filters {

	import starling.filters.FragmentFilter;
	import starling.filters.CompositeFilter;
	import starling.filters.BlurFilter;

	/**
	 * @externs
	 */
	public class DropShadowFilter extends FragmentFilter {
		public var alpha:Number;
		public var angle:Number;
		public var blur:Number;
		public var color:uint;
		public var distance:Number;
		public function DropShadowFilter(distance:Number = 0, angle:Number = 0, color:uint = 0, alpha:Number = 0, blur:Number = 0, resolution:Number = 0):void {}
	}

}
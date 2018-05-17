package starling.filters {

	import starling.filters.FragmentFilter;
	import starling.filters.BlurFilter;
	import starling.filters.CompositeFilter;

	/**
	 * @externs
	 */
	public class GlowFilter extends FragmentFilter {
		public var alpha:Number;
		public var blur:Number;
		public var color:uint;
		public function GlowFilter(color:uint = 0, alpha:Number = 0, blur:Number = 0, resolution:Number = 0):void {}
	}

}
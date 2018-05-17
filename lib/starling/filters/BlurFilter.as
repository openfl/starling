package starling.filters {

	import starling.filters.FragmentFilter;
	// import starling.filters.BlurEffect;
	import starling.core.Starling;

	/**
	 * @externs
	 */
	public class BlurFilter extends FragmentFilter {
		public var blurX:Number;
		public var blurY:Number;
		public function BlurFilter(blurX:Number = 0, blurY:Number = 0, resolution:Number = 0):void {}
	}

}
package starling.filters {

	import starling.filters.FragmentFilter;
	// import starling.filters.DisplacementMapEffect;
	import starling.rendering.Effect;
	import starling.textures.Texture;

	/**
	 * @externs
	 */
	public class DisplacementMapFilter extends FragmentFilter {
		public var componentX:uint;
		public var componentY:uint;
		public function get dispEffect():starling.rendering.Effect { return null; } //DisplacementMapEffect;
		public var mapRepeat:Boolean;
		public var mapTexture:starling.textures.Texture;
		public var mapX:Number;
		public var mapY:Number;
		public var scaleX:Number;
		public var scaleY:Number;
		public function DisplacementMapFilter(mapTexture:starling.textures.Texture, componentX:uint = 0, componentY:uint = 0, scaleX:Number = 0, scaleY:Number = 0):void {}
	}

}
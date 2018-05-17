package starling.styles {

	import starling.rendering.VertexDataFormat;
	import starling.styles.MeshStyle;
	// import starling.styles.DistanceFieldEffect;
	import starling.utils.Color;
	import starling.utils.MathUtil;

	/**
	 * @externs
	 */
	public class DistanceFieldStyle extends MeshStyle {
		public var alpha:Number;
		public var mode:String;
		public var multiChannel:Boolean;
		public var outerAlphaEnd:Number;
		public var outerAlphaStart:Number;
		public var outerColor:uint;
		public var outerThreshold:Number;
		public var shadowOffsetX:Number;
		public var shadowOffsetY:Number;
		public var softness:Number;
		public var threshold:Number;
		public function DistanceFieldStyle(softness:Number = 0, threshold:Number = 0):void {}
		public function setupBasic():void {}
		public function setupDropShadow(blur:Number = 0, offsetX:Number = 0, offsetY:Number = 0, color:uint = 0, alpha:Number = 0):void {}
		public function setupGlow(blur:Number = 0, color:uint = 0, alpha:Number = 0):void {}
		public function setupOutline(width:Number = 0, color:uint = 0, alpha:Number = 0):void {}
		/** Basic distance field rendering, without additional effects. */
		public static const MODE_BASIC:String = "basic";

		/** Adds an outline around the edge of the shape. */
		public static const MODE_OUTLINE:String = "outline";

		/** Adds a smooth glow effect around the shape. */
		public static const MODE_GLOW:String = "glow";

		/** Adds a drop shadow behind the shape. */
		public static const MODE_SHADOW:String = "shadow";
		public static var VERTEX_FORMAT:starling.rendering.VertexDataFormat;
	}

}
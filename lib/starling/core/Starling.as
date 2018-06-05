package starling.core {
	
	
	import openfl.display3D.Context3D;
	import openfl.display3D.Context3DProfile;
	import openfl.display3D.Context3DRenderMode;
	import openfl.display.Stage;
	import openfl.display.Stage3D;
	import openfl.geom.Rectangle;
	// import openfl.Vector;
	import starling.animation.Juggler;
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import starling.display.Stage;
	import starling.events.EventDispatcher;
	import starling.events.TouchProcessor;
	import starling.rendering.Painter;
	
	
	/**
	 * @externs
	 */
	public class Starling extends EventDispatcher {
		
		public static function get VERSION ():String { return null; }
		
		public function get isStarted():Boolean { return false; }
		public function get juggler():Juggler { return null; }
		public function get painter():Painter { return null; }
		public function get context():Context3D { return null; }
		public var simulateMultitouch:Boolean;
		public var enableErrorChecking:Boolean;
		public var antiAliasing:int;
		public var viewPort:Rectangle;
		public function get contentScaleFactor():Number { return 0; }
		public function get nativeOverlay():Sprite { return null; }
		public var showStats:Boolean;
		public function get stage():starling.display.Stage { return null; }
		public function get stage3D():Stage3D { return null; }
		public function get nativeStage():openfl.display.Stage { return null; }
		public function get root():DisplayObject { return null; }
		public var rootClass:Class;
		public var shareContext:Boolean;
		public function get profile():String { return null; }
		public var supportHighResolutions:Boolean;
		public var supportBrowserZoom:Boolean;
		public var skipUnchangedFrames:Boolean;
		public var touchProcessor:TouchProcessor;
		public function get frameID():uint { return 0; }
		public function get contextValid():Boolean { return false; }
		public static function get current():Starling { return null; }
		public static function get all():Vector.<Starling> { return null; }
		public static var multitouchEnabled:Boolean;
		
		public function Starling(rootClass:Class, stage:openfl.display.Stage, 
								viewPort:Rectangle=null, stage3D:Stage3D=null,
								renderMode:String="auto", profile:Object="auto") {}
		public function dispose():void {}
		public function nextFrame():void {}
		public function advanceTime(passedTime:Number):void {}
		public function render():void {}
		public function stopWithFatalError(message:String):void {}
		public function makeCurrent():void {}
		public function start():void {}
		public function stop(suspendRendering:Boolean=false):void {}
		public function setRequiresRedraw():void {}
		public function showStatsAt(horizontalAlign:String="left",
									verticalAlign:String="top", scale:Number=1):void {}
		
		
	}
	
	
}
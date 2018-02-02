package starling.core;


import openfl.display3D.Context3D;
import openfl.display3D.Context3DProfile;
import openfl.display3D.Context3DRenderMode;
import openfl.display.Stage in OpenFLStage;
import openfl.display.Stage3D;
import openfl.geom.Rectangle;
import openfl.Vector;
import starling.animation.Juggler;
import starling.display.DisplayObject;
import starling.display.Sprite;
import starling.display.Stage;
import starling.events.EventDispatcher;
import starling.events.TouchProcessor;
import starling.rendering.Painter;

@:jsRequire("starling/core/Starling", "default")


extern class Starling extends EventDispatcher {
	
	public static var VERSION:String;
	
	public var isStarted(get, never):Bool;
	public var juggler(get, never):Juggler;
	public var painter(get, never):Painter;
	public var context(get, never):Context3D;
	public var simulateMultitouch(get, set):Bool;
	public var enableErrorChecking(get, set):Bool;
	public var antiAliasing(get, set):Int;
	public var viewPort(get, set):Rectangle;
	public var contentScaleFactor(get, never):Float;
	public var nativeOverlay(get, never):Sprite;
	public var showStats(get, set):Bool;
	public var stage(get, never):Stage;
	public var stage3D(get, never):Stage3D;
	public var nativeStage(get, never):OpenFLStage;
	public var root(get, never):DisplayObject;
	public var rootClass(get, set):Class<Dynamic>;
	public var shareContext(get, set):Bool;
	public var profile(get, never):Context3DProfile;
	public var supportHighResolutions(get, set):Bool;
	public var skipUnchangedFrames(get, set):Bool;
	public var touchProcessor(get, set):TouchProcessor;
	public var frameID(get, never):UInt;
	public var contextValid(get, never):Bool;
	public static var current(get, never):Starling;
	public static var all(get, never):Vector<Starling>;
	public static var multitouchEnabled(get, set):Bool;
	
	public function new(rootClass:Class<Dynamic>, stage:OpenFLStage, 
                             viewPort:Rectangle=null, stage3D:Stage3D=null,
                             renderMode:Context3DRenderMode=AUTO, profile:Dynamic="auto");
	public function dispose():Void;
	public function nextFrame():Void;
	public function advanceTime(passedTime:Float):Void;
	public function render():Void;
	public function stopWithFatalError(message:String):Void;
	public function makeCurrent():Void;
	public function start():Void;
	public function stop(suspendRendering:Bool=false):Void;
	public function setRequiresRedraw():Void;
	public function showStatsAt(horizontalAlign:String="left",
                                verticalAlign:String="top", scale:Float=1):Void;
	
	
}
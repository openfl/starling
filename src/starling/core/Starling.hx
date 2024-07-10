// =================================================================================================
//
//	Starling Framework
//	Copyright Gamua GmbH. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================
package starling.core;

import haxe.macro.Compiler;
import haxe.Timer;
import openfl.display.DisplayObjectContainer;
import openfl.display.Shape;
import openfl.display.Sprite;
import openfl.display.Stage3D;
import openfl.display.Stage in OpenFLStage;
import openfl.display.StageAlign;
import openfl.display.StageScaleMode;
import openfl.display3D.Context3D;
import openfl.display3D.Context3DCompareMode;
import openfl.display3D.Context3DProfile;
import openfl.display3D.Context3DRenderMode;
import openfl.display3D.Context3DTriangleFace;
import openfl.display3D.Program3D;
import openfl.errors.ArgumentError;
import openfl.errors.Error;
import openfl.events.ErrorEvent;
import openfl.events.Event;
import openfl.events.KeyboardEvent;
import openfl.events.MouseEvent;
import openfl.events.TouchEvent;
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.system.Capabilities;
import openfl.text.TextField;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;
import openfl.ui.KeyLocation;
import openfl.ui.Mouse;
import openfl.ui.Multitouch;
import openfl.ui.MultitouchInputMode;
import openfl.utils.ByteArray;
import openfl.Lib;
import starling.animation.Juggler;
import starling.display.DisplayObject;
import starling.display.Stage;
import starling.events.EventDispatcher;
import starling.events.ResizeEvent;
import starling.events.TouchPhase;
import starling.events.TouchProcessor;
import starling.rendering.Painter;
import starling.utils.Align;
import starling.utils.Color;
import starling.utils.MatrixUtil;
import starling.utils.Pool;
import starling.utils.RectangleUtil;
import starling.utils.SystemUtil;

/**
 * Dispatched when a new render context is created. The 'data' property references the context.
 * @:meta(Event(name = "context3DCreate", type = "starling.events.Event"))
 * 
 * Dispatched when the root class has been created. The 'data' property references that object.
 * @:meta(Event(name = "rootCreated", type = "starling.events.Event"))
 * 
 * Dispatched when a fatal error is encountered. The 'data' property contains an error string.
 * @:meta(Event(name = "fatalError", type = "starling.events.Event"))
 * 
 * Dispatched when the display list is about to be rendered. This event provides the last
 * opportunity to make changes before the display list is rendered.
 * @:meta(Event(name = "render", type = "starling.events.Event"))
 * 
 * The Starling class represents the core of the Starling framework.
 * 
 * The Starling framework enables the creation of 2D applications and games using the Stage3D
 * architecture introduced in Flash Player 11. It implements a display tree system similar to
 * conventional Flash, leveraging GPUs for accelerated rendering.
 * 
 * To create a Starling-powered application, instantiate the Starling class:
 * 
 * var starling:Starling = new Starling(Game, stage);
 * 
 * The first parameter, a subclass of 'starling.display.Sprite', specifies the application root
 * class. For example, "Game" becomes the root object created upon Starling initialization.
 * The second parameter is the conventional Flash stage object, where Starling contents are
 * displayed directly below by default.
 * 
 * It's recommended to store the Starling instance as a member variable to prevent garbage
 * collection. Start Starling after creation:
 * 
 * starling.start();
 * 
 * Starling renders at the application's defined frame rate, as set in the Flash stage.
 * 
 * Context3D Profiles:
 * 
 * Stage3D supports various rendering profiles, all compatible with Starling:
 * - BASELINE_CONSTRAINED: Broadest hardware compatibility for browser deployment.
 * - BASELINE: Recommended for mobile apps, with efficient RectangleTextures and AGAL support.
 * - BASELINE_EXTENDED: Adds support for larger textures (up to 4096x4096).
 * - STANDARD_CONSTRAINED, STANDARD, STANDARD_EXTENDED: Offer additional AGAL features.
 * 
 * Use "auto" for Starling to select the best available profile automatically, but test with all
 * profiles during development.
 * 
 * Accessing the Starling Object:
 * 
 * Use the static method Starling.current() within your application to access the active
 * Starling instance.
 * 
 * Viewport:
 * 
 * By default, Starling renders to the entire stage size. Use the "viewPort" property to render
 * to a specific area or adapt to stage size changes. Listen for the RESIZE event dispatched by
 * the Starling stage for the latter.
 * 
 * Native Overlay:
 * 
 * The nativeOverlay property provides a Flash Sprite overlaying Starling content. Add Flash
 * objects to this overlay as needed. Remove child objects from the overlay to avoid performance
 * penalties, especially on mobile platforms.
 * 
 * Multitouch:
 * 
 * Starling supports multitouch input where available. Simulate multitouch during development
 * with Shift/Ctrl (Cmd on Mac). Enable this with simulateMultitouch property.
 * 
 * Skipping Unchanged Frames:
 * 
 * Enable skipUnchangedFrames to skip rendering static scenes, conserving battery on mobile
 * devices. Refer to property documentation for details.
 * 
 * Handling Lost Render Context:
 * 
 * Starling attempts automatic recovery from lost Stage3D contexts. Manage context loss manually
 * using Event.CONTEXT3D_CREATE and Texture.onRestore for custom logic. Utilize AssetManager for
 * optimized texture loading.
 * 
 * Sharing a 3D Context:
 * 
 * Starling manages Stage3D context by default. For integration with other Stage3D engines, use
 * shareContext to synchronize contexts and input handling.
 * 
 * For more information, refer to the Starling wiki tutorial on context sharing.
 * 
 * @see starling.utils.AssetManager
 * @see starling.textures.Texture
 */
@:access(starling.display.Stage)
class Starling extends EventDispatcher {
	/** The version of the Starling framework. */
	public static var VERSION:String = Compiler.getDefine("starling");

	// members
	@:noCompletion private var __stage:Stage; // starling.display.stage!
	@:noCompletion private var __rootClass:Class<Dynamic>;
	@:noCompletion private var __root:DisplayObject;
	@:noCompletion private var __juggler:Juggler;
	@:noCompletion private var __painter:Painter;
	@:noCompletion private var __touchProcessor:TouchProcessor;
	@:noCompletion private var __antiAliasing:Int;
	@:noCompletion private var __frameTimestamp:Float;
	@:noCompletion private var __frameID:UInt;
	@:noCompletion private var __leftMouseDown:Bool;
	@:noCompletion private var __statsDisplay:StatsDisplay;
	@:noCompletion private var __statsDisplayAlign:openfl.utils.Object;
	@:noCompletion private var __started:Bool;
	@:noCompletion private var __rendering:Bool;
	@:noCompletion private var __supportHighResolutions:Bool;
	@:noCompletion private var __supportBrowserZoom:Bool;
	@:noCompletion private var __skipUnchangedFrames:Bool;
	@:noCompletion private var __showStats:Bool;
	@:noCompletion private var __supportsCursor:Bool;
	@:noCompletion private var __multitouchEnabled:Bool;

	@:noCompletion private var __viewPort:Rectangle;
	@:noCompletion private var __previousViewPort:Rectangle;
	@:noCompletion private var __clippedViewPort:Rectangle;

	@:noCompletion private var __nativeStage:OpenFLStage;
	@:noCompletion private var __nativeStageEmpty:Bool;
	@:noCompletion private var __nativeOverlay:Sprite;
	@:noCompletion private var __nativeOverlayBlocksTouches:Bool;

	private static var sCurrent:Starling;
	private static var sAll:Array<Starling> = new Array<Starling>();

	#if commonjs
	private static function __init__() {
		untyped Object.defineProperties(Starling.prototype, {
			"touchEventTypes": {get: untyped __js__("function () { return this.get_touchEventTypes (); }")},
			"mustAlwaysRender": {get: untyped __js__("function () { return this.get_mustAlwaysRender (); }")},
			"isStarted": {get: untyped __js__("function () { return this.get_isStarted (); }")},
			"juggler": {get: untyped __js__("function () { return this.get_juggler (); }")},
			"context": {
				get: untyped __js__("function () { return this.get_context (); }"),
				set: untyped __js__("function (v) { return this.set_context (v); }")
			},
			"simulateMultitouch": {
				get: untyped __js__("function () { return this.get_simulateMultitouch (); }"),
				set: untyped __js__("function (v) { return this.set_simulateMultitouch (v); }")
			},
			"enableErrorChecking": {
				get: untyped __js__("function () { return this.get_enableErrorChecking (); }"),
				set: untyped __js__("function (v) { return this.set_enableErrorChecking (v); }")
			},
			"antiAliasing": {
				get: untyped __js__("function () { return this.get_antiAliasing (); }"),
				set: untyped __js__("function (v) { return this.set_antiAliasing (v); }")
			},
			"viewPort": {
				get: untyped __js__("function () { return this.get_viewPort (); }"),
				set: untyped __js__("function (v) { return this.set_viewPort (v); }")
			},
			"contentScaleFactor": {get: untyped __js__("function () { return this.get_contentScaleFactor (); }")},
			"nativeOverlay": {get: untyped __js__("function () { return this.get_nativeOverlay (); }")},
			"nativeOverlayBlocksTouches": {
				get: untyped __js__("function () { return this.get_nativeOverlayBlocksTouches (); }"),
				set: untyped __js__("function (v) { return this.set_nativeOverlayBlocksTouches (v); }")
			},
			"showStats": {
				get: untyped __js__("function () { return this.get_showStats (); }"),
				set: untyped __js__("function (v) { return this.set_showStats (v); }")
			},
			"stage": {get: untyped __js__("function () { return this.get_stage (); }")},
			"stage3D": {get: untyped __js__("function () { return this.get_stage3D (); }")},
			"nativeStage": {get: untyped __js__("function () { return this.get_nativeStage (); }")},
			"root": {get: untyped __js__("function () { return this.get_root (); }")},
			"rootClass": {
				get: untyped __js__("function () { return this.get_rootClass (); }"),
				set: untyped __js__("function (v) { return this.set_rootClass (v); }")
			},
			"shareContext": {
				get: untyped __js__("function () { return this.get_shareContext (); }"),
				set: untyped __js__("function (v) { return this.set_shareContext (v); }")
			},
			"profile": {get: untyped __js__("function () { return this.get_profile (); }")},
			"supportHighResolutions": {
				get: untyped __js__("function () { return this.get_supportHighResolutions (); }"),
				set: untyped __js__("function (v) { return this.set_supportHighResolutions (v); }")
			},
			"skipUnchangedFrames": {
				get: untyped __js__("function () { return this.get_skipUnchangedFrames (); }"),
				set: untyped __js__("function (v) { return this.set_skipUnchangedFrames (v); }")
			},
			"touchProcessor": {
				get: untyped __js__("function () { return this.get_touchProcessor (); }"),
				set: untyped __js__("function (v) { return this.set_touchProcessor (v); }")
			},
			"discardSystemGestures": {
				get: untyped __js__("function () { return this.get_discardSystemGestures (); }"),
				set: untyped __js__("function (v) { return this.set_discardSystemGestures (v); }")
			},
			"frameID": {get: untyped __js__("function () { return this.get_frameID (); }")},
			"contextValid": {get: untyped __js__("function () { return this.get_contextValid (); }")},
		});

		untyped Object.defineProperties(Starling, {
			"current": {get: untyped __js__("function () { return Starling.get_current (); }")},
			"all": {get: untyped __js__("function () { return Starling.get_all (); }")},
			"contentScaleFactor": {get: untyped __js__("function () { return Starling.get_contentScaleFactor (); }")},
			"multitouchEnabled": {
				get: untyped __js__("function () { return Starling.get_multitouchEnabled (); }"),
				set: untyped __js__("function (v) { return Starling.set_multitouchEnabled (v); }")
			},
		});
	}
	#end

	// construction

	/**
	 * Creates a new Starling instance.
	 * 
	 * @param rootClass   A subclass of 'starling.display.DisplayObject'. It will be created
	 *                    as soon as initialization is finished and will become the first child
	 *                    of the Starling stage. Pass <code>null</code> if you don't want to
	 *                    create a root object right away. (You can use the
	 *                    <code>rootClass</code> property later to make that happen.)
	 * @param stage       The Flash (2D) stage.
	 * @param viewPort    A rectangle describing the area into which the content will be 
	 *                    rendered. Default: stage size.
	 * @param stage3D     The Stage3D object into which the content will be rendered. If it 
	 *                    already contains a context, <code>sharedContext</code> will be set
	 *                    to <code>true</code>. Default: the first available Stage3D.
	 * @param renderMode  The Context3D render mode that should be requested.
	 *                    Use this parameter if you want to force "software" rendering.
	 * @param profile     The Context3D profile that should be requested.
	 *                    <ul>
	 *                    <li>If you pass a profile String, this profile is enforced.</li>
	 *                    <li>Pass an Array of profiles to make Starling pick the first
	 *                        one that works (starting with the first array element).</li>
	 *                    <li>Pass the String "auto" to make Starling pick the best available
	 *                        profile automatically.</li>
	 *                    </ul>
	 * @param sharedContext Whether the Stage3D context is shared or not. Default: <code>null</code>.
	 */
	public function new(rootClass:Class<Dynamic>, stage:openfl.display.Stage, viewPort:Rectangle = null, stage3D:Stage3D = null,
			renderMode:Context3DRenderMode = AUTO, profile:Dynamic = "auto", sharedContext:Null<Bool> = null) {
		super();

		if (stage == null)
			throw new ArgumentError("Stage must not be null");
		if (viewPort == null)
			viewPort = new Rectangle(0, 0, stage.stageWidth, stage.stageHeight);
		if (stage3D == null)
			stage3D = stage.stage3Ds[0];

		// TODO it might make sense to exchange the 'renderMode' and 'profile' parameters.

		SystemUtil.initialize();
		sAll.push(this);
		makeCurrent();

		__rootClass = rootClass;
		__viewPort = viewPort;
		__previousViewPort = new Rectangle();
		__stage = new Stage(Std.int(viewPort.width), Std.int(viewPort.height), stage.color);
		__nativeOverlay = new Sprite();
		__nativeStage = stage;
		__nativeStage.addChild(__nativeOverlay);
		__touchProcessor = new TouchProcessor(__stage);
		__touchProcessor.discardSystemGestures = !SystemUtil.isDesktop;
		__juggler = new Juggler();
		__antiAliasing = 0;
		__supportHighResolutions = false;
		__painter = new Painter(stage3D, sharedContext);
		__frameTimestamp = Lib.getTimer() / 1000.0;
		__frameID = 1;
		__supportsCursor = Mouse.supportsCursor || Capabilities.os.indexOf("Windows") == 0;
		__statsDisplayAlign = {};

		// register appropriate touch/mouse event handlers
		setMultitouchEnabled(Multitouch.inputMode == MultitouchInputMode.TOUCH_POINT, true);

		// make the native overlay behave just like one would expect intuitively
		nativeOverlayBlocksTouches = true;

		// all other modes are problematic in Starling, so we force those here
		stage.scaleMode = StageScaleMode.NO_SCALE;
		stage.align = StageAlign.TOP_LEFT;

		// register other event handlers
		stage.addEventListener(Event.ENTER_FRAME, onEnterFrame, false, 0, true);
		stage.addEventListener(KeyboardEvent.KEY_DOWN, onKey, false, 0, true);
		stage.addEventListener(KeyboardEvent.KEY_UP, onKey, false, 0, true);
		stage.addEventListener(Event.RESIZE, onResize, false, 0, true);
		stage.addEventListener(Event.MOUSE_LEAVE, onMouseLeave, false, 0, true);
		stage.addEventListener(Event.ACTIVATE, onActivate, false, 0, true);

		stage3D.addEventListener(Event.CONTEXT3D_CREATE, onContextCreated, false, 10, true);
		stage3D.addEventListener(ErrorEvent.ERROR, onStage3DError, false, 10, true);

		var runtimeVersion:Int = #if flash Std.parseInt(SystemUtil.version.split(",").shift()) #else 26 #end;
		if (runtimeVersion < 19) {
			var runtime:String = SystemUtil.isAIR ? "Adobe AIR" : "Flash Player";
			stopWithFatalError("Your " + runtime + " installation is outdated. " + "This software requires at least version 19.");
		} else if (__painter.shareContext) {
			Timer.delay(initialize, 1); // we don't call it right away, because Starling should
			// behave the same way with or without a shared context
		} else {
			__painter.requestContext3D(renderMode, profile);
		}
	}

	/**
	 * Disposes of all resources used by the stage, including children, render context,
	 * and event listeners.
	 * Stops ongoing animations and removes event listeners for frame updates, keyboard,
	 * resize, mouse, and touch events.
	 * Also handles specific AIR platform events if applicable.
	 * Finally, cleans up touch processing, rendering, and stage resources.
	 */
	public function dispose():Void {
		stop(true);

		__nativeStage.removeEventListener(Event.ENTER_FRAME, onEnterFrame, false);
		__nativeStage.removeEventListener(KeyboardEvent.KEY_DOWN, onKey, false);
		__nativeStage.removeEventListener(KeyboardEvent.KEY_UP, onKey, false);
		__nativeStage.removeEventListener(Event.RESIZE, onResize, false);
		__nativeStage.removeEventListener(Event.MOUSE_LEAVE, onMouseLeave, false);
		#if air
		__nativeStage.removeEventListener(Event.BROWSER_ZOOM_CHANGE, onBrowserZoomChange, false);
		#end
		__nativeStage.removeChild(__nativeOverlay);

		stage3D.removeEventListener(Event.CONTEXT3D_CREATE, onContextCreated, false);
		stage3D.removeEventListener(Event.CONTEXT3D_CREATE, onContextRestored, false);
		stage3D.removeEventListener(ErrorEvent.ERROR, onStage3DError, false);

		for (touchEventType in getTouchEventTypes(__multitouchEnabled))
			__nativeStage.removeEventListener(touchEventType, onTouch, false);

		if (__touchProcessor != null)
			__touchProcessor.dispose();
		if (__painter != null)
			__painter.dispose();
		if (__stage != null)
			__stage.dispose();

		var index:Int = sAll.indexOf(this);
		if (index != -1)
			sAll.splice(index, 1);
		if (sCurrent == this)
			sCurrent = null;
	}

	// functions

	private function initialize():Void {
		makeCurrent();
		updateViewPort(true);

		// ideal time: after viewPort setup, before root creation
		dispatchEventWith(Event.CONTEXT3D_CREATE, false, context);

		initializeRoot();
		__frameTimestamp = Lib.getTimer() / 1000.0;
	}

	private function initializeRoot():Void {
		if (__root == null && __rootClass != null) {
			__root = Type.createInstance(__rootClass, []);
			if (__root == null || !#if (haxe_ver < 4.2) Std.is #else Std.isOfType #end (__root, DisplayObject))
				throw new Error("Invalid root class: " + __rootClass);
			__stage.addChildAt(__root, 0);

			dispatchEventWith(starling.events.Event.ROOT_CREATED, false, __root);
		}
	}

	/**
	 * Advances the game or animation by one frame.
	 * Calculates the time passed since the last frame using Lib.getTimer(),
	 * limits the maximum delta to prevent time-based animation issues,
	 * and updates the game logic and renders the frame.
	 */
	public function nextFrame():Void {
		var now:Float = Lib.getTimer() / 1000.0;
		var passedTime:Float = now - __frameTimestamp;
		__frameTimestamp = now;

		// Truncate the maximum delta to avoid overloading time-based animations
		if (passedTime > 1.0) {
			passedTime = 1.0;
		} else if (passedTime < 0.0) {
			// Handle the timer rollover case
			passedTime = 1.0 / __nativeStage.frameRate;
		}

		advanceTime(passedTime);
		render();
	}

	/**
	 * Dispatches ENTER_FRAME events on the display list, advances the Juggler, 
	 * and processes touches.
	 * 
	 * @param passedTime The time that has passed since the last frame, in seconds.
	 */
	public function advanceTime(passedTime:Float):Void {
		if (!contextValid)
			return;

		makeCurrent();

		__touchProcessor.advanceTime(passedTime);
		__stage.advanceTime(passedTime);
		__juggler.advanceTime(passedTime);
	}

	/**
	 * Renders the complete display list. Before rendering, the context is cleared; afterwards,
	 * it is presented (to avoid this, enable <code>shareContext</code>).
	 *
	 * <p>This method also dispatches an <code>Event.RENDER</code> event on the Starling
	 * instance. That's the last opportunity to make changes before the display list is
	 * rendered.</p>
	 */
	public function render():Void {
		if (!contextValid)
			return;

		makeCurrent();
		updateViewPort();

		if (__stage.requiresRedraw || mustAlwaysRender) {
			dispatchEventWith(starling.events.Event.RENDER);

			__painter.nextFrame();
			__painter.pixelSize = 1.0 / contentScaleFactor;

			var scaleX:Float = __viewPort.width / __stage.stageWidth;
			var scaleY:Float = __viewPort.height / __stage.stageHeight;

			__painter.state.setProjectionMatrix(__viewPort.x < 0 ? -__viewPort.x / scaleX : 0.0, __viewPort.y < 0 ? -__viewPort.y / scaleY : 0.0,
				__clippedViewPort.width / scaleX, __clippedViewPort.height / scaleY, __stage.stageWidth, __stage.stageHeight, __stage.cameraPosition);

			if (!__painter.shareContext)
				__painter.clear(__stage.color, Color.getAlpha(__stage.color));

			__stage.render(__painter);
			__painter.finishFrame();
			__painter.frameID = ++__frameID;

			if (!__painter.shareContext)
				__painter.present();
		} else {
			dispatchEventWith(starling.events.Event.SKIP_FRAME);
		}

		if (__statsDisplay != null) {
			__statsDisplay.drawCount = __painter.drawCount;
		}
	}

	private function updateViewPort(forceUpdate:Bool = false):Void {
		// the last set viewport is stored in a variable; that way, people can modify the
		// viewPort directly (without a copy) and we still know if it has changed.

		if (forceUpdate || !RectangleUtil.compare(__viewPort, __previousViewPort)) {
			__previousViewPort.setTo(__viewPort.x, __viewPort.y, __viewPort.width, __viewPort.height);

			// Constrained mode requires that the viewport is within the native stage bounds;
			// thus, we use a clipped viewport when configuring the back buffer. (In baseline
			// mode, that's not necessary, but it does not hurt either.)

			updateClippedViewPort();
			updateStatsDisplayPosition();

			var contentScaleFactor:Float = __supportHighResolutions ? __nativeStage.contentsScaleFactor : 1.0;

			#if air
			if (__supportBrowserZoom)
				contentScaleFactor *= __nativeStage.browserZoomFactor;
			#end

			__painter.configureBackBuffer(__clippedViewPort, contentScaleFactor, __antiAliasing, true, __supportBrowserZoom);

			setRequiresRedraw();
		}
	}

	private function updateClippedViewPort():Void {
		var stageBounds:Rectangle = Pool.getRectangle(0, 0, __nativeStage.stageWidth, __nativeStage.stageHeight);

		__clippedViewPort = RectangleUtil.intersect(__viewPort, stageBounds, __clippedViewPort);

		if (__clippedViewPort.width < 32)
			__clippedViewPort.width = 32;
		if (__clippedViewPort.height < 32)
			__clippedViewPort.height = 32;

		Pool.putRectangle(stageBounds);
	}

	private function updateNativeOverlay():Void {
		__nativeOverlay.x = __viewPort.x;
		__nativeOverlay.y = __viewPort.y;
		__nativeOverlay.scaleX = __viewPort.width / __stage.stageWidth;
		__nativeOverlay.scaleY = __viewPort.height / __stage.stageHeight;
	}

	/**
	 * Stops Starling right away and displays an error message on the native overlay.
	 * This method will also cause Starling to dispatch a FATAL_ERROR event.
	 * 
	 * @param message The error message to display.
	 */
	public function stopWithFatalError(message:String):Void {
		var background:Shape = new Shape();
		background.graphics.beginFill(0x0, 0.8);
		background.graphics.drawRect(0, 0, __stage.stageWidth, __stage.stageHeight);
		background.graphics.endFill();

		var textField:TextField = new TextField();
		var textFormat:TextFormat = new TextFormat("_sans", 14, 0xFFFFFF);
		textFormat.align = TextFormatAlign.CENTER;
		textField.defaultTextFormat = textFormat;
		textField.wordWrap = true;
		textField.width = __stage.stageWidth * 0.75;
		textField.autoSize = TextFieldAutoSize.CENTER;
		textField.text = message;
		textField.x = (__stage.stageWidth - textField.width) / 2;
		textField.y = (__stage.stageHeight - textField.height) / 2;
		textField.background = true;
		textField.backgroundColor = 0x550000;

		updateNativeOverlay();
		nativeOverlay.addChild(background);
		nativeOverlay.addChild(textField);
		stop(true);

		trace("[Starling] " + message);
		dispatchEventWith(starling.events.Event.FATAL_ERROR, false, message);
	}

	/**
	 * Makes this Starling instance the <code>current</code> one.
	 */
	public function makeCurrent():Void {
		sCurrent = this;
	}

	/**
	 * As soon as Starling is started, it will queue input events (keyboard/mouse/touch);
	 * furthermore, the method <code>nextFrame</code> will be called once per Flash Player
	 * frame. (Except when <code>shareContext</code> is enabled: in that case, you have to
	 * call that method manually.)
	 */
	public function start():Void {
		__started = __rendering = true;
		__frameTimestamp = Lib.getTimer() / 1000.0;
	}

	/**
	 * Stops all logic and input processing, effectively freezing the app in its current state.
	 * Per default, rendering will continue: that's because the classic display list
	 * is only updated when Stage3D is. (If Starling stopped rendering, conventional Flash
	 * contents would freeze, as well.)
	 * 
	 * <p>However, if you don't need classic Flash contents, you can stop rendering, too.
	 * On some mobile systems (e.g., iOS), you are even required to do so if you have
	 * activated background code execution.</p>
	 * 
	 * @param suspendRendering If true, rendering will also be stopped. Default is false.
	 */
	public function stop(suspendRendering:Bool = false):Void {
		__started = false;
		__rendering = !suspendRendering;
	}

	/**
	 * Makes sure that the next frame is actually rendered.
	 *
	 * <p>When <code>skipUnchangedFrames</code> is enabled, some situations require that you
	 * manually force a redraw, e.g., when a RenderTexture is changed. This method is the
	 * easiest way to do so; it's just a shortcut to <code>stage.setRequiresRedraw()</code>.</p>
	 */
	public function setRequiresRedraw():Void {
		__stage.setRequiresRedraw();
	}

	// event handlers

	private function onStage3DError(event:ErrorEvent):Void {
		if (event.errorID == 3702) {
			var mode:String = Capabilities.playerType == "Desktop" ? "renderMode" : "wmode";
			stopWithFatalError("Context3D not available! Possible reasons: wrong " + mode + " or missing device support.");
		} else
			stopWithFatalError("Stage3D error: " + event.text);
	}

	private function onContextCreated(event:Event):Void {
		stage3D.removeEventListener(Event.CONTEXT3D_CREATE, onContextCreated);
		stage3D.addEventListener(Event.CONTEXT3D_CREATE, onContextRestored, false, 10, true);

		trace("[Starling] Context ready. Display Driver: " + context.driverInfo);
		initialize();
	}

	private function onContextRestored(event:Event):Void {
		trace("[Starling] Context restored.");
		updateViewPort(true);
		__painter.setupContextDefaults();
		dispatchEventWith(Event.CONTEXT3D_CREATE, false, context);
	}

	private function onEnterFrame(event:Event):Void {
		// On mobile, the native display list is only updated on stage3D draw calls.
		// Thus, we render even when Starling is paused.

		if (!__painter.shareContext) {
			if (__started)
				nextFrame();
			else if (__rendering)
				render();
		}

		updateNativeOverlay();
	}

	private function onActivate(event:Event):Void {
		// with 'skipUnchangedFrames' enabled, a forced redraw is required when the app
		// is restored on some platforms (namely Windows with BASELINE_CONSTRAINED profile
		// and some Android versions).

		Timer.delay(setRequiresRedraw, 100);
	}

	private function onKey(event:KeyboardEvent):Void {
		if (!__started)
			return;

		var keyEvent:starling.events.KeyboardEvent = new starling.events.KeyboardEvent(event.type, event.charCode, event.keyCode, event.keyLocation,
			event.ctrlKey, event.altKey, event.shiftKey);

		makeCurrent();
		__stage.dispatchEvent(keyEvent);

		if (keyEvent.isDefaultPrevented())
			event.preventDefault();
	}

	private function onResize(event:Event):Void {
		var stageWidth:Int = cast(event.target, OpenFLStage).stageWidth;
		var stageHeight:Int = cast(event.target, OpenFLStage).stageHeight;

		function dispatchResizeEvent():Void {
			// on Android, the context is not valid while we're resizing. To avoid problems
			// with user code, we delay the event dispatching until it becomes valid again.

			makeCurrent();
			removeEventListener(Event.CONTEXT3D_CREATE, dispatchResizeEvent);
			__stage.dispatchEvent(new ResizeEvent(Event.RESIZE, stageWidth, stageHeight));
		}

		if (contextValid)
			dispatchResizeEvent();
		else
			addEventListener(Event.CONTEXT3D_CREATE, dispatchResizeEvent);
	}

	private function onBrowserZoomChange(event:Event):Void {
		#if air
		__painter.refreshBackBufferSize(__nativeStage.contentsScaleFactor * __nativeStage.browserZoomFactor);
		#end
	}

	private function onMouseLeave(event:Event):Void {
		__touchProcessor.enqueueMouseLeftStage();
	}

	private function onTouch(event:Event):Void {
		if (!__started)
			return;

		var globalX:Float;
		var globalY:Float;
		var touchID:Int;
		var phase:String = null;
		var pressure:Float = 1.0;
		var width:Float = 1.0;
		var height:Float = 1.0;

		// figure out general touch properties
		if (#if (haxe_ver < 4.2) Std.is #else Std.isOfType #end (event, MouseEvent)) {
			var mouseEvent:MouseEvent = cast event;
			globalX = mouseEvent.stageX;
			globalY = mouseEvent.stageY;
			touchID = 0;

			// MouseEvent.buttonDown returns true for both left and right button (AIR supports
			// the right mouse button). We only want to react on the left button for now,
			// so we have to save the state for the left button manually.
			if (event.type == MouseEvent.MOUSE_DOWN)
				__leftMouseDown = true;
			else if (event.type == MouseEvent.MOUSE_UP)
				__leftMouseDown = false;
		} else {
			var touchEvent:TouchEvent = cast(event, TouchEvent);

			// On a system that supports both mouse and touch input, the primary touch point
			// is dispatched as mouse event as well. Since we don't want to listen to that
			// event twice, we ignore the primary touch in that case.

			if (__supportsCursor && touchEvent.isPrimaryTouchPoint)
				return;
			else {
				globalX = touchEvent.stageX;
				globalY = touchEvent.stageY;
				touchID = touchEvent.touchPointID;
				pressure = touchEvent.pressure;
				width = touchEvent.sizeX;
				height = touchEvent.sizeY;
			}
		}

		// Determine touch phase
		switch (event.type) {
			case TouchEvent.TOUCH_BEGIN, MouseEvent.MOUSE_DOWN:
				phase = TouchPhase.BEGAN;
			case TouchEvent.TOUCH_MOVE, MouseEvent.MOUSE_MOVE:
				phase = (__leftMouseDown || event.type == TouchEvent.TOUCH_MOVE) ? TouchPhase.MOVED : TouchPhase.HOVER;
			case TouchEvent.TOUCH_END, MouseEvent.MOUSE_UP:
				phase = TouchPhase.ENDED;
		}

		// move position into viewport bounds
		globalX = __stage.stageWidth * (globalX - __viewPort.x) / __viewPort.width;
		globalY = __stage.stageHeight * (globalY - __viewPort.y) / __viewPort.height;

		// enqueue touch in touch processor
		__touchProcessor.enqueue(touchID, phase, globalX, globalY, pressure, width, height);

		// allow objects that depend on mouse-over state to be updated immediately
		if (event.type == MouseEvent.MOUSE_UP && __supportsCursor)
			__touchProcessor.enqueue(touchID, TouchPhase.HOVER, globalX, globalY);
	}

	private function hitTestNativeOverlay(localX:Float, localY:Float):Bool {
		if (__nativeOverlay.numChildren > 0) {
			var globalPos:Point = Pool.getPoint();
			var matrix:Matrix = Pool.getMatrix(__nativeOverlay.scaleX, 0, 0, __nativeOverlay.scaleY, __nativeOverlay.x, __nativeOverlay.y);
			MatrixUtil.transformCoords(matrix, localX, localY, globalPos);
			var result:Bool = __nativeOverlay.hitTestPoint(globalPos.x, globalPos.y, true);
			Pool.putPoint(globalPos);
			Pool.putMatrix(matrix);
			return result;
		}
		return false;
	}

	private function setMultitouchEnabled(value:Bool, forceUpdate:Bool = false):Void {
		if (forceUpdate || value != __multitouchEnabled) {
			var oldEventTypes:Array<String> = getTouchEventTypes(__multitouchEnabled);
			var newEventTypes:Array<String> = getTouchEventTypes(value);

			for (oldEventType in oldEventTypes)
				__nativeStage.removeEventListener(oldEventType, onTouch);

			for (newEventType in newEventTypes)
				__nativeStage.addEventListener(newEventType, onTouch, false, 0, true);

			__touchProcessor.cancelTouches();
			__multitouchEnabled = value;
		}
	}

	private function getTouchEventTypes(multitouchEnabled:Bool):Array<String> {
		var types = new Array<String>();

		if (multitouchEnabled) {
			types.push(TouchEvent.TOUCH_BEGIN);
			types.push(TouchEvent.TOUCH_MOVE);
			types.push(TouchEvent.TOUCH_END);
		}

		if (!multitouchEnabled || __supportsCursor) {
			types.push(MouseEvent.MOUSE_DOWN);
			types.push(MouseEvent.MOUSE_MOVE);
			types.push(MouseEvent.MOUSE_UP);
		}

		return types;
	}

	private var mustAlwaysRender(get, never):Bool;

	private function get_mustAlwaysRender():Bool {
		// On mobile, and in some browsers with the "baselineConstrained" profile, the
		// standard display list is only rendered after calling "context.present()".
		// In such a case, we cannot omit frames if there is any content on the stage.

		#if !flash
		if (!Reflect.hasField(__nativeStage, "context3D") || Reflect.field(__nativeStage, "context3D") == context)
			return true;
		#end

		if (!__skipUnchangedFrames || __painter.shareContext)
			return true;
		else if (SystemUtil.isDesktop && profile != Context3DProfile.BASELINE_CONSTRAINED)
			return false;
		else {
			// Rendering can be skipped when both this and previous frame are empty.
			var nativeStageEmpty:Bool = isNativeDisplayObjectEmpty(__nativeStage);
			var mustAlwaysRender:Bool = !nativeStageEmpty || !__nativeStageEmpty;
			__nativeStageEmpty = nativeStageEmpty;

			return mustAlwaysRender;
		}
	}

	// properties

	/**
	 * Indicates if this Starling instance is started.
	 * 
	 * @return A boolean value indicating whether the Starling instance is started.
	 */
	public var isStarted(get, never):Bool;

	private inline function get_isStarted():Bool {
		return __started;
	}

	/**
	 * The default juggler of this instance. Will be advanced once per frame.
	 * 
	 * @return The default Juggler instance.
	 */
	public var juggler(get, never):Juggler;

	private inline function get_juggler():Juggler {
		return __juggler;
	}

	/**
	 * The painter, which is used for all rendering. The same instance is passed to all
	 * <code>render</code> methods each frame.
	 * 
	 * @return The Painter instance used for all rendering.
	 */
	public var painter(get, never):Painter;

	private inline function get_painter():Painter {
		return __painter;
	}

	/**
	 * The render context of this instance.
	 * 
	 * @return The Context3D object representing the render context of this instance.
	 */
	public var context(get, never):Context3D;

	private inline function get_context():Context3D {
		return __painter.context;
	}

	/**
	 * Indicates if multitouch simulation with "Shift" and "Ctrl"/"Cmd" keys is enabled.
	 * 
	 * @default false
	 * 
	 * @return A boolean value indicating whether multitouch simulation is enabled.
	 */
	public var simulateMultitouch(get, set):Bool;

	private inline function get_simulateMultitouch():Bool {
		return __touchProcessor.simulateMultitouch;
	}

	private inline function set_simulateMultitouch(value:Bool):Bool {
		return __touchProcessor.simulateMultitouch = value;
	}

	/**
	 * Indicates if Stage3D render methods will report errors. It's recommended to activate
	 * this when writing custom rendering code (shaders, etc.), since you'll get more detailed
	 * error messages. However, it has a very negative impact on performance, and it prevents
	 * ATF textures from being restored on a context loss. Never activate for release builds!
	 * 
	 * @default false
	 * 
	 * @return A boolean value indicating whether error checking is enabled for Stage3D render methods.
	 */
	public var enableErrorChecking(get, set):Bool;

	private inline function get_enableErrorChecking():Bool {
		return __painter.enableErrorChecking;
	}

	private inline function set_enableErrorChecking(value:Bool):Bool {
		return __painter.enableErrorChecking = value;
	}

	/**
	 * The antialiasing level. 0 - no antialiasing, 16 - maximum antialiasing.
	 * 
	 * @default 0
	 * 
	 * @return An integer representing the antialiasing level.
	 * @param value The antialiasing level to set, ranging from 0 (no antialiasing) to 16 (maximum antialiasing).
	 */
	public var antiAliasing(get, set):Int;

	private inline function get_antiAliasing():Int {
		return __antiAliasing;
	}

	private inline function set_antiAliasing(value:Int):Int {
		if (__antiAliasing != value) {
			__antiAliasing = value;
			if (contextValid)
				updateViewPort(true);
		}
		return value;
	}

	/**
	 * The viewport into which Starling contents will be rendered.
	 * 
	 * @return A Rectangle object representing the viewport.
	 * @param value The Rectangle to set as the viewport.
	 */
	public var viewPort(get, set):Rectangle;

	private function get_viewPort():Rectangle {
		return __viewPort;
	}

	private inline function set_viewPort(value:Rectangle):Rectangle {
		__viewPort.copyFrom(value);
		return value;
	}

	/**
	 * The ratio between viewPort width and stage width. Useful for choosing a different
	 * set of textures depending on the display resolution.
	 * 
	 * @return A float value representing the ratio between the viewPort width and the stage width.
	 */
	public var contentScaleFactor(get, never):Float;

	private inline function get_contentScaleFactor():Float {
		return (__viewPort.width * __painter.backBufferScaleFactor) / __stage.stageWidth;
	}

	/**
	 * A Flash Sprite placed directly on top of the Starling content. Use it to display native
	 * Flash components.
	 * 
	 * @return The Flash Sprite used as a native overlay.
	 */
	public var nativeOverlay(get, never):Sprite;

	private inline function get_nativeOverlay():Sprite {
		return __nativeOverlay;
	}

	/**
	 * If enabled, touches or mouse events on the native overlay won't be propagated to
	 * Starling.
	 * 
	 * @default false
	 * 
	 * @return A boolean value indicating whether touches or mouse events on the native overlay are blocked from propagating to Starling.
	 */
	public var nativeOverlayBlocksTouches(get, set):Bool;

	private inline function get_nativeOverlayBlocksTouches():Bool {
		return __touchProcessor.occlusionTest != null;
	}

	private inline function set_nativeOverlayBlocksTouches(value:Bool):Bool {
		if (value != __nativeOverlayBlocksTouches)
			__touchProcessor.occlusionTest = value ? hitTestNativeOverlay : null;
		return __nativeOverlayBlocksTouches = value;
	}

	/**
	 * Indicates if a small statistics box (with FPS, memory usage, and draw count) is
	 * displayed.
	 *
	 * <p>Beware that the memory usage should be taken with a grain of salt. The value is
	 * determined via <code>System.totalMemory</code> and does not take texture memory
	 * into account. It is recommended to use Adobe Scout for reliable and comprehensive
	 * memory analysis.</p>
	 * 
	 * @return A boolean value indicating whether the statistics box is displayed.
	 */
	public var showStats(get, set):Bool;

	private inline function get_showStats():Bool {
		return __showStats;
	}

	private inline function set_showStats(value:Bool):Bool {
		__showStats = value;

		if (value) {
			var h = Reflect.hasField(__statsDisplayAlign, "horizontal") ? Reflect.field(__statsDisplayAlign, "horizontal") : null;
			var v = Reflect.hasField(__statsDisplayAlign, "vertical") ? Reflect.field(__statsDisplayAlign, "vertical") : null;
			showStatsAt(h != null ? h : "left", v != null ? v : "top");
		} else if (__statsDisplay != null) {
			__statsDisplay.removeFromParent();
		}

		return value;
	}

	/**
	 * Displays the statistics box at a certain position.
	 * 
	 * @param horizontalAlign The horizontal alignment of the statistics box. Default is "left".
	 * @param verticalAlign The vertical alignment of the statistics box. Default is "top".
	 * @param scale The scale factor of the statistics box. Default is 1.
	 */
	public function showStatsAt(horizontalAlign:String = "left", verticalAlign:String = "top", scale:Float = 1):Void {
		function onRootCreated():Void {
			if (__showStats)
				showStatsAt(horizontalAlign, verticalAlign, scale);
			removeEventListener(starling.events.Event.ROOT_CREATED, onRootCreated);
		}

		__showStats = true;
		Reflect.setField(__statsDisplayAlign, "horizontal", horizontalAlign);
		Reflect.setField(__statsDisplayAlign, "vertical", verticalAlign);

		if (context == null) {
			// Starling is not yet ready - we postpone this until it's initialized.
			addEventListener(starling.events.Event.ROOT_CREATED, onRootCreated);
		} else {
			if (__statsDisplay == null) {
				__statsDisplay = new StatsDisplay();
				__statsDisplay.touchable = false;
			}

			__stage.addChild(__statsDisplay);
			__statsDisplay.scaleX = __statsDisplay.scaleY = scale;
			__statsDisplay.showSkipped = __skipUnchangedFrames;

			updateClippedViewPort();
			updateStatsDisplayPosition();
		}
	}

	private function updateStatsDisplayPosition():Void {
		if (!__showStats || __statsDisplay == null)
			return;

		// The stats display must always be visible, i.e. inside the clipped viewPort.
		// So we take viewPort clipping into account when calculating its position.

		var horizontalAlign:String = Reflect.hasField(__statsDisplayAlign, "horizontal") ? Reflect.field(__statsDisplayAlign, "horizontal") : null;
		var verticalAlign:String = Reflect.hasField(__statsDisplayAlign, "vertical") ? Reflect.field(__statsDisplayAlign, "vertical") : null;
		var scaleX:Float = __viewPort.width / __stage.stageWidth;
		var scaleY:Float = __viewPort.height / __stage.stageHeight;
		var clipping:Rectangle = Pool.getRectangle(__viewPort.x < 0 ? -__viewPort.x / scaleX : 0.0, __viewPort.y < 0 ? -__viewPort.y / scaleY : 0.0,
			__clippedViewPort.width / scaleX, __clippedViewPort.height / scaleY);

		if (horizontalAlign == Align.LEFT)
			__statsDisplay.x = clipping.x;
		else if (horizontalAlign == Align.RIGHT)
			__statsDisplay.x = clipping.right - __statsDisplay.width;
		else if (horizontalAlign == Align.CENTER)
			__statsDisplay.x = (clipping.right - __statsDisplay.width) / 2;
		else
			throw new ArgumentError("Invalid horizontal alignment: " + horizontalAlign);

		if (verticalAlign == Align.TOP)
			__statsDisplay.y = clipping.y;
		else if (verticalAlign == Align.BOTTOM)
			__statsDisplay.y = clipping.bottom - __statsDisplay.height;
		else if (verticalAlign == Align.CENTER)
			__statsDisplay.y = (clipping.bottom - __statsDisplay.height) / 2;
		else
			throw new ArgumentError("Invalid vertical alignment: " + verticalAlign);

		Pool.putRectangle(clipping);
	}

	/**
	 * The Starling stage object, which is the root of the display tree that is rendered.
	 * 
	 * @return The Starling stage object.
	 */
	public var stage(get, never):Stage;

	private inline function get_stage():Stage {
		return __stage;
	}

	/**
	 * The Flash Stage3D object Starling renders into.
	 * 
	 * @return The Stage3D object used by Starling for rendering.
	 */
	public var stage3D(get, never):Stage3D;

	private inline function get_stage3D():Stage3D {
		return __painter.stage3D;
	}

	/**
	 * The instance of the root class provided in the constructor. Available as soon as 
	 * the event 'ROOT_CREATED' has been dispatched.
	 * 
	 * @return The instance of the root class.
	 */
	public var nativeStage(get, never):OpenFLStage;

	private inline function get_nativeStage():OpenFLStage {
		return __nativeStage;
	}

	/** The instance of the root class provided in the constructor. Available as soon as 
	 * the event 'ROOT_CREATED' has been dispatched. */
	public var root(get, never):DisplayObject;

	private inline function get_root():DisplayObject {
		return __root;
	}

	/**
	 * The class that will be instantiated by Starling as the 'root' display object.
	 * Must be a subclass of 'starling.display.DisplayObject'.
	 *
	 * <p>If you passed <code>null</code> as the first parameter to the Starling constructor,
	 * you can use this property to set the root class at a later time. As soon as the class
	 * is instantiated, Starling will dispatch a <code>ROOT_CREATED</code> event.</p>
	 *
	 * <p>Beware: you cannot change the root class once the root object has been
	 * instantiated.</p>
	 * 
	 * @return The class that will be instantiated as the 'root' display object.
	 * @param value The class to be set as the 'root' display object.
	 */
	public var rootClass(get, set):Class<Dynamic>;

	private inline function get_rootClass():Class<Dynamic> {
		return __rootClass;
	}

	private inline function set_rootClass(value:Class<Dynamic>):Class<Dynamic> {
		if (__rootClass != null && __root != null)
			throw new Error("Root class may not change after root has been instantiated");
		else if (__rootClass == null) {
			__rootClass = value;
			if (context != null)
				initializeRoot();
		}
		return value;
	}

	/**
	 * Indicates if another Starling instance (or another Stage3D framework altogether)
	 * uses the same render context. If enabled, Starling will not execute any destructive
	 * context operations (e.g., not call 'configureBackBuffer', 'clear', 'present', etc.).
	 * This has to be done manually, then.
	 * 
	 * @default false
	 * 
	 * @return A boolean value indicating whether the render context is shared with another Starling instance or Stage3D framework.
	 */
	public var shareContext(get, set):Bool;

	private inline function get_shareContext():Bool {
		return __painter.shareContext;
	}

	private inline function set_shareContext(value:Bool):Bool {
		if (!value)
			__previousViewPort.setEmpty(); // forces back buffer update
		return __painter.shareContext = value;
	}

	/**
	 * The Context3D profile of the current render context, or <code>null</code>
	 * if the context has not been created yet.
	 * 
	 * @return The Context3D profile of the current render context, or <code>null</code> if the context is not created.
	 */
	public var profile(get, never):Context3DProfile;

	private inline function get_profile():Context3DProfile {
		return __painter.profile;
	}

	/**
	 * Indicates that if the device supports HiDPI screens, Starling will attempt to allocate
	 * a larger back buffer than indicated via the viewPort size. Note that this is used
	 * on Desktop only; mobile AIR apps still use the "requestedDisplayResolution" parameter
	 * in the application descriptor XML.
	 * 
	 * @default false
	 * 
	 * @return A boolean value indicating whether Starling attempts to allocate a larger back buffer for HiDPI screens.
	 */
	public var supportHighResolutions(get, set):Bool;

	private inline function get_supportHighResolutions():Bool {
		return __supportHighResolutions;
	}

	private inline function set_supportHighResolutions(value:Bool):Bool {
		if (__supportHighResolutions != value) {
			__supportHighResolutions = value;
			if (contextValid)
				updateViewPort(true);
		}
		return value;
	}

	/**
	 * If enabled, the Stage3D back buffer will change its size according to the browser zoom
	 * value - similar to what's done when "supportHighResolutions" is enabled. The resolution
	 * is updated on the fly when the zoom factor changes. Only relevant for the browser plugin.
	 * 
	 * @default false
	 * 
	 * @return A boolean value indicating whether the Stage3D back buffer size adjusts according to the browser zoom value.
	 */
	public var supportBrowserZoom(get, set):Bool;

	private inline function get_supportBrowserZoom():Bool {
		return __supportBrowserZoom;
	}

	private inline function set_supportBrowserZoom(value:Bool):Bool {
		if (__supportBrowserZoom != value) {
			__supportBrowserZoom = value;
			#if air
			if (contextValid)
				updateViewPort(true);

			if (value)
				__nativeStage.addEventListener(Event.BROWSER_ZOOM_CHANGE, onBrowserZoomChange, false, 0, true);
			else
				__nativeStage.removeEventListener(Event.BROWSER_ZOOM_CHANGE, onBrowserZoomChange, false);
			#end
		}
		return value;
	}

	/**
	 * When enabled, Starling will skip rendering the stage if it hasn't changed since the
	 * last frame. This is great for apps that remain static from time to time, since it will
	 * greatly reduce power consumption. You should activate this whenever possible!
	 *
	 * <p>The reason why it's disabled by default is that it causes problems with Render-
	 * and VideoTextures. When you use those, you either have to disable this property
	 * temporarily or call <code>setRequiresRedraw()</code> (ideally on the stage) whenever
	 * those textures are changing. Otherwise, the changes won't show up.</p>
	 *
	 * @default false
	 * 
	 * @return A boolean value indicating whether rendering is skipped for unchanged frames.
	 */
	public var skipUnchangedFrames(get, set):Bool;

	private inline function get_skipUnchangedFrames():Bool {
		return __skipUnchangedFrames;
	}

	private inline function set_skipUnchangedFrames(value:Bool):Bool {
		__skipUnchangedFrames = value;
		__nativeStageEmpty = false; // required by 'mustAlwaysRender'
		if (__statsDisplay != null)
			__statsDisplay.showSkipped = value;
		return value;
	}

	/**
	 * The TouchProcessor is passed all mouse and touch input and is responsible for
	 * dispatching TouchEvents to the Starling display tree. If you want to handle these
	 * types of input manually, pass your own custom subclass to this property.
	 * 
	 * @return The current TouchProcessor instance.
	 */
	public var touchProcessor(get, set):TouchProcessor;

	private inline function get_touchProcessor():TouchProcessor {
		return __touchProcessor;
	}

	private inline function set_touchProcessor(value:TouchProcessor):TouchProcessor {
		if (value == null)
			throw new ArgumentError("TouchProcessor must not be null");
		else if (value != __touchProcessor) {
			__touchProcessor.dispose();
			__touchProcessor = value;
		}
		return value;
	}

	/**
	 * When enabled, all touches that start very close to the screen edges are discarded.
	 * On mobile, such touches often indicate swipes that are meant to use OS features.
	 * By default, margins of 15 points at the top, bottom, and left side of the screen are
	 * checked. Call <code>starling.touchProcessor.setSystemGestureMargins()</code> to adapt
	 * the margins in each direction.
	 * 
	 * @default true on mobile, false on desktop
	 * 
	 * @return A boolean value indicating whether touches near the screen edges are discarded.
	 */
	public var discardSystemGestures(get, set):Bool;

	private inline function get_discardSystemGestures():Bool {
		return __touchProcessor.discardSystemGestures;
	}

	private inline function set_discardSystemGestures(value:Bool):Bool {
		__touchProcessor.discardSystemGestures = value;
		return value;
	}

	/**
	 * The number of frames that have been rendered since this instance was created.
	 * 
	 * @return An unsigned integer representing the number of frames rendered since the creation of this instance.
	 */
	public var frameID(get, never):UInt;

	private inline function get_frameID():UInt {
		return __frameID;
	}

	/**
	 * Indicates if the Context3D object is currently valid (i.e., it hasn't been lost or disposed).
	 * 
	 * @return A boolean value indicating whether the Context3D object is currently valid.
	 */
	public var contextValid(get, never):Bool;

	private inline function get_contextValid():Bool {
		return __painter.contextValid;
	}

	// static properties

	/**
	 * The currently active Starling instance.
	 * 
	 * @return The currently active Starling instance.
	 */
	public static var current(get, never):Starling;

	private static inline function get_current():Starling {
		return sCurrent;
	}

	/**
	 * All Starling instances.
	 * 
	 * <p>CAUTION: This is not a copy, but the actual object! Do not modify!</p>
	 * 
	 * @return An array of all Starling instances.
	 */
	public static var all(get, never):Array<Starling>;

	private static inline function get_all():Array<Starling> {
		return sAll;
	}

	/**
	 * The render context of the currently active Starling instance.
	 * 
	 * @return The current Context3D instance.
	 */
	public static var currentContext(get, never):Context3D;

	private static inline function get_currentContext():Context3D {
		return sCurrent != null ? sCurrent.context : null;
	}

	/**
	 * The default juggler of the currently active Starling instance.
	 * 
	 * @return The default Juggler instance.
	 */
	public static var currentJuggler(get, never):Juggler;

	private static inline function get_currentJuggler():Juggler {
		return sCurrent != null ? sCurrent.__juggler : null;
	}

	/**
	 * The contentScaleFactor of the currently active Starling instance.
	 * 
	 * @return A float value representing the content scale factor.
	 */
	public static var currentContentScaleFactor(get, never):Float;

	private static inline function get_currentContentScaleFactor():Float {
		return sCurrent != null ? sCurrent.contentScaleFactor : 1.0;
	}

	/**
	 * Indicates if multitouch input should be supported. You can enable or disable
	 * multitouch at any time; just beware that any current touches will be cancelled.
	 * 
	 * @return A boolean value indicating whether multitouch input is enabled.
	 * @default false
	 */
	public static var multitouchEnabled(get, set):Bool;

	private static inline function get_multitouchEnabled():Bool {
		var enabled:Bool = Multitouch.inputMode == MultitouchInputMode.TOUCH_POINT;
		var outOfSync:Bool = false;

		for (star in sAll)
			if (star.__multitouchEnabled != enabled)
				outOfSync = true;

		if (outOfSync)
			trace("[Starling] Warning: multitouch settings are out of sync. Always set " + "'Starling.multitouchEnabled' instead of 'Multitouch.inputMode'.");

		return enabled;
	}

	private static inline function set_multitouchEnabled(value:Bool):Bool {
		var wasEnabled:Bool = Multitouch.inputMode == MultitouchInputMode.TOUCH_POINT;

		Multitouch.inputMode = value ? MultitouchInputMode.TOUCH_POINT : MultitouchInputMode.NONE;

		var isEnabled:Bool = Multitouch.inputMode == MultitouchInputMode.TOUCH_POINT;

		if (wasEnabled != isEnabled) {
			for (star in sAll)
				star.setMultitouchEnabled(isEnabled);
		}

		return value;
	}

	/** The number of frames that have been rendered since the current instance was created. */
	// public static var frameID(get, never):UInt;
	// public static function get_frameID():UInt
	// {
	//     return sCurrent != null ? sCurrent.__frameID : 0;
	// }

	private function isNativeDisplayObjectEmpty(object:openfl.display.DisplayObject):Bool {
		if (object == null)
			return true;
		else if (#if (haxe_ver < 4.2) Std.is #else Std.isOfType #end (object, DisplayObjectContainer)) {
			var container:DisplayObjectContainer = cast object;
			var numChildren:Int = container.numChildren;

			for (i in 0...numChildren) {
				if (!isNativeDisplayObjectEmpty(container.getChildAt(i)))
					return false;
			}

			return true;
		} else
			return !object.visible;
	}
}

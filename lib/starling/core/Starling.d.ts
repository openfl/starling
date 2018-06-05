// =================================================================================================
//
//	Starling Framework
//	Copyright Gamua GmbH. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

import Sprite from "openfl/display/Sprite";
import OpenFLStage from "openfl/display/Stage";
import Context3D from "openfl/display3D/Context3D";
import Context3DProfile from "openfl/display3D/Context3DProfile";
import Context3DRenderMode from "openfl/display3D/Context3DRenderMode";
import Rectangle from "openfl/geom/Rectangle";
import Vector from "openfl/Vector";
import Juggler from "./../animation/Juggler";
import DisplayObject from "./../display/DisplayObject";
import Stage from "./../display/Stage";
import EventDispatcher from "./../events/EventDispatcher";
import TouchProcessor from "./../events/TouchProcessor";
import Painter from "./../rendering/Painter";
import Stage3D from "openfl/display/Stage3D";

declare namespace starling.core
{
	/** Dispatched when a new render context is created. The 'data' property references the context. */
	// @:meta(Event(name="context3DCreate", type="starling.events.Event"))

	/** Dispatched when the root class has been created. The 'data' property references that object. */
	// @:meta(Event(name="rootCreated", type="starling.events.Event"))

	/** Dispatched when a fatal error is encountered. The 'data' property contains an error string. */
	// @:meta(Event(name="fatalError", type="starling.events.Event"))

	/** Dispatched when the display list is about to be rendered. This event provides the last
	 *  opportunity to make changes before the display list is rendered. */
	// @:meta(Event(name="render", type="starling.events.Event"))

	/** The Starling class represents the core of the Starling framework.
	 *
	 *  <p>The Starling framework makes it possible to create 2D applications and games that make
	 *  use of the Stage3D architecture introduced in Flash Player 11. It implements a display tree
	 *  system that is very similar to that of conventional Flash, while leveraging modern GPUs
	 *  to speed up rendering.</p>
	 *  
	 *  <p>The Starling class represents the link between the conventional Flash display tree and
	 *  the Starling display tree. To create a Starling-powered application, you have to create
	 *  an instance of the Starling class:</p>
	 *  
	 *  <pre>starling:Starling = new Starling(Game, stage);</pre>
	 *  
	 *  <p>The first parameter has to be a Starling display object class, e.g. a subclass of 
	 *  <code>starling.display.Sprite</code>. In the sample above, the class "Game" is the
	 *  application root. An instance of "Game" will be created as soon as Starling is initialized.
	 *  The second parameter is the conventional (Flash) stage object. Per default, Starling will
	 *  display its contents directly below the stage.</p>
	 *  
	 *  <p>It is recommended to store the Starling instance as a member variable, to make sure
	 *  that the Garbage Collector does not destroy it. After creating the Starling object, you 
	 *  have to start it up like this:</p>
	 * 
	 *  <pre>starling.start();</pre>
	 * 
	 *  <p>It will now render the contents of the "Game" class in the frame rate that is set up for
	 *  the application (as defined in the Flash stage).</p> 
	 * 
	 *  <strong>Context3D Profiles</strong>
	 * 
	 *  <p>Stage3D supports different rendering profiles, and Starling works with all of them. The
	 *  last parameter of the Starling constructor allows you to choose which profile you want.
	 *  The following profiles are available:</p>
	 * 
	 *  <ul>
	 *    <li>BASELINE_CONSTRAINED: provides the broadest hardware reach. If you develop for the
	 *        browser, this is the profile you should test with.</li>
	 *    <li>BASELINE: recommend for any mobile application, as it allows Starling to use a more
	 *        memory efficient texture type (RectangleTextures). It also supports more complex
	 *        AGAL code.</li>
	 *    <li>BASELINE_EXTENDED: adds support for textures up to 4096x4096 pixels. This is
	 *        especially useful on mobile devices with very high resolutions.</li>
	 *    <li>STANDARD_CONSTRAINED, STANDARD, STANDARD_EXTENDED: each provide more AGAL features,
	 *        among other things. Most Starling games will not gain much from them.</li>
	 *  </ul>
	 *  
	 *  <p>The recommendation is to deploy your app with the profile "auto" (which makes Starling
	 *  pick the best available of those), but to test it in all available profiles.</p>
	 *  
	 *  <strong>Accessing the Starling object</strong>
	 * 
	 *  <p>From within your application, you can access the current Starling object anytime
	 *  through the static method <code>Starling.current</code>. It will return the active Starling
	 *  instance (most applications will only have one Starling object, anyway).</p> 
	 * 
	 *  <strong>Viewport</strong>
	 * 
	 *  <p>The area the Starling content is rendered into is, per default, the complete size of the 
	 *  stage. You can, however, use the "viewPort" property to change it. This can be  useful 
	 *  when you want to render only into a part of the screen, or if the player size changes. For
	 *  the latter, you can listen to the RESIZE-event dispatched by the Starling
	 *  stage.</p>
	 * 
	 *  <strong>Native overlay</strong>
	 *  
	 *  <p>Sometimes you will want to display native Flash content on top of Starling. That's what the
	 *  <code>nativeOverlay</code> property is for. It returns a Flash Sprite lying directly
	 *  on top of the Starling content. You can add conventional Flash objects to that overlay.</p>
	 *  
	 *  <p>Beware, though, that conventional Flash content on top of 3D content can lead to
	 *  performance penalties on some (mobile) platforms. For that reason, always remove all child
	 *  objects from the overlay when you don't need them any longer.</p>
	 *  
	 *  <strong>Multitouch</strong>
	 *  
	 *  <p>Starling supports multitouch input on devices that provide it. During development, 
	 *  where most of us are working with a conventional mouse and keyboard, Starling can simulate 
	 *  multitouch events with the help of the "Shift" and "Ctrl" (Mac: "Cmd") keys. Activate
	 *  this feature by enabling the <code>simulateMultitouch</code> property.</p>
	 *
	 *  <strong>Skipping Unchanged Frames</strong>
	 *
	 *  <p>It happens surprisingly often in an app or game that a scene stays completely static for
	 *  several frames. So why redraw the stage at all in those situations? That's exactly the
	 *  point of the <code>skipUnchangedFrames</code>-property. If enabled, static scenes are
	 *  recognized as such and the back buffer is simply left as it is. On a mobile device, the
	 *  impact of this feature can't be overestimated! There's simply no better way to enhance
	 *  battery life. Make it a habit to always activate it; look at the documentation of the
	 *  corresponding property for details.</p>
	 *  
	 *  <strong>Handling a lost render context</strong>
	 *  
	 *  <p>On some operating systems and under certain conditions (e.g. returning from system
	 *  sleep), Starling's stage3D render context may be lost. Starling will try to recover
	 *  from a lost context automatically; to be able to do this, it will cache textures in
	 *  RAM. This will take up quite a bit of extra memory, though, which might be problematic
	 *  especially on mobile platforms. To avoid the higher memory footprint, it's recommended
	 *  to load your textures with Starling's "AssetManager"; it is smart enough to recreate a
	 *  texture directly from its origin.</p>
	 *
	 *  <p>In case you want to react to a context loss manually, Starling dispatches an event with
	 *  the type "Event.CONTEXT3D_CREATE" when the context is restored, and textures will execute
	 *  their <code>root.onRestore</code> callback, to which you can attach your own logic.
	 *  Refer to the "Texture" class for more information.</p>
	 *
	 *  <strong>Sharing a 3D Context</strong>
	 * 
	 *  <p>Per default, Starling handles the Stage3D context itself. If you want to combine
	 *  Starling with another Stage3D engine, however, this may not be what you want. In this case,
	 *  you can make use of the <code>shareContext</code> property:</p> 
	 *  
	 *  <ol>
	 *    <li>Manually create and configure a context3D object that both frameworks can work with
	 *        (ideally through <code>RenderUtil.requestContext3D</code> and
	 *        <code>context.configureBackBuffer</code>).</li>
	 *    <li>Initialize Starling with the stage3D instance that contains that configured context.
	 *        This will automatically enable <code>shareContext</code>.</li>
	 *    <li>Call <code>start()</code> on your Starling instance (as usual). This will make  
	 *        Starling queue input events (keyboard/mouse/touch).</li>
	 *    <li>Create a game loop (e.g. using the native <code>ENTER_FRAME</code> event) and let it  
	 *        call Starling's <code>nextFrame</code> as well as the equivalent method of the other 
	 *        Stage3D engine. Surround those calls with <code>context.clear()</code> and 
	 *        <code>context.present()</code>.</li>
	 *  </ol>
	 *  
	 *  <p>The Starling wiki contains a <a href="http://goo.gl/BsXzw">tutorial</a> with more 
	 *  information about this topic.</p>
	 *
	 *  @see starling.utils.AssetManager
	 *  @see starling.textures.Texture
	 *
	 */
	export class Starling extends EventDispatcher
	{
		/** The version of the Starling framework. */
		public static VERSION:string;
		
		// construction
		
		/** Creates a new Starling instance. 
		 * @param rootClass  A subclass of 'starling.display.DisplayObject'. It will be created
		 *                   as soon as initialization is finished and will become the first child
		 *                   of the Starling stage. Pass <code>null</code> if you don't want to
		 *                   create a root object right away. (You can use the
		 *                   <code>rootClass</code> property later to make that happen.)
		 * @param stage      The Flash (2D) stage.
		 * @param viewPort   A rectangle describing the area into which the content will be 
		 *                   rendered. Default: stage size
		 * @param stage3D    The Stage3D object into which the content will be rendered. If it 
		 *                   already contains a context, <code>sharedContext</code> will be set
		 *                   to <code>true</code>. Default: the first available Stage3D.
		 * @param renderMode The Context3D render mode that should be requested.
		 *                   Use this parameter if you want to force "software" rendering.
		 * @param profile    The Context3D profile that should be requested.
		 *
		 *                   <ul>
		 *                   <li>If you pass a profile String, this profile is enforced.</li>
		 *                   <li>Pass an Array of profiles to make Starling pick the first
		 *                       one that works (starting with the first array element).</li>
		 *                   <li>Pass the String "auto" to make Starling pick the best available
		 *                       profile automatically.</li>
		 *                   </ul>
		 */
		public constructor(rootClass:any, stage:OpenFLStage, 
								viewPort?:Rectangle, stage3D?:Stage3D,
								renderMode?:Context3DRenderMode, profile?:any, sharedContext?:null | boolean);
		
		/** Disposes all children of the stage and the render context; removes all registered
		 * event listeners. */
		public dispose():void;
		
		// functions
		
		/** Calls <code>advanceTime()</code> (with the time that has passed since the last frame)
		 * and <code>render()</code>. */
		public nextFrame():void;
		
		/** Dispatches ENTER_FRAME events on the display list, advances the Juggler 
		 * and processes touches. */
		public advanceTime(passedTime:number):void;

		/** Renders the complete display list. Before rendering, the context is cleared; afterwards,
		 * it is presented (to avoid this, enable <code>shareContext</code>).
		 *
		 * <p>This method also dispatches an <code>Event.RENDER</code>-event on the Starling
		 * instance. That's the last opportunity to make changes before the display list is
		 * rendered.</p> */
		public render():void;
		
		/** Stops Starling right away and displays an error message on the native overlay.
		 * This method will also cause Starling to dispatch a FATAL_ERROR event. */
		public stopWithFatalError(message:string):void;
		
		/** Make this Starling instance the <code>current</code> one. */
		public makeCurrent():void;
		
		/** As soon as Starling is started, it will queue input events (keyboard/mouse/touch);   
		 * furthermore, the method <code>nextFrame</code> will be called once per Flash Player
		 * frame. (Except when <code>shareContext</code> is enabled: in that case, you have to
		 * call that method manually.) */
		public start():void;
		
		/** Stops all logic and input processing, effectively freezing the app in its current state.
		 * Per default, rendering will continue: that's because the classic display list
		 * is only updated when stage3D is. (If Starling stopped rendering, conventional Flash
		 * contents would freeze, as well.)
		 * 
		 * <p>However, if you don't need classic Flash contents, you can stop rendering, too.
		 * On some mobile systems (e.g. iOS), you are even required to do so if you have
		 * activated background code execution.</p>
		 */
		public stop(suspendRendering?:boolean):void;

		/** Makes sure that the next frame is actually rendered.
		 *
		 *  <p>When <code>skipUnchangedFrames</code> is enabled, some situations require that you
		 *  manually force a redraw, e.g. when a RenderTexture is changed. This method is the
		 *  easiest way to do so; it's just a shortcut to <code>stage.setRequiresRedraw()</code>.
		 *  </p>
		 */
		public setRequiresRedraw():void;

		// properties
		
		/** Indicates if this Starling instance is started. */
		public readonly isStarted:boolean;
		protected get_isStarted():boolean;

		/** The default juggler of this instance. Will be advanced once per frame. */
		public readonly juggler:Juggler;
		protected get_juggler():Juggler;
		
		/** The painter, which is used for all rendering. The same instance is passed to all
		 *  <code>render</code>methods each frame. */
		public readonly painter:Painter;
		protected get_painter():Painter;
		
		/** The render context of this instance. */
		public readonly context:Context3D;
		protected get_context():Context3D;

		/** Indicates if multitouch simulation with "Shift" and "Ctrl"/"Cmd"-keys is enabled.
		 *  @default false */
		public simulateMultitouch:boolean;
		protected get_simulateMultitouch():boolean;
		protected set_simulateMultitouch(value:boolean):boolean;
		
		/** Indicates if Stage3D render methods will report errors. It's recommended to activate
		 * this when writing custom rendering code (shaders, etc.), since you'll get more detailed
		 * error messages. However, it has a very negative impact on performance, and it prevents
		 * ATF textures from being restored on a context loss. Never activate for release builds!
		 *
		 * @default false */
		public enableErrorChecking:boolean;
		protected get_enableErrorChecking():boolean;
		protected set_enableErrorChecking(value:boolean):boolean;

		/** The antialiasing level. 0 - no antialasing, 16 - maximum antialiasing. @default 0 */
		public antiAliasing:number;
		protected get_antiAliasing():number;
		protected set_antiAliasing(value:number):number;
		
		/** The viewport into which Starling contents will be rendered. */
		public viewPort:Rectangle;
		protected get_viewPort():Rectangle;
		protected set_viewPort(value:Rectangle):Rectangle;
		
		/** The ratio between viewPort width and stage width. Useful for choosing a different
		 * set of textures depending on the display resolution. */
		public readonly contentScaleFactor:number;
		protected get_contentScaleFactor():number;
		
		/** A Flash Sprite placed directly on top of the Starling content. Use it to display native
		 * Flash components. */ 
		public readonly nativeOverlay:Sprite;
		protected get_nativeOverlay():Sprite;
		
		/** Indicates if a small statistics box (with FPS, memory usage and draw count) is
		 * displayed.
		 *
		 * <p>Beware that the memory usage should be taken with a grain of salt. The value is
		 * determined via <code>System.totalMemory</code> and does not take texture memory
		 * into account. It is recommended to use Adobe Scout for reliable and comprehensive
		 * memory analysis.</p>
		 */
		public showStats:boolean;
		protected get_showStats():boolean;
		protected set_showStats(value:boolean):boolean;
		
		/** Displays the statistics box at a certain position. */
		public showStatsAt(horizontalAlign?:string,
									verticalAlign?:string, scale?:number):void;
		
		/** The Starling stage object, which is the root of the display tree that is rendered. */
		public readonly stage:Stage;
		protected get_stage():Stage;

		/** The Flash Stage3D object Starling renders into. */
		public readonly stage3D:Stage3D;
		protected get_stage3D():Stage3D;
		
		/** The Flash (2D) stage object Starling renders beneath. */
		public readonly nativeStage:OpenFLStage;
		protected get_nativeStage():OpenFLStage;
		
		/** The instance of the root class provided in the constructor. Available as soon as 
		 * the event 'ROOT_CREATED' has been dispatched. */
		public readonly root:DisplayObject;
		protected get_root():DisplayObject;

		/** The class that will be instantiated by Starling as the 'root' display object.
		 * Must be a subclass of 'starling.display.DisplayObject'.
		 *
		 * <p>If you passed <code>null</code> as first parameter to the Starling constructor,
		 * you can use this property to set the root class at a later time. As soon as the class
		 * is instantiated, Starling will dispatch a <code>ROOT_CREATED</code> event.</p>
		 *
		 * <p>Beware: you cannot change the root class once the root object has been
		 * instantiated.</p>
		 */
		public rootClass:any;
		protected get_rootClass():any;
		protected set_rootClass(value:any):any;

		/** Indicates if another Starling instance (or another Stage3D framework altogether)
		 * uses the same render context. If enabled, Starling will not execute any destructive
		 * context operations (e.g. not call 'configureBackBuffer', 'clear', 'present', etc.
		 * This has to be done manually, then. @default false */
		public shareContext:boolean;
		protected get_shareContext():boolean;
		protected set_shareContext(value:boolean):boolean;

		/** The Context3D profile of the current render context, or <code>null</code>
		 * if the context has not been created yet. */
		public readonly profile:Context3DProfile;
		protected get_profile():Context3DProfile;

		/** Indicates that if the device supports HiDPI screens Starling will attempt to allocate
		 * a larger back buffer than indicated via the viewPort size. Note that this is used
		 * on Desktop only; mobile AIR apps still use the "requestedDisplayResolution" parameter
		 * the application descriptor XML. @default false */
		public supportHighResolutions:boolean;
		protected get_supportHighResolutions():boolean;
		protected set_supportHighResolutions(value:boolean):boolean;

		/** If enabled, the Stage3D back buffer will change its size according to the browser zoom
		 *  value - similar to what's done when "supportHighResolutions" is enabled. The resolution
		 *  is updated on the fly when the zoom factor changes. Only relevant for the browser plugin.
		 *  @default false */
		public supportBrowserZoom:boolean;
		protected get_supportBrowserZoom():boolean;
		protected set_supportBrowserZoom(value:boolean):boolean;

		/** When enabled, Starling will skip rendering the stage if it hasn't changed since the
		 *  last frame. This is great for apps that remain static from time to time, since it will
		 *  greatly reduce power consumption. You should activate this whenever possible!
		 *
		 *  <p>The reason why it's disabled by default is just that it causes problems with Render-
		 *  and VideoTextures. When you use those, you either have to disable this property
		 *  temporarily, or call <code>setRequiresRedraw()</code> (ideally on the stage) whenever
		 *  those textures are changing. Otherwise, the changes won't show up.</p>
		 *
		 *  @default false
		 */
		public skipUnchangedFrames:boolean;
		protected get_skipUnchangedFrames():boolean;
		protected set_skipUnchangedFrames(value:boolean):boolean;
		
		/** The TouchProcessor is passed all mouse and touch input and is responsible for
		 * dispatching TouchEvents to the Starling display tree. If you want to handle these
		 * types of input manually, pass your own custom subclass to this property. */
		public touchProcessor:TouchProcessor;
		protected get_touchProcessor():TouchProcessor;
		protected set_touchProcessor(value:TouchProcessor):TouchProcessor;

		/** The number of frames that have been rendered since this instance was created. */
		public readonly frameID:number;
		protected get_frameID():number;
		
		/** Indicates if the Context3D object is currently valid (i.e. it hasn't been lost or
		 * disposed). */
		public readonly contextValid:boolean;
		protected get_contextValid():boolean;

		// static properties
		
		/** The currently active Starling instance. */
		public static readonly current:Starling;
		protected static get_current():Starling;

		/** All Starling instances. <p>CAUTION: not a copy, but the actual object! Do not modify!</p> */
		public static readonly all:Vector<Starling>;
		protected static get_all():Vector<Starling>;
		
		/** The render context of the currently active Starling instance. */
		// public static readonly context:Context3D;
		// protected static get_context():Context3D { return sCurrent != null ? sCurrent.context : null; }
		
		/** The default juggler of the currently active Starling instance. */
		// public static readonly juggler:Juggler;
		// protected static get_juggler():Juggler { return sCurrent != null ? sCurrent.__juggler : null; }
		
		/** The contentScaleFactor of the currently active Starling instance. */
		// public static readonly contentScaleFactor:number;
		// protected static get_contentScaleFactor():number 
		// {
		//     return sCurrent != null ? sCurrent.contentScaleFactor : 1.0;
		// }
		
		/** Indicates if multitouch input should be supported. */
		public static multitouchEnabled:boolean;
		protected static get_multitouchEnabled():boolean;
		protected static set_multitouchEnabled(value:boolean):boolean;
	}
}

export default starling.core.Starling;
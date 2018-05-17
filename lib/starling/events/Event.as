package starling.events {

	import starling.utils.StringUtil;
	

	/**
	 * @externs
	 */
	public class Event {
		public function get bubbles():Boolean { return false; }
		public function get currentTarget():EventDispatcher { return null; }
		public function get data():Object { return null; }
		public function get target():EventDispatcher { return null; }
		public function get type():String { return null; }
		public function Event(type:String, bubbles:Boolean = false, data:Object = null):void {}
		public function stopImmediatePropagation():void {}
		public function stopPropagation():void {}
		public function toString():String { return null; }
		/** Event type for a display object that is added to a parent. */
		public static const ADDED:String = "added";
		/** Event type for a display object that is added to the stage */
		public static const ADDED_TO_STAGE:String = "addedToStage";
		/** Event type for a display object that is entering a new frame. */
		public static const ENTER_FRAME:String = "enterFrame";
		/** Event type for a display object that is removed from its parent. */
		public static const REMOVED:String = "removed";
		/** Event type for a display object that is removed from the stage. */
		public static const REMOVED_FROM_STAGE:String = "removedFromStage";
		/** Event type for a triggered button. */
		public static const TRIGGERED:String = "triggered";
		/** Event type for a resized Flash Player. */
		public static const RESIZE:String = "resize";
		/** Event type that may be used whenever something finishes. */
		public static const COMPLETE:String = "complete";
		/** Event type for a (re)created stage3D rendering context. */
		public static const CONTEXT3D_CREATE:String = "context3DCreate";
		/** Event type that is dispatched by the Starling instance directly before rendering. */
		public static const RENDER:String = "render";
		/** Event type that indicates that the root DisplayObject has been created. */
		public static const ROOT_CREATED:String = "rootCreated";
		/** Event type for an animated object that requests to be removed from the juggler. */
		public static const REMOVE_FROM_JUGGLER:String = "removeFro__juggler";
		/** Event type that is dispatched by the AssetManager after a context loss. */
		public static const TEXTURES_RESTORED:String = "texturesRestored";
		/** Event type that is dispatched by the AssetManager when a file/url cannot be loaded. */
		public static const IO_ERROR:String = "ioError";
		/** Event type that is dispatched by the AssetManager when a file/url cannot be loaded. */
		public static const SECURITY_ERROR:String = "securityError";
		/** Event type that is dispatched by the AssetManager when an xml or json file couldn't
		 * be parsed. */
		public static const PARSE_ERROR:String = "parseError";
		/** Event type that is dispatched by the Starling instance when it encounters a problem
		 * from which it cannot recover, e.g. a lost device context. */
		public static const FATAL_ERROR:String = "fatalError";

		/** An event type to be utilized in custom events. Not used by Starling right now. */
		public static const CHANGE:String = "change";
		/** An event type to be utilized in custom events. Not used by Starling right now. */
		public static const CANCEL:String = "cancel";
		/** An event type to be utilized in custom events. Not used by Starling right now. */
		public static const SCROLL:String = "scroll";
		/** An event type to be utilized in custom events. Not used by Starling right now. */
		public static const OPEN:String = "open";
		/** An event type to be utilized in custom events. Not used by Starling right now. */
		public static const CLOSE:String = "close";
		/** An event type to be utilized in custom events. Not used by Starling right now. */
		public static const SELECT:String = "select";
		/** An event type to be utilized in custom events. Not used by Starling right now. */
		public static const READY:String = "ready";
		/** An event type to be utilized in custom events. Not used by Starling right now. */
		public static const UPDATE:String = "update";
	}
	
}
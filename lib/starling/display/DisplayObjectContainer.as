package starling.display {
	
	import starling.display.DisplayObject;
	import starling.utils.MatrixUtil;
	import starling.events.Event;
	import starling.rendering.BatchToken;
	
	/**
	 * @externs
	 */
	public class DisplayObjectContainer extends DisplayObject {
		public function get numChildren():int { return 0; }
		public var touchGroup:Boolean;
		public function addChild(child:DisplayObject):DisplayObject { return null; }
		public function addChildAt(child:DisplayObject, index:int):DisplayObject { return null; }
		public function broadcastEvent(event:Event):void {}
		public function broadcastEventWith(eventType:String, data:Object = null):void {}
		public function contains(child:DisplayObject):Boolean { return false; }
		public function getChildAt(index:int):DisplayObject { return null; }
		public function getChildByName(name:String):DisplayObject { return null; }
		public function getChildIndex(child:DisplayObject):int { return 0; }
		public function removeChild(child:DisplayObject, dispose:Boolean = false):DisplayObject { return null; }
		public function removeChildAt(index:int, dispose:Boolean = false):DisplayObject { return null; }
		public function removeChildren(beginIndex:int = 0, endIndex:int = 0, dispose:Boolean = false):void {}
		public function setChildIndex(child:DisplayObject, index:int):void {}
		public function sortChildren(compareFunction:Function):void {}
		public function swapChildren(child1:DisplayObject, child2:DisplayObject):void {}
		public function swapChildrenAt(index1:int, index2:int):void {}
	}
	
}
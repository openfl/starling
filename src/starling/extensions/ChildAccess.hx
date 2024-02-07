package starling.extensions;
#if flash
import flash.text.StyleSheet;
#end
import haxe.Constraints.Function;
import openfl.display.BitmapData;
import openfl.errors.TypeError;
import openfl.geom.Matrix;
import openfl.geom.Matrix3D;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.geom.Vector3D;
import openfl.media.Sound;
import openfl.media.SoundTransform;
import starling.display.Button;
import starling.display.Canvas;
import starling.display.DisplayObject;
import starling.display.DisplayObjectContainer;
import starling.display.Image;
import starling.display.Mesh;
import starling.display.MeshBatch;
import starling.display.MovieClip;
import starling.display.Quad;
import starling.display.Sprite;
import starling.display.Sprite3D;
import starling.display.Stage;
import starling.events.Event;
import starling.filters.FragmentFilter;
import starling.geom.Polygon;
import starling.rendering.Painter;
import starling.rendering.VertexDataFormat;
import starling.styles.MeshStyle;
import starling.text.TextField;
import starling.text.TextFormat;
import starling.textures.Texture;
import starling.utils.MeshSubset;

/**
	The ChildAccess abstract simplifies access to nested DisplayObjects. Although
	performance may be somewhat slower than using direct references, this is especially
	useful when setting up a UI or performing non-intensive tasks.

	For example, consider the following hierarchy:

	   movieClip -> sprite -> sprite2 -> textField

	You can use ChildAccess to more easily reference TextField:

	```haxe
	var movieClip:ChildAccess<MovieClip> = movieClip;
	movieClip.sprite.sprite2.textField.text = "Hello World";
	```

	Without ChildAccess, it can be more difficult to access nested objects:

	```haxe
	var sprite:Sprite = cast movieClip.getChildByName("sprite");
	var sprite2:Sprite = cast sprite.getChildByName("sprite2");
	var textField:TextField = cast sprite2.getChildByName("textField");
	textField.text = "Hello World";
	```

	ChildAccess provides most of the benefits of dynamic references, while
	still remaining strongly typed for properties.

	You can use array access to reach child instances as well. This is useful if the child object
	has the name of a DisplayObject property, or if it uses special characters:

	```haxe
	var movieClip:ChildAccess<MovieClip> = movieClip;
	movieClip.sprite["sprite2"].x = 100;
	```
**/
@:access(starling.display.DisplayObject)
@:transitive
@:forward
abstract ChildAccess<T:DisplayObject>(T) from T to T
{
	//################################################################################
	// Button
	//################################################################################
	/* Accesses the `abortDistance` property (for Button instances only). */
	public var abortDistance(get, set):Float;
	private inline function get_abortDistance():Float { return cast(this, Button).abortDistance; }
	private inline function set_abortDistance(value:Float):Float { return cast(this, Button).abortDistance = value; }
	
	/* Accesses the `alphaWhenDisabled` property (for Button instances only). */
	public var alphaWhenDisabled(get, set):Float;
	private inline function get_alphaWhenDisabled():Float { return cast(this, Button).alphaWhenDisabled; }
	private inline function set_alphaWhenDisabled(value:Float):Float { return cast(this, Button).alphaWhenDisabled = value; }
	
	/* Accesses the `alphaWhenDown` property (for Button instances only). */
	public var alphaWhenDown(get, set):Float;
	private inline function get_alphaWhenDown():Float { return cast(this, Button).alphaWhenDown; }
	private inline function set_alphaWhenDown(value:Float):Float { return cast(this, Button).alphaWhenDown = value; }
	
	/* Accesses the `disabledState` property (for Button instances only). */
	public var disabledState(get, set):Texture;
	private inline function get_disabledState():Texture { return cast(this, Button).disabledState; }
	private inline function set_disabledState(value:Texture):Texture { return cast(this, Button).disabledState = value; }
	
	/* Accesses the `downState` property (for Button instances only). */
	public var downState(get, set):Texture;
	private inline function get_downState():Texture { return cast(this, Button).downState; }
	private inline function set_downState(value:Texture):Texture { return cast(this, Button).downState = value; }
	
	/* Accesses the `enabled` property (for Button instances only). */
	public var enabled(get, set):Bool;
	private inline function get_enabled():Bool { return cast(this, Button).enabled; }
	private inline function set_enabled(value:Bool):Bool { return cast(this, Button).enabled = value; }
	
	/* Accesses the `minHitAreaSize` property (for Button instances only). */
	public var minHitAreaSize(get, set):Float;
	private inline function get_minHitAreaSize():Float { return cast(this, Button).minHitAreaSize; }
	private inline function set_minHitAreaSize(value:Float):Float { return cast(this, Button).minHitAreaSize = value; }
	
	/* Accesses the `overlay` property (for Button instances only). */
	public var overlay(get, never):Sprite;
	private inline function get_overlay():Sprite { return cast(this, Button).overlay; }
	
	/* Accesses the `overState` property (for Button instances only). */
	public var overState(get, set):Texture;
	private inline function get_overState():Texture { return cast(this, Button).overState; }
	private inline function set_overState(value:Texture):Texture { return cast(this, Button).overState = value; }
	
	/* Accesses the `scaleWhenDown` property (for Button instances only). */
	public var scaleWhenDown(get, set):Float;
	private inline function get_scaleWhenDown():Float { return cast(this, Button).scaleWhenDown; }
	private inline function set_scaleWhenDown(value:Float):Float { return cast(this, Button).scaleWhenDown = value; }
	
	/* Accesses the `scaleWhenOver` property (for Button instances only). */
	public var scaleWhenOver(get, set):Float;
	private inline function get_scaleWhenOver():Float { return cast(this, Button).scaleWhenOver; }
	private inline function set_scaleWhenOver(value:Float):Float { return cast(this, Button).scaleWhenOver = value; }
	
	/* Accesses the `state` property (for Button instances only). */
	public var state(get, set):String;
	private inline function get_state():String { return cast(this, Button).state; }
	private inline function set_state(value:String):String { return cast(this, Button).state = value; }
	
	/* Accesses the `textFormat` property (for Button instances only). */
	public var textFormat(get, set):TextFormat;
	private inline function get_textFormat():TextFormat { return cast(this, Button).textFormat; }
	private inline function set_textFormat(value:TextFormat):TextFormat { return cast(this, Button).textFormat = value; }
	
	/* Accesses the `textStyle` property (for Button instances only). */
	public var textStyle(get, set):MeshStyle;
	private inline function get_textStyle():MeshStyle { return cast(this, Button).textStyle; }
	private inline function set_textStyle(value:MeshStyle):MeshStyle { return cast(this, Button).textStyle = value; }
	
	/* Accesses the `upState` property (for Button instances only). */
	public var upState(get, set):Texture;
	private inline function get_upState():Texture { return cast(this, Button).upState; }
	private inline function set_upState(value:Texture):Texture { return cast(this, Button).upState = value; }
	
	/* Accesses the `readjustSize` method (for Button instances only). */
	public function readjustSizeButton(resetTextBounds:Bool = true):Void
	{
		cast(this, Button).readjustSize(resetTextBounds);
	}
	//################################################################################
	//\Button
	//################################################################################
	
	//################################################################################
	// Canvas
	//################################################################################
	/* Accesses the `beginFill` method (for Canvas instances only). */
	public function beginFill(color:UInt = 0xffffff, alpha:Float = 1.0):Void
	{
		cast(this, Canvas).beginFill(color, alpha);
	}
	
	/* Accesses the `drawCircle` method (for Canvas instances only). */
	public function drawCircle(x:Float, y:Float, radius:Float, numSides:Int = -1):Void
	{
		cast(this, Canvas).drawCircle(x, y, radius, numSides);
	}
	
	/* Accesses the `drawEllipse` method (for Canvas instances only). */
	public function drawEllipse(x:Float, y:Float, width:Float, height:Float, numSides:Int = -1):Void
	{
		cast(this, Canvas).drawEllipse(x, y, width, height, numSides);
	}
	
	/* Accesses the `drawPolygon` method (for Canvas instances only). */
	public function drawPolygon(polygon:Polygon):Void
	{
		cast(this, Canvas).drawPolygon(polygon);
	}
	
	/* Accesses the `drawRectangle` method (for Canvas instances only). */
	public function drawRectangle(x:Float, y:Float, width:Float, height:Float):Void
	{
		cast(this, Canvas).drawRectangle(x, y, width, height);
	}
	
	/* Accesses the `endFill` method (for Canvas instances only). */
	public function endFill():Void
	{
		cast(this, Canvas).endFill();
	}
	//################################################################################
	//\Canvas
	//################################################################################
	
	//################################################################################
	// DisplayObject
	//################################################################################
	/* Accesses the `alpha` property */
	public var alpha(get, set):Float;
	private inline function get_alpha():Float { return this.alpha; }
	private inline function set_alpha(value:Float):Float { return this.alpha = value; }
	
	/* Accesses the `base` property */
	public var base(get, never):DisplayObject;
	private inline function get_base():DisplayObject { return this.base; }
	
	/* Accesses the `blendMode` property */
	public var blendMode(get, set):String;
	private inline function get_blendMode():String { return this.blendMode; }
	private inline function set_blendMode(value:String):String { return this.blendMode = value; }
	
	/* Accesses the `bounds` property */
	public var bounds(get, never):Rectangle;
	private inline function get_bounds():Rectangle { return this.bounds; }
	
	/* Accesses the `filter` property */
	public var filter(get, set):FragmentFilter;
	private inline function get_filter():FragmentFilter { return this.filter; }
	private inline function set_filter(value:FragmentFilter):FragmentFilter { return this.filter = value; }
	
	/* Accesses the `height` property */
	public var height(get, set):Float;
	private inline function get_height():Float { return this.height; }
	private inline function set_height(value:Float):Float { return this.height = value; }
	
	/* Accesses the `is3D` property */
	public var is3D(get, never):Bool;
	private inline function get_is3D():Bool { return this.is3D; }
	
	/* Accesses the `mask` property */
	public var mask(get, set):DisplayObject;
	private inline function get_mask():DisplayObject { return this.mask; }
	private inline function set_mask(value:DisplayObject):DisplayObject { return this.mask = value; }
	
	/* Accesses the `maskInverted` property */
	public var maskInverted(get, set):Bool;
	private inline function get_maskInverted():Bool { return this.maskInverted; }
	private inline function set_maskInverted(value:Bool):Bool { return this.maskInverted = value; }
	
	/* Accesses the `name` property */
	public var name(get, set):String;
	private inline function get_name():String { return this.name; }
	private inline function set_name(value:String):String { return this.name = value; }
	
	/* Accesses the `parent` property */
	public var parent(get, never):DisplayObject;
	private inline function get_parent():DisplayObject { return this.parent; }
	
	/* Accesses the `pivotX` property */
	public var pivotX(get, set):Float;
	private inline function get_pivotX():Float { return this.pivotX; }
	private inline function set_pivotX(value:Float):Float { return this.pivotX = value; }
	
	/* Accesses the `pivotY` property */
	public var pivotY(get, set):Float;
	private inline function get_pivotY():Float { return this.pivotY; }
	private inline function set_pivotY(value:Float):Float { return this.pivotY = value; }
	
	/* Accesses the `requiresRedraw` property */
	public var requiresRedraw(get, never):Bool;
	private inline function get_requiresRedraw():Bool { return this.requiresRedraw; }
	
	/* Accesses the `root` property */
	public var root(get, never):DisplayObject;
	private inline function get_root():DisplayObject { return this.root; }
	
	/* Accesses the `rotation` property */
	public var rotation(get, set):Float;
	private inline function get_rotation():Float { return this.rotation; }
	private inline function set_rotation(value:Float):Float { return this.rotation = value; }
	
	/* Accesses the `scale` property */
	public var scale(get, set):Float;
	private inline function get_scale():Float { return this.scale; }
	private inline function set_scale(value:Float):Float { return this.scale = value; }
	
	/* Accesses the `scaleX` property */
	public var scaleX(get, set):Float;
	private inline function get_scaleX():Float { return this.scaleX; }
	private inline function set_scaleX(value:Float):Float { return this.scaleX = value; }
	
	/* Accesses the `scaleY` property */
	public var scaleY(get, set):Float;
	private inline function get_scaleY():Float { return this.scaleY; }
	private inline function set_scaleY(value:Float):Float { return this.scaleY = value; }
	
	/* Accesses the `skewX` property */
	public var skewX(get, set):Float;
	private inline function get_skewX():Float { return this.skewX; }
	private inline function set_skewX(value:Float):Float { return this.skewX = value; }
	
	/* Accesses the `skewY` property */
	public var skewY(get, set):Float;
	private inline function get_skewY():Float { return this.skewY; }
	private inline function set_skewY(value:Float):Float { return this.skewY = value; }
	
	/* Accesses the `stage` property */
	public var stage(get, never):Stage;
	private inline function get_stage():Stage { return this.stage; }
	
	/* Accesses the `touchable` property */
	public var touchable(get, set):Bool;
	private inline function get_touchable():Bool { return this.touchable; }
	private inline function set_touchable(value:Bool):Bool { return this.touchable = value; }
	
	/* Accesses the `transformationMatrix` property */
	public var transformationMatrix(get, set):Matrix;
	private inline function get_transformationMatrix():Matrix { return this.transformationMatrix; }
	private inline function set_transformationMatrix(value:Matrix):Matrix { return this.transformationMatrix = value; }
	
	/* Accesses the `transformationMatrix3D` property */
	public var transformationMatrix3D(get, never):Matrix3D;
	private inline function get_transformationMatrix3D():Matrix3D { return this.transformationMatrix3D; }
	
	/* Accesses the `useHandCursor` property. */
	public var useHandCursor(get, set):Bool;
	private inline function get_useHandCursor():Bool { return this.useHandCursor; }
	private inline function set_useHandCursor(value:Bool):Bool { return this.useHandCursor = value; }
	
	/* Accesses the `visible` property */
	public var visible(get, set):Bool;
	private inline function get_visible():Bool { return this.visible; }
	private inline function set_visible(value:Bool):Bool { return this.visible = value; }
	
	/* Accesses the `width` property */
	public var width(get, set):Float;
	private inline function get_width():Float { return this.width; }
	private inline function set_width(value:Float):Float { return this.width = value; }
	
	/* Accesses the `x` property */
	public var x(get, set):Float;
	private inline function get_x():Float { return this.x; }
	private inline function set_x(value:Float):Float { return this.x = value; }
	
	/* Accesses the `y` property */
	public var y(get, set):Float;
	private inline function get_y():Float { return this.y; }
	private inline function set_y(value:Float):Float { return this.y = value; }
	
	/* Moves the pivot point to a certain position within the local coordinate system of the object. */
	public function alignPivot(horizontalAlign:String = "center", verticalAlign:String = "center"):Void
	{
		this.alignPivot(horizontalAlign, verticalAlign);
	}
	
	/* Disposes all resources of the display object. */
	public function dispose():Void
	{
		this.dispose();
	}
	
	/* Draws the object into a BitmapData object. */
	public function drawToBitmapData(out:BitmapData = null, color:UInt = 0x0, alpha:Float = 0.0):BitmapData
	{
		return this.drawToBitmapData(out, color, alpha);
	}
	
	/* Returns a rectangle that completely encloses the object as it appears in another coordinate system. */
	public function getBounds(targetSpace:DisplayObject, out:Rectangle = null):Rectangle
	{
		return this.getBounds(targetSpace, out);
	}
	
	/* Creates a matrix that represents the transformation from the local coordinate system to another. */
	public function getTransformationMatrix(targetSpace:DisplayObject, out:Matrix = null):Matrix
	{
		return this.getTransformationMatrix(targetSpace, out);
	}
	
	/* Creates a matrix that represents the transformation from the local coordinate system to another. */
	public function getTransformationMatrix3D(targetSpace:DisplayObject, out:Matrix3D = null):Matrix3D
	{
		return this.getTransformationMatrix3D(targetSpace, out);
	}
	
	/* Transforms a point from global (stage) coordinates to the local coordinate system. */
	public function globalToLocal(globalPoint:Point, out:Point = null):Point
	{
		return this.globalToLocal(globalPoint, out);
	}
	
	/* Transforms a point from global (stage) coordinates to the 3D local coordinate system. */
	public function globalToLocal3D(globalPoint:Point, out:Vector3D = null):Vector3D
	{
		return this.globalToLocal3D(globalPoint, out);
	}
	
	/* Returns the object that is found topmost beneath a point in local coordinates, or null if the test fails. */
	public function hitTest(localPoint:Point):DisplayObject
	{
		return this.hitTest(localPoint);
	}
	
	/* Checks if a certain point is inside the display object's mask. */
	public function hitTestMask(localPoint:Point):Bool
	{
		return this.hitTestMask(localPoint);
	}
	
	/* Transforms a 3D point from the local coordinate system to global (stage) coordinates. */
	public function local3DToGlobal(localPoint:Vector3D, out:Point = null):Point
	{
		return this.local3DToGlobal(localPoint, out);
	}
	
	/* Transforms a point from the local coordinate system to global (stage) coordinates. */
	public function localToGlobal(localPoint:Point, out:Point = null):Point
	{
		return this.localToGlobal(localPoint, out);
	}
	
	/* Removes the object from its parent, if it has one, and optionally disposes it. */
	public function removeFromParent(dispose:Bool = false):Void
	{
		this.removeFromParent(dispose);
	}
	
	/* Renders the display object with the help of a painter object. */
	public function render(painter:Painter):Void
	{
		this.render(painter);
	}
	
	/* Forces the object to be redrawn in the next frame. */
	public function setRequiresRedraw():Void
	{
		this.setRequiresRedraw();
	}
	//################################################################################
	//\DisplayObject
	//################################################################################

	//################################################################################
	// DisplayObjectContainer
	//################################################################################
	/* Accesses the `numChildren` property (for DisplayObjectContainer instances only). */
	public var numChildren(get, never):Int;
	private inline function get_numChildren():Int { return cast(this, DisplayObjectContainer).numChildren; }
	
	/* Accesses the `touchGroup` property (for DisplayObjectContainer instances only). */
	public var touchGroup(get, set):Bool;
	private inline function get_touchGroup():Bool { return cast(this, DisplayObjectContainer).touchGroup; }
	private inline function set_touchGroup(value:Bool):Bool { return cast(this, DisplayObjectContainer).touchGroup = value; }
	
	/* Accesses the `addChild` method (for DisplayObjectContainer instances only). */
	public function addChild(child:DisplayObject):DisplayObject
	{
		return cast(this, DisplayObjectContainer).addChild(child);
	}
	
	/* Accesses the `addChildAt` method (for DisplayObjectContainer instances only). */
	public function addChildAt(child:DisplayObject, index:Int):DisplayObject
	{
		return cast(this, DisplayObjectContainer).addChildAt(child, index);
	}
	
	/* Accesses the `broadcastEvent` method (for DisplayObjectContainer instances only). */
	public function broadcastEvent(event:Event):Void
	{
		return cast(this, DisplayObjectContainer).broadcastEvent(event);
	}
	
	/* Accesses the `broadcastEventWith` method (for DisplayObjectContainer instances only). */
	public function broadcastEventWith(eventType:String, data:Dynamic = null):Void
	{
		return cast(this, DisplayObjectContainer).broadcastEventWith(eventType, data);
	}
	
	/* Accesses the `contains` method (for DisplayObjectContainer instances only). */
	public function contains(child:DisplayObject):Bool
	{
		return cast(this, DisplayObjectContainer).contains(child);
	}
	
	/* Accesses the `getChildAt` method (for DisplayObjectContainer instances only). */
	public function getChildAt(index:Int):DisplayObject
	{
		return cast(this, DisplayObjectContainer).getChildAt(index);
	}
	
	/* Accesses the `getChildByName` method (for DisplayObjectContainer instances only). */
	public function getChildByName(name:String):DisplayObject
	{
		return cast(this, DisplayObjectContainer).getChildByName(name);
	}
	
	/* Accesses the `getChildIndex` method (for DisplayObjectContainer instances only). */
	public function getChildIndex(child:DisplayObject):Int
	{
		return cast(this, DisplayObjectContainer).getChildIndex(child);
	}
	
	/* Accesses the `removeChild` method (for DisplayObjectContainer instances only). */
	public function removeChild(child:DisplayObject, dispose:Bool = false):DisplayObject
	{
		return cast(this, DisplayObjectContainer).removeChild(child, dispose);
	}
	
	/* Accesses the `removeChildAt` method (for DisplayObjectContainer instances only). */
	public function removeChildAt(index:Int, dispose:Bool = false):DisplayObject
	{
		return cast(this, DisplayObjectContainer).removeChildAt(index, dispose);
	}
	
	/* Accesses the `removeChildren` method (for DisplayObjectContainer instances only). */
	public function removeChildren(beginIndex:Int = 0, endIndex:Int = -1, dispose:Bool = false):Void
	{
		cast(this, DisplayObjectContainer).removeChildren(beginIndex, endIndex, dispose);
	}
	
	/* Accesses the `setChildIndex` method (for DisplayObjectContainer instances only). */
	public function setChildIndex(child:DisplayObject, index:Int):Void
	{
		cast(this, DisplayObjectContainer).setChildIndex(child, index);
	}
	
	/* Accesses the `sortChildren` method (for DisplayObjectContainer instances only). */
	public function sortChildren(compareFunction:DisplayObject->DisplayObject->Int):Void
	{
		cast(this, DisplayObjectContainer).sortChildren(compareFunction);
	}
	
	/* Accesses the `swapChildren` method (for DisplayObjectContainer instances only). */
	public function swapChildren(child1:DisplayObject, child2:DisplayObject):Void
	{
		cast(this, DisplayObjectContainer).swapChildren(child1, child2);
	}
	
	/* Accesses the `swapChildrenAt` method (for DisplayObjectContainer instances only). */
	public function swapChildrenAt(index1:Int, index2:Int):Void
	{
		cast(this, DisplayObjectContainer).swapChildrenAt(index1, index2);
	}
	//################################################################################
	//\DisplayObjectContainer
	//################################################################################
	
	//################################################################################
	// EventDispatcher
	//################################################################################
	/* Registers an event listener at a certain object. */
    public function addEventListener(type:String, listener:Function):Void
	{
		this.addEventListener(type, listener);
	}
	
	/* Dispatches an event to all objects that have registered listeners for its type. */
	public function dispatchEvent(event:Event):Void
	{
		this.dispatchEvent(event);
	}
	
	/* Dispatches an event with the given parameters to all objects that have registered listeners for the given type. */
	public function dispatchEventWith(type:String, bubbles:Bool = false, data:Dynamic = null):Void
	{
		this.dispatchEventWith(type, bubbles, data);
	}
	
	/* If called with one argument, figures out if there are any listeners registered for the given event type. */
	public function hasEventListener(type:String, listener:Function = null):Bool
	{
		return this.hasEventListener(type, listener);
	}
	
	/* Removes an event listener from the object. */
	public function removeEventListener(type:String, listener:Function):Void
	{
		this.removeEventListener(type, listener);
	}
	
	/* Removes all event listeners with a certain type, or all of them if type is null. */
	public function removeEventListeners(type:String = null):Void
	{
		this.removeEventListeners(type);
	}
	//################################################################################
	//\EventDispatcher
	//################################################################################
	
	//################################################################################
	// Image
	//################################################################################
	/* Accesses the `scale9Grid` property (for Image and Button instances only). */
	public var scale9Grid(get, set):Rectangle;
	private inline function get_scale9Grid():Rectangle
	{
		if (#if (haxe_ver >= 4.2) Std.isOfType #else Std.is #end (this, Image))
		{
			return cast(this, Image).scale9Grid;
		}
		else if (#if (haxe_ver >= 4.2) Std.isOfType #else Std.is #end (this, Button))
		{
			return cast(this, Button).scale9Grid;
		}
		else
		{
			throw new TypeError("object reference must be an Image or Button instance");
		}
	}
	private inline function set_scale9Grid(value:Rectangle):Rectangle { return cast(this, Image).scale9Grid = value; }
	
	/* Accesses the `tileGrid` property (for Image instances only). */
	public var tileGrid(get, set):Rectangle;
	private inline function get_tileGrid():Rectangle { return cast(this, Image).tileGrid; }
	private inline function set_tileGrid(value:Rectangle):Rectangle { return cast(this, Image).tileGrid = value; }
	//################################################################################
	//\Image
	//################################################################################
	
	//################################################################################
	// Mesh
	//################################################################################
	/* Accesses the `color` property (for Mesh and Button instances only). */
	public var color(get, set):UInt;
	private inline function get_color():UInt 
	{
		if (#if (haxe_ver >= 4.2) Std.isOfType #else Std.is #end (this, Mesh))
		{
			return cast(this, Mesh).color;
		}
		else if (#if (haxe_ver >= 4.2) Std.isOfType #else Std.is #end (this, Button))
		{
			return cast(this, Button).color;
		}
		else
		{
			throw new TypeError("object reference must be a Mesh or Button instance");
		}
	}
	private inline function set_color(value:UInt):UInt 
	{
		if (#if (haxe_ver >= 4.2) Std.isOfType #else Std.is #end (this, Mesh))
		{
			return cast(this, Mesh).color = value;
		}
		else if (#if (haxe_ver >= 4.2) Std.isOfType #else Std.is #end (this, Button))
		{
			return cast(this, Button).color = value;
		}
		else
		{
			throw new TypeError("object reference must be a Mesh or Button instance");
		}
	}
	
	/* Accesses the `numIndices` property (for Mesh instances only). */
	public var numIndices(get, never):Int;
	private inline function get_numIndices():Int { return cast(this, Mesh).numIndices; }
	
	/* Accesses the `numTriangles` property (for Mesh instances only). */
	public var numTriangles(get, never):Int;
	private inline function get_numTriangles():Int { return cast(this, Mesh).numTriangles; }
	
	/* Accesses the `numVertices` property (for Mesh instances only). */
	public var numVertices(get, never):Int;
	private inline function get_numVertices():Int { return cast(this, Mesh).numVertices; }
	
	/* Accesses the `pixelSnapping` property (for Mesh, Button and TextField instances only). */
	public var pixelSnapping(get, set):Bool;
	private inline function get_pixelSnapping():Bool 
	{
		if (#if (haxe_ver >= 4.2) Std.isOfType #else Std.is #end (this, Mesh))
		{
			return cast(this, Mesh).pixelSnapping;
		}
		else if (#if (haxe_ver >= 4.2) Std.isOfType #else Std.is #end (this, Button))
		{
			return cast(this, Button).pixelSnapping;
		}
		else if (#if (haxe_ver >= 4.2) Std.isOfType #else Std.is #end (this, TextField))
		{
			return cast(this, TextField).pixelSnapping;
		}
		else
		{
			throw new TypeError("object reference must be a Mesh, Button or TextField instance");
		}
	}
	private inline function set_pixelSnapping(value:Bool):Bool
	{
		if (#if (haxe_ver >= 4.2) Std.isOfType #else Std.is #end (this, Mesh))
		{
			return cast(this, Mesh).pixelSnapping = value;
		}
		else if (#if (haxe_ver >= 4.2) Std.isOfType #else Std.is #end (this, Button))
		{
			return cast(this, Button).pixelSnapping = value;
		}
		else if (#if (haxe_ver >= 4.2) Std.isOfType #else Std.is #end (this, TextField))
		{
			return cast(this, TextField).pixelSnapping = value;
		}
		else
		{
			throw new TypeError("object reference must be a Mesh, Button or TextField instance");
		}
	}
	
	/* Accesses the `style` property (for Mesh, Button and TextField instances only). */
	public var style(get, set):MeshStyle;
	private inline function get_style():MeshStyle
	{
		if (#if (haxe_ver >= 4.2) Std.isOfType #else Std.is #end (this, Mesh))
		{
			return cast(this, Mesh).style;
		}
		else if (#if (haxe_ver >= 4.2) Std.isOfType #else Std.is #end (this, Button))
		{
			return cast(this, Button).style;
		}
		else if (#if (haxe_ver >= 4.2) Std.isOfType #else Std.is #end (this, TextField))
		{
			return cast(this, TextField).style;
		}
		else
		{
			throw new TypeError("object reference must be a Mesh or Button instance");
		}
	}
	private inline function set_style(value:MeshStyle):MeshStyle
	{
		if (#if (haxe_ver >= 4.2) Std.isOfType #else Std.is #end (this, Mesh))
		{
			return cast(this, Mesh).style = value;
		}
		else if (#if (haxe_ver >= 4.2) Std.isOfType #else Std.is #end (this, Mesh))
		{
			return cast(this, Button).style = value;
		}
		else if (#if (haxe_ver >= 4.2) Std.isOfType #else Std.is #end (this, TextField))
		{
			return cast(this, TextField).style = value;
		}
		else
		{
			throw new TypeError("object reference must be a Mesh or Button instance");
		}
	}
	
	/* Accesses the `texture` property (for Mesh instances only). */
	public var texture(get, set):Texture;
	private inline function get_texture():Texture { return cast(this, Mesh).texture; }
	private inline function set_texture(value:Texture):Texture { return cast(this, Mesh).texture = value; }
	
	/* Accesses the `textureRepeat` property (for Mesh instances only). */
	public var textureRepeat(get, set):Bool;
	private inline function get_textureRepeat():Bool { return cast(this, Mesh).textureRepeat; }
	private inline function set_textureRepeat(value:Bool):Bool { return cast(this, Mesh).textureRepeat = value; }
	
	/* Accesses the `textureSmoothing` property (for Mesh and Button instances only). */
	public var textureSmoothing(get, set):String;
	private inline function get_textureSmoothing():String
	{
		if (#if (haxe_ver >= 4.2) Std.isOfType #else Std.is #end (this, Mesh))
		{
			return cast(this, Mesh).textureSmoothing;
		}
		else if (#if (haxe_ver >= 4.2) Std.isOfType #else Std.is #end (this, Button))
		{
			return cast(this, Button).textureSmoothing;
		}
		else
		{
			throw new TypeError("object reference must be a Mesh or Button instance");
		}
	}
	private inline function set_textureSmoothing(value:String):String
	{
		if (#if (haxe_ver >= 4.2) Std.isOfType #else Std.is #end (this, Mesh))
		{
			return cast(this, Mesh).textureSmoothing = value;
		}
		else if (#if (haxe_ver >= 4.2) Std.isOfType #else Std.is #end (this, Button))
		{
			return cast(this, Button).textureSmoothing = value;
		}
		else
		{
			throw new TypeError("object reference must be a Mesh or Button instance");
		}
	}
	
	/* Accesses the `vertexFormat` property (for Mesh instances only). */
	public var vertexFormat(get, never):VertexDataFormat;
	private inline function get_vertexFormat():VertexDataFormat { return cast(this, Mesh).vertexFormat; }
	
	/* Accesses the `getTexCoords` method (for Mesh instances only). */
	public function getTexCoords(vertexID:Int, out:Point = null):Point
	{
		return cast(this, Mesh).getTexCoords(vertexID, out);
	}
	
	/* Accesses the `getVertexAlpha` method (for Mesh instances only). */
	public function getVertexAlpha(vertexID:Int):Float
	{
		return cast(this, Mesh).getVertexAlpha(vertexID);
	}
	
	/* Accesses the `getVertexColor` method (for Mesh instances only). */
	public function getVertexColor(vertexID:Int):UInt
	{
		return cast(this, Mesh).getVertexColor(vertexID);
	}
	
	/* Accesses the `getVertexPosition` method (for Mesh instances only). */
	public function getVertexPosition(vertexID:Int, out:Point = null):Point
	{
		return cast(this, Mesh).getVertexPosition(vertexID, out);
	}
	
	/* Accesses the `setIndexDataChanged` method (for Mesh instances only). */
	public function setIndexDataChanged():Void
	{
		cast(this, Mesh).setIndexDataChanged();
	}
	
	/* Accesses the `setStyle` method (for Mesh instances only). */
	public function setStyle(meshStyle:MeshStyle = null, mergeWithPredecessor:Bool = true):Void
	{
		cast(this, Mesh).setStyle(meshStyle, mergeWithPredecessor);
	}
	
	/* Accesses the `setTexCoords` method (for Mesh instances only). */
	public function setTexCoords(vertexID:Int, u:Float, v:Float):Void
	{
		cast(this, Mesh).setTexCoords(vertexID, u, v);
	}
	
	/* Accesses the `setVertexAlpha` method (for Mesh instances only). */
	public function setVertexAlpha(vertexID:Int, alpha:Float):Void
	{
		cast(this, Mesh).setVertexAlpha(vertexID, alpha);
	}
	
	/* Accesses the `setVertexColor` method (for Mesh instances only). */
	public function setVertexColor(vertexID:Int, color:UInt):Void
	{
		cast(this, Mesh).setVertexColor(vertexID, color);
	}
	
	/* Accesses the `setVertexDataChanged` method (for Mesh instances only). */
	public function setVertexDataChanged():Void
	{
		cast(this, Mesh).setVertexDataChanged();
	}
	
	/* Accesses the `setVertexPosition` method (for Mesh instances only). */
	public function setVertexPosition(vertexID:Int, x:Float, y:Float):Void
	{
		cast(this, Mesh).setVertexPosition(vertexID, x, y);
	}
	//################################################################################
	//\Mesh
	//################################################################################
	
	//################################################################################
	// MeshBatch
	//################################################################################
	/* Accesses the `batchable` property (for MeshBatch and TextField instances only). */
	public var batchable(get, set):Bool;
	private inline function get_batchable():Bool 
	{
		if (#if (haxe_ver >= 4.2) Std.isOfType #else Std.is #end (this, MeshBatch))
		{
			return cast(this, MeshBatch).batchable;
		}
		else if (#if (haxe_ver >= 4.2) Std.isOfType #else Std.is #end (this, TextField))
		{
			return cast(this, TextField).batchable;
		}
		else
		{
			throw new TypeError("object reference must be a MeshBatch or TextField instance");
		}
	}
	private inline function set_batchable(value:Bool):Bool
	{
		if (#if (haxe_ver >= 4.2) Std.isOfType #else Std.is #end (this, MeshBatch))
		{
			return cast(this, MeshBatch).batchable = value;
		}
		else if (#if (haxe_ver >= 4.2) Std.isOfType #else Std.is #end (this, TextField))
		{
			return cast(this, TextField).batchable = value;
		}
		else
		{
			throw new TypeError("object reference must be a MeshBatch or TextField instance");
		}
	}
	
	//private inline function set_numIndices(value:Int):Int { return cast(this, MeshBatch).numIndices = value; }
	
	//private inline function set_numVertices(value:Int):Int { return cast(this, MeshBatch).numVertices = value; }
	
	/* Accesses the `addMesh` method (for MeshBatch instances only). */
	public function addMesh(mesh:Mesh, matrix:Matrix, alpha:Float = 1.0, subset:MeshSubset = null,
							ignoreTransformations:Bool = false):Void
	{
		cast(this, MeshBatch).addMesh(mesh, matrix, alpha, subset, ignoreTransformations);
	}
	
	/* Accesses the `addMeshAt` method (for MeshBatch instances only). */
	public function addMeshAt(mesh:Mesh, indexID:Int = -1, vertexID:Int = -1, matrix:Matrix = null,
							  alpha:Float = 1.0, subset:MeshSubset, ignoreTransformations:Bool = false):Void
	{
		cast(this, MeshBatch).addMeshAt(mesh, indexID, vertexID, matrix, alpha, subset, ignoreTransformations);
	}
	
	/* Accesses the `canAddMesh` method (for MeshBatch instances only). */
	public function canAddMesh(mesh:Mesh, numVertices:Int = -1):Bool
	{
		return cast(this, MeshBatch).canAddMesh(mesh, numVertices);
	}
	
	/* Accesses the `clear` method (for MeshBatch and Canvas instances only). */
	public function clear():Void
	{
		if (#if (haxe_ver >= 4.2) Std.isOfType #else Std.is #end (this, MeshBatch))
		{
			cast(this, MeshBatch).clear();
		}
		else if (#if (haxe_ver >= 4.2) Std.isOfType #else Std.is #end (this, Canvas))
		{
			cast(this, Canvas).clear();
		}
		else
		{
			throw new TypeError("object reference must be a MeshBatch or Canvas instance");
		}
	}
	//################################################################################
	//\MeshBatch
	//################################################################################
	
	//################################################################################
	// MovieClip
	//################################################################################
	/* Accesses the `currentFrame` property (for MovieClip instances only). */
	public var currentFrame(get, set):Int;
	private inline function get_currentFrame():Int { return cast(this, MovieClip).currentFrame; }
	private inline function set_currentFrame(value:Int):Int { return cast(this, MovieClip).currentFrame = value; }
	
	/* Accesses the `currentTime` property (for MovieClip instances only). */
	public var currentTime(get, set):Float;
	private inline function get_currentTime():Float { return cast(this, MovieClip).currentTime; }
	private inline function set_currentTime(value:Float):Float { return cast(this, MovieClip).currentTime = value; }
	
	/* Accesses the `fps` property (for MovieClip instances only). */
	public var fps(get, set):Float;
	private inline function get_fps():Float { return cast(this, MovieClip).fps; }
	private inline function set_fps(value:Float):Float { return cast(this, MovieClip).fps = value; }
	
	/* Accesses the `isComplete` property (for MovieClip instances only). */
	public var isComplete(get, never):Bool;
	private inline function get_isComplete():Bool { return cast(this, MovieClip).isComplete; }
	
	/* Accesses the `isPlaying` property (for MovieClip instances only). */
	public var isPlaying(get, never):Bool;
	private inline function get_isPlaying():Bool { return cast(this, MovieClip).isPlaying; }
	
	/* Accesses the `color` property (for MovieClip instances only). */
	public var loop(get, set):Bool;
	private inline function get_loop():Bool { return cast(this, MovieClip).loop; }
	private inline function set_loop(value:Bool):Bool { return cast(this, MovieClip).loop = value; }
	
	/* Accesses the `muted` property (for MovieClip instances only). */
	public var muted(get, set):Bool;
	private inline function get_muted():Bool { return cast(this, MovieClip).muted; }
	private inline function set_muted(value:Bool):Bool { return cast(this, MovieClip).muted; }
	
	/* Accesses the `numFrames` property (for MovieClip instances only). */
	public var numFrames(get, never):Int;
	private inline function get_numFrames():Int { return cast(this, MovieClip).numFrames; }
	
	/* Accesses the `soundTransform` property (for MovieClip instances only). */
	public var soundTransform(get, set):SoundTransform;
	private inline function get_soundTransform():SoundTransform { return cast(this, MovieClip).soundTransform; }
	private inline function set_soundTransform(value:SoundTransform):SoundTransform { return cast(this, MovieClip).soundTransform; }
	
	/* Accesses the `totalTime` property (for MovieClip instances only). */
	public var totalTime(get, never):Float;
	private inline function get_totalTime():Float { return cast(this, MovieClip).totalTime; }
	
	/* Accesses the `addFrame` method (for MovieClip instances only). */
	public function addFrame(texture:Texture, sound:Sound = null, duration:Float = -1):Void
	{
		cast(this, MovieClip).addFrame(texture, sound, duration);
	}
	
	/* Accesses the `addFrameAt` method (for MovieClip instances only). */
	public function addFrameAt(frameID:Int, texture:Texture, sound:Sound = null, duration:Float = -1):Void
	{
		cast(this, MovieClip).addFrameAt(frameID, texture, sound, duration);
	}
	
	/* Accesses the `advanceTime` method (for MovieClip instances only). */
	public function advanceTime(passedTime:Float):Void
	{
		cast(this, MovieClip).advanceTime(passedTime);
	}
	
	/* Accesses the `getFrameAction` method (for MovieClip instances only). */
	public function getFrameAction(frameID:Int):Function
	{
		return cast(this, MovieClip).getFrameAction(frameID);
	}
	
	/* Accesses the `getFrameDuration` method (for MovieClip instances only). */
	public function getFrameDuration(frameID:Int):Float
	{
		return cast(this, MovieClip).getFrameDuration(frameID);
	}
	
	/* Accesses the `getFrameSound` method (for MovieClip instances only). */
	public function getFrameSound(frameID:Int):Sound
	{
		return cast(this, MovieClip).getFrameSound(frameID);
	}
	
	/* Accesses the `getFrameTexture` method (for MovieClip instances only). */
	public function getFrameTexture(frameID:Int):Texture
	{
		return cast(this, MovieClip).getFrameTexture(frameID);
	}
	
	/* Accesses the `pause` method (for MovieClip instances only). */
	public function pause():Void
	{
		cast(this, MovieClip).pause();
	}
	
	/* Accesses the `play` method (for MovieClip instances only). */
	public function play():Void
	{
		cast(this, MovieClip).play();
	}
	
	/* Accesses the `removeFrameAt` method (for MovieClip instances only). */
	public function removeFrameAt(frameID:Int):Void
	{
		cast(this, MovieClip).removeFrameAt(frameID);
	}
	
	/* Accesses the `reverseFrames` method (for MovieClip instances only). */
	public function reverseFrames():Void
	{
		cast(this, MovieClip).reverseFrames();
	}
	
	/* Accesses the `setFrameAction` method (for MovieClip instances only). */
	public function setFrameAction(frameID:Int, action:Function):Void
	{
		cast(this, MovieClip).setFrameAction(frameID, action);
	}
	
	/* Accesses the `setFrameDuration` method (for MovieClip instances only). */
	public function setFrameDuration(frameID:Int, duration:Float):Void
	{
		cast(this, MovieClip).setFrameDuration(frameID, duration);
	}
	
	/* Accesses the `setFrameSound` method (for MovieClip instances only). */
	public function setFrameSound(frameID:Int, sound:Sound):Void
	{
		cast(this, MovieClip).setFrameSound(frameID, sound);
	}
	
	/* Accesses the `setFrameTexture` method (for MovieClip instances only). */
	public function setFrameTexture(frameID:Int, texture:Texture):Void
	{
		cast(this, MovieClip).setFrameTexture(frameID, texture);
	}
	
	/* Accesses the `stop` method (for MovieClip instances only). */
	public function stop():Void
	{
		cast(this, MovieClip).stop();
	}
	//################################################################################
	//\MovieClip
	//################################################################################
	
	//################################################################################
	// Quad
	//################################################################################
	/* Accesses the `readjustSize` method (for Quad instances only). */
	public function readjustSize(width:Float = -1, height:Float = -1):Void
	{
		cast(this, Quad).readjustSize(width, height);
	}
	//################################################################################
	//\Quad
	//################################################################################
	
	//################################################################################
	// Sprite3D
	//################################################################################
	/* Accesses the `isFlat` property (for Sprite3D instances only). */
	public var isFlat(get, never):Bool;
	private inline function get_isFlat():Bool { return cast(this, Sprite3D).isFlat; }
	
	/* Accesses the `pivotZ` property (for Sprite3D instances only). */
	public var pivotZ(get, set):Float;
	private inline function get_pivotZ():Float { return cast(this, Sprite3D).pivotZ; }
	private inline function set_pivotZ(value:Float):Float { return cast(this, Sprite3D).pivotZ = value; }
	
	/* Accesses the `rotationX` property (for Sprite3D instances only). */
	public var rotationX(get, set):Float;
	private inline function get_rotationX():Float { return cast(this, Sprite3D).rotationX; }
	private inline function set_rotationX(value:Float):Float { return cast(this, Sprite3D).rotationX = value; }
	
	/* Accesses the `rotationY` property (for Sprite3D instances only). */
	public var rotationY(get, set):Float;
	private inline function get_rotationY():Float { return cast(this, Sprite3D).rotationY; }
	private inline function set_rotationY(value:Float):Float { return cast(this, Sprite3D).rotationY = value; }
	
	/* Accesses the `rotationZ` property (for Sprite3D instances only). */
	public var rotationZ(get, set):Float;
	private inline function get_rotationZ():Float { return cast(this, Sprite3D).rotationZ; }
	private inline function set_rotationZ(value:Float):Float { return cast(this, Sprite3D).rotationZ = value; }
	
	/* Accesses the `scaleZ` property (for Sprite3D instances only). */
	public var scaleZ(get, set):Float;
	private inline function get_scaleZ():Float { return cast(this, Sprite3D).scaleZ; }
	private inline function set_scaleZ(value:Float):Float { return cast(this, Sprite3D).scaleZ = value; }
	
	/* Accesses the `z` property (for Sprite3D instances only). */
	public var z(get, set):Float;
	private inline function get_z():Float { return cast(this, Sprite3D).z; }
	private inline function set_z(value:Float):Float { return cast(this, Sprite3D).z = value; }
	//################################################################################
	//\Sprite3D
	//################################################################################
	
	//################################################################################
	// TextField
	//################################################################################
	/* Accesses the `autoScale` property (for Sprite3D instances only). */
	public var autoScale(get, set):Bool;
	private inline function get_autoScale():Bool { return cast(this, TextField).autoScale; }
	private inline function set_autoScale(value:Bool):Bool { return cast(this, TextField).autoScale = value; }
	
	/* Accesses the `autoSize` property (for Sprite3D instances only). */
	public var autoSize(get, set):String;
	private inline function get_autoSize():String { return cast(this, TextField).autoSize; }
	private inline function set_autoSize(value:String):String { return cast(this, TextField).autoSize = value; }
	
	/* Accesses the `border` property (for Sprite3D instances only). */
	public var border(get, set):Bool;
	private inline function get_border():Bool { return cast(this, TextField).border; }
	private inline function set_border(value:Bool):Bool { return cast(this, TextField).border = value; }
	
	/* Accesses the `format` property (for Sprite3D instances only). */
	public var format(get, set):TextFormat;
	private inline function get_format():TextFormat { return cast(this, TextField).format; }
	private inline function set_format(value:TextFormat):TextFormat { return cast(this, TextField).format = value; }
	
	/* Accesses the `isHtmlText` property (for Sprite3D instances only). */
	public var isHtmlText(get, set):Bool;
	private inline function get_isHtmlText():Bool { return cast(this, TextField).isHtmlText; }
	private inline function set_isHtmlText(value:Bool):Bool { return cast(this, TextField).isHtmlText = value; }
	
	/* Accesses the `padding` property (for Sprite3D instances only). */
	public var padding(get, set):Float;
	private inline function get_padding():Float { return cast(this, TextField).padding; }
	private inline function set_padding(value:Float):Float { return cast(this, TextField).padding = value; }
	
	#if flash
	/* Accesses the `styleSheet` property (for Sprite3D instances only). */
	public var styleSheet(get, set):StyleSheet;
	private inline function get_styleSheet():StyleSheet { return cast(this, TextField).styleSheet; }
	private inline function set_styleSheet(value:StyleSheet):StyleSheet { return cast(this, TextField).styleSheet = value; }
	#end
	
	/* Accesses the `text` property (for TextField and Button instances only). */
	public var text(get, set):String;
	private inline function get_text():String
	{
		if (#if (haxe_ver >= 4.2) Std.isOfType #else Std.is #end (this, TextField))
		{
			return cast(this, TextField).text;
		}
		else if (#if (haxe_ver >= 4.2) Std.isOfType #else Std.is #end (this, Button))
		{
			return cast(this, Button).text;
		}
		else
		{
			throw new TypeError("object reference must be a TextField or Button instance");
		}
	}
	private inline function set_text(value:String):String
	{
		if (#if (haxe_ver >= 4.2) Std.isOfType #else Std.is #end (this, TextField))
		{
			return cast(this, TextField).text = value;
		}
		else if (#if (haxe_ver >= 4.2) Std.isOfType #else Std.is #end (this, Button))
		{
			return cast(this, Button).text = value;
		}
		else
		{
			throw new TypeError("object reference must be a TextField or Button instance");
		}
	}
	
	/* Accesses the `textBounds` property (for TextField and Button instances only - read-only for TextField). */
	public var textBounds(get, set):Rectangle;
	private inline function get_textBounds():Rectangle
	{
		if (#if (haxe_ver >= 4.2) Std.isOfType #else Std.is #end (this, TextField))
		{
			return cast(this, TextField).textBounds;
		}
		else if (#if (haxe_ver >= 4.2) Std.isOfType #else Std.is #end (this, Button))
		{
			return cast(this, Button).textBounds;
		}
		else
		{
			throw new TypeError("object reference must be a TextField or Button instance");
		}
	}
	private inline function set_textBounds(value:Rectangle):Rectangle
	{
		if (#if (haxe_ver >= 4.2) Std.isOfType #else Std.is #end (this, Button))
		{
			return cast(this, Button).textBounds = value;
		}
		else
		{
			throw new TypeError("object reference must be a Button instance");
		}
	}
	
	public var wordWrap(get, set):Bool;
	private inline function get_wordWrap():Bool { return cast(this, TextField).wordWrap; }
	private inline function set_wordWrap(value:Bool):Bool { return cast(this, TextField).wordWrap = value; }
	
	/* Accesses the `getTextBounds` method (for TextField instances only). */
	public function getTextBounds(targetSpace:DisplayObject, out:Rectangle = null):Rectangle
	{
		return cast(this, TextField).getTextBounds(targetSpace, out);
	}
	
	/* Accesses the `setRequiresRecomposition` method (for Canvas instances only). */
	public function setRequiresRecomposition():Void
	{
		cast(this, TextField).setRequiresRecomposition();
	}
	//################################################################################
	//\TextField
	//################################################################################
	
	/**
		Creates a new ChildAccess abstract.
	**/
	public inline function new(displayObject:T)
	{
		this = displayObject;
	}
	
	/**
		Resolves a child DisplayObject by name (if this is an instance
		of DisplayObjectContainer) or otherwise will return `null`.
		@param childName The name of the desired child DisplayObject.
		@return The child DisplayObject, if available.
	**/
	@:op(a.b)
	@:arrayAccess
	@:noCompletion private function __resolve(childName:String):ChildAccess<DisplayObject>
	{
		if (this != null && #if (haxe_ver >= 4.2) Std.isOfType #else Std.is #end (this, DisplayObjectContainer))
		{
			var container:DisplayObjectContainer = cast this;
			return container.getChildByName(childName);
		}
		return null;
	}
	
	@:to private static inline function __toButton(value:ChildAccess<Dynamic>):Button
	{
		if (value != null && !#if (haxe_ver >= 4.2) Std.isOfType #else Std.is #end (value, Button))
		{
			throw new TypeError("Cannot cast object reference to Button");
		}
		
		return cast value;
	}
	
	@:to private static inline function __toCanvas(value:ChildAccess<Dynamic>):Canvas
	{
		if (value != null && !#if (haxe_ver >= 4.2) Std.isOfType #else Std.is #end (value, Canvas))
		{
			throw new TypeError("Cannot cast object reference to Canvas");
		}
		
		return cast value;
	}
	
	@:to private static inline function __toDisplayObjectContainer(value:ChildAccess<Dynamic>):DisplayObjectContainer
	{
		if (value != null && !#if (haxe_ver >= 4.2) Std.isOfType #else Std.is #end (value, DisplayObjectContainer))
		{
			throw new TypeError("Cannot cast object reference to DisplayObjectContainer");
		}
		
		return cast value;
	}
	
	@:to private static inline function __toImage(value:ChildAccess<Dynamic>):Image
	{
		if (value != null && !#if (haxe_ver >= 4.2) Std.isOfType #else Std.is #end (value, Image))
		{
			throw new TypeError("Cannot cast object reference to Image");
		}
		
		return cast value;
	}
	
	@:to private static inline function __toMesh(value:ChildAccess<Dynamic>):Mesh
	{
		if (value != null && !#if (haxe_ver >= 4.2) Std.isOfType #else Std.is #end (value, Mesh))
		{
			throw new TypeError("Cannot cast object reference to Mesh");
		}
		
		return cast value;
	}
	
	@:to private static inline function __toMeshBatch(value:ChildAccess<Dynamic>):MeshBatch
	{
		if (value != null && !#if (haxe_ver >= 4.2) Std.isOfType #else Std.is #end (value, MeshBatch))
		{
			throw new TypeError("Cannot cast object reference to MeshBatch");
		}
		
		return cast value;
	}
	
	@:to private static inline function __toMovieClip(value:ChildAccess<Dynamic>):MovieClip
	{
		if (value != null && !#if (haxe_ver >= 4.2) Std.isOfType #else Std.is #end (value, MovieClip))
		{
			throw new TypeError("Cannot cast object reference to MovieClip");
		}
		
		return cast value;
	}
	
	@:to private static inline function __toQuad(value:ChildAccess<Dynamic>):Quad
	{
		if (value != null && !#if (haxe_ver >= 4.2) Std.isOfType #else Std.is #end (value, Quad))
		{
			throw new TypeError("Cannot cast object reference to Quad");
		}
		
		return cast value;
	}
	
	@:to private static inline function __toSprite(value:ChildAccess<Dynamic>):Sprite
	{
		if (value != null && !#if (haxe_ver >= 4.2) Std.isOfType #else Std.is #end (value, Sprite))
		{
			throw new TypeError("Cannot cast object reference to Sprite");
		}
		
		return cast value;
	}
	
	@:to private static inline function __toSprite3D(value:ChildAccess<Dynamic>):Sprite3D
	{
		if (value != null && !#if (haxe_ver >= 4.2) Std.isOfType #else Std.is #end (value, Sprite3D))
		{
			throw new TypeError("Cannot cast object reference to Sprite3D");
		}
		
		return cast value;
	}
	
	@:to private static inline function __toTextField(value:ChildAccess<Dynamic>):TextField
	{
		if (value != null && !#if (haxe_ver >= 4.2) Std.isOfType #else Std.is #end (value, TextField))
		{
			throw new TypeError("Cannot cast object reference to TextField");
		}
		
		return cast value;
	}
	
}
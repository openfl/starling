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

import openfl.geom.Rectangle;
import openfl.system.System;

import starling.display.DisplayObject;
import starling.display.Quad;
import starling.display.Sprite;
import starling.events.EnterFrameEvent;
import starling.events.Event;
import starling.rendering.Painter;
import starling.styles.MeshStyle;
import starling.text.BitmapFont;
import starling.text.TextField;
import starling.utils.Align;
import starling.utils.MathUtil;

/** A small, lightweight box that displays the current framerate, memory consumption and
 *  the number of draw calls per frame. The display is updated automatically once per frame. */
class StatsDisplay extends Sprite
{
    private static inline var UPDATE_INTERVAL:Float = 0.5;
    private static inline var B_TO_MB:Float = 1.0 / (1024 * 1024); // convert from bytes to MB
    
    private var __background:Quad;
    private var __labels:TextField;
    private var __values:TextField;
    
    private var __frameCount:Int = 0;
    private var __totalTime:Float = 0;

    private var __fps:Float = 0;
    private var __memory:Float = 0;
    private var __gpuMemory:Float = 0;
    private var __drawCount:Int = 0;
    private var __skipCount:Int = 0;
	private var __showSkipped:Bool = false;
    
    #if commonjs
    private static function __init__ () {
        
        untyped Object.defineProperties (StatsDisplay.prototype, {
            "supportsGpuMem": { get: untyped __js__ ("function () { return this.get_supportsGpuMem (); }") },
            "drawCount": { get: untyped __js__ ("function () { return this.get_drawCount (); }"), set: untyped __js__ ("function (v) { return this.set_drawCount (v); }") },
            "fps": { get: untyped __js__ ("function () { return this.get_fps (); }"), set: untyped __js__ ("function (v) { return this.set_fps (v); }") },
            "memory": { get: untyped __js__ ("function () { return this.get_memory (); }"), set: untyped __js__ ("function (v) { return this.set_memory (v); }") },
            "gpuMemory": { get: untyped __js__ ("function () { return this.get_gpuMemory (); }"), set: untyped __js__ ("function (v) { return this.set_gpuMemory (v); }") },
			"showSkipped": { get: untyped __js__ ("function () { return this.get_showSkipped (); }"), set: untyped __js__ ("function (v) { return this.set_showSkipped (v); }") },
        });
        
    }
    #end
    
    /** Creates a new Statistics Box. */
    public function new()
    {
        super();

        var fontName:String = BitmapFont.MINI;
        var fontSize:Float = BitmapFont.NATIVE_SIZE;
        var fontColor:UInt  = 0xffffff;
        var width:Int    = 90;
        var height:Int   = 45;

        __labels = new TextField(width, height);
        __labels.format.setTo(fontName, fontSize, fontColor, Align.LEFT, Align.TOP);
        __labels.batchable = true;
        __labels.x = 2;

        __values = new TextField(width - 1, height, "");
        __values.format.setTo(fontName, fontSize, fontColor, Align.RIGHT, Align.TOP);
        __values.batchable = true;

        __background = new Quad(width, height, 0x0);
		updateLabels();

        // make sure that rendering takes 2 draw calls
        if (__background.style.type != MeshStyle) __background.style = new MeshStyle();
        if (__labels.style.type     != MeshStyle) __labels.style     = new MeshStyle();
        if (__values.style.type     != MeshStyle) __values.style     = new MeshStyle();

        addChild(__background);
        addChild(__labels);
        addChild(__values);
        
        addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
        addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
    }
    
    private function onAddedToStage(e:Event):Void
    {
        addEventListener(Event.ENTER_FRAME, onEnterFrame);
		Starling.current.addEventListener(Event.SKIP_FRAME, onSkipFrame);
        __totalTime = __frameCount = __skipCount = 0;
        update();
    }
    
    private function onRemovedFromStage(e:Event):Void
    {
        removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		Starling.current.removeEventListener(Event.SKIP_FRAME, onSkipFrame);
    }
    
    private function onEnterFrame(e:Event):Void
    {
        var event:EnterFrameEvent = cast(e, EnterFrameEvent);
        __totalTime += event.passedTime;
        __frameCount++;
        
        if (__totalTime > UPDATE_INTERVAL)
        {
            update();
            __frameCount = __skipCount = 0;
            __totalTime = 0;
        }
    }
	
	private function onSkipFrame():Void
	{
		__skipCount += 1;
	}
    
    /** Updates the displayed values. */
    public function update():Void
    {
        __background.color = __skipCount > __frameCount / 2 ? 0x003F00 : 0x0;
        __fps = __totalTime > 0 ? __frameCount / __totalTime : 0;
        __memory = System.totalMemory * B_TO_MB;
        #if flash
        __gpuMemory = supportsGpuMem ? Reflect.field(Starling.current.context, "totalGPUMemory") * B_TO_MB : -1;
        #else
        __gpuMemory = supportsGpuMem ? Starling.current.context.totalGPUMemory * B_TO_MB : -1;
        #end
		
		var skippedPerSec:Float = __totalTime > 0 ? __skipCount / __totalTime : 0;
        var skippedText:String = __showSkipped ? MathUtil.toFixed(skippedPerSec, skippedPerSec < 100 ? 1 : 0) : "";
        var fpsText:String = MathUtil.toFixed(__fps, __fps < 100 ? 1 : 0);
        var memText:String = MathUtil.toFixed(__memory, __memory < 100 ? 1 : 0);
        var gpuMemText:String = MathUtil.toFixed(__gpuMemory, __gpuMemory < 100 ? 1 : 0);
        var drwText:String = Std.string(__totalTime > 0 ? __drawCount - 2 : __drawCount); // ignore self
		
		__values.text = fpsText + "\n" + (__showSkipped ? skippedText + "\n" : "") +
            memText + "\n" + (__gpuMemory >= 0 ? gpuMemText + "\n" : "") + drwText;
    }

	private function updateLabels():Void
	{
		var labels:Array<String> = ["frames/sec:"];
		if (__showSkipped) labels.insert(labels.length, "skipped/sec:");
		labels.insert(labels.length, "std memory:");
		if (supportsGpuMem) labels.insert(labels.length, "gpu memory:");
		labels.insert(labels.length, "draw calls:");

		__labels.text = labels.join("\n");
		__background.height = __labels.textBounds.height + 4;
	}
    
    /** @private */
    @:noCompletion public override function render(painter:Painter):Void
    {
        // By calling 'finishQuadBatch' and 'excludeFromCache', we can make sure that the stats
        // display is always rendered with exactly two draw calls. That is taken into account
        // when showing the drawCount value (see 'ignore self' comment above)

        painter.excludeFromCache(this);
        painter.finishMeshBatch();
        super.render(painter);
    }
    
    /** @private */
    override public function getBounds(targetSpace:DisplayObject, out:Rectangle = null):Rectangle
    {
        return __background.getBounds(targetSpace, out);
    }

    /** Indicates if the current runtime supports the 'totalGPUMemory' API. */
    private var supportsGpuMem(get, never):Bool;
    private function get_supportsGpuMem():Bool
    {
        #if !display
        #if flash
        return Reflect.hasField(Starling.current.context, "totalGPUMemory");
        #else
        return Starling.current.context.totalGPUMemory != 0;
        #end
        #else
        return false;
        #end
    }
    
    /** The number of Stage3D draw calls per second. */
    public var drawCount(get, set):Int;
    private function get_drawCount():Int { return __drawCount; }
    private function set_drawCount(value:Int):Int { return __drawCount = value; }
    
    /** The current frames per second (updated twice per second). */
    public var fps(get, set):Float;
    private function get_fps():Float { return __fps; }
    private function set_fps(value:Float):Float { return __fps = value; }
    
    /** The currently required system memory in MB. */
    public var memory(get, set):Float;
    private function get_memory():Float { return __memory; }
    private function set_memory(value:Float):Float { return __memory = value; }
    
    /** The currently used graphics memory in MB. */
    public var gpuMemory(get, set):Float;
    private function get_gpuMemory():Float { return __gpuMemory; }
    private function set_gpuMemory(value:Float):Float { return __gpuMemory = value; }
	
	/** Indicates if the number of skipped frames should be shown. */
	public var showSkipped(get, set):Bool;
	private function get_showSkipped():Bool { return __showSkipped; }
	private function set_showSkipped(value:Bool):Bool
	{
		__showSkipped = value;
		updateLabels();
		update();
		return __showSkipped;
	}
}
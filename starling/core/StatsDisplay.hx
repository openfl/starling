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

import openfl.system.System;

import starling.display.BlendMode;
import starling.display.Quad;
import starling.display.Sprite;
import starling.events.EnterFrameEvent;
import starling.events.Event;
import starling.rendering.Painter;
import starling.styles.MeshStyle;
import starling.text.BitmapFont;
import starling.text.TextField;
import starling.utils.Align;

/** A small, lightweight box that displays the current framerate, memory consumption and
 *  the number of draw calls per frame. The display is updated automatically once per frame. */
class StatsDisplay extends Sprite
{
    private static inline var UPDATE_INTERVAL:Float = 0.5;
    private static inline var B_TO_MB:Float = 1.0 / (1024 * 1024);
    
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
    
    /** Creates a new Statistics Box. */
    public function new()
    {
        super();
        
        var fontName:String = BitmapFont.MINI;
        var fontSize:Number = BitmapFont.NATIVE_SIZE;
        var fontColor:UInt  = 0xffffff;
        var width:Number    = 90;
        var height:Number   = supportsGpuMem ? 35 : 27;
        var gpuLabel:String = supportsGpuMem ? "\ngpu memory:" : "";
        var labels:String   = "frames/sec:\nstd memory:" + gpuLabel + "\ndraw calls:";

        __labels = new TextField(width, height, labels);
        __labels.format.setTo(fontName, fontSize, fontColor, Align.LEFT);
        __labels.batchable = true;
        __labels.x = 2;

        __values = new TextField(width - 1, height, "");
        __values.format.setTo(fontName, fontSize, fontColor, Align.RIGHT);
        __values.batchable = true;

        __background = new Quad(width, height, 0x0);

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
        __totalTime = __frameCount = __skipCount = 0;
        update();
    }
    
    private function onRemovedFromStage(e:Event):Void
    {
        removeEventListener(Event.ENTER_FRAME, onEnterFrame);
    }
    
    private function onEnterFrame(e:Event):Void
    {
        var event:EnterFrameEvent = cast(e, EnterFrameEvent);
        __totalTime += event.passedTime;
        __frameCount++;
        
        if (__totalTime > UPDATE_INTERVAL)
        {
            update();
            __frameCount = __skipCount = __totalTime = 0;
        }
    }
    
    /** Updates the displayed values. */
    public function update():Void
    {
        __background.color = __skipCount > __frameCount / 2 ? 0x003F00 : 0x0;
        __fps = __totalTime > 0 ? __frameCount / __totalTime : 0;
        __memory = System.totalMemory * B_TO_MB;
        __gpuMemory = supportsGpuMem ? Reflect.field(Starling.context, totalGPUMemory) * B_TO_MB : -1;

        var fpsText:String = __fps < 100 ? Math.round(__fps * 10) / 10 : Math.round(__fps);
        var memText:String = __memory < 100 ? Math.round(__memory * 10) / 10 : Math.round(__memory);
        var gpuMemText:String = __gpuMemory < 100 ? Math.round(__gpuMemory * 10) / 10 : Math.round(__gpuMemory);
        var drwText:String = (__totalTime > 0 ? __drawCount-2 : __drawCount) // ignore self

        __values.text = fpsText + "\n" + memText + "\n" +
            (__gpuMemory >= 0 ? gpuMemText + "\n" : "") + drwText;
    }
    
    /** Call this once in every frame that can skip rendering because nothing changed. */
    public function markFrameAsSkipped():Void
    {
        __skipCount += 1;
    }
    
    public override function render(support:RenderSupport, parentAlpha:Float):Void
    {
        // By calling 'finishQuadBatch' and 'excludeFromCache', we can make sure that the stats
        // display is always rendered with exactly two draw calls. That is taken into account
        // when showing the drawCount value (see 'ignore self' comment above)

        painter.excludeFromCache(this);
        painter.finishMeshBatch();
        super.render(painter);
    }
    
    /** Indicates if the current runtime supports the 'totalGPUMemory' API. */
    private var supportsGpuMem(get, never):Bool;
    private function get_supportsGpuMem():Bool
    {
        #if flash
        return Reflect.hasField(Starling.context, "totalGPUMemory");
        #else
        return Starling.context.totalGPUMemory != 0;
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
}
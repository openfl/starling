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

@:jsRequire("starling/core/StatsDisplay", "default")

extern class StatsDisplay extends Sprite
{
    /** Creates a new Statistics Box. */
    public function new();
    
    /** Updates the displayed values. */
    public function update():Void;

    /** Call this once in every frame that can skip rendering because nothing changed. */
    public function markFrameAsSkipped():Void;
    
    /** The number of Stage3D draw calls per second. */
    public var drawCount(get, set):Int;
    private function get_drawCount():Int;
    private function set_drawCount(value:Int):Int;
    
    /** The current frames per second (updated twice per second). */
    public var fps(get, set):Float;
    private function get_fps():Float;
    private function set_fps(value:Float):Float;
    
    /** The currently required system memory in MB. */
    public var memory(get, set):Float;
    private function get_memory():Float;
    private function set_memory(value:Float):Float;
    
    /** The currently used graphics memory in MB. */
    public var gpuMemory(get, set):Float;
    private function get_gpuMemory():Float;
    private function set_gpuMemory(value:Float):Float;
}
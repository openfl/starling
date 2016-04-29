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
import flash.system.System;

import starling.display.BlendMode;
import starling.display.Quad;
import starling.display.Sprite;
import starling.events.EnterFrameEvent;
import starling.events.Event;
import starling.rendering.Painter;
import starling.text.BitmapFont;
import starling.text.TextField;
import starling.text.TextFormat;
import starling.utils.Align;

/** A small, lightweight box that displays the current framerate, memory consumption and
 *  the number of draw calls per frame. The display is updated automatically once per frame. */
class StatsDisplay extends Sprite
{
    private inline static var UPDATE_INTERVAL:Float = 0.5;
    
    private var _background:Quad;
    private var _textField:TextField;
    
    private var _frameCount:Int = 0;
    private var _totalTime:Float = 0;
    
    private var _fps:Float = 0;
    private var _memory:Float = 0;
    private var _drawCount:Int = 0;
    
    /** Creates a new Statistics Box. */
    public function new()
    {
        super();
        var format:TextFormat = new TextFormat(BitmapFont.MINI, BitmapFont.NATIVE_SIZE,
                0xffffff, Align.LEFT, Align.TOP);

        _background = new Quad(50, 25, 0x0);
        _textField = new TextField(48, 25, "", format);
        _textField.x = 2;

        addChild(_background);
        addChild(_textField);
        
        blendMode = BlendMode.NONE;
        
        addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
        addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
    }
    
    private function onAddedToStage():Void
    {
        addEventListener(Event.ENTER_FRAME, onEnterFrame);
        _totalTime = _frameCount = 0;
        update();
    }
    
    private function onRemovedFromStage():Void
    {
        removeEventListener(Event.ENTER_FRAME, onEnterFrame);
    }
    
    private function onEnterFrame(event:EnterFrameEvent):Void
    {
        _totalTime += event.passedTime;
        _frameCount++;
        
        if (_totalTime > UPDATE_INTERVAL)
        {
            update();
            _frameCount = 0;
            _totalTime = 0;
        }
    }
    
    /** Updates the displayed values. */
    public function update():Void
    {
        _fps = _totalTime > 0 ? _frameCount / _totalTime : 0;
        _memory = System.totalMemory * 0.000000954; // 1.0 / (1024*1024) to convert to MB
        
        #if 0
        _textField.text = "FPS: " + _fps.toFixed(_fps < 100 ? 1 : 0) +
                        "\nMEM: " + _memory.toFixed(_memory < 100 ? 1 : 0) +
                        "\nDRW: " + (_totalTime > 0 ? _drawCount - 2 : _drawCount); // ignore self
        #else
        _textField.text = "FPS: " + _fps +
                        "\nMEM: " + _memory +
                        "\nDRW: " + (_totalTime > 0 ? _drawCount - 2 : _drawCount);
        #end
    }
    
    public override function render(painter:Painter):Void
    {
        // By calling "finishQuadBatch" here, we can make sure that the stats display is
        // always rendered with exactly two draw calls. That is taken into account when showing
        // the drawCount value (see 'ignore self' comment above)

        painter.finishMeshBatch();
        super.render(painter);
    }
    
    /** The number of Stage3D draw calls per second. */
    public var drawCount(get, set):Int;
    @:noCompletion private function get_drawCount():Int { return _drawCount; }
    @:noCompletion private function set_drawCount(value:Int):Int { return _drawCount = value; }
    
    /** The current frames per second (updated twice per second). */
    public var fps(get, set):Float;
    @:noCompletion private function get_fps():Float { return _fps; }
    @:noCompletion private function set_fps(value:Float):Float { return _fps = value; }
    
    /** The currently required system memory in MB. */
    public var memory(get, set):Float;
    @:noCompletion private function get_memory():Float { return _memory; }
    @:noCompletion private function set_memory(value:Float):Float { return _memory = value; }
}
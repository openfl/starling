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
import starling.text.BitmapFont;
import starling.text.TextField;
import starling.utils.HAlign;
import starling.utils.VAlign;

/** A small, lightweight box that displays the current framerate, memory consumption and
 *  the number of draw calls per frame. The display is updated automatically once per frame. */
class StatsDisplay extends Sprite
{
    private inline static var UPDATE_INTERVAL:Float = 0.5;
    
    private var mBackground:Quad;
    private var mTextField:TextField;
    
    private var mFrameCount:Int = 0;
    private var mTotalTime:Float = 0;
    
    private var mFps:Float = 0;
    private var mMemory:Float = 0;
    private var mDrawCount:Int = 0;
    
    /** Creates a new Statistics Box. */
    public function new()
    {
        super();
        mBackground = new Quad(70, 45, 0x0);
        mTextField = new TextField(68, 45, "", "_sans", 12, 0xffffff);
        mTextField.x = 2;
        mTextField.hAlign = HAlign.LEFT;
        mTextField.vAlign = VAlign.TOP;
        
        addChild(mBackground);
        addChild(mTextField);
        
        blendMode = BlendMode.NONE;
        
        addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
        addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
    }
    
    private function onAddedToStage(e:Event):Void
    {
        addEventListener(Event.ENTER_FRAME, onEnterFrame);
        mTotalTime = mFrameCount = 0;
        update();
    }
    
    private function onRemovedFromStage(e:Event):Void
    {
        removeEventListener(Event.ENTER_FRAME, onEnterFrame);
    }
    
    private function onEnterFrame(e:Event):Void
    {
        var event:EnterFrameEvent = cast(e, EnterFrameEvent);
        mTotalTime += event.passedTime;
        mFrameCount++;
        
        if (mTotalTime > UPDATE_INTERVAL)
        {
            update();
            mFrameCount = Std.int(mTotalTime = 0);
        }
    }
    
    /** Updates the displayed values. */
    public function update():Void
    {
        mFps = mTotalTime > 0 ? mFrameCount / mTotalTime : 0;
        mMemory = System.totalMemory * 0.000000954; // 1.0 / (1024*1024) to convert to MB
        
        mTextField.text = "FPS: " + Math.round(mFps * 10) / 10 + 
                        "\nMEM: " + Math.round(mMemory * 10) / 10 +
                        "\nDRW: " + (mTotalTime > 0 ? mDrawCount-2 : mDrawCount); // ignore self 
    }
    
    public override function render(support:RenderSupport, parentAlpha:Float):Void
    {
        // The display should always be rendered with two draw calls, so that we can
        // always reduce the draw count by that number to get the number produced by the 
        // actual content.
        
        support.finishQuadBatch();
        super.render(support, parentAlpha);
    }
    
    /** The number of Stage3D draw calls per second. */
    public var drawCount(get, set):Int;
    private function get_drawCount():Int { return mDrawCount; }
    private function set_drawCount(value:Int):Int { return mDrawCount = value; }
    
    /** The current frames per second (updated twice per second). */
    public var fps(get, set):Float;
    private function get_fps():Float { return mFps; }
    private function set_fps(value:Float):Float { return mFps = value; }
    
    /** The currently required system memory in MB. */
    public var memory(get, set):Float;
    private function get_memory():Float { return mMemory; }
    private function set_memory(value:Float):Float { return mMemory = value; }
}
// =================================================================================================
//
//	Starling Framework
//	Copyright Gamua GmbH. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

package starling.core
{
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
internal class StatsDisplay extends Sprite
{
    private const UPDATE_INTERVAL:Float = 0.5;
    
    private var mBackground:Quad;
    private var mTextField:TextField;
    
    private var mFrameCount:Int = 0;
    private var mTotalTime:Float = 0;
    
    private var mFps:Float = 0;
    private var mMemory:Float = 0;
    private var mDrawCount:Int = 0;
    
    /** Creates a new Statistics Box. */
    public function StatsDisplay()
    {
        mBackground = new Quad(50, 25, 0x0);
        mTextField = new TextField(48, 25, "", BitmapFont.MINI, BitmapFont.NATIVE_SIZE, 0xffffff);
        mTextField.x = 2;
        mTextField.hAlign = HAlign.LEFT;
        mTextField.vAlign = VAlign.TOP;
        
        addChild(mBackground);
        addChild(mTextField);
        
        blendMode = BlendMode.NONE;
        
        addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
        addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
    }
    
    private function onAddedToStage():Void
    {
        addEventListener(Event.ENTER_FRAME, onEnterFrame);
        mTotalTime = mFrameCount = 0;
        update();
    }
    
    private function onRemovedFromStage():Void
    {
        removeEventListener(Event.ENTER_FRAME, onEnterFrame);
    }
    
    private function onEnterFrame(event:EnterFrameEvent):Void
    {
        mTotalTime += event.passedTime;
        mFrameCount++;
        
        if (mTotalTime > UPDATE_INTERVAL)
        {
            update();
            mFrameCount = mTotalTime = 0;
        }
    }
    
    /** Updates the displayed values. */
    public function update():Void
    {
        mFps = mTotalTime > 0 ? mFrameCount / mTotalTime : 0;
        mMemory = System.totalMemory * 0.000000954; // 1.0 / (1024*1024) to convert to MB
        
        mTextField.text = "FPS: " + mFps.toFixed(mFps < 100 ? 1 : 0) + 
                        "\nMEM: " + mMemory.toFixed(mMemory < 100 ? 1 : 0) +
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
    public function get drawCount():Int { return mDrawCount; }
    public function set drawCount(value:Int):Void { mDrawCount = value; }
    
    /** The current frames per second (updated twice per second). */
    public function get fps():Float { return mFps; }
    public function set fps(value:Float):Void { mFps = value; }
    
    /** The currently required system memory in MB. */
    public function get memory():Float { return mMemory; }
    public function set memory(value:Float):Void { mMemory = value; }
}
}
package scenes;
import flash.system.System;

import starling.core.Starling;
import starling.display.Button;
import starling.display.Image;
import starling.display.Sprite;
import starling.events.EnterFrameEvent;
import starling.events.Event;
import starling.text.TextField;
import starling.utils.StringUtil.formatString;

@:keep class BenchmarkScene extends Scene
{
    private var mStartButton:Button;
    private var mResultText:TextField;
    
    private var mContainer:Sprite;
    private var mFrameCount:Int;
    private var mElapsed:Float;
    private var mStarted:Bool;
    private var mFailCount:Int;
    private var mWaitFrames:Int;
    
    public function new()
    {
        super();
        
        // the container will hold all test objects
        mContainer = new Sprite();
        mContainer.touchable = false; // we do not need touch events on the test objects -- 
                                      // thus, it is more efficient to disable them.
        addChildAt(mContainer, 0);
        
        mStartButton = new Button(Game.assets.getTexture("button_normal"), "Start benchmark");
        mStartButton.addEventListener(Event.TRIGGERED, onStartButtonTriggered);
        mStartButton.x = Constants.CenterX - Std.int(mStartButton.width / 2);
        mStartButton.y = 20;
        addChild(mStartButton);
        
        mStarted = false;
        mElapsed = 0.0;
        
        addEventListener(Event.ENTER_FRAME, onEnterFrame);
    }
    
    public override function dispose():Void
    {
        removeEventListener(Event.ENTER_FRAME, onEnterFrame);
        mStartButton.removeEventListener(Event.TRIGGERED, onStartButtonTriggered);
        super.dispose();
    }
    
    private function onEnterFrame(event:EnterFrameEvent):Void
    {
        if (!mStarted) return;
        
        mElapsed += event.passedTime;
        mFrameCount++;
        
        if (mFrameCount % mWaitFrames == 0)
        {
            var fps:Float = mWaitFrames / mElapsed;
            var targetFps:Int = Std.int(Starling.current.nativeStage.frameRate);
            
            if (Math.ceil(fps) >= targetFps)
            {
                mFailCount = 0;
                addTestObjects();
            }
            else
            {
                mFailCount++;
                
                if (mFailCount > 20)
                    mWaitFrames = 5; // slow down creation process to be more exact
                if (mFailCount > 30)
                    mWaitFrames = 10;
                if (mFailCount == 40)
                    benchmarkComplete(); // target fps not reached for a while
            }
            
            mElapsed = mFrameCount = 0;
        }
        
        var numObjects:Int = mContainer.numChildren;
        var passedTime:Float = event.passedTime;
        
        //for (var i:Int=0; i<numObjects; ++i)
        for(i in 0 ... numObjects)
            mContainer.getChildAt(i).rotation += Math.PI / 2 * passedTime;
    }
    
    private function onStartButtonTriggered():Void
    {
        trace("Starting benchmark");
        
        mStartButton.visible = false;
        mStarted = true;
        mFailCount = 0;
        mWaitFrames = 2;
        mFrameCount = 0;
        
        if (mResultText != null) 
        {
            mResultText.removeFromParent(true);
            mResultText = null;
        }
        
        addTestObjects();
    }
    
    private function addTestObjects():Void
    {
        var padding:Int = 15;
        var numObjects:Int = mFailCount > 20 ? 2 : 10;
        
        //for (var i:Int = 0; i<numObjects; ++i)
        for(i in 0 ... numObjects)
        {
            var egg:Image = new Image(Game.assets.getTexture("benchmark_object"));
            egg.x = padding + Math.random() * (Constants.GameWidth - 2 * padding);
            egg.y = padding + Math.random() * (Constants.GameHeight - 2 * padding);
            mContainer.addChild(egg);
        }
    }
    
    private function benchmarkComplete():Void
    {
        mStarted = false;
        mStartButton.visible = true;
        
        var fps:Int = Std.int(Starling.current.nativeStage.frameRate);
        
        trace("Benchmark complete!");
        trace("FPS: " + fps);
        trace("Number of objects: " + mContainer.numChildren);
        
        var resultString:String = formatString("Result:\n{0} objects\nwith {1} fps",
                                               [mContainer.numChildren, fps]);
        mResultText = new TextField(240, 200, resultString);
        mResultText.fontSize = 30;
        mResultText.x = Constants.CenterX - mResultText.width / 2;
        mResultText.y = Constants.CenterY - mResultText.height / 2;
        
        addChild(mResultText);
        
        mContainer.removeChildren();
        #if 0
        System.pauseForGCIfCollectionImminent();
        #end
    }
    
    
}
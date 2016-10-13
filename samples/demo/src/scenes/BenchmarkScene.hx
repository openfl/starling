package scenes;
import starling.core.Starling;
import starling.display.Button;
import starling.display.DisplayObject;
import starling.display.Image;
import starling.display.Sprite;
import starling.events.EnterFrameEvent;
import starling.events.Event;
import starling.text.BitmapFont;
import starling.text.TextField;
import starling.textures.Texture;
import starling.utils.ArrayUtil;
import starling.utils.StringUtil.formatString;

@:keep class BenchmarkScene extends Scene
{
    private static inline var FRAME_TIME_WINDOW_SIZE:Int = 10;
    private static inline var MAX_FAIL_COUNT:Int = 100;

    private var mStartButton:Button;
    private var mResultText:TextField;
    private var mStatusText:TextField;
    private var mContainer:Sprite;
    private var mObjectPool:Array<DisplayObject>;
    private var mObjectTexture:Texture;

    private var mFrameCount:Int;
    private var mFailCount:Int;
    private var mStarted:Bool;
    private var mFrameTimes:Array<Float>;
    private var mTargetFps:Int;

    private var mPhase:Int;

    public function new()
    {
        super();

        // the container will hold all test objects
        mContainer = new Sprite();
        mContainer.x = Constants.CenterX;
        mContainer.y = Constants.CenterY;
        mContainer.touchable = false; // we do not need touch events on the test objects --
                                      // thus, it is more efficient to disable them.
        addChildAt(mContainer, 0);

        mStatusText = new TextField(Constants.GameWidth - 40, 30, "",
                "DejaVu Sans", 24);
        mStatusText.x = 20;
        mStatusText.y = 10;
        addChild(mStatusText);

        mStartButton = new Button(Game.assets.getTexture("button_normal"), "Start benchmark");
        mStartButton.fontName = "DejaVu Sans";
        mStartButton.addEventListener(Event.TRIGGERED, onStartButtonTriggered);
        mStartButton.x = Constants.CenterX - Std.int(mStartButton.width / 2);
        mStartButton.y = 20;
        addChild(mStartButton);
        
        mStarted = false;
        mFrameTimes = new Array<Float>();
        mObjectPool = new Array<DisplayObject>();
        mObjectTexture = Game.assets.getTexture("benchmark_object");

        addEventListener(Event.ENTER_FRAME, onEnterFrame);
    }
    
    public override function dispose():Void
    {
        removeEventListener(Event.ENTER_FRAME, onEnterFrame);
        mStartButton.removeEventListener(Event.TRIGGERED, onStartButtonTriggered);

        for (object in mObjectPool)
            object.dispose();

        super.dispose();
    }

    private function onStartButtonTriggered():Void
    {
        trace("Starting benchmark");

        mStartButton.visible = false;
        mStarted = true;
        mTargetFps = Std.int(Starling.current.nativeStage.frameRate);
        mFrameCount = 0;
        mFailCount = 0;
        mPhase = 0;

        for (i in 0...FRAME_TIME_WINDOW_SIZE)
            mFrameTimes[i] = 1.0 / mTargetFps;

        if (mResultText != null)
        {
            mResultText.removeFromParent(true);
            mResultText = null;
        }
    }

    private function onEnterFrame(event:EnterFrameEvent, passedTime:Float):Void
    {
        if (!mStarted) return;

        mFrameCount++;
        mContainer.rotation += event.passedTime * 0.5;
        mFrameTimes[FRAME_TIME_WINDOW_SIZE] = 0.0;

        for (i in 0...FRAME_TIME_WINDOW_SIZE)
            mFrameTimes[i] += passedTime;

        var measuredFps:Float = FRAME_TIME_WINDOW_SIZE / mFrameTimes.shift();

        if (mPhase == 0)
        {
            if (measuredFps < 0.985 * mTargetFps)
            {
                mFailCount++;

                if (mFailCount == MAX_FAIL_COUNT)
                    mPhase = 1;
            }
            else
            {
                addTestObjects(16);
                mContainer.scale *= 0.99;
                mFailCount = 0;
            }
        }
        if (mPhase == 1)
        {
            if (measuredFps > 0.99 * mTargetFps)
            {
                mFailCount--;

                if (mFailCount == 0)
                    benchmarkComplete();
            }
            else
            {
                removeTestObjects(1);
                mContainer.scale /= 0.9993720513; // 0.99 ^ (1/16)
            }
        }

        if (mFrameCount % Std.int(mTargetFps / 4) == 0)
            mStatusText.text = mContainer.numChildren + " objects";
    }

    private function addTestObjects(count:Int):Void
    {
        var scale:Float = 1.0 / mContainer.scale;

        for (i in 0...count)
        {
            var egg:DisplayObject = getObjectFromPool();
            var distance:Float = (100 + Math.random() * 100) * scale;
            var angle:Float = Math.random() * Math.PI * 2.0;

            egg.x = Math.cos(angle) * distance;
            egg.y = Math.sin(angle) * distance;
            egg.rotation = angle + Math.PI / 2.0;
            egg.scale = scale;

            mContainer.addChild(egg);
        }
    }

    private function removeTestObjects(count:Int):Void
    {
        var numChildren:Int = mContainer.numChildren;

        if (count >= numChildren)
            count  = numChildren;

        for (i in 0...count)
            putObjectToPool(mContainer.removeChildAt(mContainer.numChildren-1));
    }

    private function getObjectFromPool():DisplayObject
    {
        // we pool mainly to avoid any garbage collection while the benchmark is running

        if (mObjectPool.length == 0)
        {
            var image:Image = new Image(mObjectTexture);
            image.alignPivot();
            return image;
        }
        else
            return mObjectPool.pop();
    }

    private function putObjectToPool(object:DisplayObject):Void
    {
        mObjectPool[mObjectPool.length] = object;
    }

    private function benchmarkComplete():Void
    {
        mStarted = false;
        mStartButton.visible = true;
        
        var fps:Int = Std.int(Starling.current.nativeStage.frameRate);
        var numChildren:Int = mContainer.numChildren;
        var resultString:String = formatString("Result:\n{0} objects\nwith {1} fps",
                                               [numChildren, fps]);
        trace(~/\n/g.replace(resultString, " "));

        mResultText = new TextField(240, 200, resultString, "DejaVu Sans");
        mResultText.fontSize = 30;
        mResultText.x = Constants.CenterX - mResultText.width / 2;
        mResultText.y = Constants.CenterY - mResultText.height / 2;
        
        addChild(mResultText);

        mContainer.scale = 1.0;
        ArrayUtil.clear(mFrameTimes);
        mStatusText.text = "";

        var i:Int = numChildren - 1;
        while ( i >= 0 )
        {
            putObjectToPool(mContainer.removeChildAt(i));
            --i;
        }
    }
}
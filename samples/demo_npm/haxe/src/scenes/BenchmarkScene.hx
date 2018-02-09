package scenes;

import openfl.Vector;

import starling.core.Starling;
import starling.display.Button;
import starling.display.DisplayObject;
import starling.display.Image;
import starling.display.Sprite;
import starling.events.EnterFrameEvent;
import starling.events.Event;
import starling.text.BitmapFont;
import starling.text.TextField;
import starling.text.TextFormat;
import starling.textures.Texture;
// import starling.utils.ArrayUtil;
import starling.utils.StringUtil;

import utils.MenuButton;

@:keep class BenchmarkScene extends Scene
{
    private static inline var FRAME_TIME_WINDOW_SIZE:Int = 10;
    private static inline var MAX_FAIL_COUNT:Int = 100;

    private var _startButton:Button;
    private var _resultText:TextField;
    private var _statusText:TextField;
    private var _container:Sprite;
    private var _objectPool:Vector<DisplayObject>;
    private var _objectTexture:Texture;

    private var _frameCount:Int;
    private var _failCount:Int;
    private var _started:Bool;
    private var _frameTimes:Vector<Float>;
    private var _targetFps:Int;
    private var _phase:Int;

    public function new()
    {
        super();

        // the container will hold all test objects
        _container = new Sprite();
        _container.x = Constants.CenterX;
        _container.y = Constants.CenterY;
        _container.touchable = false; // we do not need touch events on the test objects --
                                      // thus, it is more efficient to disable them.
        addChildAt(_container, 0);

        _statusText = new TextField(Constants.GameWidth - 40, 30);
        _statusText.format = new TextFormat(BitmapFont.MINI, BitmapFont.NATIVE_SIZE * 2);
        _statusText.x = 20;
        _statusText.y = 10;
        addChild(_statusText);

        _startButton = new MenuButton("Start benchmark");
        _startButton.addEventListener(Event.TRIGGERED, onStartButtonTriggered);
        _startButton.x = Constants.CenterX - Std.int(_startButton.width / 2);
        _startButton.y = 20;
        addChild(_startButton);
        
        _started = false;
        _frameTimes = new Vector<Float>();
        _objectPool = new Vector<DisplayObject>();
        _objectTexture = Game.assets.getTexture("benchmark_object");

        addEventListener(Event.ENTER_FRAME, onEnterFrame);
    }
    
    public override function dispose():Void
    {
        removeEventListener(Event.ENTER_FRAME, onEnterFrame);
        _startButton.removeEventListener(Event.TRIGGERED, onStartButtonTriggered);

        for (object in _objectPool)
            object.dispose();

        super.dispose();
    }

    private function onStartButtonTriggered():Void
    {
        trace("Starting benchmark");

        _startButton.visible = false;
        _started = true;
        _targetFps = Std.int(Starling.current.nativeStage.frameRate);
        _frameCount = 0;
        _failCount = 0;
        _phase = 0;
        
        if (_targetFps <= 0) _targetFps = 60;

        for (i in 0...FRAME_TIME_WINDOW_SIZE)
            _frameTimes[i] = 1.0 / _targetFps;

        if (_resultText != null)
        {
            _resultText.removeFromParent(true);
            _resultText = null;
        }
    }

    private function onEnterFrame(event:EnterFrameEvent, passedTime:Float):Void
    {
        if (!_started) return;

        _frameCount++;
        _container.rotation += event.passedTime * 0.5;
        _frameTimes[FRAME_TIME_WINDOW_SIZE] = 0.0;

        for (i in 0...FRAME_TIME_WINDOW_SIZE)
            _frameTimes[i] += passedTime;

        var measuredFps:Float = FRAME_TIME_WINDOW_SIZE / _frameTimes.shift();

        if (_phase == 0)
        {
            if (measuredFps < 0.985 * _targetFps)
            {
                _failCount++;

                if (_failCount == MAX_FAIL_COUNT)
                    _phase = 1;
            }
            else
            {
                addTestObjects(16);
                _container.scale *= 0.99;
                _failCount = 0;
            }
        }
        if (_phase == 1)
        {
            if (measuredFps > 0.99 * _targetFps)
            {
                _failCount--;

                if (_failCount == 0)
                    benchmarkComplete();
            }
            else
            {
                removeTestObjects(1);
                _container.scale /= 0.9993720513; // 0.99 ^ (1/16)
            }
        }

        if (_frameCount % Std.int(_targetFps / 4) == 0)
            _statusText.text = _container.numChildren + " objects";
    }

    private function addTestObjects(count:Int):Void
    {
        var scale:Float = 1.0 / _container.scale;

        for (i in 0...count)
        {
            var egg:DisplayObject = getObjectFromPool();
            var distance:Float = (100 + Math.random() * 100) * scale;
            var angle:Float = Math.random() * Math.PI * 2.0;

            egg.x = Math.cos(angle) * distance;
            egg.y = Math.sin(angle) * distance;
            egg.rotation = angle + Math.PI / 2.0;
            egg.scale = scale;

            _container.addChild(egg);
        }
    }

    private function removeTestObjects(count:Int):Void
    {
        var numChildren:Int = _container.numChildren;

        if (count >= numChildren)
            count  = numChildren;

        for (i in 0...count)
            putObjectToPool(_container.removeChildAt(_container.numChildren-1));
    }

    private function getObjectFromPool():DisplayObject
    {
        // we pool mainly to avoid any garbage collection while the benchmark is running

        if (_objectPool.length == 0)
        {
            var image:Image = new Image(_objectTexture);
            image.alignPivot();
            image.pixelSnapping = false; // slightly faster (and doesn't work here, anyway)
            return image;
        }
        else
            return _objectPool.pop();
    }

    private function putObjectToPool(object:DisplayObject):Void
    {
        _objectPool[_objectPool.length] = object;
    }

    private function benchmarkComplete():Void
    {
        _started = false;
        _startButton.visible = true;
        
        var fps:Int = Std.int(Starling.current.nativeStage.frameRate);
        var numChildren:Int = _container.numChildren;
        var resultString:String = StringUtil.format("Result:\n{0} objects\nwith {1} fps",
                                               [numChildren, fps]);
        trace(~/\n/g.replace(resultString, " "));

        _resultText = new TextField(240, 200, resultString);
        _resultText.format.font = "DejaVu Sans";
        _resultText.format.size = 30;
        _resultText.x = Constants.CenterX - _resultText.width / 2;
        _resultText.y = Constants.CenterY - _resultText.height / 2;
        
        addChild(_resultText);

        _container.scale = 1.0;
        _frameTimes.length = 0;
        _statusText.text = "";

        var i:Int = numChildren - 1;
        while ( i >= 0 )
        {
            putObjectToPool(_container.removeChildAt(i));
            --i;
        }
    }
}
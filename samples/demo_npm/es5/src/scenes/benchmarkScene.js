'use strict';
var Vector = require ("openfl/Vector").default;

var Starling = require ("starling/core/Starling").default;
var Button = require ("starling/display/Button").default;
var DisplayObject = require ("starling/display/DisplayObject").default;
var Image = require ("starling/display/Image").default;
var Sprite = require ("starling/display/Sprite").default;
var EnterFrameEvent = require ("starling/events/EnterFrameEvent").default;
var Event = require ("starling/events/Event").default;
var BitmapFont = require ("starling/text/BitmapFont").default;
var TextField = require ("starling/text/TextField").default;
var TextFormat = require ("starling/text/TextFormat").default;
var Texture = require ("starling/textures/Texture").default;
var StringUtil = require ("starling/utils/StringUtil").default;

var MenuButton = require ("./../utils/menuButton").default;
var Constants = require ("./../constants").default;
var Game = require ("./../game").default;
var Scene = require ("./scene").default;

var BenchmarkScene = function()
{
    Scene.call(this);
    
    this.onStartButtonTriggered = this.onStartButtonTriggered.bind(this);
    this.onEnterFrame = this.onEnterFrame.bind(this);
    this.addTestObjects = this.addTestObjects.bind (this);

    // the container will hold all test objects
    this._container = new Sprite();
    this._container.x = Constants.CenterX;
    this._container.y = Constants.CenterY;
    this._container.touchable = false; // we do not need touch events on the test objects --
                                    // thus, it is more efficient to disable them.
    this.addChildAt(this._container, 0);

    this._statusText = new TextField(Constants.GameWidth - 40, 30);
    this._statusText.format = new TextFormat(BitmapFont.MINI, BitmapFont.NATIVE_SIZE * 2);
    this._statusText.x = 20;
    this._statusText.y = 10;
    this.addChild(this._statusText);

    this._startButton = new MenuButton("Start benchmark");
    this._startButton.addEventListener(Event.TRIGGERED, this.onStartButtonTriggered);
    this._startButton.x = Constants.CenterX - (this._startButton.width / 2);
    this._startButton.y = 20;
    this.addChild(this._startButton);
    
    this._started = false;
    this._frameTimes = new Vector();
    this._objectPool = new Vector();
    this._objectTexture = Game.assets.getTexture("benchmark_object");

    this.addEventListener(Event.ENTER_FRAME, this.onEnterFrame);
}

BenchmarkScene.prototype = Object.create(Scene.prototype);
BenchmarkScene.prototype.constructor = BenchmarkScene;

BenchmarkScene.FRAME_TIME_WINDOW_SIZE = 10;
BenchmarkScene.MAX_FAIL_COUNT = 100;

BenchmarkScene.prototype.dispose = function()
{
    this.removeEventListener(Event.ENTER_FRAME, this.onEnterFrame);
    this._startButton.removeEventListener(Event.TRIGGERED, this.onStartButtonTriggered);

    for (var i = 0; i < this._objectPool.length; i++)
    {
        var object = this._objectPool[i];
        object.dispose();
    }
    Scene.prototype.dispose.call(this);
}

BenchmarkScene.prototype.onStartButtonTriggered = function()
{
    console.log("Starting benchmark");

    this._startButton.visible = false;
    this._started = true;
    this._targetFps = Starling.current.nativeStage.frameRate;
    this._frameCount = 0;
    this._failCount = 0;
    this._phase = 0;

    for (var i = 0; i < BenchmarkScene.FRAME_TIME_WINDOW_SIZE; i++)
        this._frameTimes[i] = 1.0 / this._targetFps;

    if (this._resultText != null)
    {
        this._resultText.removeFromParent(true);
        this._resultText = null;
    }
}

BenchmarkScene.prototype.onEnterFrame = function(event, passedTime)
{
    if (!this._started) return;

    this._frameCount++;
    this._container.rotation += event.passedTime * 0.5;
    this._frameTimes[BenchmarkScene.FRAME_TIME_WINDOW_SIZE] = 0.0;

    for (var i = 0; i < BenchmarkScene.FRAME_TIME_WINDOW_SIZE; i++)
        this._frameTimes[i] += passedTime;

    var measuredFps = BenchmarkScene.FRAME_TIME_WINDOW_SIZE / this._frameTimes.shift();

    if (this._phase == 0)
    {
        if (measuredFps < 0.985 * this._targetFps)
        {
            this._failCount++;

            if (this._failCount == BenchmarkScene.MAX_FAIL_COUNT)
                this._phase = 1;
        }
        else
        {
            this.addTestObjects(16);
            this._container.scale *= 0.99;
            this._failCount = 0;
        }
    }
    if (this._phase == 1)
    {
        if (measuredFps > 0.99 * this._targetFps)
        {
            this._failCount--;

            if (this._failCount == 0)
            this.benchmarkComplete();
        }
        else
        {
            this.removeTestObjects(1);
            this.    _container.scale /= 0.9993720513; // 0.99 ^ (1/16)
        }
    }

    if (this._frameCount % (this._targetFps / 4) == 0)
    this._statusText.text = this._container.numChildren + " objects";
}

BenchmarkScene.prototype.addTestObjects = function(count)
{
    var scale = 1.0 / this._container.scale;

    for (var i = 0; i < count; i++)
    {
        var egg = this.getObjectFromPool();
        var distance = (100 + Math.random() * 100) * scale;
        var angle = Math.random() * Math.PI * 2.0;

        egg.x = Math.cos(angle) * distance;
        egg.y = Math.sin(angle) * distance;
        egg.rotation = angle + Math.PI / 2.0;
        egg.scale = scale;

        this._container.addChild(egg);
    }
}

BenchmarkScene.prototype.removeTestObjects = function(count)
{
    var numChildren = this._container.numChildren;

    if (count >= numChildren)
        count  = numChildren;

    for (var i = 0; i < count; i++)
        this.putObjectToPool(this._container.removeChildAt(this._container.numChildren-1));
}

BenchmarkScene.prototype.getObjectFromPool = function()
{
    // we pool mainly to avoid any garbage collection while the benchmark is running

    if (this._objectPool.length == 0)
    {
        var image = new Image(this._objectTexture);
        image.alignPivot();
        image.pixelSnapping = false; // slightly faster (and doesn't work here, anyway)
        return image;
    }
    else
        return this._objectPool.pop();
}

BenchmarkScene.prototype.putObjectToPool = function(object)
{
    this._objectPool[this._objectPool.length] = object;
}

BenchmarkScene.prototype.benchmarkComplete = function()
{
    this._started = false;
    this._startButton.visible = true;
    
    var fps = Starling.current.nativeStage.frameRate;
    var numChildren = this._container.numChildren;
    var resultString = StringUtil.format("Result:\n{0} objects\nwith {1} fps",
                                            [numChildren, fps]);
    console.log(resultString.replace("\n", " "));

    this._resultText = new TextField(240, 200, resultString);
    this._resultText.format.font = "DejaVu Sans";
    this._resultText.format.size = 30;
    this._resultText.x = Constants.CenterX - this._resultText.width / 2;
    this._resultText.y = Constants.CenterY - this._resultText.height / 2;
    
    this.addChild(this._resultText);

    this._container.scale = 1.0;
    this._frameTimes.length = 0;
    this._statusText.text = "";

    for (var i = numChildren - 1; i >= 0; --i)
    {
        this.putObjectToPool(this._container.removeChildAt(i));
    }
}

module.exports.BenchmarkScene = BenchmarkScene;
module.exports.default = BenchmarkScene;
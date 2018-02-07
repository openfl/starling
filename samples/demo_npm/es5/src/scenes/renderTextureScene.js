'use strict';
var Matrix = require ("openfl/geom/Matrix").default;
var Point = require ("openfl/geom/Point").default;
var Vector = require ("openfl/Vector").default;

var BlendMode = require ("starling/display/BlendMode").default;
var Button = require ("starling/display/Button").default;
var DisplayObject = require ("starling/display/DisplayObject").default;
var Image = require ("starling/display/Image").default;
var Event = require ("starling/events/Event").default;
var Touch = require ("starling/events/Touch").default;
var TouchEvent = require ("starling/events/TouchEvent").default;
var TouchPhase = require ("starling/events/TouchPhase").default;
var TextField = require ("starling/text/TextField").default;
var RenderTexture = require ("starling/textures/RenderTexture").default;
var Max = require ("starling/utils/Max").default;

var MenuButton = require ("./../utils/menuButton").default;
var Constants = require ("./../constants").default;
var Game = require ("./../game").default;
var Scene = require ("./scene").default;

var RenderTextureScene = function()
{
    Scene.call(this);
    
    this.onTouch = this.onTouch.bind(this);
    this.onButtonTriggered = this.onButtonTriggered.bind(this);
    
    this._colors = [];
    this._renderTexture = new RenderTexture(320, 435);
    
    this._canvas = new Image(this._renderTexture);
    this._canvas.addEventListener(TouchEvent.TOUCH, this.onTouch);
    this.addChild(this._canvas);
    
    this._brush = new Image(Game.assets.getTexture("brush"));
    this._brush.pivotX = this._brush.width / 2;
    this._brush.pivotY = this._brush.height / 2;
    this._brush.blendMode = BlendMode.NORMAL;
    
    var infoText = new TextField(256, 128, "Touch the screen\nto draw!");
    infoText.format.font = "DejaVu Sans";
    infoText.format.size = 24;
    infoText.x = Constants.CenterX - infoText.width / 2;
    infoText.y = Constants.CenterY - infoText.height / 2;
    this._renderTexture.draw(infoText);
    infoText.dispose();
    
    this._button = new MenuButton("Mode: Draw");
    this._button.x = (Constants.CenterX - this._button.width / 2);
    this._button.y = 15;
    this._button.addEventListener(Event.TRIGGERED, this.onButtonTriggered);
    this.addChild(this._button);
}

RenderTextureScene.prototype = Object.create(Scene.prototype);
RenderTextureScene.prototype.constructor = RenderTextureScene;

RenderTextureScene.prototype.onTouch = function(event)
{
    // touching the canvas will draw a brush texture. The 'drawBundled' method is not
    // strictly necessary, but it's faster when you are drawing with several fingers
    // simultaneously.
    
    this._renderTexture.drawBundled(function()
    {
        var touches = event.getTouches(this._canvas);
    
        for (var i = 0; i < touches.length; i++)
        {
            var touch = touches[i];
            
            if (touch.phase == TouchPhase.BEGAN)
                this._colors[touch.id] = Math.round(Math.random() * 0xFFFFFF);
            
            if (touch.phase == TouchPhase.HOVER || touch.phase == TouchPhase.ENDED)
                continue;
            
            var brushColor = this._colors[touch.id];
            var location = touch.getLocation(this._canvas);
            this._brush.x = location.x;
            this._brush.y = location.y;
            this._brush.color = brushColor;
            this._brush.rotation = Math.random() * Math.PI * 2.0;
            
            this._renderTexture.draw(this._brush);
            
            // necessary because 'Starling.skipUnchangedFrames == true'
            this.setRequiresRedraw();
        }
    }.bind(this));
}

RenderTextureScene.prototype.onButtonTriggered = function()
{
    if (this._brush.blendMode == BlendMode.NORMAL)
    {
        this._brush.blendMode = BlendMode.ERASE;
        this._button.text = "Mode: Erase";
    }
    else
    {
        this._brush.blendMode = BlendMode.NORMAL;
        this._button.text = "Mode: Draw";
    }
}

RenderTextureScene.prototype.dispose = function()
{
    this._renderTexture.dispose();
    Scene.prototype.dispose.call(this);
}

module.exports.RenderTextureScene = RenderTextureScene;
module.exports.default = RenderTextureScene;
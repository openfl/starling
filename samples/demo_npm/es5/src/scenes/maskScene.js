'use strict';
var Point = require ("openfl/geom/Point").default;

var Starling = require ("starling/core/Starling").default;
var Canvas = require ("starling/display/Canvas").default;
var Image = require ("starling/display/Image").default;
var Quad = require ("starling/display/Quad").default;
var Sprite = require ("starling/display/Sprite").default;
var Touch = require ("starling/events/Touch").default;
var TouchEvent = require ("starling/events/TouchEvent").default;
var TouchPhase = require ("starling/events/TouchPhase").default;
var ColorMatrixFilter = require ("starling/filters/ColorMatrixFilter").default;
var TextField = require ("starling/text/TextField").default;

var Constants = require ("./../constants").default;
var Game = require ("./../game").default;
var Scene = require ("./scene").default;

var MaskScene = function()
{
    Scene.call(this);
    
    this.onTouch = this.onTouch.bind(this);
    
    this._contents = new Sprite();
    this.addChild(this._contents);
    
    var stageWidth  = Starling.current.stage.stageWidth;
    var stageHeight = Starling.current.stage.stageHeight;
    
    var touchQuad = new Quad(stageWidth, stageHeight);
    touchQuad.alpha = 0; // only used to get touch events
    this.addChildAt(touchQuad, 0);
    
    var image = new Image(Game.assets.getTexture("flight_00"));
    image.x = (stageWidth - image.width) / 2;
    image.y = 80;
    this._contents.addChild(image);

    // just to prove it works, use a filter on the image.
    var cm = new ColorMatrixFilter();
    cm.adjustHue(-0.5);
    image.filter = cm;
    
    var maskText = new TextField(256, 128,
        "Move the mouse (or a finger) over the screen to move the mask.");
    maskText.format.font = "DejaVu Sans";
    maskText.x = (stageWidth - maskText.width) / 2;
    maskText.y = 260;
    maskText.format.size = 20;
    this._contents.addChild(maskText);
    
    this._maskDisplay = this.createCircle();
    this._maskDisplay.alpha = 0.1;
    this._maskDisplay.touchable = false;
    this.addChild(this._maskDisplay);

    this._mask2 = this.createCircle();
    this._contents.mask = this._mask2;
    
    this.addEventListener(TouchEvent.TOUCH, this.onTouch);
}

MaskScene.prototype = Object.create(Scene.prototype);
MaskScene.prototype.constructor = MaskScene;

MaskScene.prototype.onTouch = function(event)
{
    var touch = event.getTouch(this, TouchPhase.HOVER);
    if (touch == null) touch = event.getTouch(this, TouchPhase.BEGAN);
    if (touch == null) touch = event.getTouch(this, TouchPhase.MOVED);

    if (touch != null)
    {
        var localPos = touch.getLocation(this);
        this._mask2.x = this._maskDisplay.x = localPos.x;
        this._mask2.y = this._maskDisplay.y = localPos.y;
    }
}

MaskScene.prototype.createCircle = function()
{
    var circle = new Canvas();
    circle.beginFill(0xEA8220);
    circle.drawCircle(0, 0, 100);
    circle.endFill();
    return circle;
}

module.exports.MaskScene = MaskScene;
module.exports.default = MaskScene;
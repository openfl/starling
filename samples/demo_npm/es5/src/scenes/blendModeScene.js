'use strict';
var BlendMode = require ("starling/display/BlendMode").default;
var Button = require ("starling/display/Button").default;
var Image = require ("starling/display/Image").default;
var Event = require ("starling/events/Event").default;
var TextField = require ("starling/text/TextField").default;

var MenuButton = require ("./../utils/menuButton").default;
var Constants = require ("./../constants").default;
var Game = require ("./../game").default;
var Scene = require ("./scene").default;

var BlendModeScene = function()
{
    Scene.call(this);
    
    this.onButtonTriggered = this.onButtonTriggered.bind(this);
    
    this._blendModes = [
        BlendMode.NORMAL,
        BlendMode.MULTIPLY,
        BlendMode.SCREEN,
        BlendMode.ADD,
        BlendMode.ERASE,
        BlendMode.NONE
    ];
    
    this._button = new MenuButton("Switch Mode");
    this._button.x = (Constants.CenterX - this._button.width / 2);
    this._button.y = 15;
    this._button.addEventListener(Event.TRIGGERED, this.onButtonTriggered);
    this.addChild(this._button);
    
    this._image = new Image(Game.assets.getTexture("starling_rocket"));
    this._image.x = (Constants.CenterX - this._image.width / 2);
    this._image.y = 170;
    this.addChild(this._image);
    
    this._infoText = new TextField(300, 32);
    this._infoText.format.size = 19;
    this._infoText.format.font = "DejaVu Sans";
    this._infoText.x = 10;
    this._infoText.y = 330;
    this.addChild(this._infoText);
    
    this.onButtonTriggered();
}

BlendModeScene.prototype = Object.create(Scene.prototype);
BlendModeScene.prototype.constructor = BlendModeScene;

BlendModeScene.prototype.onButtonTriggered = function()
{
    var blendMode = this._blendModes.shift();
    this._blendModes.push(blendMode);
    
    this._infoText.text = blendMode;
    this._image.blendMode = blendMode;
}

module.exports.BlendModeScene = BlendModeScene;
module.exports.default = BlendModeScene;
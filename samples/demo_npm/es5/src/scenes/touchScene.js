'use strict';
var Image = require ("starling/display/Image").default;
var TextField = require ("starling/text/TextField").default;
var MathUtil = require ("starling/utils/MathUtil").default;

var TouchSheet = require ("./../utils/touchSheet").default;

var Constants = require ("./../constants").default;
var Game = require ("./../game").default;
var Scene = require ("./scene").default;

var TouchScene = function()
{
    Scene.call(this);
    var description = "[use Ctrl/Cmd & Shift to simulate multi-touch]";
    
    var infoText = new TextField(300, 25, description);
    infoText.format.font = "DejaVu Sans";
    infoText.x = infoText.y = 10;
    this.addChild(infoText);
    
    // to find out how to react to touch events have a look at the TouchSheet class! 
    // It's part of the demo.
    
    var sheet = new TouchSheet(new Image(Game.assets.getTexture("starling_sheet")));
    sheet.x = Constants.CenterX;
    sheet.y = Constants.CenterY;
    sheet.rotation = MathUtil.deg2rad(10);
    this.addChild(sheet);
}

TouchScene.prototype = Object.create(Scene.prototype);
TouchScene.prototype.constructor = TouchScene;

module.exports.TouchScene = TouchScene;
module.exports.default = TouchScene;
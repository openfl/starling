'use strict';
var Rectangle = require ("openfl/geom/Rectangle").default;

var Button = require ("starling/display/Button").default;
var Sprite = require ("starling/display/Sprite").default;

var MenuButton = require ("./../utils/menuButton").default;
var Constants = require ("./../constants").default;

var Scene = function()
{
    Sprite.call(this);
    // the main menu listens for TRIGGERED events, so we just need to add the button.
    // (the event will bubble up when it's dispatched.)
    
    this._backButton = new MenuButton("Back", 88, 50);
    this._backButton.x = Constants.CenterX - this._backButton.width / 2;
    this._backButton.y = Constants.GameHeight - this._backButton.height + 4;
    this._backButton.name = "backButton";
    this._backButton.textBounds.y -= 3;
    this._backButton.readjustSize(); // forces textBounds to update
    this.addChild(this._backButton);
}

Scene.prototype = Object.create(Sprite.prototype);
Scene.prototype.constructor = Scene;

module.exports.Scene = Scene;
module.exports.default = Scene;
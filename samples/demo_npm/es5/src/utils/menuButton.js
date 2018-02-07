'use strict';
var Rectangle = require ("openfl/geom/Rectangle").default;

var Button = require ("starling/display/Button").default;

var Game = require ("./../game").default;

/** A simple button that uses "scale9grid" with a single texture. */
var MenuButton = function (text, width, height)
{
    if (width === undefined) width = 128;
    if (height === undefined) height = 32;
    
    Button.call(this, Game.assets.getTexture("button_normal"), text);

    this.textFormat.font = "DejaVu Sans";
    this.scale9Grid = new Rectangle(12.5, 12.5, 20, 20);
    this.width = width;
    this.height = height;
}

MenuButton.prototype = Object.create(Button.prototype);
MenuButton.prototype.constructor = MenuButton;

module.exports.MenuButton = MenuButton;
module.exports.default = MenuButton;
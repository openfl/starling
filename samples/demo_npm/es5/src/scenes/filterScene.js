'use strict';
var BitmapData = require ("openfl/display/BitmapData").default;
var BitmapDataChannel = require ("openfl/display/BitmapDataChannel").default;

var Starling = require ("starling/core/Starling").default;
var Button = require ("starling/display/Button").default;
var Image = require ("starling/display/Image").default;
var Event = require ("starling/events/Event").default;
var BlurFilter = require ("starling/filters/BlurFilter").default;
var ColorMatrixFilter = require ("starling/filters/ColorMatrixFilter").default;
var DisplacementMapFilter = require ("starling/filters/DisplacementMapFilter").default;
var DropShadowFilter = require ("starling/filters/DropShadowFilter").default;
var FilterChain = require ("starling/filters/FilterChain").default;
var FragmentFilter = require ("starling/filters/FragmentFilter").default;
var GlowFilter = require ("starling/filters/GlowFilter").default;
var TextField = require ("starling/text/TextField").default;
var Texture = require ("starling/textures/Texture").default;

var MenuButton = require ("./../utils/menuButton").default;
var Constants = require ("./../constants").default;
var Game = require ("./../game").default;
var Scene = require ("./scene").default;

var FilterScene = function()
{
    Scene.call(this);
    
    this.onButtonTriggered = this.onButtonTriggered.bind(this);
    
    this._button = new MenuButton("Switch Filter");
    this._button.x = (Constants.CenterX - this._button.width / 2);
    this._button.y = 15;
    this._button.addEventListener(Event.TRIGGERED, this.onButtonTriggered);
    this.addChild(this._button);
    
    this._image = new Image(Game.assets.getTexture("starling_rocket"));
    this._image.x = (Constants.CenterX - this._image.width / 2);
    this._image.y = 170;
    this.addChild(this._image);
    
    this._infoText = new TextField(300, 32);
    this._infoText.format.font = "DejaVu Sans";
    this._infoText.format.size = 19;
    this._infoText.x = 10;
    this._infoText.y = 330;
    this.addChild(this._infoText);
    
    this.initFilters();
    this.onButtonTriggered();
}

FilterScene.prototype = Object.create(Scene.prototype);
FilterScene.prototype.constructor = FilterScene;

FilterScene.prototype.dispose = function()
{
    this._displacementMap.dispose();
    Scene.prototype.dispose.call(this)
}

FilterScene.prototype.onButtonTriggered = function()
{
    var filterInfo = this._filterInfos.shift();
    this._filterInfos.push(filterInfo);
    
    this._infoText.text = filterInfo[0];
    this._image.filter  = filterInfo[1];
}

FilterScene.prototype.initFilters = function()
{
    this._filterInfos = [
        ["Identity", new FragmentFilter()],
        ["Blur", new BlurFilter()],
        ["Drop Shadow", new DropShadowFilter()],
        ["Glow", new GlowFilter()]
    ];
    
    this._displacementMap = this.createDisplacementMap(this._image.width, this._image.height);
    
    var displacementFilter = new DisplacementMapFilter(
        this._displacementMap, BitmapDataChannel.RED, BitmapDataChannel.GREEN, 25, 25);
        this._filterInfos.push(["Displacement Map", displacementFilter]);
    
    var invertFilter = new ColorMatrixFilter();
    invertFilter.invert();
    this._filterInfos.push(["Invert", invertFilter]);
    
    var grayscaleFilter = new ColorMatrixFilter();
    grayscaleFilter.adjustSaturation(-1);
    this._filterInfos.push(["Grayscale", grayscaleFilter]);
    
    var saturationFilter = new ColorMatrixFilter();
    saturationFilter.adjustSaturation(1);
    this._filterInfos.push(["Saturation", saturationFilter]);
    
    var contrastFilter = new ColorMatrixFilter();
    contrastFilter.adjustContrast(0.75);
    this._filterInfos.push(["Contrast", contrastFilter]);

    var brightnessFilter = new ColorMatrixFilter();
    brightnessFilter.adjustBrightness(-0.25);
    this._filterInfos.push(["Brightness", brightnessFilter]);

    var hueFilter = new ColorMatrixFilter();
    hueFilter.adjustHue(1);
    this._filterInfos.push(["Hue", hueFilter]);
    
    var chain = new FilterChain([hueFilter, new DropShadowFilter()]);
    this._filterInfos.push(["Hue + Shadow", chain]);
}

FilterScene.prototype.createDisplacementMap = function(width, height)
{
    var scale = Starling.current.contentScaleFactor;
    var map = new BitmapData((width*scale), (height*scale), false);
    map.perlinNoise(20*scale, 20*scale, 3, 5, false, true);
    var texture = Texture.fromBitmapData(map, false, false, scale);
    return texture;
}

module.exports.FilterScene = FilterScene;
module.exports.default = FilterScene;
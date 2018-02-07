'use strict';
var BitmapData = require ("openfl/display/BitmapData").default;
var Error = require ("openfl/errors/Error").default;
var ByteArray = require ("openfl/utils/ByteArray").default;

var Image = require ("starling/display/Image").default;
var TextField = require ("starling/text/TextField").default;
var Texture = require ("starling/textures/Texture").default;

var Constants = require ("./../constants").default;
var Game = require ("./../game").default;
var Scene = require ("./scene").default;

var TextureScene = function()
{
    Scene.call(this);
    // the flight textures are actually loaded from an atlas texture.
    // the "AssetManager" class wraps it away for us.
    
    var image1 = new Image(Game.assets.getTexture("flight_00"));
    image1.x = -20;
    image1.y = 0;
    this.addChild(image1);
    
    var image2 = new Image(Game.assets.getTexture("flight_04"));
    image2.x = 90;
    image2.y = 85;
    this.addChild(image2);
    
    var image3 = new Image(Game.assets.getTexture("flight_08"));
    image3.x = 100;
    image3.y = -60;
    this.addChild(image3);
    
    try
    {
        // display a compressed texture

        var compressedBA = Game.assets.getByteArray("compressed_texture");
        var compressedTexture = Texture.fromAtfData(compressedBA);
        var image4 = new Image(compressedTexture);
        image4.x = Constants.CenterX - image4.width / 2;
        image4.y = 280;
        this.addChild(image4);
    }
    catch (e)
    {
        // if it fails, it's probably not supported
        var textValue = "ATF textures are not fully supported in non Flash/Air targets.";
        var textField = new TextField(220, 128, textValue);
        textField.format.font = "DejaVu Sans";
        textField.format.size = 14;
        textField.x = Constants.CenterX - textField.width / 2;
        textField.y = 280;
        this.addChild(textField);
    }
}

TextureScene.prototype = Object.create(Scene.prototype);
TextureScene.prototype.constructor = TextureScene;

module.exports.TextureScene = TextureScene;
module.exports.default = TextureScene;
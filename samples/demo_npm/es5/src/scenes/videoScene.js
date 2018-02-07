'use strict';
var Error = require ("openfl/errors/Error").default;
var NetStatusEvent = require ("openfl/events/NetStatusEvent").default;
var NetConnection = require ("openfl/net/NetConnection").default;
var NetStream = require ("openfl/net/NetStream").default;

var Image = require ("starling/display/Image").default;
var TextField = require ("starling/text/TextField").default;
var Texture = require ("starling/textures/Texture").default;
var SystemUtil = require ("starling/utils/SystemUtil").default;

var Constants = require ("./../constants").default;
var Game = require ("./../game").default;
var Scene = require ("./scene").default;

var VideoScene = function()
{
	Scene.call(this);
	
	this.onNetStatus = this.onNetStatus.bind(this);
	
	this.url = "assets/videos/sample.mp4";
	this.play();
}

VideoScene.prototype = Object.create(Scene.prototype);
VideoScene.prototype.constructor = VideoScene;

VideoScene.prototype.play = function()
{
	if (SystemUtil.supportsVideoTexture)
	{
		this.nc = new NetConnection();
		this.nc.connect(null);
		
		this.ns = new NetStream(this.nc);
		this.ns.addEventListener(NetStatusEvent.NET_STATUS, this.onNetStatus);
		
		this.ns.client = { onMetaData:function(info) {
			console.log(info.duration);
		}};
		
		this.texture = Texture.fromNetStream(this.ns, 1, function()
		{
			this.image = new Image(this.texture);
			this.addChild(this.image);
			var scale = 320 / this.image.width;
			this.image.scaleX = this.image.scaleY = scale;
			this.image.y = 120;
		}.bind(this));
		
		this.ns.play(this.url);
	}
	else
	{
		var errorMessage = "Video texture is not supported on this platform";
		
		var textField = new TextField(220, 128, errorMessage);
		textField.format.font = "DejaVu Sans";
		textField.x = Constants.CenterX - textField.width / 2;
		textField.y = Constants.CenterY - textField.height / 2;
		this.addChild(textField);
	}
}

VideoScene.prototype.onNetStatus = function(e)
{
	console.log(e.info.code);
}

VideoScene.prototype.dispose = function()
{
	if (this.ns != null) {
		this.ns.close();
	}
	if (this.image != null) {
		if (this.image.parent != null) {
			this.image.parent.removeChild(this.image, true);
			this.image = null;
		}
	}
	if (this.texture != null) {
		this.texture.dispose();
		this.texture = null;
	}
	Scene.prototype.dispose.call(this);
}

module.exports.VideoScene = VideoScene;
module.exports.default = VideoScene;
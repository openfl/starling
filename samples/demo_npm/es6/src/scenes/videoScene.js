import Error from "openfl/errors/Error";
import NetStatusEvent from "openfl/events/NetStatusEvent";
import NetConnection from "openfl/net/NetConnection";
import NetStream from "openfl/net/NetStream";

import Image from "starling/display/Image";
import TextField from "starling/text/TextField";
import Texture from "starling/textures/Texture";
import SystemUtil from "starling/utils/SystemUtil";

import Constants from "./../constants";
import Game from "./../game";
import Scene from "./scene";

class VideoScene extends Scene
{
	url:String = "assets/videos/sample.mp4";
	
	constructor()
	{
		super(); 
		this.play();
	}
	
	play()
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
			
			this.texture = Texture.fromNetStream(this.ns, 1, () =>
			{
				this.image = new Image(this.texture);
				this.addChild(this.image);
				var scale = 320 / this.image.width;
				this.image.scaleX = this.image.scaleY = scale;
				this.image.y = 120;
			});
			
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
	
	onNetStatus = (e) => 
	{
		console.log(e.info.code);
	}
	
	dispose()
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
		super.dispose();
	}
}

export default VideoScene;
package scenes;

import openfl.errors.Error;
import openfl.events.NetStatusEvent;
import openfl.net.NetConnection;
import openfl.net.NetStream;
import starling.display.Image;
import starling.text.TextField;
import starling.textures.Texture;

@:keep class VideoScene extends Scene
{
	var url:String = "videos/sample.mp4";
	var texture:Texture;
	var ns:NetStream;
	var nc:NetConnection;
	var image:Image;
	
	public function new()
	{
		super(); 
		play();
	}
	
	function play() 
	{
		nc = new NetConnection();
		nc.connect(null);
		
		ns = new NetStream(nc);
		ns.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
		
		ns.client = { onMetaData:function(info:MetaInfo) {
			trace(info.duration);
		}};
		
		try
		{
			texture = Texture.fromNetStream(ns, 1, function():Void
			{
				image = new Image(texture);
				addChild(image);
				var scale:Float = 320 / image.width;
				image.scaleX = image.scaleY = scale;
				image.y = 120;
			});
		}
		catch (e:Dynamic)
		{
			var textField:TextField = new TextField(220, 128, 
				"Video texture is not supported on this platform", "DejaVu Sans", 14);
			textField.x = Constants.CenterX - textField.width / 2;
			textField.y = Constants.CenterY - textField.height / 2;
			addChild(textField);
		}
		
		ns.play(url);
	}
	
	static private function onNetStatus(e:NetStatusEvent):Void 
	{
		trace(e.info.code);
	}
	
	override public function dispose():Void
	{
		ns.close();
		if (image != null) {
			if (image.parent != null) {
				image.parent.removeChild(image, true);
				image = null;
			}
		}
		if (texture != null) {
			texture.dispose();
			texture = null;
		}
		super.dispose();
	}
}

typedef MetaInfo =
{
	var duration:Float;
	var width:UInt;
	var height:UInt;
	var framerate:UInt;
}
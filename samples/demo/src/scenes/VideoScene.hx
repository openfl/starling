package scenes;

import openfl.errors.Error;
import openfl.events.NetStatusEvent;
import openfl.net.NetConnection;
import openfl.net.NetStream;
import starling.display.Image;
import starling.events.EnterFrameEvent;
import starling.events.Event;
import starling.text.TextField;
import starling.textures.Texture;
import starling.utils.SystemUtil;

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
		if (SystemUtil.supportsVideoTexture)
		{
			nc = new NetConnection();
			nc.connect(null);
			
			ns = new NetStream(nc);
			ns.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
			
			ns.client = { onMetaData:function(info:MetaInfo) {
				// trace(info.duration);
			}};
			
			texture = Texture.fromNetStream(ns, 1, function(texture:Texture):Void
			{
				image = new Image(texture);
				addChild(image);
				var scale:Float = 320 / image.width;
				image.scaleX = image.scaleY = scale;
				image.y = 120;
			});
			
			ns.play(url);
		}
		else
		{
			#if flash
				var errorMessage:String = "Video texture requires AIR 17.0, Flash Player 18.0";
			#else
				var errorMessage:String = "Video texture is not supported on this platform";
			#end
			
            var textField:TextField = new TextField(220, 128, errorMessage);
            textField.format.font = "DejaVu Sans";
			textField.x = Constants.CenterX - textField.width / 2;
			textField.y = Constants.CenterY - textField.height / 2;
			addChild(textField);
		}
	}

	private function onEnterFrame(event:EnterFrameEvent, passedTime:Float):Void
	{
		setRequiresRedraw();
	}
	
	private function onNetStatus(e:NetStatusEvent):Void 
	{
		// trace(e.info.code);
		switch(e.info.code)
		{
			case "NetStream.Play.Start":
				addEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			case "NetStream.Play.Stop", "NetStream.Play.Complete":
                removeEventListener(Event.ENTER_FRAME, onEnterFrame);
            
            default:
		}
	}
	
	override public function dispose():Void
	{
		removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		if (ns != null) {
			ns.close();
		}
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
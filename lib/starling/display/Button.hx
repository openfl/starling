package starling.display;

import starling.display.DisplayObjectContainer;
import starling.text.TextField;
import Std;
import starling.display.Sprite;
import starling.display.Image;

@:jsRequire("starling/display/Button", "default")

@:meta(Event(name = "triggered", type = "starling.events.Event")) extern class Button extends DisplayObjectContainer {
	var alphaWhenDisabled(get,set) : Float;
	var alphaWhenDown(get,set) : Float;
	var color(get,set) : UInt;
	var disabledState(get,set) : starling.textures.Texture;
	var downState(get,set) : starling.textures.Texture;
	var enabled(get,set) : Bool;
	var overState(get,set) : starling.textures.Texture;
	var overlay(get,never) : Sprite;
	var pixelSnapping(get,set) : Bool;
	var scale9Grid(get,set) : openfl.geom.Rectangle;
	var scaleWhenDown(get,set) : Float;
	var scaleWhenOver(get,set) : Float;
	var state(get,set) : String;
	var style(get,set) : starling.styles.MeshStyle;
	var text(get,set) : String;
	var textBounds(get,set) : openfl.geom.Rectangle;
	var textFormat(get,set) : starling.text.TextFormat;
	var textStyle(get,set) : starling.styles.MeshStyle;
	var textureSmoothing(get,set) : String;
	var upState(get,set) : starling.textures.Texture;
	function new(upState : starling.textures.Texture, ?text : String, ?downState : starling.textures.Texture, ?overState : starling.textures.Texture, ?disabledState : starling.textures.Texture) : Void;
	function readjustSize(resetTextBounds : Bool = false) : Void;
}
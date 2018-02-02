package starling.textures;

import starling.textures.ConcreteTexture;
import starling.core.Starling;
import Std;
import Reflect;
import js.Boot;
import haxe.Timer;

@:jsRequire("starling/textures/ConcreteRectangleTexture", "default")

@:allow(starling) extern class ConcreteRectangleTexture extends ConcreteTexture {
	var rectBase(get,never) : openfl.display3D.textures.RectangleTexture;
}

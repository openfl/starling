package starling.textures;

import Std;
import starling.textures.SubTexture;
import haxe.ds.StringMap;

@:jsRequire("starling/textures/TextureAtlas", "default")

extern class TextureAtlas implements Dynamic {

	function new(texture:Dynamic, ?atlasXml:Dynamic);
	var __atlasTexture:Dynamic;
	var __subTextures:Dynamic;
	var __subTextureNames:Dynamic;
	function dispose():Dynamic;
	function getXmlFloat(xml:Dynamic, attributeName:Dynamic):Dynamic;
	function parseAtlasXml(atlasXml:Dynamic):Dynamic;
	function getTexture(name:Dynamic):Dynamic;
	function getTextures(?prefix:Dynamic, ?result:Dynamic):Dynamic;
	function getNames(?prefix:Dynamic, ?result:Dynamic):Dynamic;
	function getRegion(name:Dynamic):Dynamic;
	function getFrame(name:Dynamic):Dynamic;
	function getRotation(name:Dynamic):Dynamic;
	function addRegion(name:Dynamic, region:Dynamic, ?frame:Dynamic, ?rotated:Dynamic):Dynamic;
	function removeRegion(name:Dynamic):Dynamic;
	var texture:Dynamic;
	function get_texture():Dynamic;
	function compare(a:Dynamic, b:Dynamic):Dynamic;
	static var sNames:Dynamic;
	static function parseBool(value:Dynamic):Dynamic;


}
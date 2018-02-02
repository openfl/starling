package starling.textures;

import starling.textures.Texture;
import haxe.Log;
import Std;

@:jsRequire("starling/textures/SubTexture", "default")

extern class SubTexture extends starling.textures.Texture implements Dynamic {

	function new(parent:Dynamic, ?region:Dynamic, ?ownsParent:Dynamic, ?frame:Dynamic, ?rotated:Dynamic, ?scaleModifier:Dynamic);
	var _parent:Dynamic;
	var _ownsParent:Dynamic;
	var _region:Dynamic;
	var _frame:Dynamic;
	var _rotated:Dynamic;
	var _width:Dynamic;
	var _height:Dynamic;
	var _scale:Dynamic;
	var _transformationMatrix:Dynamic;
	var _transformationMatrixToRoot:Dynamic;
	function setTo(parent:Dynamic, ?region:Dynamic, ?ownsParent:Dynamic, ?frame:Dynamic, ?rotated:Dynamic, ?scaleModifier:Dynamic):Dynamic;
	function updateMatrices():Dynamic;
	override function dispose():Dynamic;
	var parent:Dynamic;
	function get_parent():Dynamic;
	var ownsParent:Dynamic;
	function get_ownsParent():Dynamic;
	var rotated:Dynamic;
	function get_rotated():Dynamic;
	var region:Dynamic;
	function get_region():Dynamic;
	override function get_transformationMatrix():Dynamic;
	override function get_transformationMatrixToRoot():Dynamic;
	override function get_base():Dynamic;
	override function get_root():Dynamic;
	override function get_format():Dynamic;
	override function get_width():Dynamic;
	override function get_height():Dynamic;
	override function get_nativeWidth():Dynamic;
	override function get_nativeHeight():Dynamic;
	override function get_mipMapping():Dynamic;
	override function get_premultipliedAlpha():Dynamic;
	override function get_scale():Dynamic;
	override function get_frame():Dynamic;


}
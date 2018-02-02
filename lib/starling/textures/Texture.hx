package starling.textures;

import starling.utils.MatrixUtil;
import starling.textures.TextureOptions;
import Std;
import js.Boot;
import Type;
import starling.textures.ConcretePotTexture;
import starling.textures.ConcreteRectangleTexture;
import starling.textures.ConcreteVideoTexture;
import starling.core.Starling;
import starling.errors.MissingContextError;
import starling.textures.AtfData;
import Reflect;
import starling.utils.SystemUtil;
import starling.errors.NotSupportedError;
import starling.utils.MathUtil;
import starling.textures.SubTexture;

@:jsRequire("starling/textures/Texture", "default")

extern class Texture implements Dynamic {

	function new();
	function dispose():Dynamic;
	function setupVertexPositions(vertexData:Dynamic, ?vertexID:Dynamic, ?attrName:Dynamic, ?bounds:Dynamic):Dynamic;
	function setupTextureCoordinates(vertexData:Dynamic, ?vertexID:Dynamic, ?attrName:Dynamic):Dynamic;
	function localToGlobal(u:Dynamic, v:Dynamic, ?out:Dynamic):Dynamic;
	function globalToLocal(u:Dynamic, v:Dynamic, ?out:Dynamic):Dynamic;
	function setTexCoords(vertexData:Dynamic, vertexID:Dynamic, attrName:Dynamic, u:Dynamic, v:Dynamic):Dynamic;
	function getTexCoords(vertexData:Dynamic, vertexID:Dynamic, ?attrName:Dynamic, ?out:Dynamic):Dynamic;
	var frame:Dynamic;
	function get_frame():Dynamic;
	var frameWidth:Dynamic;
	function get_frameWidth():Dynamic;
	var frameHeight:Dynamic;
	function get_frameHeight():Dynamic;
	var width:Dynamic;
	function get_width():Dynamic;
	var height:Dynamic;
	function get_height():Dynamic;
	var nativeWidth:Dynamic;
	function get_nativeWidth():Dynamic;
	var nativeHeight:Dynamic;
	function get_nativeHeight():Dynamic;
	var scale:Dynamic;
	function get_scale():Dynamic;
	var base:Dynamic;
	function get_base():Dynamic;
	var root:Dynamic;
	function get_root():Dynamic;
	var format:Dynamic;
	function get_format():Dynamic;
	var mipMapping:Dynamic;
	function get_mipMapping():Dynamic;
	var premultipliedAlpha:Dynamic;
	function get_premultipliedAlpha():Dynamic;
	var transformationMatrix:Dynamic;
	function get_transformationMatrix():Dynamic;
	var transformationMatrixToRoot:Dynamic;
	function get_transformationMatrixToRoot():Dynamic;
	static var sDefaultOptions:Dynamic;
	static var sRectangle:Dynamic;
	static var sMatrix:Dynamic;
	static var sPoint:Dynamic;
	static function fromData(data:Dynamic, ?options:Dynamic):Dynamic;
	static function fromTextureBase(base:Dynamic, width:Dynamic, height:Dynamic, ?options:Dynamic):Dynamic;
	static function fromEmbeddedAsset(assetClass:Dynamic, ?mipMapping:Dynamic, ?optimizeForRenderToTexture:Dynamic, ?scale:Dynamic, ?format:Dynamic, ?forcePotTexture:Dynamic):Dynamic;
	static function fromBitmap(bitmap:Dynamic, ?generateMipMaps:Dynamic, ?optimizeForRenderToTexture:Dynamic, ?scale:Dynamic, ?format:Dynamic, ?forcePotTexture:Dynamic, ?async:Dynamic):Dynamic;
	static function fromBitmapData(data:Dynamic, ?generateMipMaps:Dynamic, ?optimizeForRenderToTexture:Dynamic, ?scale:Dynamic, ?format:Dynamic, ?forcePotTexture:Dynamic, ?async:Dynamic):Dynamic;
	static function fromAtfData(data:Dynamic, ?scale:Dynamic, ?useMipMaps:Dynamic, ?async:Dynamic, ?premultipliedAlpha:Dynamic):Dynamic;
	static function fromNetStream(stream:Dynamic, ?scale:Dynamic, ?onComplete:Dynamic):Dynamic;
	static function fromVideoAttachment(type:Dynamic, attachment:Dynamic, scale:Dynamic, onComplete:Dynamic):Dynamic;
	static function fromColor(width:Dynamic, height:Dynamic, ?color:Dynamic, ?alpha:Dynamic, ?optimizeForRenderToTexture:Dynamic, ?scale:Dynamic, ?format:Dynamic, ?forcePotTexture:Dynamic):Dynamic;
	static function empty(width:Dynamic, height:Dynamic, ?premultipliedAlpha:Dynamic, ?mipMapping:Dynamic, ?optimizeForRenderToTexture:Dynamic, ?scale:Dynamic, ?format:Dynamic, ?forcePotTexture:Dynamic):Dynamic;
	static function fromTexture(texture:Dynamic, ?region:Dynamic, ?frame:Dynamic, ?rotated:Dynamic, ?scaleModifier:Dynamic):Dynamic;
	static var maxSize:Dynamic;
	static function get_maxSize():Dynamic;
	static var asyncBitmapUploadEnabled:Dynamic;
	static function get_asyncBitmapUploadEnabled():Dynamic;
	static function set_asyncBitmapUploadEnabled(value:Dynamic):Dynamic;


}
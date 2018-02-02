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

extern class Texture {
	var base(get,never) : openfl.display3D.textures.TextureBase;
	var format(get,never) : openfl.display3D.Context3DTextureFormat;
	var frame(get,never) : openfl.geom.Rectangle;
	var frameHeight(get,never) : Float;
	var frameWidth(get,never) : Float;
	var height(get,never) : Float;
	var mipMapping(get,never) : Bool;
	var nativeHeight(get,never) : Float;
	var nativeWidth(get,never) : Float;
	var premultipliedAlpha(get,never) : Bool;
	var root(get,never) : ConcreteTexture;
	var scale(get,never) : Float;
	var transformationMatrix(get,never) : openfl.geom.Matrix;
	var transformationMatrixToRoot(get,never) : openfl.geom.Matrix;
	var width(get,never) : Float;
	function dispose() : Void;
	function getTexCoords(vertexData : starling.rendering.VertexData, vertexID : Int, ?attrName : String, ?out : openfl.geom.Point) : openfl.geom.Point;
	function globalToLocal(u : Float, v : Float, ?out : openfl.geom.Point) : openfl.geom.Point;
	function localToGlobal(u : Float, v : Float, ?out : openfl.geom.Point) : openfl.geom.Point;
	function setTexCoords(vertexData : starling.rendering.VertexData, vertexID : Int, attrName : String, u : Float, v : Float) : Void;
	function setupTextureCoordinates(vertexData : starling.rendering.VertexData, vertexID : Int = 0, ?attrName : String) : Void;
	function setupVertexPositions(vertexData : starling.rendering.VertexData, vertexID : Int = 0, ?attrName : String, ?bounds : openfl.geom.Rectangle) : Void;
	static var asyncBitmapUploadEnabled(get,set) : Bool;
	static var maxSize(get,never) : Int;
	static function empty(width : Float, height : Float, premultipliedAlpha : Bool = false, mipMapping : Bool = false, optimizeForRenderToTexture : Bool = false, scale : Float = 0, ?format : String, forcePotTexture : Bool = false) : Texture;
	static function fromAtfData(data : openfl.utils.ByteArray, scale : Float = 0, useMipMaps : Bool = false, async : Null<Texture -> Void> = null, premultipliedAlpha : Bool = false) : Texture;
	static function fromBitmap(bitmap : openfl.display.Bitmap, generateMipMaps : Bool = false, optimizeForRenderToTexture : Bool = false, scale : Float = 0, ?format : openfl.display3D.Context3DTextureFormat, forcePotTexture : Bool = false, async : Null<Texture -> Void> = null) : Texture;
	static function fromBitmapData(data : openfl.display.BitmapData, generateMipMaps : Bool = false, optimizeForRenderToTexture : Bool = false, scale : Float = 0, ?format : openfl.display3D.Context3DTextureFormat, forcePotTexture : Bool = false, async : Null<Texture -> Void> = null) : Texture;
	static function fromColor(width : Float, height : Float, color : UInt = 0, alpha : Float = 0, optimizeForRenderToTexture : Bool = false, scale : Float = 0, ?format : String, forcePotTexture : Bool = false) : Texture;
	static function fromData(data : Dynamic, ?options : TextureOptions) : Texture;
	static function fromEmbeddedAsset(assetClass : Class<Dynamic>, mipMapping : Bool = false, optimizeForRenderToTexture : Bool = false, scale : Float = 0, ?format : openfl.display3D.Context3DTextureFormat, forcePotTexture : Bool = false) : Texture;
	static function fromNetStream(stream : openfl.net.NetStream, scale : Float = 0, onComplete : Null<Texture -> Void> = null) : Texture;
	static function fromTexture(texture : Texture, ?region : openfl.geom.Rectangle, ?frame : openfl.geom.Rectangle, rotated : Bool = false, scaleModifier : Float = 0) : Texture;
	static function fromTextureBase(base : openfl.display3D.textures.TextureBase, width : Int, height : Int, ?options : TextureOptions) : ConcreteTexture;
}

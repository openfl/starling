package starling.rendering;

import Std;
import starling.utils.StringUtil;
import starling.utils.MatrixUtil;
import starling.utils.MathUtil;
import starling.core.Starling;
import starling.errors.MissingContextError;
import starling.styles.MeshStyle;
import starling.rendering.VertexDataFormat;

@:jsRequire("starling/rendering/VertexData", "default")

extern class VertexData {
	var format(get,set) : VertexDataFormat;
	var formatString(get,never) : String;
	var numVertices(get,set) : Int;
	var premultipliedAlpha(get,set) : Bool;
	var rawData(get,never) : openfl.utils.ByteArray;
	var size(get,never) : Int;
	var sizeIn32Bits(get,never) : Int;
	var tinted(get,set) : Bool;
	var vertexSize(get,never) : Int;
	var vertexSizeIn32Bits(get,never) : Int;
	function new(?format : Dynamic, initialCapacity : Int = 0) : Void;
	function clear() : Void;
	function clone() : VertexData;
	function colorize(?attrName : String, color : UInt = 0, alpha : Float = 0, vertexID : Int = 0, numVertices : Int = 0) : Void;
	function copyAttributeTo(target : VertexData, targetVertexID : Int, attrName : String, ?matrix : openfl.geom.Matrix, vertexID : Int = 0, numVertices : Int = 0) : Void;
	function copyTo(target : VertexData, targetVertexID : Int = 0, ?matrix : openfl.geom.Matrix, vertexID : Int = 0, numVertices : Int = 0) : Void;
	function createVertexBuffer(upload : Bool = false, ?bufferUsage : String) : openfl.display3D.VertexBuffer3D;
	function getAlpha(vertexID : Int, ?attrName : String) : Float;
	function getBounds(?attrName : String, ?matrix : openfl.geom.Matrix, vertexID : Int = 0, numVertices : Int = 0, ?out : openfl.geom.Rectangle) : openfl.geom.Rectangle;
	function getBoundsProjected(attrName : String, matrix : openfl.geom.Matrix3D, camPos : openfl.geom.Vector3D, vertexID : Int = 0, numVertices : Int = 0, ?out : openfl.geom.Rectangle) : openfl.geom.Rectangle;
	function getColor(vertexID : Int, ?attrName : String) : UInt;
	function getFloat(vertexID : Int, attrName : String) : Float;
	function getFormat(attrName : String) : String;
	function getOffset(attrName : String) : Int;
	function getOffsetIn32Bits(attrName : String) : Int;
	function getPoint(vertexID : Int, attrName : String, ?out : openfl.geom.Point) : openfl.geom.Point;
	function getPoint3D(vertexID : Int, attrName : String, ?out : openfl.geom.Vector3D) : openfl.geom.Vector3D;
	function getPoint4D(vertexID : Int, attrName : String, ?out : openfl.geom.Vector3D) : openfl.geom.Vector3D;
	function getSize(attrName : String) : Int;
	function getSizeIn32Bits(attrName : String) : Int;
	function getUnsignedInt(vertexID : Int, attrName : String) : UInt;
	function hasAttribute(attrName : String) : Bool;
	function scaleAlphas(attrName : String, factor : Float, vertexID : Int = 0, numVertices : Int = 0) : Void;
	function setAlpha(vertexID : Int, attrName : String, alpha : Float) : Void;
	function setColor(vertexID : Int, attrName : String, color : UInt) : Void;
	function setFloat(vertexID : Int, attrName : String, value : Float) : Void;
	function setPoint(vertexID : Int, attrName : String, x : Float, y : Float) : Void;
	function setPoint3D(vertexID : Int, attrName : String, x : Float, y : Float, z : Float) : Void;
	function setPoint4D(vertexID : Int, attrName : String, x : Float, y : Float, z : Float, w : Float = 0) : Void;
	function setPremultipliedAlpha(value : Bool, updateData : Bool) : Void;
	function setUnsignedInt(vertexID : Int, attrName : String, value : UInt) : Void;
	function toString() : String;
	function transformPoints(attrName : String, matrix : openfl.geom.Matrix, vertexID : Int = 0, numVertices : Int = 0) : Void;
	function translatePoints(attrName : String, deltaX : Float, deltaY : Float, vertexID : Int = 0, numVertices : Int = 0) : Void;
	function trim() : Void;
	function updateTinted(?attrName : String) : Bool;
	function uploadToVertexBuffer(buffer : openfl.display3D.VertexBuffer3D, vertexID : Int = 0, numVertices : Int = 0) : Void;
}

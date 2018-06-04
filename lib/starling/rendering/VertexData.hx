// =================================================================================================
//
//  Starling Framework
//  Copyright Gamua GmbH. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

package starling.rendering;

import openfl.display3D.Context3D;
import openfl.display3D.VertexBuffer3D;
import openfl.errors.ArgumentError;
import openfl.errors.IllegalOperationError;
import openfl.geom.Matrix;
import openfl.geom.Matrix3D;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.geom.Vector3D;
import openfl.utils.ByteArray;
import openfl.utils.Endian;
import openfl.Vector;

import starling.core.Starling;
import starling.errors.MissingContextError;
import starling.styles.MeshStyle;
import starling.utils.MathUtil;
import starling.utils.MatrixUtil;
import starling.utils.Max;
import starling.utils.StringUtil;

/** The VertexData class manages a raw list of vertex information, allowing direct upload
 *  to Stage3D vertex buffers. <em>You only have to work with this class if you're writing
 *  your own rendering code (e.g. if you create custom display objects).</em>
 *
 *  <p>To render objects with Stage3D, you have to organize vertices and indices in so-called
 *  vertex- and index-buffers. Vertex buffers store the coordinates of the vertices that make
 *  up an object; index buffers reference those vertices to determine which vertices spawn
 *  up triangles. Those buffers reside in graphics memory and can be accessed very
 *  efficiently by the GPU.</p>
 *
 *  <p>Before you can move data into the buffers, you have to set it up in conventional
 *  memory — that is, in a Vector or a ByteArray. Since it's quite cumbersome to manually
 *  create and manipulate those data structures, the IndexData and VertexData classes provide
 *  a simple way to do just that. The data is stored sequentially (one vertex or index after
 *  the other) so that it can easily be uploaded to a buffer.</p>
 *
 *  <strong>Vertex Format</strong>
 *
 *  <p>The VertexData class requires a custom format string on initialization, or an instance
 *  of the VertexDataFormat class. Here is an example:</p>
 *
 *  <listing>
 *  vertexData = new VertexData("position:float2, color:bytes4");
 *  vertexData.setPoint(0, "position", 320, 480);
 *  vertexData.setColor(0, "color", 0xff00ff);</listing>
 *
 *  <p>This instance is set up with two attributes: "position" and "color". The keywords
 *  after the colons depict the format and size of the data that each property uses; in this
 *  case, we store two floats for the position (for the x- and y-coordinates) and four
 *  bytes for the color. Please refer to the VertexDataFormat documentation for details.</p>
 *
 *  <p>The attribute names are then used to read and write data to the respective positions
 *  inside a vertex. Furthermore, they come in handy when copying data from one VertexData
 *  instance to another: attributes with equal name and data format may be transferred between
 *  different VertexData objects, even when they contain different sets of attributes or have
 *  a different layout.</p>
 *
 *  <strong>Colors</strong>
 *
 *  <p>Always use the format <code>bytes4</code> for color data. The color access methods
 *  expect that format, since it's the most efficient way to store color data. Furthermore,
 *  you should always include the string "color" (or "Color") in the name of color data;
 *  that way, it will be recognized as such and will always have its value pre-filled with
 *  pure white at full opacity.</p>
 *
 *  <strong>Premultiplied Alpha</strong>
 *
 *  <p>Per default, color values are stored with premultiplied alpha values, which
 *  means that the <code>rgb</code> values were multiplied with the <code>alpha</code> values
 *  before saving them. You can change this behavior with the <code>premultipliedAlpha</code>
 *  property.</p>
 *
 *  <p>Beware: with premultiplied alpha, the alpha value always affects the resolution of
 *  the RGB channels. A small alpha value results in a lower accuracy of the other channels,
 *  and if the alpha value reaches zero, the color information is lost altogether.</p>
 *
 *  <strong>Tinting</strong>
 *
 *  <p>Some low-end hardware is very sensitive when it comes to fragment shader complexity.
 *  Thus, Starling optimizes shaders for non-tinted meshes. The VertexData class keeps track
 *  of its <code>tinted</code>-state, at least at a basic level: whenever you change color
 *  or alpha value of a vertex to something different than white (<code>0xffffff</code>) with
 *  full alpha (<code>1.0</code>), the <code>tinted</code> property is enabled.</p>
 *
 *  <p>However, that value is not entirely accurate: when you restore the color of just a
 *  range of vertices, or copy just a subset of vertices to another instance, the property
 *  might wrongfully indicate a tinted mesh. If that's the case, you can either call
 *  <code>updateTinted()</code> or assign a custom value to the <code>tinted</code>-property.
 *  </p>
 *
 *  @see VertexDataFormat
 *  @see IndexData
 */

@:jsRequire("starling/rendering/VertexData", "default")

extern class VertexData
{
    /** Creates an empty VertexData object with the given format and initial capacity.
     *
     *  @param format
     *
     *  Either a VertexDataFormat instance or a String that describes the data format.
     *  Refer to the VertexDataFormat class for more information. If you don't pass a format,
     *  the default <code>MeshStyle.VERTEX_FORMAT</code> will be used.
     *
     *  @param initialCapacity
     *
     *  The initial capacity affects just the way the internal ByteArray is allocated, not the
     *  <code>numIndices</code> value, which will always be zero when the constructor returns.
     *  The reason for this behavior is the peculiar way in which ByteArrays organize their
     *  memory:
     *
     *  <p>The first time you set the length of a ByteArray, it will adhere to that:
     *  a ByteArray with length 20 will take up 20 bytes (plus some overhead). When you change
     *  it to a smaller length, it will stick to the original value, e.g. with a length of 10
     *  it will still take up 20 bytes. However, now comes the weird part: change it to
     *  anything above the original length, and it will allocate 4096 bytes!</p>
     *
     *  <p>Thus, be sure to always make a generous educated guess, depending on the planned
     *  usage of your VertexData instances.</p>
     */
    public function new(format:Dynamic=null, initialCapacity:Int=32);

    /** Explicitly frees up the memory used by the ByteArray. */
    public function clear():Void;

    /** Creates a duplicate of the vertex data object. */
    public function clone():VertexData;

    /** Copies the vertex data (or a range of it, defined by 'vertexID' and 'numVertices')
     *  of this instance to another vertex data object, starting at a certain target index.
     *  If the target is not big enough, it will be resized to fit all the new vertices.
     *
     *  <p>If you pass a non-null matrix, the 2D position of each vertex will be transformed
     *  by that matrix before storing it in the target object. (The position being either an
     *  attribute with the name "position" or, if such an attribute is not found, the first
     *  attribute of each vertex. It must consist of two float values containing the x- and
     *  y-coordinates of the vertex.)</p>
     *
     *  <p>Source and target do not need to have the exact same format. Only properties that
     *  exist in the target will be copied; others will be ignored. If a property with the
     *  same name but a different format exists in the target, an exception will be raised.
     *  Beware, though, that the copy-operation becomes much more expensive when the formats
     *  differ.</p>
     */
    public function copyTo(target:VertexData, targetVertexID:Int=0, matrix:Matrix=null,
                           vertexID:Int=0, numVertices:Int=-1):Void;

    /** Copies a specific attribute of all contained vertices (or a range of them, defined by
     *  'vertexID' and 'numVertices') to another VertexData instance. Beware that both name
     *  and format of the attribute must be identical in source and target.
     *  If the target is not big enough, it will be resized to fit all the new vertices.
     *
     *  <p>If you pass a non-null matrix, the specified attribute will be transformed by
     *  that matrix before storing it in the target object. It must consist of two float
     *  values.</p>
     */
    public function copyAttributeTo(target:VertexData, targetVertexID:Int, attrName:String,
                                    matrix:Matrix=null, vertexID:Int=0, numVertices:Int=-1):Void;

    /** Optimizes the ByteArray so that it has exactly the required capacity, without
     *  wasting any memory. If your VertexData object grows larger than the initial capacity
     *  you passed to the constructor, call this method to avoid the 4k memory problem. */
    public function trim():Void;

    /** Returns a string representation of the VertexData object,
     *  describing both its format and size. */
    public function toString():String;

    // read / write attributes

    /** Reads an unsigned integer value from the specified vertex and attribute. */
    public function getUnsignedInt(vertexID:Int, attrName:String):UInt;

    /** Writes an unsigned integer value to the specified vertex and attribute. */
    public function setUnsignedInt(vertexID:Int, attrName:String, value:UInt):Void;

    /** Reads a float value from the specified vertex and attribute. */
    public function getFloat(vertexID:Int, attrName:String):Float;

    /** Writes a float value to the specified vertex and attribute. */
    public function setFloat(vertexID:Int, attrName:String, value:Float):Void;

    /** Reads a Point from the specified vertex and attribute. */
    public function getPoint(vertexID:Int, attrName:String, out:Point=null):Point;

    /** Writes the given coordinates to the specified vertex and attribute. */
    public function setPoint(vertexID:Int, attrName:String, x:Float, y:Float):Void;

    /** Reads a Vector3D from the specified vertex and attribute.
     *  The 'w' property of the Vector3D is ignored. */
    public function getPoint3D(vertexID:Int, attrName:String, out:Vector3D=null):Vector3D;

    /** Writes the given coordinates to the specified vertex and attribute. */
    public function setPoint3D(vertexID:Int, attrName:String, x:Float, y:Float, z:Float):Void;

    /** Reads a Vector3D from the specified vertex and attribute, including the fourth
     *  coordinate ('w'). */
    public function getPoint4D(vertexID:Int, attrName:String, out:Vector3D=null):Vector3D;

    /** Writes the given coordinates to the specified vertex and attribute. */
    public function setPoint4D(vertexID:Int, attrName:String,
                               x:Float, y:Float, z:Float, w:Float=1.0):Void;

    /** Reads an RGB color from the specified vertex and attribute (no alpha). */
    public function getColor(vertexID:Int, attrName:String="color"):UInt;

    /** Writes the RGB color to the specified vertex and attribute (alpha is not changed). */
    public function setColor(vertexID:Int, attrName:String, color:UInt):Void;

    /** Reads the alpha value from the specified vertex and attribute. */
    public function getAlpha(vertexID:Int, attrName:String="color"):Float;

    /** Writes the given alpha value to the specified vertex and attribute (range 0-1). */
    public function setAlpha(vertexID:Int, attrName:String, alpha:Float):Void;

    // bounds helpers

    /** Calculates the bounds of the 2D vertex positions identified by the given name.
     *  The positions may optionally be transformed by a matrix before calculating the bounds.
     *  If you pass an 'out' Rectangle, the result will be stored in this rectangle
     *  instead of creating a new object. To use all vertices for the calculation, set
     *  'numVertices' to '-1'. */
    public function getBounds(attrName:String="position", matrix:Matrix=null,
                              vertexID:Int=0, numVertices:Int=-1, out:Rectangle=null):Rectangle;

    /** Calculates the bounds of the 2D vertex positions identified by the given name,
     *  projected into the XY-plane of a certain 3D space as they appear from the given
     *  camera position. Note that 'camPos' is expected in the target coordinate system
     *  (the same that the XY-plane lies in).
     *
     *  <p>If you pass an 'out' Rectangle, the result will be stored in this rectangle
     *  instead of creating a new object. To use all vertices for the calculation, set
     *  'numVertices' to '-1'.</p> */
    public function getBoundsProjected(attrName:String, matrix:Matrix3D,
                                       camPos:Vector3D, vertexID:Int=0, numVertices:Int=-1,
                                       out:Rectangle=null):Rectangle;

    /** Indicates if color attributes should be stored premultiplied with the alpha value.
     *  Changing this value does <strong>not</strong> modify any existing color data.
     *  If you want that, use the <code>setPremultipliedAlpha</code> method instead.
     *  @default true */
    public var premultipliedAlpha(get, set):Bool;
    private function get_premultipliedAlpha():Bool;
    private function set_premultipliedAlpha(value:Bool):Bool;

    /** Changes the way alpha and color values are stored. Optionally updates all existing
     *  vertices. */
    public function setPremultipliedAlpha(value:Bool, updateData:Bool):Void;

    /** Updates the <code>tinted</code> property from the actual color data. This might make
     *  sense after copying part of a tinted VertexData instance to another, since not each
     *  color value is checked in the process. An instance is tinted if any vertices have a
     *  non-white color or are not fully opaque. */
    public function updateTinted(attrName:String="color"):Bool;

    // modify multiple attributes

    /** Transforms the 2D positions of subsequent vertices by multiplication with a
     *  transformation matrix. */
    public function transformPoints(attrName:String, matrix:Matrix,
                                    vertexID:Int=0, numVertices:Int=-1):Void;

    /** Translates the 2D positions of subsequent vertices by a certain offset. */
    public function translatePoints(attrName:String, deltaX:Float, deltaY:Float,
                                    vertexID:Int=0, numVertices:Int=-1):Void;

    /** Multiplies the alpha values of subsequent vertices by a certain factor. */
    public function scaleAlphas(attrName:String, factor:Float,
                                vertexID:Int=0, numVertices:Int=-1):Void;

    /** Writes the given RGB and alpha values to the specified vertices. */
    public function colorize(attrName:String="color", color:UInt=0xffffff, alpha:Float=1.0,
                             vertexID:Int=0, numVertices:Int=-1):Void;

    // format helpers

    /** Returns the format of a certain vertex attribute, identified by its name.
      * Typical values: <code>float1, float2, float3, float4, bytes4</code>. */
    public function getFormat(attrName:String):String;

    /** Returns the size of a certain vertex attribute in bytes. */
    public function getSize(attrName:String):Int;

    /** Returns the size of a certain vertex attribute in 32 bit units. */
    public function getSizeIn32Bits(attrName:String):Int;

    /** Returns the offset (in bytes) of an attribute within a vertex. */
    public function getOffset(attrName:String):Int;

    /** Returns the offset (in 32 bit units) of an attribute within a vertex. */
    public function getOffsetIn32Bits(attrName:String):Int;

    /** Indicates if the VertexData instances contains an attribute with the specified name. */
    public function hasAttribute(attrName:String):Bool;

    // VertexBuffer helpers

    /** Creates a vertex buffer object with the right size to fit the complete data.
     *  Optionally, the current data is uploaded right away. */
    public function createVertexBuffer(upload:Bool=false,
                                       bufferUsage:String="staticDraw"):VertexBuffer3D;

    /** Uploads the complete data (or a section of it) to the given vertex buffer. */
    public function uploadToVertexBuffer(buffer:VertexBuffer3D, vertexID:Int=0, numVertices:Int=-1):Void;

    // properties

    /** The total number of vertices. If you make the object bigger, it will be filled up with
     *  <code>1.0</code> for all alpha values and zero for everything else. */
    public var numVertices(get, set):Int;
    private function get_numVertices():Int;
    private function set_numVertices(value:Int):Int;

    /** The raw vertex data; not a copy! */
    public var rawData(get, never):ByteArray;
    private function get_rawData():ByteArray;

    /** The format that describes the attributes of each vertex.
     *  When you assign a different format, the raw data will be converted accordingly,
     *  i.e. attributes with the same name will still point to the same data.
     *  New properties will be filled up with zeros (except for colors, which will be
     *  initialized with an alpha value of 1.0). As a side-effect, the instance will also
     *  be trimmed. */
    public var format(get, set):VertexDataFormat;
    private function get_format():VertexDataFormat;
    private function set_format(value:VertexDataFormat):VertexDataFormat;

    /** Indicates if the mesh contains any vertices that are not white or not fully opaque.
     *  If <code>false</code> (and the value wasn't modified manually), the result is 100%
     *  accurate; <code>true</code> represents just an educated guess. To be entirely sure,
     *  you may call <code>updateTinted()</code>.
     */
    public var tinted(get, set):Bool;
    private function get_tinted():Bool;
    private function set_tinted(value:Bool):Bool;

    /** The format string that describes the attributes of each vertex. */
    public var formatString(get, never):String;
    private function get_formatString():String;

    /** The size (in bytes) of each vertex. */
    public var vertexSize(get, never):Int;
    private function get_vertexSize():Int;

    /** The size (in 32 bit units) of each vertex. */
    public var vertexSizeIn32Bits(get, never):Int;
    private function get_vertexSizeIn32Bits():Int;

    /** The size (in bytes) of the raw vertex data. */
    public var size(get, never):Int;
    private function get_size():Int;

    /** The size (in 32 bit units) of the raw vertex data. */
    public var sizeIn32Bits(get, never):Int;
    private function get_sizeIn32Bits():Int;
}
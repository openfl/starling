// =================================================================================================
//
//	Starling Framework
//	Copyright Gamua GmbH. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

package starling.rendering;

import openfl.display3D.VertexBuffer3D;
import openfl.errors.ArgumentError;
import openfl.utils.Dictionary;
import openfl.Vector;

import starling.core.Starling;
import starling.utils.StringUtil;

/** Describes the memory layout of VertexData instances, as used for every single vertex.
 *
 *  <p>The format is set up via a simple String. Here is an example:</p>
 *
 *  <listing>
 *  format = VertexDataFormat.fromString("position:float2, color:bytes4");</listing>
 *
 *  <p>This String describes two attributes: "position" and "color". The keywords after
 *  the colons depict the format and size of the data that each attribute uses; in this
 *  case, we store two floats for the position (taking up the x- and y-coordinates) and four
 *  bytes for the color. (The available formats are the same as those defined in the
 *  <code>Context3DVertexBufferFormat</code> class:
 *  <code>float1, float2, float3, float4, bytes4</code>.)</p>
 *
 *  <p>You cannot create a VertexData instance with its constructor; instead, you must use the
 *  static <code>fromString</code>-method. The reason for this behavior: the class maintains
 *  a cache, and a call to <code>fromString</code> will return an existing instance if an
 *  equivalent format has already been created in the past. That saves processing time and
 *  memory.</p>
 *
 *  <p>VertexDataFormat instances are immutable, i.e. they are solely defined by their format
 *  string and cannot be changed later.</p>
 *
 *  @see VertexData
 */

@:jsRequire("starling/rendering/VertexDataFormat", "default")

extern class VertexDataFormat
{
    /** Don't use the constructor, but call <code>VertexDataFormat.fromString</code> instead.
     *  This allows for efficient format caching. */
    public function new();

    /** Creates a new VertexDataFormat instance from the given String, or returns one from
     *  the cache (if an equivalent String has already been used before).
     *
     *  @param format
     *
     *  Describes the attributes of each vertex, consisting of a comma-separated
     *  list of attribute names and their format, e.g.:
     *
     *  <pre>"position:float2, texCoords:float2, color:bytes4"</pre>
     *
     *  <p>This set of attributes will be allocated for each vertex, and they will be
     *  stored in exactly the given order.</p>
     *
     *  <ul>
     *    <li>Names are used to access the specific attributes of a vertex. They are
     *        completely arbitrary.</li>
     *    <li>The available formats can be found in the <code>Context3DVertexBufferFormat</code>
     *        class in the <code>flash.display3D</code> package.</li>
     *    <li>Both names and format strings are case-sensitive.</li>
     *    <li>Always use <code>bytes4</code> for color data that you want to access with the
     *        respective methods.</li>
     *    <li>Furthermore, the attribute names of colors should include the string "color"
     *        (or the uppercase variant). If that's the case, the "alpha" channel of the color
     *        will automatically be initialized with "1.0" when the VertexData object is
     *        created or resized.</li>
     *  </ul>
     */
    public static function fromString(format:String):VertexDataFormat;

    /** Creates a new VertexDataFormat instance by appending the given format string
     *  to the current instance's format. */
    public function extend(format:String):VertexDataFormat;

    // query methods

    /** Returns the size of a certain vertex attribute in bytes. */
    public function getSize(attrName:String):Int;

    /** Returns the size of a certain vertex attribute in 32 bit units. */
    public function getSizeIn32Bits(attrName:String):Int;

    /** Returns the offset (in bytes) of an attribute within a vertex. */
    public function getOffset(attrName:String):Int;

    /** Returns the offset (in 32 bit units) of an attribute within a vertex. */
    public function getOffsetIn32Bits(attrName:String):Int;

    /** Returns the format of a certain vertex attribute, identified by its name.
     *  Typical values: <code>float1, float2, float3, float4, bytes4</code>. */
    public function getFormat(attrName:String):String;

    /** Returns the name of the attribute at the given position within the vertex format. */
    public function getName(attrIndex:Int):String;

    /** Indicates if the format contains an attribute with the given name. */
    public function hasAttribute(attrName:String):Bool;

    // context methods

    /** Specifies which vertex data attribute corresponds to a single vertex shader
     *  program input. This wraps the <code>Context3D</code>-method with the same name,
     *  automatically replacing <code>attrName</code> with the corresponding values for
     *  <code>bufferOffset</code> and <code>format</code>. */
    public function setVertexBufferAt(index:Int, buffer:VertexBuffer3D, attrName:String):Void;

    /** Returns the normalized format string. */
    public function toString():String;

    // properties

    /** Returns the normalized format string. */
    public var formatString(get, never):String;
    private function get_formatString():String;

    /** The size (in bytes) of each vertex. */
    public var vertexSize(get, never):Int;
    private function get_vertexSize():Int;

    /** The size (in 32 bit units) of each vertex. */
    public var vertexSizeIn32Bits(get, never):Int;
    private function get_vertexSizeIn32Bits():Int;

    /** The number of attributes per vertex. */
    public var numAttributes(get, never):Int;
    private function get_numAttributes():Int;
}
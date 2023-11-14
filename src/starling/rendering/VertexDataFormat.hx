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
class VertexDataFormat
{
    private var _format:String;
    private var _vertexSize:Int;
    private var _attributes:Vector<VertexDataAttribute>;

    // format cache
    private static var sFormats:Map<String, VertexDataFormat> = new Map();

    /** Don't use the constructor, but call <code>VertexDataFormat.fromString</code> instead.
     *  This allows for efficient format caching. */
    public function new()
    {
        _attributes = new Vector<VertexDataAttribute>();
    }
    
    #if commonjs
    private static function __init__ () {
        
        untyped Object.defineProperties (VertexDataFormat.prototype, {
            "attributes": { get: untyped __js__ ("function () { return this.get_attributes (); }") },
            "formatString": { get: untyped __js__ ("function () { return this.get_formatString (); }") },
            "vertexSize": { get: untyped __js__ ("function () { return this.get_vertexSize (); }") },
            "vertexSizeIn32Bits": { get: untyped __js__ ("function () { return this.get_vertexSizeIn32Bits (); }") },
            "numAttributes": { get: untyped __js__ ("function () { return this.get_numAttributes (); }") },
        });
        
    }
    #end

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
    public static function fromString(format:String):VertexDataFormat
    {
        if (format == null) format = "";
        if (sFormats.exists(format)) return sFormats[format];
        else
        {
            var instance:VertexDataFormat = new VertexDataFormat();
            instance.parseFormat(format);

            var normalizedFormat:String = instance._format;

            if (sFormats.exists(normalizedFormat))
                instance = sFormats[normalizedFormat];

            sFormats[format] = instance;
            sFormats[normalizedFormat] = instance;

            return instance;
        }
    }

    /** Creates a new VertexDataFormat instance by appending the given format string
     *  to the current instance's format. */
    public function extend(format:String):VertexDataFormat
    {
        return fromString(_format + ", " + format);
    }

    // query methods

    /** Returns the size of a certain vertex attribute in bytes. */
    public function getSize(attrName:String):Int
    {
        return getAttribute(attrName).size;
    }

    /** Returns the size of a certain vertex attribute in 32 bit units. */
    public function getSizeIn32Bits(attrName:String):Int
    {
        return Std.int(getAttribute(attrName).size / 4);
    }

    /** Returns the offset (in bytes) of an attribute within a vertex. */
    public function getOffset(attrName:String):Int
    {
        return getAttribute(attrName).offset;
    }

    /** Returns the offset (in 32 bit units) of an attribute within a vertex. */
    public function getOffsetIn32Bits(attrName:String):Int
    {
        return Std.int(getAttribute(attrName).offset / 4);
    }

    /** Returns the format of a certain vertex attribute, identified by its name.
     *  Typical values: <code>float1, float2, float3, float4, bytes4</code>. */
    public function getFormat(attrName:String):String
    {
        return getAttribute(attrName).format;
    }

    /** Returns the name of the attribute at the given position within the vertex format. */
    public function getName(attrIndex:Int):String
    {
        return _attributes[attrIndex].name;
    }

    /** Indicates if the format contains an attribute with the given name. */
    public function hasAttribute(attrName:String):Bool
    {
        var numAttributes:Int = _attributes.length;

        for (i in 0...numAttributes)
            if (_attributes[i].name == attrName) return true;

        return false;
    }

    // context methods

    /** Specifies which vertex data attribute corresponds to a single vertex shader
     *  program input. This wraps the <code>Context3D</code>-method with the same name,
     *  automatically replacing <code>attrName</code> with the corresponding values for
     *  <code>bufferOffset</code> and <code>format</code>. */
    public function setVertexBufferAt(index:Int, buffer:VertexBuffer3D, attrName:String):Void
    {
        var attribute:VertexDataAttribute = getAttribute(attrName);
        Starling.current.context.setVertexBufferAt(index, buffer, Std.int(attribute.offset / 4), attribute.format);
    }

    // parsing

    private function parseFormat(format:String):Void
    {
        if (format != null && format != "")
        {
            _attributes.length = 0;
            _format = "";

            var parts = format.split(",");
            var numParts:Int = parts.length;
            var offset:Int = 0;

            for (i in 0...numParts)
            {
                var attrDesc:String = parts[i];
                var attrParts = attrDesc.split(":");

                if (attrParts.length != 2)
                    throw new ArgumentError("Missing colon: " + attrDesc);

                var attrName:String = StringUtil.trim(attrParts[0]);
                var attrFormat:String = StringUtil.trim(attrParts[1]);

                if (attrName.length == 0 || attrFormat.length == 0)
                    throw new ArgumentError(("Invalid format string: " + attrDesc));

                var attribute:VertexDataAttribute =
                    new VertexDataAttribute(attrName, attrFormat, offset);

                offset += attribute.size;

                _format += (i == 0 ? "" : ", ") + attribute.name + ":" + attribute.format;
                _attributes[_attributes.length] = attribute; // avoid 'push'
            }

            _vertexSize = offset;
        }
        else
        {
            _format = "";
        }
    }

    /** Returns the normalized format string. */
    public function toString():String
    {
        return _format;
    }

    // internal methods

    /** @private */
    /*internal*/ function getAttribute(attrName:String):VertexDataAttribute
    {
        var i:Int, attribute:VertexDataAttribute;
        var numAttributes:Int = _attributes.length;

        for (i in 0...numAttributes)
        {
            attribute = _attributes[i];
            if (attribute.name == attrName) return attribute;
        }

        return null;
    }

    /** @private */
    @:allow(starling) private var attributes(get, never):Vector<VertexDataAttribute>;
    private function get_attributes():Vector<VertexDataAttribute>
    {
        return _attributes;
    }

    // properties

    /** Returns the normalized format string. */
    public var formatString(get, never):String;
    private function get_formatString():String
    {
        return _format;
    }

    /** The size (in bytes) of each vertex. */
    public var vertexSize(get, never):Int;
    private function get_vertexSize():Int
    {
        return _vertexSize;
    }

    /** The size (in 32 bit units) of each vertex. */
    public var vertexSizeIn32Bits(get, never):Int;
    private function get_vertexSizeIn32Bits():Int
    {
        return Std.int(_vertexSize / 4);
    }

    /** The number of attributes per vertex. */
    public var numAttributes(get, never):Int;
    private function get_numAttributes():Int
    {
        return _attributes.length;
    }
}
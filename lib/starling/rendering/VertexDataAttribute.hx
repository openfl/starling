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

import openfl.errors.ArgumentError;
import openfl.utils.Dictionary;

/** Holds the properties of a single attribute in a VertexDataFormat instance.
 *  The member variables must never be changed; they are only <code>public</code>
 *  for performance reasons. */

@:jsRequire("starling/rendering/VertexDataAttribute", "default")

extern class VertexDataAttribute
{
    /** Creates a new instance with the given properties. */
    public function new(name:String, format:String, offset:Int);
}
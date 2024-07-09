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

import starling.utils.StringUtil;

/** Points to a location within a list of MeshBatches.
 *
 *  <p>Starling uses these tokens in its render cache. Each call to
 *  <code>painter.pushState()</code> or <code>painter.popState()</code> provides a token
 *  referencing the current location within the cache. In the next frame, if the relevant
 *  part of the display tree has not changed, these tokens can be used to render directly
 *  from the cache instead of constructing new MeshBatches.</p>
 *
 *  @see Painter
 */
class BatchToken
{
    /** The ID of the current MeshBatch. */
    public var batchID:Int;

    /** The ID of the next vertex within the current MeshBatch. */
    public var vertexID:Int;

    /** The ID of the next index within the current MeshBatch. */
    public var indexID:Int;

    /** Creates a new BatchToken. */
    public function new(batchID:Int=0, vertexID:Int=0, indexID:Int=0)
    {
        setTo(batchID, vertexID, indexID);
    }

    /** Copies the properties from the given token to this instance. */
    public function copyFrom(token:BatchToken):Void
    {
        batchID  = token.batchID;
        vertexID = token.vertexID;
        indexID  = token.indexID;
    }

    /** Changes all properties at once. */
    public function setTo(batchID:Int=0, vertexID:Int=0, indexID:Int=0):Void
    {
        this.batchID = batchID;
        this.vertexID = vertexID;
        this.indexID = indexID;
    }

    /** Resets all properties to zero. */
    public function reset():Void
    {
        batchID = vertexID = indexID = 0;
    }

    /** Indicates if this token contains the same values as the given one. */
    public function equals(other:BatchToken):Bool
    {
        return batchID == other.batchID && vertexID == other.vertexID && indexID == other.indexID;
    }

    /** Creates a String representation of this instance. */
    public function toString():String
    {
        return '[BatchToken batchID=$batchID vertexID=$vertexID indexID=$indexID]';
    }
}
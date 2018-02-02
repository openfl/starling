// =================================================================================================
//
//	Starling Framework
//	Copyright Gamua GmbH. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

package starling.utils;

/** A class describing a range of vertices and indices, thus referencing a subset of a Mesh. */
class MeshSubset
{
    /** The ID of the first vertex. */
    public var vertexID:Int;

    /** The total number of vertices. */
    public var numVertices:Int;

    /** The ID of the first index. */
    public var indexID:Int;

    /** The total number of indices. */
    public var numIndices:Int;

    /** Creates a new MeshSubset. */
    public function new(vertexID:Int=0, numVertices:Int=-1,
                        indexID:Int=0,  numIndices:Int=-1)
    {
        setTo(vertexID, numVertices, indexID, numIndices);
    }

    /** Changes all properties at once.
     *  Call without any arguments to reference a complete mesh. */
    public function setTo(vertexID:Int=0, numVertices:Int=-1,
                           indexID:Int=0, numIndices:Int=-1):Void
    {
        this.vertexID = vertexID;
        this.numVertices = numVertices;
        this.indexID = indexID;
        this.numIndices = numIndices;
    }
}
declare namespace starling.utils
{
    /** A class describing a range of vertices and indices, thus referencing a subset of a Mesh. */
    export class MeshSubset
    {
        /** The ID of the first vertex. */
        public vertexID:number;

        /** The total number of vertices. */
        public numVertices:number;

        /** The ID of the first index. */
        public indexID:number;

        /** The total number of indices. */
        public numIndices:number;

        /** Creates a new MeshSubset. */
        public constructor(vertexID?:number, numVertices?:number,
                            indexID?:number,  numIndices?:number);

        /** Changes all properties at once.
         *  Call without any arguments to reference a complete mesh. */
        public setTo(vertexID?:number, numVertices?:number,
                            indexID?:number, numIndices?:number):void;
    }
}

export default starling.utils.MeshSubset;
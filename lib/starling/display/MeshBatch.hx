// =================================================================================================
//
//	Starling Framework
//	Copyright Gamua GmbH. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

package starling.display;

import openfl.geom.Matrix;
import starling.rendering.Effect;

import starling.rendering.IndexData;
import starling.rendering.MeshEffect;
import starling.rendering.Painter;
import starling.rendering.VertexData;
import starling.styles.MeshStyle;
import starling.utils.MatrixUtil;
import starling.utils.MeshSubset;

/** Combines a number of meshes to one display object and renders them efficiently.
 *
 *  <p>The most basic tangible (non-container) display object in Starling is the Mesh.
 *  However, a mesh typically does not render itself; it just holds the data describing its
 *  geometry. Rendering is orchestrated by the "MeshBatch" class. As its name suggests, it
 *  acts as a batch for an arbitrary number of Mesh instances; add meshes to a batch and they
 *  are all rendered together, in one draw call.</p>
 *
 *  <p>You can only batch meshes that share similar properties, e.g. they need to have the
 *  same texture and the same blend mode. The first object you add to a batch will decide
 *  this state; call <code>canAddMesh</code> to find out if a new mesh shares that state.
 *  To reset the current state, you can call <code>clear</code>; this will also remove all
 *  geometry that has been added thus far.</p>
 *
 *  <p>Starling will use MeshBatch instances (or compatible objects) for all rendering.
 *  However, you can also instantiate MeshBatch instances yourself and add them to the display
 *  tree. That makes sense for an object containing a large number of meshes; that way, that
 *  object can be created once and then rendered very efficiently, without having to copy its
 *  vertices and indices between buffers and GPU memory.</p>
 *
 *  @see Mesh
 *  @see Sprite
 */

@:jsRequire("starling/display/MeshBatch", "default")

extern class MeshBatch extends Mesh
{
    /** The maximum number of vertices that fit into one MeshBatch. */
    public static var MAX_NUM_VERTICES:Int;

    /** Creates a new, empty MeshBatch instance. */
    public function new();

    /** @inheritDoc */
    override public function dispose():Void;

    /** This method must be called whenever the mesh's vertex data was changed. Makes
     *  sure that the vertex buffer is synchronized before rendering, and forces a redraw. */
    override public function setVertexDataChanged():Void;

    /** This method must be called whenever the mesh's index data was changed. Makes
     *  sure that the index buffer is synchronized before rendering, and forces a redraw. */
    override public function setIndexDataChanged():Void;

    /** Removes all geometry. */
    public function clear():Void;

    /** Adds a mesh to the batch by appending its vertices and indices.
     *
     *  @param mesh      the mesh to add to the batch.
     *  @param matrix    transform all vertex positions with a certain matrix. If this
     *                   parameter is omitted, <code>mesh.transformationMatrix</code>
     *                   will be used instead (except if the last parameter is enabled).
     *  @param alpha     will be multiplied with each vertex' alpha value.
     *  @param subset    the subset of the mesh you want to add, or <code>null</code> for
     *                   the complete mesh.
     *  @param ignoreTransformations   when enabled, the mesh's vertices will be added
     *                   without transforming them in any way (no matter the value of the
     *                   <code>matrix</code> parameter).
     */
    public function addMesh(mesh:Mesh, matrix:Matrix=null, alpha:Float=1.0,
                            subset:MeshSubset=null, ignoreTransformations:Bool=false):Void;

    /** Adds a mesh to the batch by copying its vertices and indices to the given positions.
     *  Beware that you need to check for yourself if those positions make sense; for example,
     *  you need to make sure that they are aligned within the 3-indices groups making up
     *  the mesh's triangles.
     *
     *  <p>It's easiest to only add objects with an identical setup, e.g. only quads.
     *  For the latter, indices are aligned in groups of 6 (one quad requires six indices),
     *  and the vertices in groups of 4 (one vertex for every corner).</p>
     */
    public function addMeshAt(mesh:Mesh, indexID:Int, vertexID:Int):Void;

    /** Indicates if the given mesh instance fits to the current state of the batch.
     *  Will always return <code>true</code> for the first added mesh; later calls
     *  will check if the style matches and if the maximum number of vertices is not
     *  exceeded.
     *
     *  @param mesh         the mesh to add to the batch.
     *  @param numVertices  if <code>-1</code>, <code>mesh.numVertices</code> will be used
     */
    public function canAddMesh(mesh:Mesh, numVertices:Int=-1):Bool;

    /** If the <code>batchable</code> property is enabled, this method will add the batch
     *  to the painter's current batch. Otherwise, this will actually do the drawing. */
    override public function render(painter:Painter):Void;

    /** @inheritDoc */
    override public function setStyle(meshStyle:MeshStyle=null,
                                      mergeWithPredecessor:Bool=true):Void;

    /** Indicates if this object will be added to the painter's batch on rendering,
     *  or if it will draw itself right away.
     *
     *  <p>Only batchable meshes can profit from the render cache; but batching large meshes
     *  may take up a lot of CPU time. Activate this property only if the batch contains just
     *  a handful of vertices (say, 20 quads).</p>
     *
     *  @default false
     */
    public var batchable(get, set):Bool;
    private function get_batchable():Bool;
    private function set_batchable(value:Bool):Bool;
}
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
class MeshBatch extends Mesh
{
    /** The maximum number of vertices that fit into one MeshBatch. */
    public static inline var MAX_NUM_VERTICES:Int = 65535;

    @:noCompletion private var __effect:MeshEffect;
    @:noCompletion private var __batchable:Bool;
    @:noCompletion private var __vertexSyncRequired:Bool;
    @:noCompletion private var __indexSyncRequired:Bool;

    // helper object
    private static var sFullMeshSubset:MeshSubset = new MeshSubset();

    #if commonjs
    private static function __init__ () {
        
        untyped Object.defineProperties (MeshBatch.prototype, {
            "batchable": { get: untyped __js__ ("function () { return this.get_batchable (); }"), set: untyped __js__ ("function (v) { return this.set_batchable (v); }") },
        });
        
    }
    #end

    /** Creates a new, empty MeshBatch instance. */
    public function new()
    {
        var vertexData:VertexData = new VertexData();
        var indexData:IndexData = new IndexData();

        super(vertexData, indexData);
    }

    /** @inheritDoc */
    override public function dispose():Void
    {
        if (__effect != null) __effect.dispose();
        super.dispose();
    }

    /** This method must be called whenever the mesh's vertex data was changed. Makes
     *  sure that the vertex buffer is synchronized before rendering, and forces a redraw. */
    override public function setVertexDataChanged():Void
    {
        __vertexSyncRequired = true;
        super.setVertexDataChanged();
    }

    /** This method must be called whenever the mesh's index data was changed. Makes
     *  sure that the index buffer is synchronized before rendering, and forces a redraw. */
    override public function setIndexDataChanged():Void
    {
        __indexSyncRequired = true;
        super.setIndexDataChanged();
    }

    @:noCompletion private function __setVertexAndIndexDataChanged():Void
    {
        __vertexSyncRequired = __indexSyncRequired = true;
    }

    @:noCompletion private function __syncVertexBuffer():Void
    {
        __effect.uploadVertexData(__vertexData);
        __vertexSyncRequired = false;
    }

    @:noCompletion private function __syncIndexBuffer():Void
    {
        __effect.uploadIndexData(__indexData);
        __indexSyncRequired = false;
    }

    /** Removes all geometry. */
    public function clear():Void
    {
        if (__parent != null) setRequiresRedraw();

        __vertexData.numVertices = 0;
        __indexData.numIndices   = 0;
        __vertexSyncRequired = true;
        __indexSyncRequired  = true;
    }

    /** Adds a mesh to the batch by appending its vertices and indices.
     *
     *  Note that the first time you add a mesh to the batch, the batch will duplicate its
     *  MeshStyle. All subsequently added meshes will then be converted to that same style.
      
     *  @param mesh      the mesh to add to the batch.
     *  @param matrix    transform all vertex positions with a certain matrix. If this
     *                   parameter is omitted, `mesh.transformationMatrix`
     *                   will be used instead (except if the last parameter is enabled).
     *  @param alpha     will be multiplied with each vertex' alpha value.
     *  @param subset    the subset of the mesh you want to add, or `null` for
     *                   the complete mesh.
     *  @param ignoreTransformations   when enabled, the mesh's vertices will be added
     *                   without transforming them in any way (no matter the value of the
     *                   `matrix` parameter).
     */
    public function addMesh(mesh:Mesh, matrix:Matrix=null, alpha:Float=1.0,
                            subset:MeshSubset=null, ignoreTransformations:Bool=false):Void
    {
        addMeshAt(mesh, -1, -1, matrix, alpha, subset, ignoreTransformations);
    }

    /** Adds a mesh to the batch by copying its vertices and indices to the given positions.
     *  Beware that you need to check for yourself if those positions make sense; for example,
     *  you need to make sure that they are aligned within the 3-indices groups making up
     *  the mesh's triangles.
     *
     *  It's easiest to only add objects with an identical setup, e.g. only quads.
     *  For the latter, indices are aligned in groups of 6 (one quad requires six indices),
     *  and the vertices in groups of 4 (one vertex for every corner).
     *
     *  Note that the first time you add a mesh to the batch, the batch will duplicate its
     *  MeshStyle. All subsequently added meshes will then be converted to that same style.
     *
     *  @param mesh      the mesh to add to the batch.
     *  @param indexID   the position at which the mesh's indices should be added to the batch.
     *                   If negative, they will be added at the very end.
     *  @param vertexID  the position at which the mesh's vertices should be added to the batch.
     *                   If negative, they will be added at the very end.
     *  @param matrix    transform all vertex positions with a certain matrix. If this
     *                   parameter is omitted, `mesh.transformationMatrix`
     *                   will be used instead (except if the last parameter is enabled).
     *  @param alpha     will be multiplied with each vertex' alpha value.
     *  @param subset    the subset of the mesh you want to add, or `null` for
     *                   the complete mesh.
     *  @param ignoreTransformations   when enabled, the mesh's vertices will be added
     *                   without transforming them in any way (no matter the value of the
     *                   `matrix` parameter).
     */
    public function addMeshAt(mesh:Mesh, indexID:Int=-1, vertexID:Int=-1,
                            matrix:Matrix=null, alpha:Float=1.0,
                            subset:MeshSubset=null, ignoreTransformations:Bool=false):Void
    {
        if (ignoreTransformations) matrix = null;
        else if (matrix == null) matrix = mesh.transformationMatrix;
        if (subset == null) subset = sFullMeshSubset;
        
        var oldNumVertices:Int = __vertexData.numVertices;
        var targetVertexID:Int = vertexID >= 0 ? vertexID : oldNumVertices;
        var targetIndexID:Int = indexID >= 0 ? indexID : __indexData.numIndices;
        var meshStyle:MeshStyle = mesh.__style;

        if (oldNumVertices == 0)
            __setupFor(mesh);

        meshStyle.batchVertexData(__style, targetVertexID, matrix, subset.vertexID, subset.numVertices);
        meshStyle.batchIndexData(__style, targetIndexID, targetVertexID - subset.vertexID,
                subset.indexID, subset.numIndices);
        
        if (alpha != 1.0) __vertexData.scaleAlphas("color", alpha, targetVertexID, subset.numVertices);
        if (__parent != null) setRequiresRedraw();

        __indexSyncRequired = __vertexSyncRequired = true;
    }

    @:noCompletion private function __setupFor(mesh:Mesh):Void
    {
        var meshStyle:MeshStyle = mesh.__style;
        var meshStyleType:Class<Dynamic> = meshStyle.type;

        if (__style.type != meshStyleType)
        {
            var newStyle:MeshStyle = Type.createInstance(meshStyleType, []);
            newStyle.copyFrom(meshStyle);
            setStyle(newStyle, false);
        }
        else
        {
            __style.copyFrom(meshStyle);
        }
    }

    /** Indicates if the given mesh instance fits to the current state of the batch.
     *  Will always return <code>true</code> for the first added mesh; later calls
     *  will check if the style matches and if the maximum number of vertices is not
     *  exceeded.
     *
     *  @param mesh         the mesh to add to the batch.
     *  @param numVertices  if <code>-1</code>, <code>mesh.numVertices</code> will be used
     */
    public function canAddMesh(mesh:Mesh, numVertices:Int=-1):Bool
    {
        var currentNumVertices:Int = __vertexData.numVertices;

        if (currentNumVertices == 0) return true;
        if (numVertices  < 0) numVertices = mesh.numVertices;
        if (numVertices == 0) return true;
        if (numVertices + currentNumVertices > MAX_NUM_VERTICES) return false;

        return __style.canBatchWith(mesh.__style);
    }

    /** If the <code>batchable</code> property is enabled, this method will add the batch
     *  to the painter's current batch. Otherwise, this will actually do the drawing. */
    override public function render(painter:Painter):Void
    {
        if (__vertexData.numVertices == 0) return;
        if (__pixelSnapping) MatrixUtil.snapToPixels(
            painter.state.modelviewMatrix, painter.pixelSize);

        if (__batchable)
        {
            painter.batchMesh(this);
        }
        else
        {
            painter.finishMeshBatch();
            painter.drawCount += 1;
            painter.prepareToDraw();
            painter.excludeFromCache(this);

            if (__vertexSyncRequired) __syncVertexBuffer();
            if (__indexSyncRequired)  __syncIndexBuffer();

            __style.updateEffect(__effect, painter.state);
            __effect.render(0, __indexData.numTriangles);
        }
    }

    /** @inheritDoc */
    override public function setStyle(meshStyle:MeshStyle=null,
                                      mergeWithPredecessor:Bool=true):Void
    {
        super.setStyle(meshStyle, mergeWithPredecessor);

        if (__effect != null)
            __effect.dispose();

        __effect = style.createEffect();
        __effect.onRestore = function(effect:Effect):Void{__setVertexAndIndexDataChanged();};

        __setVertexAndIndexDataChanged(); // we've got a new set of buffers!
    }

    /** The total number of vertices in the mesh. If you change this to a smaller value,
     *  the surplus will be deleted. Make sure that no indices reference those deleted
     *  vertices! */
    private function set_numVertices(value:Int):Int
    {
        if (__vertexData.numVertices != value)
        {
            __vertexData.numVertices = value;
            __vertexSyncRequired = true;
            setRequiresRedraw();
        }
        return value;
    }

    /** The total number of indices in the mesh. If you change this to a smaller value,
     *  the surplus will be deleted. Always make sure that the number of indices
     *  is a multiple of three! */
    private function set_numIndices(value:Int):Int
    {
        if (__indexData.numIndices != value)
        {
            __indexData.numIndices = value;
            __indexSyncRequired = true;
            setRequiresRedraw();
        }
        return value;
    }

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
    private function get_batchable():Bool { return __batchable; }
    private function set_batchable(value:Bool):Bool
    {
        if (__batchable != value)
        {
            __batchable = value;
            setRequiresRedraw();
        }
        return value;
    }
}
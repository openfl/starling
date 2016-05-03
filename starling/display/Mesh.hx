// =================================================================================================
//
//  Starling Framework
//  Copyright Gamua GmbH. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

package starling.display;
import flash.geom.Point;
import flash.geom.Rectangle;
import openfl.errors.ArgumentError;

#if 0
import starling.core.starling_internal;
#end
import starling.rendering.IndexData;
import starling.rendering.Painter;
import starling.rendering.VertexData;
import starling.rendering.VertexDataFormat;
import starling.styles.MeshStyle;
import starling.textures.Texture;
import starling.utils.MatrixUtil;
import starling.utils.MeshUtil;

#if 0
use namespace starling_internal;
#end

/** The base class for all tangible (non-container) display objects, spawned up by a number
 *  of triangles.
 *
 *  <p>Since Starling uses Stage3D for rendering, all rendered objects must be constructed
 *  from triangles. A mesh stores the information of its triangles through VertexData and
 *  IndexData structures. The default format stores position, color and texture coordinates
 *  for each vertex.</p>
 *
 *  <p>How a mesh is rendered depends on its style. Per default, this is an instance
 *  of the <code>MeshStyle</code> base class; however, subclasses may extend its behavior
 *  to add support for color transformations, normal mapping, etc.</p>
 *
 *  @see MeshBatch
 *  @see starling.styles.MeshStyle
 *  @see starling.rendering.VertexData
 *  @see starling.rendering.IndexData
 */
class Mesh extends DisplayObject
{
    /** @private */ private var _style:MeshStyle;
    /** @private */ private var _vertexData:VertexData;
    /** @private */ private var _indexData:IndexData;
    /** @private */ private var _pixelSnapping:Bool;

    private static var sDefaultStyle:Class<MeshStyle> = MeshStyle;

    /** Creates a new mesh with the given vertices and indices.
     *  If you don't pass a style, an instance of <code>MeshStyle</code> will be created
     *  for you. Note that the format of the vertex data will be matched to the
     *  given style right away. */
    public function new(vertexData:VertexData, indexData:IndexData, style:MeshStyle=null)
    {
        super();
        if (vertexData == null) throw new ArgumentError("VertexData must not be null");
        if (indexData == null)  throw new ArgumentError("IndexData must not be null");

        _vertexData = vertexData;
        _indexData = indexData;

        setStyle(style, false);
        
        _pixelSnapping = false;
    }

    /** @inheritDoc */
    override public function dispose():Void
    {
        _vertexData.clear();
        _indexData.clear();

        super.dispose();
    }

    /** @inheritDoc */
    override public function hitTest(localPoint:Point):DisplayObject
    {
        if (!visible || !touchable || !hitTestMask(localPoint)) return null;
        else return MeshUtil.containsPoint(_vertexData, _indexData, localPoint) ? this : null;
    }

    /** @inheritDoc */
    override public function getBounds(targetSpace:DisplayObject, out:Rectangle=null):Rectangle
    {
        return MeshUtil.calculateBounds(_vertexData, this, targetSpace, out);
    }

    /** @inheritDoc */
    override public function render(painter:Painter):Void
    {
        if (_pixelSnapping)
            MatrixUtil.snapToPixels(painter.state.modelviewMatrix, painter.pixelSize);

        painter.batchMesh(this);
    }

    /** Sets the style that is used to render the mesh. Styles (which are always subclasses of
     *  <code>MeshStyle</code>) provide a means to completely modify the way a mesh is rendered.
     *  For example, they may add support for color transformations or normal mapping.
     *
     *  <p>When assigning a new style, the vertex format will be changed to fit it.
     *  Do not use the same style instance on multiple objects! Instead, make use of
     *  <code>style.clone()</code> to assign an identical style to multiple meshes.</p>
     *
     *  @param meshStyle             the style to assign. If <code>null</code>, an instance of
     *                               a standard <code>MeshStyle</code> will be created.
     *  @param mergeWithPredecessor  if enabled, all attributes of the previous style will be
     *                               be copied to the new one, if possible.
     */
    public function setStyle(meshStyle:MeshStyle=null, mergeWithPredecessor:Bool=true):Void
    {
        if (meshStyle == null) meshStyle = Type.createInstance(sDefaultStyle, []);
        else if (meshStyle == _style) return;
        else if (meshStyle.target != null) meshStyle.target.setStyle();

        if (_style != null)
        {
            if (mergeWithPredecessor) meshStyle.copyFrom(_style);
            _style.setTarget(null);
        }

        _style = meshStyle;
        _style.setTarget(this, _vertexData, _indexData);
    }

    // vertex manipulation

    /** The position of the vertex at the specified index, in the mesh's local coordinate
     *  system.
     *
     *  <p>Only modify the position of a vertex if you know exactly what you're doing, as
     *  some classes might not work correctly when their vertices are moved. E.g. the
     *  <code>Quad</code> class expects its vertices to spawn up a perfectly rectangular
     *  area; some of its optimized methods won't work correctly if that premise is no longer
     *  fulfilled or the original bounds change.</p>
     */
    public function getVertexPosition(vertexID:Int, out:Point=null):Point
    {
        return _style.getVertexPosition(vertexID, out);
    }

    public function setVertexPosition(vertexID:Int, x:Float, y:Float):Void
    {
        _style.setVertexPosition(vertexID, x, y);
    }

    /** Returns the alpha value of the vertex at the specified index. */
    public function getVertexAlpha(vertexID:Int):Float
    {
        return _style.getVertexAlpha(vertexID);
    }

    /** Sets the alpha value of the vertex at the specified index to a certain value. */
    public function setVertexAlpha(vertexID:Int, alpha:Float):Void
    {
        _style.setVertexAlpha(vertexID, alpha);
    }

    /** Returns the RGB color of the vertex at the specified index. */
    public function getVertexColor(vertexID:Int):UInt
    {
        return _style.getVertexColor(vertexID);
    }

    /** Sets the RGB color of the vertex at the specified index to a certain value. */
    public function setVertexColor(vertexID:Int, color:UInt):Void
    {
        _style.setVertexColor(vertexID, color);
    }

    /** Returns the texture coordinates of the vertex at the specified index. */
    public function getTexCoords(vertexID:Int, out:Point = null):Point
    {
        return _style.getTexCoords(vertexID, out);
    }

    /** Sets the texture coordinates of the vertex at the specified index to the given values. */
    public function setTexCoords(vertexID:Int, u:Float, v:Float):Void
    {
        _style.setTexCoords(vertexID, u, v);
    }

    // properties

    /** The vertex data describing all vertices of the mesh.
     *  Any change requires a call to <code>setRequiresRedraw</code>. */
    private var vertexData(get, never):VertexData;
    private function get_vertexData():VertexData { return _vertexData; }

    /** The index data describing how the vertices are interconnected.
     *  Any change requires a call to <code>setRequiresRedraw</code>. */
    private var indexData(get, never):IndexData;
    private function get_indexData():IndexData { return _indexData; }

    /** The style that is used to render the mesh. Styles (which are always subclasses of
     *  <code>MeshStyle</code>) provide a means to completely modify the way a mesh is rendered.
     *  For example, they may add support for color transformations or normal mapping.
     *
     *  <p>The setter will simply forward the assignee to <code>setStyle(value)</code>.</p>
     *
     *  @default MeshStyle
     */
    public var style(get, set):MeshStyle;
    @:noCompletion private function get_style():MeshStyle { return _style; }
    @:noCompletion private function set_style(value:MeshStyle):MeshStyle
    {
        setStyle(value);
        return value;
    }

    /** The texture that is mapped to the mesh (or <code>null</code>, if there is none). */
    public var texture(get, set):Texture;
    @:noCompletion private function get_texture():Texture { return _style.texture; }
    @:noCompletion private function set_texture(value:Texture):Texture { return _style.texture = value; }

    /** Changes the color of all vertices to the same value.
     *  The getter simply returns the color of the first vertex. */
    public var color(get, set):UInt;
    @:noCompletion private function get_color():UInt { return _style.color; }
    @:noCompletion private function set_color(value:UInt):UInt { return _style.color = value; }

    /** The smoothing filter that is used for the texture.
     *  @default bilinear */
    public var textureSmoothing(get, set):String;
    @:noCompletion private function get_textureSmoothing():String { return _style.textureSmoothing; }
    @:noCompletion private function set_textureSmoothing(value:String):String { return _style.textureSmoothing = value; }

    /** Indicates if pixels at the edges will be repeated or clamped. Only works for
     *  power-of-two textures; for a solution that works with all kinds of textures,
     *  see <code>Image.tileGrid</code>. @default false */
    public var textureRepeat(get, set):Bool;
    @:noCompletion private function get_textureRepeat():Bool { return _style.textureRepeat; }
    @:noCompletion private function set_textureRepeat(value:Bool):Bool { return _style.textureRepeat = value; }

    /** Controls whether or not the instance snaps to the nearest pixel. This can prevent the
     *  object from looking blurry when it's not exactly aligned with the pixels of the screen.
     *  @default false */
    public var pixelSnapping (get, set):Bool;
    @:noCompletion private function get_pixelSnapping():Bool { return _pixelSnapping; }
    @:noCompletion private function set_pixelSnapping(value:Bool):Bool { return _pixelSnapping = value; }

    /** The total number of vertices in the mesh. */
    public var numVertices(get, set):Int;
    @:noCompletion private function get_numVertices():Int { return _vertexData.numVertices; }
    @:noCompletion private function set_numVertices(value:Int):Int { return _vertexData.numVertices = value; }

    /** The total number of indices referencing vertices. */
    public var numIndices(get, set):Int;
    @:noCompletion private function get_numIndices():Int { return _indexData.numIndices; }
    @:noCompletion private function set_numIndices(value:Int):Int { return _indexData.numIndices = value; }

    /** The total number of triangles in this mesh.
     *  (In other words: the number of indices divided by three.) */
    public var numTriangles(get, set):Int;
    @:noCompletion private function get_numTriangles():Int { return _indexData.numTriangles; }
    @:noCompletion private function set_numTriangles(value):Int { return _indexData.numTriangles = value; }

    /** The format used to store the vertices. */
    public var vertexFormat(get, never):VertexDataFormat;
    @:noCompletion private function get_vertexFormat():VertexDataFormat { return _style.vertexFormat; }

    // static properties

    /** The default style used for meshes if no specific style is provided. The default is
     *  <code>starling.rendering.MeshStyle</code>, and any assigned class must be a subclass
     *  of the same. */
    public static var defaultStyle(get, set):Class<MeshStyle>;
    @:noCompletion private static function get_defaultStyle():Class<MeshStyle> { return sDefaultStyle; }
    @:noCompletion private static function set_defaultStyle(value:Class<MeshStyle>):Class<MeshStyle>
    {
        return sDefaultStyle = value;
    }
}

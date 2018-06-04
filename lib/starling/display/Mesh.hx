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

import openfl.errors.ArgumentError;
import openfl.geom.Point;
import openfl.geom.Rectangle;

import starling.geom.Polygon;
import starling.rendering.IndexData;
import starling.rendering.Painter;
import starling.rendering.VertexData;
import starling.rendering.VertexDataFormat;
import starling.styles.MeshStyle;
import starling.textures.Texture;
import starling.utils.MatrixUtil;
import starling.utils.MeshUtil;

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

@:jsRequire("starling/display/Mesh", "default")

extern class Mesh extends DisplayObject
{
    /** Creates a new mesh with the given vertices and indices.
     *  If you don't pass a style, an instance of <code>MeshStyle</code> will be created
     *  for you. Note that the format of the vertex data will be matched to the
     *  given style right away. */
    public function new(vertexData:VertexData, indexData:IndexData, style:MeshStyle=null);

    /** @inheritDoc */
    override public function dispose():Void;

    /** @inheritDoc */
    override public function hitTest(localPoint:Point):DisplayObject;

    /** @inheritDoc */
    override public function getBounds(targetSpace:DisplayObject, out:Rectangle=null):Rectangle;

    /** @inheritDoc */
    override public function render(painter:Painter):Void;

    /** Sets the style that is used to render the mesh. Styles (which are always subclasses of
     *  <code>MeshStyle</code>) provide a means to completely modify the way a mesh is rendered.
     *  For example, they may add support for color transformations or normal mapping.
     *
     *  <p>When assigning a new style, the vertex format will be changed to fit it.
     *  Do not use the same style instance on multiple objects! Instead, make use of
     *  <code>style.clone()</code> to assign an identical style to multiple meshes.</p>
     *
     *  @param meshStyle             the style to assign. If <code>null</code>, the default
     *                               style will be created.
     *  @param mergeWithPredecessor  if enabled, all attributes of the previous style will be
     *                               be copied to the new one, if possible.
     *  @see #defaultStyle
     *  @see #defaultStyleFactory
     */
    public function setStyle(meshStyle:MeshStyle=null, mergeWithPredecessor:Bool=true):Void;

    /** This method is called whenever the mesh's vertex data was changed.
     *  The base implementation simply forwards to <code>setRequiresRedraw</code>. */
    public function setVertexDataChanged():Void;

    /** This method is called whenever the mesh's index data was changed.
     *  The base implementation simply forwards to <code>setRequiresRedraw</code>. */
    public function setIndexDataChanged():Void;

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
    public function getVertexPosition(vertexID:Int, out:Point=null):Point;

    public function setVertexPosition(vertexID:Int, x:Float, y:Float):Void;

    /** Returns the alpha value of the vertex at the specified index. */
    public function getVertexAlpha(vertexID:Int):Float;

    /** Sets the alpha value of the vertex at the specified index to a certain value. */
    public function setVertexAlpha(vertexID:Int, alpha:Float):Void;

    /** Returns the RGB color of the vertex at the specified index. */
    public function getVertexColor(vertexID:Int):UInt;

    /** Sets the RGB color of the vertex at the specified index to a certain value. */
    public function setVertexColor(vertexID:Int, color:UInt):Void;

    /** Returns the texture coordinates of the vertex at the specified index. */
    public function getTexCoords(vertexID:Int, out:Point = null):Point;

    /** Sets the texture coordinates of the vertex at the specified index to the given values. */
    public function setTexCoords(vertexID:Int, u:Float, v:Float):Void;

    // properties

    /** The vertex data describing all vertices of the mesh.
     *  Any change requires a call to <code>setRequiresRedraw</code>. */
    private var vertexData(get, never):VertexData;
    private function get_vertexData():VertexData;

    /** The index data describing how the vertices are interconnected.
     *  Any change requires a call to <code>setRequiresRedraw</code>. */
    private var indexData(get, never):IndexData;
    private function get_indexData():IndexData;

    /** The style that is used to render the mesh. Styles (which are always subclasses of
     *  <code>MeshStyle</code>) provide a means to completely modify the way a mesh is rendered.
     *  For example, they may add support for color transformations or normal mapping.
     *  Beware: a style instance may only be used on one mesh at a time.
     *
     *  @default MeshStyle
     *  @see #setStyle()
     */
    public var style(get, set):MeshStyle;
    private function get_style():MeshStyle;
    private function set_style(value:MeshStyle):MeshStyle;

    /** The texture that is mapped to the mesh (or <code>null</code>, if there is none). */
    public var texture(get, set):Texture;
    private function get_texture():Texture;
    private function set_texture(value:Texture):Texture;

    /** Changes the color of all vertices to the same value.
     *  The getter simply returns the color of the first vertex. */
    public var color(get, set):UInt;
    private function get_color():UInt;
    private function set_color(value:UInt):UInt;

    /** The smoothing filter that is used for the texture.
     *  @default bilinear */
    public var textureSmoothing(get, set):String;
    private function get_textureSmoothing():String;
    private function set_textureSmoothing(value:String):String;

    /** Indicates if pixels at the edges will be repeated or clamped. Only works for
     *  power-of-two textures; for a solution that works with all kinds of textures,
     *  see <code>Image.tileGrid</code>. @default false */
    public var textureRepeat(get, set):Bool;
    private function get_textureRepeat():Bool;
    private function set_textureRepeat(value:Bool):Bool;

    /** Controls whether or not the instance snaps to the nearest pixel. This can prevent the
     *  object from looking blurry when it's not exactly aligned with the pixels of the screen.
     *  @default false */
    public var pixelSnapping(get, set):Bool;
    private function get_pixelSnapping():Bool;
    private function set_pixelSnapping(value:Bool):Bool;

    /** The total number of vertices in the mesh. */
    public var numVertices(get, never):Int;
    private function get_numVertices():Int;

    /** The total number of indices referencing vertices. */
    public var numIndices(get, never):Int;
    private function get_numIndices():Int;

    /** The total number of triangles in this mesh.
     *  (In other words: the number of indices divided by three.) */
    public var numTriangles(get, never):Int;
    private function get_numTriangles():Int;

    /** The format used to store the vertices. */
    public var vertexFormat(get, never):VertexDataFormat;
    private function get_vertexFormat():VertexDataFormat;

    // static properties

    /** The default style used for meshes if no specific style is provided. The default is
     *  <code>starling.rendering.MeshStyle</code>, and any assigned class must be a subclass
     *  of the same. */
    public static var defaultStyle(get, set):Class<Dynamic>;
    private static function get_defaultStyle():Class<Dynamic>;
    private static function set_defaultStyle(value:Class<Dynamic>):Class<Dynamic>;

    /** A factory method that is used to create the 'MeshStyle' for a mesh if no specific
     *  style is provided. That's useful if you are creating a hierarchy of objects, all
     *  of which need to have a certain style. Different to the <code>defaultStyle</code>
     *  property, this method allows plugging in custom logic and passing arguments to the
     *  constructor. Return <code>null</code> to fall back to the default behavior (i.e.
     *  to instantiate <code>defaultStyle</code>). The <code>mesh</code>-parameter is optional
     *  and may be omitted.
     *
     *  <listing>
     *  Mesh.defaultStyleFactory = function(mesh:Mesh):MeshStyle
     *  {
     *      return new ColorizeMeshStyle(Math.random() * 0xffffff);
     *  }</listing>
     */
    public static var defaultStyleFactory(get, set):?Mesh->MeshStyle;
    private static function get_defaultStyleFactory():?Mesh->MeshStyle;
    private static function set_defaultStyleFactory(value:?Mesh->MeshStyle):?Mesh->MeshStyle;

    // static methods

    /** Creates a mesh from the specified polygon.
     *  Vertex positions and indices will be set up according to the polygon;
     *  any other vertex attributes (e.g. texture coordinates) need to be set up manually.
     */
    public static function fromPolygon(polygon:Polygon, style:MeshStyle=null):Mesh;
}
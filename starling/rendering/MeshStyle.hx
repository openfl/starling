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
import flash.geom.Matrix;
import flash.geom.Point;

#if 0
import starling.core.starling_internal;
#end
import starling.display.Mesh;
import starling.events.Event;
import starling.events.EventDispatcher;
import starling.textures.Texture;
import starling.textures.TextureSmoothing;

/** Dispatched every frame on styles assigned to display objects connected to the stage. */
#if 0
[Event(name="enterFrame", type="starling.events.EnterFrameEvent")]
#end

/** MeshStyles provide a means to completely modify the way a mesh is rendered.
 *  The base class provides Starling's standard mesh rendering functionality: colored and
 *  (optionally) textured meshes. Subclasses may add support for additional features like
 *  color transformations, normal mapping, etc.
 *
 *  <p><strong>Using styles</strong></p>
 *
 *  <p>First, create an instance of the desired style. Configure the style by updating its
 *  properties, then assign it to the mesh. Here is an example that uses a fictitious
 *  <code>ColorStyle</code>:</p>
 *
 *  <listing>
 *  var image:Image = new Image(heroTexture);
 *  var colorStyle:ColorStyle = new ColorStyle();
 *  colorStyle.redOffset = 0.5;
 *  colorStyle.redMultiplier = 2.0;
 *  image.style = colorStyle;</listing>
 *
 *  <p>Beware:</p>
 *
 *  <ul>
 *    <li>A style instance may only be used on one object at a time.</li>
 *    <li>A style might require the use of a specific vertex format;
 *        when the style is assigned, the mesh is converted to that format.</li>
 *  </ul>
 *
 *  <p><strong>Creating your own styles</strong></p>
 *
 *  <p>To create custom rendering code in Starling, you need to extend two classes:
 *  <code>MeshStyle</code> and <code>MeshEffect</code>. While the effect class contains
 *  the actual AGAL rendering code, the style provides the API that other developers will
 *  interact with.</p>
 *
 *  <p>Subclasses of <code>MeshStyle</code> will add specific properties that configure the
 *  style's outcome, like the <code>redOffset</code> and <code>redMultiplier</code> properties
 *  in the sample above. Here's how to properly create such a class:</p>
 *
 *  <ul>
 *    <li>Always provide a constructor that can be called without any arguments.</li>
 *    <li>Override <code>copyFrom</code> — that's necessary for batching.</li>
 *    <li>Override <code>createEffect</code> — this method must return the
 *        <code>MeshEffect</code> that will do the actual Stage3D rendering.</li>
 *    <li>Override <code>updateEffect</code> — this configures the effect created above
 *        right before rendering.</li>
 *    <li>Override <code>canBatchWith</code> if necessary — this method figures out if one
 *        instance of the style can be batched with another. If they all can, you can leave
 *        this out.</li>
 *  </ul>
 *
 *  <p>If the style requires a custom vertex format, you must also:</p>
 *
 *  <ul>
 *    <li>add a static constant called <code>VERTEX_FORMAT</code> to the class and</li>
 *    <li>override <code>get vertexFormat</code> and let it return exactly that format.</li>
 *  </ul>
 *
 *  <p>When that's done, you can turn to the implementation of your <code>MeshEffect</code>;
 *  the <code>createEffect</code>-override will return an instance of this class.
 *  Directly before rendering begins, Starling will then call <code>updateEffect</code>
 *  to set it up.</p>
 *
 *  @see MeshEffect
 *  @see VertexDataFormat
 *  @see starling.display.Mesh
 */
class MeshStyle extends EventDispatcher
{
    /** The vertex format expected by this style (the same as found in the MeshEffect-class). */
    public static var VERTEX_FORMAT:VertexDataFormat = MeshEffect.VERTEX_FORMAT;

    private var _type:Class<MeshStyle>;
    private var _target:Mesh;
    private var _texture:Texture;
    private var _textureSmoothing:String;
    private var _vertexData:VertexData;   // just a reference to the target's vertex data
    private var _indexData:IndexData;     // just a reference to the target's index data

    // helper objects
    private static var sPoint:Point = new Point();

    /** Creates a new MeshStyle instance.
     *  Subclasses must provide a constructor that can be called without any arguments. */
    public function new()
    {
        super();
        _textureSmoothing = TextureSmoothing.BILINEAR;
        _type = Type.getClass(this);
    }

    /** Copies all properties of the given style to the current instance (or a subset, if the
     *  classes don't match). Must be overridden by all subclasses!
     */
    public function copyFrom(meshStyle:MeshStyle):Void
    {
        _texture = meshStyle._texture;
        _textureSmoothing = meshStyle._textureSmoothing;
    }

    /** Creates a clone of this instance. The method will work for subclasses automatically,
     *  no need to override it. */
    public function clone():MeshStyle
    {
        var clone:MeshStyle = Type.createInstance(type, []);
        clone.copyFrom(this);
        return clone;
    }

    /** Creates the effect that does the actual, low-level rendering.
     *  To be overridden by subclasses!
     */
    public function createEffect():MeshEffect
    {
        return new MeshEffect();
    }

    /** Updates the settings of the given effect to match the current style.
     *  The given <code>effect</code> will always match the class returned by
     *  <code>createEffect</code>.
     *
     *  <p>To be overridden by subclasses!</p>
     */
    public function updateEffect(effect:MeshEffect, state:RenderState):Void
    {
        effect.texture = _texture;
        effect.textureSmoothing = _textureSmoothing;
        effect.mvpMatrix3D = state.mvpMatrix3D;
        effect.alpha = state.alpha;
    }

    /** Indicates if the current instance can be batched with the given style.
     *  To be overridden by subclasses if default behavior is not sufficient.
     *  The base implementation just checks if the styles are of the same type
     *  and if the textures are compatible.
     */
    public function canBatchWith(meshStyle:MeshStyle):Bool
    {
        if (_type == meshStyle._type)
        {
            var newTexture:Texture = meshStyle._texture;

            if (_texture == null && newTexture == null) return true;
            else if (_texture != null && newTexture != null)
                return _texture.base == newTexture.base &&
                       _textureSmoothing == meshStyle._textureSmoothing;
            else return false;
        }
        else return false;
    }

    /** Copies the vertex data of the style's current target to the target of another style.
     *  If you pass a matrix, all vertices will be transformed during the process.
     *
     *  <p>This method is used when batching meshes together for rendering. The parameter
     *  <code>targetStyle</code> will point to the style of a <code>MeshBatch</code> (a
     *  subclass of <code>Mesh</code>). Subclasses may override this method if they need
     *  to modify the vertex data in that process.</p>
     */
    public function batchVertexData(targetStyle:MeshStyle, targetVertexID:Int=0,
                                    matrix:Matrix=null, vertexID:Int=0, numVertices:Int=-1):Void
    {
        _vertexData.copyTo(targetStyle._vertexData, targetVertexID, matrix, vertexID, numVertices);
    }

    /** Copies the index data of the style's current target to the target of another style.
     *  The given offset value will be added to all indices during the process.
     *
     *  <p>This method is used when batching meshes together for rendering. The parameter
     *  <code>targetStyle</code> will point to the style of a <code>MeshBatch</code> (a
     *  subclass of <code>Mesh</code>). Subclasses may override this method if they need
     *  to modify the index data in that process.</p>
     */
    public function batchIndexData(targetStyle:MeshStyle, targetIndexID:Int=0, offset:Int=0,
                                   indexID:Int=0, numIndices:Int=-1):Void
    {
        _indexData.copyTo(targetStyle._indexData, targetIndexID, offset, indexID, numIndices);
    }

    /** Call this method if the target needs to be redrawn.
     *  The call is simply forwarded to the mesh. */
    private function setRequiresRedraw():Void
    {
        if (_target != null) _target.setRequiresRedraw();
    }

    /** Called when assigning a target mesh. Override to plug in class-specific logic. */
    private function onTargetAssigned(target:Mesh):Void
    { }

    // enter frame event

    override public function addEventListener(type:String, listener:Dynamic):Void
    {
        if (type == Event.ENTER_FRAME && _target != null)
            _target.addEventListener(Event.ENTER_FRAME, onEnterFrame);

        super.addEventListener(type, listener);
    }

    override public function removeEventListener(type:String, listener:Dynamic):Void
    {
        if (type == Event.ENTER_FRAME && _target != null)
            _target.removeEventListener(type, onEnterFrame);

        super.removeEventListener(type, listener);
    }

    private function onEnterFrame(event:Event):Void
    {
        dispatchEvent(event);
    }

    // internal methods

    /** @private */
    public function setTarget(target:Mesh=null, vertexData:VertexData=null,
                                         indexData:IndexData=null):Void
    {
        if (_target != target)
        {
            if (_target != null) _target.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
            if (vertexData != null) vertexData.format = vertexFormat;

            _target = target;
            _vertexData = vertexData;
            _indexData = indexData;

            if (target != null)
            {
                if (hasEventListener(Event.ENTER_FRAME))
                    target.addEventListener(Event.ENTER_FRAME, onEnterFrame);

                onTargetAssigned(target);
            }
        }
    }

    // vertex manipulation

    /** Returns the alpha value of the vertex at the specified index. */
    public function getVertexAlpha(vertexID:Int):Float
    {
        return _vertexData.getAlpha(vertexID);
    }

    /** Sets the alpha value of the vertex at the specified index to a certain value. */
    public function setVertexAlpha(vertexID:Int, alpha:Float):Void
    {
        _vertexData.setAlpha(vertexID, "color", alpha);
        setRequiresRedraw();
    }

    /** Returns the RGB color of the vertex at the specified index. */
    public function getVertexColor(vertexID:Int):UInt
    {
        return _vertexData.getColor(vertexID);
    }

    /** Sets the RGB color of the vertex at the specified index to a certain value. */
    public function setVertexColor(vertexID:Int, color:UInt):Void
    {
        _vertexData.setColor(vertexID, "color", color);
        setRequiresRedraw();
    }

    /** Returns the texture coordinates of the vertex at the specified index. */
    public function getTexCoords(vertexID:Int, out:Point = null):Point
    {
        if (_texture != null) return _texture.getTexCoords(_vertexData, vertexID, "texCoords", out);
        else return _vertexData.getPoint(vertexID, "texCoords", out);
    }

    /** Sets the texture coordinates of the vertex at the specified index to the given values. */
    public function setTexCoords(vertexID:Int, u:Float, v:Float):Void
    {
        if (_texture != null) _texture.setTexCoords(_vertexData, vertexID, "texCoords", u, v);
        else _vertexData.setPoint(vertexID, "texCoords", u, v);

        setRequiresRedraw();
    }

    // properties

    /** Returns a reference to the vertex data of the assigned target (or <code>null</code>
     *  if there is no target). Beware: the style itself does not own any vertices;
     *  it is limited to manipulating those of the target mesh. */
    private var vertexData(get, never):VertexData;
    @:noCompletion private function get_vertexData():VertexData { return _vertexData; }

    /** Returns a reference to the index data of the assigned target (or <code>null</code>
     *  if there is no target). Beware: the style itself does not own any indices;
     *  it is limited to manipulating those of the target mesh. */
    private var indexData(get, never):IndexData;
    @:noCompletion private function get_indexData():IndexData { return _indexData; }

    /** The actual class of this style. */
    public var type(get, never):Class<MeshStyle>;
    @:noCompletion private function get_type():Class<MeshStyle> { return _type; }

    /** Changes the color of all vertices to the same value.
     *  The getter simply returns the color of the first vertex. */
    public var color(get, set):UInt;
    @:noCompletion private function get_color():UInt
    {
        if (_vertexData.numVertices > 0) return _vertexData.getColor(0);
        else return 0x0;
    }

    @:noCompletion private function set_color(value:UInt):UInt
    {
        #if 0
        var i:Int;
        #end
        var numVertices:Int = _vertexData.numVertices;

        for (i in 0 ... numVertices)
            _vertexData.setColor(i, "color", value);

        setRequiresRedraw();
        return value;
    }

    /** The format used to store the vertices. */
    public var vertexFormat(get, never):VertexDataFormat;
    @:noCompletion private function get_vertexFormat():VertexDataFormat
    {
        return VERTEX_FORMAT;
    }

    /** The texture that is mapped to the mesh (or <code>null</code>, if there is none). */
    public var texture(get, set):Texture;
    @:noCompletion private function get_texture():Texture { return _texture; }
    @:noCompletion private function set_texture(value:Texture):Texture
    {
        if (value != _texture)
        {
            if (value != null)
            {
                var i:Int;
                var numVertices:Int = _vertexData != null ? _vertexData.numVertices : 0;

                for (i in 0 ... numVertices)
                {
                    getTexCoords(i, sPoint);
                    value.setTexCoords(_vertexData, i, "texCoords", sPoint.x, sPoint.y);
                }
            }

            _texture = value;
            setRequiresRedraw();
        }
        return value;
    }

    /** The smoothing filter that is used for the texture. @default bilinear */
    public var textureSmoothing(get, set):String;
    @:noCompletion private function get_textureSmoothing():String { return _textureSmoothing; }
    @:noCompletion private function set_textureSmoothing(value:String):String
    {
        if (value != _textureSmoothing)
        {
            _textureSmoothing = value;
            setRequiresRedraw();
        }
        return value;
    }

    /** The target the style is currently assigned to. */
    public var target(get, never):Mesh;
    @:noCompletion private function get_target():Mesh { return _target; }
}

// =================================================================================================
//
//	Starling Framework
//	Copyright Gamua GmbH. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

package starling.filters;

import openfl.display.BitmapDataChannel;
import openfl.display3D.Context3D;
import openfl.display3D.Context3DProgramType;
import openfl.geom.Matrix3D;
import openfl.geom.Rectangle;
import openfl.Vector;

import starling.core.Starling;
import starling.display.Stage;
import starling.rendering.FilterEffect;
import starling.rendering.Painter;
import starling.rendering.Program;
import starling.rendering.VertexDataFormat;
import starling.textures.Texture;
import starling.utils.RenderUtil;

/** The DisplacementMapFilter class uses the pixel values from the specified texture (called
 *  the map texture) to perform a displacement of an object. You can use this filter
 *  to apply a warped or mottled effect to any object that inherits from the DisplayObject
 *  class.
 *
 *  <p>The filter uses the following formula:</p>
 *  <listing>dstPixel[x, y] = srcPixel[x + ((componentX(x, y) - 128) &#42; scaleX) / 256,
 *                      y + ((componentY(x, y) - 128) &#42; scaleY) / 256]
 *  </listing>
 *
 *  <p>Where <code>componentX(x, y)</code> gets the componentX property color value from the
 *  map texture at <code>(x - mapX, y - mapY)</code>.</p>
 *
 *  <strong>Clamping to the Edges</strong>
 *
 *  <p>Per default, the filter allows the object to grow beyond its actual bounds to make
 *  room for the displacement (depending on <code>scaleX/Y</code>). If you want to clamp the
 *  displacement to the actual object bounds, set all margins to zero via a call to
 *  <code>filter.padding.setTo()</code>. This works only with rectangular, stage-aligned
 *  objects, though.</p>
 */
class DisplacementMapFilter extends FragmentFilter
{
    private var _mapX:Float;
    private var _mapY:Float;

    // helpers
    private static var sBounds:Rectangle = new Rectangle();

    #if commonjs
    private static function __init__ () {
        
        untyped Object.defineProperties (DisplacementMapFilter.prototype, {
            "componentX": { get: untyped __js__ ("function () { return this.get_componentX (); }"), set: untyped __js__ ("function (v) { return this.set_componentX (v); }") },
            "componentY": { get: untyped __js__ ("function () { return this.get_componentY (); }"), set: untyped __js__ ("function (v) { return this.set_componentY (v); }") },
            "scaleX": { get: untyped __js__ ("function () { return this.get_scaleX (); }"), set: untyped __js__ ("function (v) { return this.set_scaleX (v); }") },
            "scaleY": { get: untyped __js__ ("function () { return this.get_scaleY (); }"), set: untyped __js__ ("function (v) { return this.set_scaleY (v); }") },
            "mapX": { get: untyped __js__ ("function () { return this.get_mapX (); }"), set: untyped __js__ ("function (v) { return this.set_mapX (v); }") },
            "mapY": { get: untyped __js__ ("function () { return this.get_mapY (); }"), set: untyped __js__ ("function (v) { return this.set_mapY (v); }") },
            "mapTexture": { get: untyped __js__ ("function () { return this.get_mapTexture (); }"), set: untyped __js__ ("function (v) { return this.set_mapTexture (v); }") },
            "mapRepeat": { get: untyped __js__ ("function () { return this.get_mapRepeat (); }"), set: untyped __js__ ("function (v) { return this.set_mapRepeat (v); }") },
        });
        
    }
    #end

    /** Creates a new displacement map filter that uses the provided map texture. */
    public function new(mapTexture:Texture,
                        componentX:UInt=0, componentY:UInt=0,
                        scaleX:Float=0.0, scaleY:Float=0.0)
    {
        super();
        
        _mapX = _mapY = 0;

        this.mapTexture = mapTexture;
        this.componentX = componentX;
        this.componentY = componentY;
        this.scaleX = scaleX;
        this.scaleY = scaleY;
    }

    /** @private */
    override public function process(painter:Painter, pool:IFilterHelper,
                                     input0:Texture = null, input1:Texture = null,
                                     input2:Texture = null, input3:Texture = null):Texture
    {
        var offsetX:Float = 0.0, offsetY:Float = 0.0;
        var targetBounds:Rectangle = pool.targetBounds;
        var stage:Stage = pool.target.stage;

        if (stage != null && (targetBounds.x < 0 || targetBounds.y < 0))
        {
            // 'targetBounds' is actually already intersected with the stage bounds.
            // If the target is partially outside the stage at the left or top, we need
            // to adjust the map coordinates accordingly. That's what 'offsetX/Y' is for.

            pool.target.getBounds(stage, sBounds);
            sBounds.inflate(padding.left, padding.top);
            offsetX = sBounds.x - pool.targetBounds.x;
            offsetY = sBounds.y - pool.targetBounds.y;
        }

        updateVertexData(input0, mapTexture, offsetX, offsetY);
        return super.process(painter, pool, input0);
    }

    /** @private */
    override private function createEffect():FilterEffect
    {
        return new DisplacementMapEffect();
    }

    private function updateVertexData(inputTexture:Texture, mapTexture:Texture,
                                      mapOffsetX:Float=0.0, mapOffsetY:Float=0.0):Void
    {
        // The size of input texture and map texture may be different. We need to calculate
        // the right values for the texture coordinates at the filter vertices.

        var mapX:Float = (_mapX + mapOffsetX + padding.left) / mapTexture.width;
        var mapY:Float = (_mapY + mapOffsetY + padding.top)  / mapTexture.height;
        var maxU:Float = inputTexture.width  / mapTexture.width;
        var maxV:Float = inputTexture.height / mapTexture.height;

        mapTexture.setTexCoords(vertexData, 0, "mapTexCoords", -mapX, -mapY);
        mapTexture.setTexCoords(vertexData, 1, "mapTexCoords", -mapX + maxU, -mapY);
        mapTexture.setTexCoords(vertexData, 2, "mapTexCoords", -mapX, -mapY + maxV);
        mapTexture.setTexCoords(vertexData, 3, "mapTexCoords", -mapX + maxU, -mapY + maxV);
    }

    private function updatePadding():Void
    {
        var paddingX:Float = Math.ceil(Math.abs(dispEffect.scaleX) / 2);
        var paddingY:Float = Math.ceil(Math.abs(dispEffect.scaleY) / 2);

        padding.setTo(paddingX, paddingX, paddingY, paddingY);
    }

    // properties

    /** Describes which color channel to use in the map image to displace the x result.
     *  Possible values are constants from the BitmapDataChannel class. */
    public var componentX(get, set):UInt;
    private function get_componentX():UInt { return dispEffect.componentX; }
    private function set_componentX(value:UInt):UInt
    {
        if (dispEffect.componentX != value)
        {
            dispEffect.componentX = value;
            setRequiresRedraw();
        }
        return value;
    }

    /** Describes which color channel to use in the map image to displace the y result.
     *  Possible values are constants from the BitmapDataChannel class. */
    public var componentY(get, set):UInt;
    private function get_componentY():UInt { return dispEffect.componentY; }
    private function set_componentY(value:UInt):UInt
    {
        if (dispEffect.componentY != value)
        {
            dispEffect.componentY = value;
            setRequiresRedraw();
        }
        return value;
    }

    /** The multiplier used to scale the x displacement result from the map calculation. */
    public var scaleX(get, set):Float;
    private function get_scaleX():Float { return dispEffect.scaleX; }
    private function set_scaleX(value:Float):Float
    {
        if (dispEffect.scaleX != value)
        {
            dispEffect.scaleX = value;
            updatePadding();
        }
        return value;
    }

    /** The multiplier used to scale the y displacement result from the map calculation. */
    public var scaleY(get, set):Float;
    private function get_scaleY():Float { return dispEffect.scaleY; }
    private function set_scaleY(value:Float):Float
    {
        if (dispEffect.scaleY != value)
        {
            dispEffect.scaleY = value;
            updatePadding();
        }
        return value;
    }

    /** The horizontal offset of the map texture relative to the origin. @default 0 */
    public var mapX(get, set):Float;
    private function get_mapX():Float { return _mapX; }
    private function set_mapX(value:Float):Float { return _mapX = value; setRequiresRedraw(); }

    /** The vertical offset of the map texture relative to the origin. @default 0 */
    public var mapY(get, set):Float;
    private function get_mapY():Float { return _mapY; }
    private function set_mapY(value:Float):Float { return _mapY = value; setRequiresRedraw(); }

    /** The texture that will be used to calculate displacement. */
    public var mapTexture(get, set):Texture;
    private function get_mapTexture():Texture { return dispEffect.mapTexture; }
    private function set_mapTexture(value:Texture):Texture
    {
        if (dispEffect.mapTexture != value)
        {
            dispEffect.mapTexture = value;
            setRequiresRedraw();
        }
        return value;
    }

    /** Indicates if pixels at the edge of the map texture will be repeated.
     *  Note that this only works if the map texture is a power-of-two texture!
     */
    public var mapRepeat(get, set):Bool;
    private function get_mapRepeat():Bool { return dispEffect.mapRepeat; }
    private function set_mapRepeat(value:Bool):Bool
    {
        if (dispEffect.mapRepeat != value)
        {
            dispEffect.mapRepeat = value;
            setRequiresRedraw();
        }
        return value;
    }

    public var dispEffect(get, never):DisplacementMapEffect;
    private function get_dispEffect():DisplacementMapEffect
    {
        return cast this.effect;
    }
}


class DisplacementMapEffect extends FilterEffect
{
    public static var VERTEX_FORMAT:VertexDataFormat =
        FilterEffect.VERTEX_FORMAT.extend("mapTexCoords:float2");

    private var _mapTexture:Texture;
    private var _mapRepeat:Bool;
    private var _componentX:UInt;
    private var _componentY:UInt;
    private var _scaleX:Float;
    private var _scaleY:Float;

    // helper objects
    private static var sOffset:Vector<Float>  = Vector.ofArray([0.5, 0.5, 0.0, 0.0]);
    private static var sClampUV:Vector<Float> = Vector.ofArray([0.0, 0.0, 0.0, 0.0]);
    private static var sMatrix:Matrix3D = new Matrix3D();
    private static var sMatrixData:Vector<Float> =
        Vector.ofArray([0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0.]);

    #if commonjs
    private static function __init__ () {
        
        untyped Object.defineProperties (DisplacementFilterEffect.prototype, {
            "componentX": { get: untyped __js__ ("function () { return this.get_componentX (); }"), set: untyped __js__ ("function (v) { return this.set_componentX (v); }") },
            "componentY": { get: untyped __js__ ("function () { return this.get_componentY (); }"), set: untyped __js__ ("function (v) { return this.set_componentY (v); }") },
            "scaleX": { get: untyped __js__ ("function () { return this.get_scaleX (); }"), set: untyped __js__ ("function (v) { return this.set_scaleX (v); }") },
            "scaleY": { get: untyped __js__ ("function () { return this.get_scaleY (); }"), set: untyped __js__ ("function (v) { return this.set_scaleY (v); }") },
            "mapTexture": { get: untyped __js__ ("function () { return this.get_mapTexture (); }"), set: untyped __js__ ("function (v) { return this.set_mapTexture (v); }") },
            "mapRepeat": { get: untyped __js__ ("function () { return this.get_mapRepeat (); }"), set: untyped __js__ ("function (v) { return this.set_mapRepeat (v); }") },
        });
        
    }
    #end

    public function new()
    {
        super();
        _componentX = _componentY = 0;
        _scaleX = _scaleY = 0;
    }

    override private function createProgram():Program
    {
        if (_mapTexture != null)
        {
            // vc0-3: mvpMatrix
            // va0:   vertex position
            // va1:   input texture coords
            // va2:   map texture coords

            var vertexShader:String = [
                "m44  op, va0, vc0", // 4x4 matrix transform to output space
                "mov  v0, va1",      // pass input texture coordinates to fragment program
                "mov  v1, va2"       // pass map texture coordinates to fragment program
            ].join("\n");

            // v0:    input texCoords
            // v1:    map texCoords
            // fc0:   offset (0.5, 0.5)
            // fc1:   clampUV (max value for U and V, stored in x and y)
            // fc2-5: matrix

            var fragmentShader:String = [
                FilterEffect.tex("ft0", "v1", 1, _mapTexture, false), // read map texture
                "sub ft1, ft0, fc0",          // subtract 0.5 -> range [-0.5, 0.5]
                "mul ft1.xy, ft1.xy, ft0.ww", // zero displacement when alpha == 0
                "m44 ft2, ft1, fc2",          // multiply matrix with displacement values
                "add ft3,  v0, ft2",          // add displacement values to texture coords
                "sat ft3.xy, ft3.xy",         // move texture coords into range 0-1
                "min ft3.xy, ft3.xy, fc1.xy", // move texture coords into range 0-maxUV
                FilterEffect.tex("oc", "ft3", 0, texture)  // read input texture at displaced coords
            ].join("\n");

            return Program.fromSource(vertexShader, fragmentShader);
        }
        else return super.createProgram();
    }

    override private function beforeDraw(context:Context3D):Void
    {
        super.beforeDraw(context);

        if (_mapTexture != null)
        {
            // already set by super class:
            //
            // vertex constants 0-3: mvpMatrix (3D)
            // vertex attribute 0:   vertex position (FLOAT_2)
            // vertex attribute 1:   texture coordinates (FLOAT_2)
            // texture 0:            input texture

            getMapMatrix(sMatrix);

            sClampUV[0] = texture.width  / texture.root.width  - 0.5 / texture.root.nativeWidth;
            sClampUV[1] = texture.height / texture.root.height - 0.5 / texture.root.nativeHeight;

            vertexFormat.setVertexBufferAt(2, vertexBuffer, "mapTexCoords");
            context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, sOffset);
            context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 1, sClampUV);
            context.setProgramConstantsFromMatrix(Context3DProgramType.FRAGMENT, 2, sMatrix, true);
            RenderUtil.setSamplerStateAt(1, _mapTexture.mipMapping, textureSmoothing, _mapRepeat);
            context.setTextureAt(1, _mapTexture.base);
        }
    }

    override private function afterDraw(context:Context3D):Void
    {
        if (_mapTexture != null)
        {
            context.setVertexBufferAt(2, null);
            context.setTextureAt(1, null);
        }

        super.afterDraw(context);
    }

    override private function get_vertexFormat():VertexDataFormat
    {
        return VERTEX_FORMAT;
    }

    /** This matrix maps RGBA values of the map texture to UV-offsets in the input texture. */
    private function getMapMatrix(out:Matrix3D):Matrix3D
    {
        if (out == null) out = new Matrix3D();

        var columnX:Int, columnY:Int;
        var scale:Float = Starling.current.contentScaleFactor;
        var textureWidth:Float  = texture.root.nativeWidth;
        var textureHeight:Float = texture.root.nativeHeight;

        for (i in 0...16)
            sMatrixData[i] = 0;

        if      (_componentX == BitmapDataChannel.RED)   columnX = 0;
        else if (_componentX == BitmapDataChannel.GREEN) columnX = 1;
        else if (_componentX == BitmapDataChannel.BLUE)  columnX = 2;
        else                                             columnX = 3;

        if      (_componentY == BitmapDataChannel.RED)   columnY = 0;
        else if (_componentY == BitmapDataChannel.GREEN) columnY = 1;
        else if (_componentY == BitmapDataChannel.BLUE)  columnY = 2;
        else                                             columnY = 3;

        sMatrixData[Std.int(columnX * 4    )] = _scaleX * scale / textureWidth;
        sMatrixData[Std.int(columnY * 4 + 1)] = _scaleY * scale / textureHeight;

        out.copyRawDataFrom(sMatrixData);

        return out;
    }

    // properties

    public var componentX(get, set):UInt;
    private function get_componentX():UInt { return _componentX; }
    private function set_componentX(value:UInt):UInt { return _componentX = value; }

	public var componentY(get, set):UInt;
    private function get_componentY():UInt { return _componentY; }
    private function set_componentY(value:UInt):UInt { return _componentY = value; }

	public var scaleX(get, set):Float;
    private function get_scaleX():Float { return _scaleX; }
    private function set_scaleX(value:Float):Float { return _scaleX = value; }

	public var scaleY(get, set):Float;
    private function get_scaleY():Float { return _scaleY; }
    private function set_scaleY(value:Float):Float { return _scaleY = value; }

	public var mapTexture(get, set):Texture;
    private function get_mapTexture():Texture { return _mapTexture; }
    private function set_mapTexture(value:Texture):Texture { return _mapTexture = value; }

	public var mapRepeat(get, set):Bool;
    private function get_mapRepeat():Bool { return _mapRepeat; }
    private function set_mapRepeat(value:Bool):Bool { return _mapRepeat = value; }
}
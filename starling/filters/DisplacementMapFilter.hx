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
import flash.geom.Point;
import openfl.display3D.Context3DMipFilter;
import openfl.display3D.Context3DTextureFilter;
import openfl.display3D.Context3DWrapMode;
import openfl.utils.Float32Array;
import openfl.Vector;
import starling.utils.ArrayUtil;
import starling.utils.VertexBufferUtil;

import starling.core.Starling;
import starling.rendering.FilterEffect;
import starling.rendering.Painter;
import starling.textures.Texture;

import flash.display.BitmapDataChannel;
import flash.display3D.Context3D;
import flash.display3D.Context3DProgramType;
import flash.geom.Matrix3D;
import flash.geom.Point;

import starling.core.Starling;
import starling.rendering.FilterEffect;
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
 *  map texture at <code>(x - mapPoint.x, y - mapPoint.y)</code>.</p>
 */
class DisplacementMapFilter extends FragmentFilter
{
    private static var sMatrixData:Vector<Float> =
        Vector.ofArray([0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0]);
    
    /** Creates a new displacement map filter that uses the provided map texture. */
    public function new(mapTexture:Texture, mapPoint:Point=null,
                                          componentX:UInt=0, componentY:UInt=0,
                                          scaleX:Float=0.0, scaleY:Float=0.0)
    {
        super();
        this.mapTexture = mapTexture;
        this.mapPoint = mapPoint;
        this.componentX = componentX;
        this.componentY = componentY;
        this.scaleX = scaleX;
        this.scaleY = scaleY;
    }

    /** @private */
    override public function process(painter:Painter, pool:ITexturePool,
                                     input0:Texture = null, input1:Texture = null,
                                     input2:Texture = null, input3:Texture = null):Texture
    {
        updateVertexData(input0, mapTexture);
        return super.process(painter, pool, input0);
    }

    /** @private */
    override private function createEffect():FilterEffect
    {
        return new DisplacementMapEffect();
    }

    private function updateVertexData(inputTexture:Texture, mapTexture:Texture):Void
    {
        // The size of input texture and map texture may be different. We need to calculate
        // the right values for the texture coordinates at the filter vertices.

        var scale:Float = Starling.sContentScaleFactor;
        var mapX:Float = (dispEffect.mapPoint.x + padding.left) / mapTexture.width;
        var mapY:Float = (dispEffect.mapPoint.y + padding.top)  / mapTexture.height;
        var maxU:Float = inputTexture.root.nativeWidth  / (mapTexture.width  * scale);
        var maxV:Float = inputTexture.root.nativeHeight / (mapTexture.height * scale);

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
    @:noCompletion private function get_componentX():UInt { return dispEffect.componentX; }
    @:noCompletion private function set_componentX(value:UInt):UInt
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
    @:noCompletion private function get_componentY():UInt { return dispEffect.componentY; }
    @:noCompletion private function set_componentY(value:UInt):UInt
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
    @:noCompletion private function get_scaleX():Float { return dispEffect.scaleX; }
    @:noCompletion private function set_scaleX(value:Float):Float
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
    @:noCompletion private function get_scaleY():Float { return dispEffect.scaleY; }
    @:noCompletion private function set_scaleY(value:Float):Float
    {
        if (dispEffect.scaleY != value)
        {
            dispEffect.scaleY = value;
            updatePadding();
        }
        return value;
    }

    /** The texture that will be used to calculate displacement. */
    public var mapTexture(get, set):Texture;
    @:noCompletion private function get_mapTexture():Texture { return dispEffect.mapTexture; }
    @:noCompletion private function set_mapTexture(value:Texture):Texture
    {
        if (dispEffect.mapTexture != value)
        {
            dispEffect.mapTexture = value;
            setRequiresRedraw();
        }
        return value;
    }

    /** A value that contains the offset of the upper-left corner of the target display
     *  object from the upper-left corner of the map image. */
    public var mapPoint(get, set):Point;
    @:noCompletion private function get_mapPoint():Point { return dispEffect.mapPoint; }
    @:noCompletion private function set_mapPoint(value:Point):Point
    {
        dispEffect.mapPoint = value;
        setRequiresRedraw();
        return value;
    }

    /** Indicates how the pixels of the map texture will be wrapped at the edge. */
    public var mapRepeat(get, set):Bool;
    @:noCompletion private function get_mapRepeat():Bool { return dispEffect.mapRepeat; }
    @:noCompletion private function set_mapRepeat(value:Bool):Bool
    {
        if (dispEffect.mapRepeat != value)
        {
            dispEffect.mapRepeat = value;
            setRequiresRedraw();
        }
        return value;
    }

    private var dispEffect(get, never):DisplacementMapEffect;
    @:noCompletion private function get_dispEffect():DisplacementMapEffect
    {
        return cast(this.effect, DisplacementMapEffect);
    }
}

class DisplacementMapEffect extends FilterEffect
{
    public static var VERTEX_FORMAT:VertexDataFormat =
        VertexDataFormat.fromString("position:float2, texCoords:float2, mapTexCoords:float2");

    private var _mapTexture:Texture;
    private var _mapPoint:Point;
    private var _mapRepeat:Bool;
    private var _componentX:Int;
    private var _componentY:Int;
    private var _scaleX:Float;
    private var _scaleY:Float;

    // helper objects
    private static var sOneHalf:Vector<Float> = [0.5, 0.5, 0.5, 0.5];
    private static var sMatrix:Matrix3D = new Matrix3D();
    private static var sMatrixData:Vector<Float> =
        Vector.ofArray([0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0]);

    public function new()
    {
        super();
        _mapPoint = new Point();
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
            // fc0:   OneHalf
            // fc1-4: matrix

            var fragmentShader:String = [
                tex("ft0", "v1", 1, _mapTexture, false), // read map texture
                "sub ft1, ft0, fc0", // subtract 0.5 -> range [-0.5, 0.5]
                "m44 ft2, ft1, fc1", // multiply matrix with displacement values
                "add ft3,  v0, ft2", // add displacement values to texture coords
                tex("oc", "ft3", 0, texture)  // read input texture at displaced coords
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

            vertexFormat.setVertexBufferAt(2, vertexBuffer, "mapTexCoords");
            context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, sOneHalf);
            context.setProgramConstantsFromMatrix(Context3DProgramType.FRAGMENT, 1, sMatrix, true);
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

    @:noCompletion override private function get_vertexFormat():VertexDataFormat
    {
        return VERTEX_FORMAT;
    }

    /** This matrix maps RGBA values of the map texture to UV-offsets in the input texture. */
    private function getMapMatrix(out:Matrix3D):Matrix3D
    {
        if (out == null) out = new Matrix3D();

        var columnX:Int, columnY:Int;
        var scale:Float = Starling.sContentScaleFactor;
        var textureWidth:Float  = texture.root.nativeWidth;
        var textureHeight:Float = texture.root.nativeHeight;

        for (i in 0 ... 16)
            sMatrixData[i] = 0;

        if      (_componentX == BitmapDataChannel.RED)   columnX = 0;
        else if (_componentX == BitmapDataChannel.GREEN) columnX = 1;
        else if (_componentX == BitmapDataChannel.BLUE)  columnX = 2;
        else                                             columnX = 3;

        if      (_componentY == BitmapDataChannel.RED)   columnY = 0;
        else if (_componentY == BitmapDataChannel.GREEN) columnY = 1;
        else if (_componentY == BitmapDataChannel.BLUE)  columnY = 2;
        else                                             columnY = 3;

        sMatrixData[columnX * 4    ] = _scaleX * scale / textureWidth;
        sMatrixData[columnY * 4 + 1] = _scaleY * scale / textureHeight;

        out.copyRawDataFrom(sMatrixData);

        return out;
    }

    private static function tex(resultReg:String, uvReg:String, sampler:Int, texture:Texture,
                                convertToPmaIfRequired:Bool=true):String
    {
        return RenderUtil.createAGALTexOperation(resultReg, uvReg, sampler, texture,
            convertToPmaIfRequired);
    }

    // properties

    public var componentX(get, set):UInt;
    @:noCompletion private function get_componentX():UInt { return _componentX; }
    @:noCompletion private function set_componentX(value:UInt):UInt { return _componentX = value; }

    public var componentY(get, set):UInt;
    @:noCompletion private function get_componentY():UInt { return _componentY; }
    @:noCompletion private function set_componentY(value:UInt):UInt { return _componentY = value; }

    public var scaleX(get, set):Float;
    @:noCompletion private function get_scaleX():Float { return _scaleX; }
    @:noCompletion private function set_scaleX(value:Float):Float { return _scaleX = value; }

    public var scaleY(get, set):Float;
    @:noCompletion private function get_scaleY():Float { return _scaleY; }
    @:noCompletion private function set_scaleY(value:Float):Float { return _scaleY = value; }

    public var mapTexture(get, set):Texture;
    @:noCompletion private function get_mapTexture():Texture { return _mapTexture; }
    @:noCompletion private function set_mapTexture(value:Texture):Texture { return _mapTexture = value; }

    public var mapPoint(get, set):Point;
    @:noCompletion private function get_mapPoint():Point { return _mapPoint; }
    @:noCompletion private function set_mapPoint(value:Point):Point
    {
        if (value != null) _mapPoint.setTo(value.x, value.y);
        else _mapPoint.setTo(0, 0);
        return value;
    }

    public var mapRepeat(get, set):Bool;
    @:noCompletion private function get_mapRepeat():Bool { return _mapRepeat; }
    @:noCompletion private function set_mapRepeat(value:Bool):Bool { return _mapRepeat = value; }
}
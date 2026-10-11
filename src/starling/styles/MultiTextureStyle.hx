// =================================================================================================
//
//	Starling Framework
//	Copyright Gamua GmbH. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

package starling.styles;

import openfl.Vector;
import openfl.display3D.Context3D;
import openfl.display3D.Context3DProfile;
import openfl.display3D.Context3DProgramType;
import openfl.display3D.Context3DTextureFormat;
import openfl.geom.Matrix;

import starling.core.Starling;
import starling.display.Mesh;
import starling.rendering.FilterEffect;
import starling.rendering.MeshEffect;
import starling.rendering.Program;
import starling.rendering.RenderState;
import starling.rendering.VertexData;
import starling.rendering.VertexDataFormat;
import starling.textures.Texture;
import starling.utils.RenderUtil;

/** Batches meshes that use different textures into a single draw call.
 *
 *  <p>Normally, Starling can only batch meshes that share the same texture. This style adds a
 *  per-vertex texture index to the vertex data and generates a fragment shader that picks the
 *  matching texture for each fragment, so up to <code>maxTextures</code> different textures
 *  can be drawn in one call.</p>
 *
 *  <p>To use it, assign the style as the default for all meshes, ideally before Starling is
 *  started:</p>
 *
 *  <listing>Mesh.defaultStyle = MultiTextureStyle;</listing>
 */
class MultiTextureStyle extends MeshStyle
{
    /** The vertex format expected by this style. */
    public static var VERTEX_FORMAT:VertexDataFormat =
        MeshStyle.VERTEX_FORMAT.extend("texture:float1");

    /** The upper limit for <code>maxTextures</code>. The "standard" profiles (AGAL 2) provide
     *  16 texture samplers (<code>fs0 – fs15</code>), the baseline profiles only eight, and
     *  "baselineConstrained" only four. A batch never references more textures than the
     *  current profile and GPU support. */
    public static inline var MAX_NUM_TEXTURES:Int = 16;

    // AGAL 1 provides eight texture samplers (fs0 – fs7), which is also the minimum that
    // OpenGL ES 2 guarantees.
    private static inline var MAX_NUM_TEXTURES_BASELINE:Int = 8;

    // "baselineConstrained" rejects shaders with more than three indirect texture reads,
    // and each texture after the first one counts as such a read.
    private static inline var MAX_NUM_TEXTURES_CONSTRAINED:Int = 4;

    // On devices that use ETC1, OpenFL samples the alpha channel of compressed textures from a
    // separate texture, in a texture unit of its own. Before OpenFL 9.5.3, that unit was
    // 'sampler + 4', so batches with such a texture stay at four textures there.
    private static inline var MAX_NUM_TEXTURES_COMPRESSED_ALPHA:Int = 4;

    private var _textures:Vector<Texture>;
    private var _numCompressedAlpha:Int = 0;

    private static var sMaxTextures:Int = 4;
    private static var sTextureIndexMap:Array<Int> = [];
    private static var sLimitContext:Context3D;
    private static var sLimit:Int = MAX_NUM_TEXTURES_BASELINE;
    private static var sTextureUnits:Int = MAX_NUM_TEXTURES;

    /** The maximum number of textures that are batched into one draw call; values are clamped
     *  to the range <code>1 – MAX_NUM_TEXTURES</code>. In baseline profiles, each fragment
     *  samples all textures of its batch, so higher values cost more fill rate there. With
     *  OpenFL, batches leave a texture unit free for each compressed texture with an alpha
     *  channel (before OpenFL 9.5.3, such batches are limited to four textures).
     *  @default 4 */
    public static var maxTextures(get, set):Int;
    private static function get_maxTextures():Int { return sMaxTextures; }
    private static function set_maxTextures(value:Int):Int
    {
        return sMaxTextures = value < 1 ? 1 : (value > MAX_NUM_TEXTURES ? MAX_NUM_TEXTURES : value);
    }

    /** @private Kept for compatibility with Starling 2.8.0; calling it is no longer necessary. */
    @:deprecated("MultiTextureStyle.init() is no longer necessary")
    public static function init():Void {}

    @:keep public function new()
    {
        super();
        _textures = new Vector<Texture>();
    }

    /** @private */
    override public function createEffect():MeshEffect
    {
        return new MultiTextureEffect();
    }

    /** @private */
    override public function updateEffect(effect:MeshEffect, state:RenderState):Void
    {
        var targetEffect:MultiTextureEffect = cast effect;
        var numTextures:Int = _textures.length;

        targetEffect.clearTextures();

        super.updateEffect(effect, state);

        for (i in 0...numTextures)
            targetEffect.setTextureAt(i, _textures[i]);
    }

    /** @private */
    override public function canBatchWith(meshStyle:MeshStyle):Bool
    {
        var mtStyle:MultiTextureStyle = #if (haxe_ver < 4.2) Std.is #else Std.isOfType #end
            (meshStyle, MultiTextureStyle) ? cast meshStyle : null;

        if (mtStyle != null)
        {
            // meshes with different sampler settings can't share a draw call
            if (textureSmoothing != mtStyle.textureSmoothing ||
                textureRepeat != mtStyle.textureRepeat)
            {
                return false;
            }

            var numTexturesToAdd:Int = _textures.length;
            var limit:Int = getTextureLimit();
            var maxTextures:Int = sMaxTextures < limit ? sMaxTextures : limit;

            #if (lime && !flash)
            var numCompressedAlpha:Int = mtStyle._numCompressedAlpha;

            if (_numCompressedAlpha > 0)
                for (i in 0...numTexturesToAdd)
                    if (isCompressedAlpha(_textures[i]) && mtStyle.getTextureIndex(_textures[i]) == -1)
                        numCompressedAlpha++;

            if (numCompressedAlpha > 0)
            {
                #if (openfl >= "9.5.3")
                var numTextureUnits:Int = sTextureUnits - numCompressedAlpha;
                if (maxTextures > numTextureUnits) maxTextures = numTextureUnits;
                #else
                if (maxTextures > MAX_NUM_TEXTURES_COMPRESSED_ALPHA)
                    maxTextures = MAX_NUM_TEXTURES_COMPRESSED_ALPHA;
                #end
            }
            #end

            if (mtStyle.numTextures + numTexturesToAdd > maxTextures)
            {
                var numSharedTextures:Int = 0;

                for (i in 0...numTexturesToAdd)
                    if (mtStyle.getTextureIndex(_textures[i]) != -1)
                        numSharedTextures++;

                return mtStyle.numTextures + numTexturesToAdd - numSharedTextures
                    <= maxTextures;
            }
            else return true;
        }

        return false;
    }

    /** @private */
    override public function batchVertexData(targetStyle:MeshStyle, targetVertexID:Int=0,
                                             matrix:Matrix=null, vertexID:Int=0,
                                             numVertices:Int=-1):Void
    {
        super.batchVertexData(targetStyle, targetVertexID, matrix, vertexID, numVertices);

        var mtTarget:MultiTextureStyle = #if (haxe_ver < 4.2) Std.is #else Std.isOfType #end
            (targetStyle, MultiTextureStyle) ? cast targetStyle : null;

        if (mtTarget != null)
        {
            var targetVertexData:VertexData = mtTarget.vertexData;
            var sourceVertexData:VertexData = this.vertexData;
            var numTextures:Int = _textures.length;
            var isIdentity:Bool = true;

            if (numVertices < 0)
                numVertices = sourceVertexData.numVertices - vertexID;

            if (targetVertexID == 0)
            {
                mtTarget._textures.length = 0;
                mtTarget._numCompressedAlpha = 0;
            }

            for (i in 0...numTextures)
            {
                var texture:Texture = _textures[i];
                var textureIndexOnTarget:Int = mtTarget.getTextureIndex(texture);

                if (textureIndexOnTarget == -1)
                {
                    textureIndexOnTarget = mtTarget.numTextures;
                    mtTarget._textures[textureIndexOnTarget] = texture;
                    if (isCompressedAlpha(texture)) mtTarget._numCompressedAlpha++;
                }

                sTextureIndexMap[i] = textureIndexOnTarget;
                isIdentity = isIdentity && i == textureIndexOnTarget;
            }

            // The vertices were copied with their indices; that's already correct if the
            // textures keep their positions on the target (the common case, e.g. with a
            // single atlas or with the render cache). An untextured mesh doesn't store the
            // index -1 in its own vertices, though.

            if (numTextures == 0)
            {
                for (i in 0...numVertices)
                    targetVertexData.setFloat(targetVertexID + i, "texture", -1);
            }
            else if (!isIdentity)
            {
                for (i in 0...numVertices)
                {
                    var sourceTexID:Int = Std.int(sourceVertexData.getFloat(vertexID + i, "texture"));
                    if (sourceTexID != -1)
                        targetVertexData.setFloat(targetVertexID + i, "texture",
                            sTextureIndexMap[sourceTexID]);
                }
            }
        }
    }

    /** @private */
    override private function onTargetAssigned(target:Mesh):Void
    {
        _textures.length = 0;
        if (target.texture != null) _textures[0] = target.texture;
        updateCompressedAlpha();
    }

    /** @private */
    override private function get_vertexFormat():VertexDataFormat
    {
        return VERTEX_FORMAT;
    }

    /** @private */
    override private function set_texture(value:Texture):Texture
    {
        if (value != null) _textures[0] = value;
        else _textures.length = 0;
        updateCompressedAlpha();
        return super.set_texture(value);
    }

    private function updateCompressedAlpha():Void
    {
        _numCompressedAlpha = 0;

        for (texture in _textures)
            if (isCompressedAlpha(texture))
                _numCompressedAlpha++;
    }

    private static inline function isCompressedAlpha(texture:Texture):Bool
    {
        return texture.format == Context3DTextureFormat.COMPRESSED_ALPHA;
    }

    // The number of textures a batch may reference with the current context: limited by the
    // profile and, with OpenFL, by the GPU (it reports a "standard" profile on any hardware).
    private static function getTextureLimit():Int
    {
        var starling:Starling = Starling.current;
        var context:Context3D = starling != null ? starling.context : null;

        if (context == null) return MAX_NUM_TEXTURES_BASELINE;
        if (context != sLimitContext)
        {
            var profile:Context3DProfile = starling.profile;
            var limit:Int;

            if (profile == Context3DProfile.BASELINE_CONSTRAINED)
                limit = MAX_NUM_TEXTURES_CONSTRAINED;
            else if (profile == Context3DProfile.BASELINE || profile == Context3DProfile.BASELINE_EXTENDED)
                limit = MAX_NUM_TEXTURES_BASELINE;
            else
                limit = MAX_NUM_TEXTURES;

            #if (lime && !flash)
            var gl = @:privateAccess context.gl;
            var numTextureUnits:Int = gl.getParameter(gl.MAX_TEXTURE_IMAGE_UNITS);
            if (numTextureUnits > 0)
            {
                sTextureUnits = numTextureUnits;
                if (numTextureUnits < limit) limit = numTextureUnits;
            }
            #end

            sLimitContext = context;
            sLimit = limit;
        }

        return sLimit;
    }

    private function getTextureIndex(texture:Texture):Int
    {
        var numTextures:Int = _textures.length;

        for (i in 0...numTextures)
            if (_textures[i].root == texture.root) return i;

        return -1;
    }

    /** The number of textures referenced by this style. */
    public var numTextures(get, never):Int;
    private function get_numTextures():Int { return _textures.length; }
}

private class MultiTextureEffect extends MeshEffect
{
    private var _textures:Vector<Texture>;

    // How many constant registers the per-texture bounds occupy (one register holds four bounds).
    private static var sRegsPerBound:Int = Math.ceil(MultiTextureStyle.MAX_NUM_TEXTURES / 4);

    // Fragment constant register layout: lower bounds, then upper bounds, then a "ones" vector.
    private static var sLowerBoundsReg:Int = 0;
    private static var sUpperBoundsReg:Int = sRegsPerBound;
    private static var sOnesReg:Int        = 2 * sRegsPerBound;

    // The active texture for a vertex is the one whose index 'k' is closest to the interpolated
    // value in 'v2.x'. We select it via the half-open range [k - 0.5, k + 0.5) instead of a strict
    // equality check: the rasterizer interpolates 'v2.x' with limited precision, so an exact
    // comparison would fail on some GPUs and leave fragments untextured (flickering / artifacts).
    private static var sLowerBounds:Vector<Float> = createBounds(-0.5);
    private static var sUpperBounds:Vector<Float> = createBounds( 0.5);
    private static var sOnes:Vector<Float> = Vector.ofArray([1.0, 1.0, 1.0, 1.0]);

    // Program names by the variant bits of textures 8 – 15, then by those of textures 0 – 7.
    private static var sProgramNames:Map<Int, Map<Int, String>> = new Map();

    private static function createBounds(offset:Float):Vector<Float>
    {
        var count:Int = sRegsPerBound * 4;
        var result:Vector<Float> = new Vector<Float>(count, true);

        for (i in 0...count)
            result[i] = i + offset;

        return result;
    }

    public function new()
    {
        super();
        _textures = new Vector<Texture>();
    }

    override private function createProgram():Program
    {
        var vertexShader:Array<String> = [
            "m44 op, va0, vc0", // 4x4 matrix transform to output clip-space
            "mov v0, va1     ", // pass texture coordinates to fragment program
            "mul v1, va2, vc4", // multiply alpha (vc4) with color (va2), pass to fp
            "mov v2, va3     "  // pass texture sampler index to fp
        ];

        var profile:Context3DProfile = Starling.current.profile;
        var isBaseline:Bool = profile == Context3DProfile.BASELINE ||
                              profile == Context3DProfile.BASELINE_CONSTRAINED ||
                              profile == Context3DProfile.BASELINE_EXTENDED;
        var agalVersion:Int = isBaseline ? 1 : 2;
        var fragmentShader:Array<String> = isBaseline ?
            createFragmentShaderForBaselineProfile(numTextures) :
            createFragmentShaderForStandardProfile(numTextures);

        // OpenFL's AGAL assembler rejects samplers above 'fs7' unless its limits are ignored
        var ignoreLimits:Bool = numTextures > 8;

        return Program.fromSource(vertexShader.join("\n"), fragmentShader.join("\n"),
            agalVersion, ignoreLimits);
    }

    private function createFragmentShaderForBaselineProfile(numTextures:Int):Array<String>
    {
        // In baseline profile, if-statements are not available. Instead, we sample all textures
        // and mask all but the active one to zero, using range checks (see 'sLowerBounds').

        var fragmentShader:Array<String> = [];

        if (numTextures == 0)
        {
            fragmentShader.push("mov ft4, fc" + sOnesReg); // no texture => white
        }
        else
        {
            for (i in 0...numTextures)
            {
                fragmentShader.push(FilterEffect.tex("ft0", "v0", i, _textures[i]));
                fragmentShader.push("sge ft1, v2.x, " + boundReg(sLowerBoundsReg, i)); // v2.x >= i - 0.5 ?
                fragmentShader.push("slt ft2, v2.x, " + boundReg(sUpperBoundsReg, i)); // v2.x <  i + 0.5 ?
                fragmentShader.push("mul ft1, ft1, ft2"); // combine to a 0/1 mask for this texture
                fragmentShader.push("mul ft0, ft0, ft1"); // keep the texel only inside the range
                fragmentShader.push(i == 0 ? "mov ft4, ft0" : "add ft4, ft4, ft0");
            }

            // vertices without a texture carry index -1, i.e. below the first range => white
            fragmentShader.push("slt ft0, v2.x, " + boundReg(sLowerBoundsReg, 0));
            fragmentShader.push("add ft4, ft4, ft0");
        }

        fragmentShader.push("mul oc, ft4, v1"); // multiply color with texel color
        return fragmentShader;
    }

    private function createFragmentShaderForStandardProfile(numTextures:Int):Array<String>
    {
        // In standard profile, we can pick the correct texture via if-operations, which is more
        // efficient (fewer texture look-ups). 'ft0' starts white so untextured vertices (index -1,
        // matching no range) are rendered as pure vertex color.

        var fragmentShader:Array<String> = ["mov ft0, fc" + sOnesReg];

        for (i in 0...numTextures)
        {
            fragmentShader.push("ifg v2.x, " + boundReg(sLowerBoundsReg, i)); // v2.x > i - 0.5 ?
            fragmentShader.push("ifl v2.x, " + boundReg(sUpperBoundsReg, i)); // v2.x < i + 0.5 ?
            fragmentShader.push(FilterEffect.tex("ft0", "v0", i, _textures[i]));
            fragmentShader.push("eif");
            fragmentShader.push("eif");
        }

        fragmentShader.push("mul oc, ft0, v1"); // multiply color with texel color
        return fragmentShader;
    }

    // Returns the AGAL address of texture 'index's bound within the given register block,
    // e.g. "fc0.x" or "fc1.z" – so the bounds can span more than one constant register.
    private function boundReg(baseReg:Int, index:Int):String
    {
        var register:Int = baseReg + Std.int(index / 4);
        var component:String = "xyzw".charAt(index % 4);
        return "fc" + register + "." + component;
    }

    override private function beforeDraw(context:Context3D):Void
    {
        super.beforeDraw(context);

        context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, sLowerBoundsReg, sLowerBounds);
        context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, sUpperBoundsReg, sUpperBounds);
        context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, sOnesReg, sOnes);

        vertexFormat.setVertexBufferAt(1, vertexBuffer, "texCoords");
        vertexFormat.setVertexBufferAt(3, vertexBuffer, "texture");

        for (i in 0...numTextures)
        {
            var texture:Texture = _textures[i];
            RenderUtil.setSamplerStateAt(i, texture.mipMapping, textureSmoothing, textureRepeat);
            context.setTextureAt(i, texture.base);
        }
    }

    override private function afterDraw(context:Context3D):Void
    {
        for (i in 0...numTextures)
            context.setTextureAt(i, null);

        context.setVertexBufferAt(1, null);
        context.setVertexBufferAt(3, null);

        super.afterDraw(context);
    }

    override private function get_vertexFormat():VertexDataFormat
    {
        return MultiTextureStyle.VERTEX_FORMAT;
    }

    // Four bits per texture: with 16 textures, the variant needs 64 bits – more than the 'UInt'
    // that 'programVariantName' can return. Thus, the program name is cached under two 32 bit
    // halves instead: one for textures 0 – 7, one for textures 8 – 15. (Plain numbers as keys,
    // so that looking up a name doesn't allocate anything.)
    override private function get_programName():String
    {
        var numTextures:Int = _textures.length;
        var low:Int = 0;
        var high:Int = 0;

        for (i in 0...numTextures)
        {
            var bits:Int = RenderUtil.getTextureVariantBits(_textures[i]);
            if (i < 8) low  |= bits << (4 * i);
            else       high |= bits << (4 * (i - 8));
        }

        var names:Map<Int, String> = sProgramNames.get(high);
        if (names == null)
        {
            names = new Map();
            sProgramNames.set(high, names);
        }

        var name:String = names.get(low);
        if (name == null)
        {
            name = programBaseName + "#" + StringTools.hex(high) + "_" + StringTools.hex(low);
            names.set(low, name);
        }

        return name;
    }

    override private function set_texture(value:Texture):Texture
    {
        if (value != null) _textures[0] = value;
        return super.set_texture(value);
    }

    public function setTextureAt(index:Int, texture:Texture):Void
    {
        _textures[index] = texture;
    }

    public function clearTextures():Void
    {
        _textures.length = 0;
    }

    public var numTextures(get, never):Int;
    private function get_numTextures():Int { return _textures.length; }
}

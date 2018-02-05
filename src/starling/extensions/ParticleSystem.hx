// =================================================================================================
//
//	Starling Framework - Particle System Extension
//	Copyright 2012 Gamua OG. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

package starling.extensions;

import openfl.display3D.Context3DBlendFactor;
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.Vector;

import starling.animation.IAnimatable;
import starling.display.BlendMode;
import starling.display.DisplayObject;
import starling.display.Mesh;
import starling.events.Event;
import starling.rendering.IndexData;
import starling.rendering.MeshEffect;
import starling.rendering.Painter;
import starling.rendering.VertexData;
import starling.styles.MeshStyle;
import starling.textures.Texture;
import starling.utils.MatrixUtil;
import starling.utils.Max;
import starling.utils.MeshSubset;

/** Dispatched when emission of particles is finished. */
@:meta(Event(name="complete", type="starling.events.Event"))

class ParticleSystem extends Mesh implements IAnimatable
{
    public static inline var MAX_NUM_PARTICLES:Int = 16383;
    
    private var _effect:MeshEffect;
    private var _vertexData:VertexData;
    private var _indexData:IndexData;
    private var _requiresSync:Bool;
    private var _batchable:Bool;

    private var _particles:Vector<Particle>;
    private var _frameTime:Float;
    private var _numParticles:Int = 0;
    private var _emissionRate:Float; // emitted particles per second
    private var _emissionTime:Float;
    private var _emitterX:Float;
    private var _emitterY:Float;
    private var _blendFactorSource:Context3DBlendFactor;
    private var _blendFactorDestination:Context3DBlendFactor;

    // helper objects
    private static var sHelperMatrix:Matrix = new Matrix();
    private static var sHelperPoint:Point = new Point();
    private static var sSubset:MeshSubset = new MeshSubset();

    #if commonjs
    private static function __init__ () {
        
        untyped Object.defineProperties (ParticleSystem.prototype, {
            "capacity": { get: untyped __js__ ("function () { return this.get_capacity (); }"), set: untyped __js__ ("function (v) { return this.set_capacity (v); }") },
            "isEmitting": { get: untyped __js__ ("function () { return this.get_isEmitting (); }") },
            "numParticles": { get: untyped __js__ ("function () { return this.get_numParticles (); }") },
            "emissionRate": { get: untyped __js__ ("function () { return this.get_emissionRate (); }"), set: untyped __js__ ("function (v) { return this.set_emissionRate (v); }") },
            "emitterX": { get: untyped __js__ ("function () { return this.get_emitterX (); }"), set: untyped __js__ ("function (v) { return this.set_emitterX (v); }") },
            "emitterY": { get: untyped __js__ ("function () { return this.get_emitterY (); }"), set: untyped __js__ ("function (v) { return this.set_emitterY (v); }") },
            "blendFactorSource": { get: untyped __js__ ("function () { return this.get_blendFactorSource (); }"), set: untyped __js__ ("function (v) { return this.set_blendFactorSource (v); }") },
            "blendFactorDestination": { get: untyped __js__ ("function () { return this.get_blendFactorDestination (); }"), set: untyped __js__ ("function (v) { return this.set_blendFactorDestination (v); }") },
            "batchable": { get: untyped __js__ ("function () { return this.get_batchable (); }"), set: untyped __js__ ("function (v) { return this.set_batchable (v); }") },
        });
        
    }
    #end

    public function new(texture:Texture=null)
    {
        _vertexData = new VertexData();
        _indexData = new IndexData();

        super(_vertexData, _indexData);

        _particles = new Vector<Particle>(0, false);
        _frameTime = 0.0;
        _emitterX = _emitterY = 0.0;
        _emissionTime = 0.0;
        _emissionRate = 10;
        _blendFactorSource = Context3DBlendFactor.ONE;
        _blendFactorDestination = Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA;
        _batchable = false;

        this.capacity = 128;
        this.texture = texture;

        updateBlendMode();
    }

    /** @inheritDoc */
    override public function dispose():Void
    {
        _effect.dispose();
        super.dispose();
    }

    /** Always returns <code>null</code>. An actual test would be too expensive. */
    override public function hitTest(localPoint:Point):DisplayObject
    {
        return null;
    }

    private function updateBlendMode():Void
    {
        var pma:Bool = texture != null ? texture.premultipliedAlpha : true;

        // Particle Designer uses special logic for a certain blend factor combination
        if (_blendFactorSource == Context3DBlendFactor.ONE &&
            _blendFactorDestination == Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA)
        {
            _vertexData.premultipliedAlpha = pma;
            if (!pma) _blendFactorSource = Context3DBlendFactor.SOURCE_ALPHA;
        }
        else
        {
            _vertexData.premultipliedAlpha = false;
        }
        
        var registeredBlendMode:BlendMode = BlendMode.getByFactors(_blendFactorSource, _blendFactorDestination);
        if (registeredBlendMode != null)
        {
            blendMode = registeredBlendMode.name;
        }
        else
        {
            blendMode = _blendFactorSource + ", " + _blendFactorDestination;
            BlendMode.register(blendMode, _blendFactorSource, _blendFactorDestination);
        }
    }
    
    private function createParticle():Particle
    {
        return new Particle();
    }
    
    private function initParticle(particle:Particle):Void
    {
        particle.x = _emitterX;
        particle.y = _emitterY;
        particle.currentTime = 0;
        particle.totalTime = 1;
        particle.color = Std.int(Math.random() * 0xffffff);
    }

    private function advanceParticle(particle:Particle, passedTime:Float):Void
    {
        particle.y += passedTime * 250;
        particle.alpha = 1.0 - particle.currentTime / particle.totalTime;
        particle.currentTime += passedTime;
    }

    private function setRequiresSync(?_):Void
    {
        _requiresSync = true;
    }

    private function syncBuffers():Void
    {
        _effect.uploadVertexData(_vertexData);
        _effect.uploadIndexData(_indexData);
        _requiresSync = false;
    }

    /** Starts the emitter for a certain time. @default infinite time */
    public function start(duration:Float=Max.MAX_VALUE):Void
    {
        if (_emissionRate != 0)
            _emissionTime = duration;
    }
    
    /** Stops emitting new particles. Depending on 'clearParticles', the existing particles
        *  will either keep animating until they die or will be removed right away. */
    public function stop(clearParticles:Bool=false):Void
    {
        _emissionTime = 0.0;
        if (clearParticles) clear();
    }
    
    /** Removes all currently active particles. */
    public function clear():Void
    {
        _numParticles = 0;
    }
    
    /** Returns an empty rectangle at the particle system's position. Calculating the
        *  actual bounds would be too expensive. */
    public override function getBounds(targetSpace:DisplayObject, 
                                        resultRect:Rectangle=null):Rectangle
    {
        if (resultRect == null) resultRect = new Rectangle();
        
        getTransformationMatrix(targetSpace, sHelperMatrix);
        MatrixUtil.transformCoords(sHelperMatrix, 0, 0, sHelperPoint);
        
        resultRect.x = sHelperPoint.x;
        resultRect.y = sHelperPoint.y;
        resultRect.width = resultRect.height = 0;
        
        return resultRect;
    }
    
    public function advanceTime(passedTime:Float):Void
    {
        setRequiresRedraw();
        setRequiresSync();

        var particleIndex:Int = 0;
        var particle:Particle;
        var maxNumParticles:Int = capacity;
        
        // advance existing particles

        while (particleIndex < _numParticles)
        {
            particle = _particles[particleIndex];
            
            if (particle.currentTime < particle.totalTime)
            {
                advanceParticle(particle, passedTime);
                ++particleIndex;
            }
            else
            {
                if (particleIndex != _numParticles - 1)
                {
                    var nextParticle:Particle = _particles[Std.int(_numParticles-1)];
                    _particles[Std.int(_numParticles-1)] = particle;
                    _particles[particleIndex] = nextParticle;
                }

                --_numParticles;

                if (_numParticles == 0 && _emissionTime == 0)
                    dispatchEventWith(Event.COMPLETE);
            }
        }
        
        // create and advance new particles
        
        if (_emissionTime > 0)
        {
            var timeBetweenParticles:Float = 1.0 / _emissionRate;
            _frameTime += passedTime;
            
            while (_frameTime > 0)
            {
                if (_numParticles < maxNumParticles)
                {
                    particle = _particles[_numParticles];
                    initParticle(particle);
                    
                    // particle might be dead at birth
                    if (particle.totalTime > 0.0)
                    {
                        advanceParticle(particle, _frameTime);
                        ++_numParticles;
                    }
                }
                
                _frameTime -= timeBetweenParticles;
            }
            
            if (_emissionTime != Max.MAX_VALUE)
                _emissionTime = _emissionTime > passedTime ? _emissionTime - passedTime : 0.0;

            if (_numParticles == 0 && _emissionTime == 0)
                dispatchEventWith(Event.COMPLETE);
        }

        // update vertex data
        
        var vertexID:Int = 0;
        var rotation:Float;
        var x:Float, y:Float;
        var offsetX:Float, offsetY:Float;
        var pivotX:Float = texture != null ? texture.width  / 2 : 5;
        var pivotY:Float = texture != null ? texture.height / 2 : 5;
        
        for (i in 0..._numParticles)
        {
            vertexID = i * 4;
            particle = _particles[i];
            rotation = particle.rotation;
            offsetX = pivotX * particle.scale;
            offsetY = pivotY * particle.scale;
            x = particle.x;
            y = particle.y;

            _vertexData.colorize("color", particle.color, particle.alpha, vertexID, 4);

            if (rotation != 0)
            {
                var cos:Float  = Math.cos(rotation);
                var sin:Float  = Math.sin(rotation);
                var cosX:Float = cos * offsetX;
                var cosY:Float = cos * offsetY;
                var sinX:Float = sin * offsetX;
                var sinY:Float = sin * offsetY;
                
                _vertexData.setPoint(vertexID,   "position", x - cosX + sinY, y - sinX - cosY);
                _vertexData.setPoint(vertexID+1, "position", x + cosX + sinY, y + sinX - cosY);
                _vertexData.setPoint(vertexID+2, "position", x - cosX - sinY, y - sinX + cosY);
                _vertexData.setPoint(vertexID+3, "position", x + cosX - sinY, y + sinX + cosY);
            }
            else 
            {
                // optimization for rotation == 0
                _vertexData.setPoint(vertexID,   "position", x - offsetX, y - offsetY);
                _vertexData.setPoint(vertexID+1, "position", x + offsetX, y - offsetY);
                _vertexData.setPoint(vertexID+2, "position", x - offsetX, y + offsetY);
                _vertexData.setPoint(vertexID+3, "position", x + offsetX, y + offsetY);
            }
        }
    }

    override public function render(painter:Painter):Void
    {
        if (_numParticles == 0)
        {
            // nothing to do =)
        }
        else if (_batchable)
        {
            sSubset.setTo(0, _numParticles * 4, 0, _numParticles * 6);
            painter.batchMesh(this, sSubset);
        }
        else
        {
            painter.finishMeshBatch();
            painter.drawCount += 1;
            painter.prepareToDraw();
            painter.excludeFromCache(this);

            if (_requiresSync) syncBuffers();

            style.updateEffect(_effect, painter.state);
            _effect.render(0, _numParticles * 2);
        }
    }

    /** Initialize the <code>ParticleSystem</code> with particles distributed randomly
        *  throughout their lifespans. */
    public function populate(count:Int):Void
    {
        var maxNumParticles:Int = capacity;
        count = Std.int(Math.min(count, maxNumParticles - _numParticles));
        
        var p:Particle;
        for (i in 0...count)
        {
            p = _particles[_numParticles+i];
            initParticle(p);
            advanceParticle(p, Math.random() * p.totalTime);
        }
        
        _numParticles += count;
    }

    public var capacity(get, set):Int;
    private function get_capacity():Int { return Std.int(_vertexData.numVertices / 4); }
    private function set_capacity(value:Int):Int
    {
        var i:Int;
        var oldCapacity:Int = capacity;
        var newCapacity:Int = value > MAX_NUM_PARTICLES ? MAX_NUM_PARTICLES : value;
        var baseVertexData:VertexData = new VertexData(style.vertexFormat, 4);
        var texture:Texture = this.texture;

        if (texture != null)
        {
            texture.setupVertexPositions(baseVertexData);
            texture.setupTextureCoordinates(baseVertexData);
        }
        else
        {
            baseVertexData.setPoint(0, "position",  0,  0);
            baseVertexData.setPoint(1, "position", 10,  0);
            baseVertexData.setPoint(2, "position",  0, 10);
            baseVertexData.setPoint(3, "position", 10, 10);
        }

        for (i in oldCapacity...newCapacity)
        {
            var numVertices:Int = i * 4;
            baseVertexData.copyTo(_vertexData, numVertices);
            _indexData.addQuad(numVertices, numVertices + 1, numVertices + 2, numVertices + 3);
            _particles[i] = createParticle();
        }

        if (newCapacity < oldCapacity)
        {
            _particles.length = newCapacity;
            _indexData.numIndices = newCapacity * 6;
            _vertexData.numVertices = newCapacity * 4;

            if (_numParticles > newCapacity)
                _numParticles = newCapacity;
        }

        _indexData.trim();
        _vertexData.trim();

        setRequiresSync();
        return value;
    }
    
    // properties

    public var isEmitting(get, never):Bool;
    private function get_isEmitting():Bool { return _emissionTime > 0 && _emissionRate > 0; }
   
    public var numParticles(get, never):Int;
    private function get_numParticles():Int { return _numParticles; }
    
    public var emissionRate(get, set):Float;
    private function get_emissionRate():Float { return _emissionRate; }
    private function set_emissionRate(value:Float):Float { return _emissionRate = value; }
    
    public var emitterX(get, set):Float;
    private function get_emitterX():Float { return _emitterX; }
    private function set_emitterX(value:Float):Float { return _emitterX = value; }
    
    public var emitterY(get, set):Float;
    private function get_emitterY():Float { return _emitterY; }
    private function set_emitterY(value:Float):Float { return _emitterY = value; }
    
    public var blendFactorSource(get, set):Context3DBlendFactor;
    private function get_blendFactorSource():Context3DBlendFactor { return _blendFactorSource; }
    private function set_blendFactorSource(value:Context3DBlendFactor):Context3DBlendFactor
    {
        _blendFactorSource = value;
        updateBlendMode();
        return value;
    }
    
    public var blendFactorDestination(get, set):Context3DBlendFactor;
    private function get_blendFactorDestination():Context3DBlendFactor { return _blendFactorDestination; }
    private function set_blendFactorDestination(value:Context3DBlendFactor):Context3DBlendFactor
    {
        _blendFactorDestination = value;
        updateBlendMode();
        return value;
    }
    
    override private function set_texture(value:Texture):Texture
    {
        super.texture = value;

        if (value != null)
        {
            var i:Int = _vertexData.numVertices - 4;
            while (i >= 0)
            {
                value.setupVertexPositions(_vertexData, i);
                value.setupTextureCoordinates(_vertexData, i);
                i -= 4;
            }
        }

        updateBlendMode();
        return value;
    }

    override public function setStyle(meshStyle:MeshStyle=null,
                                        mergeWithPredecessor:Bool=true):Void
    {
        super.setStyle(meshStyle, mergeWithPredecessor);

        if (_effect != null)
            _effect.dispose();

        _effect = style.createEffect();
        _effect.onRestore = setRequiresSync;
    }

    /** Indicates if this object will be added to the painter's batch on rendering,
        *  or if it will draw itself right away. Note that this should only be enabled if the
        *  number of particles is reasonably small. */
    public var batchable(get, set):Bool;
    private function get_batchable():Bool { return _batchable; }
    private function set_batchable(value:Bool):Bool
    {
        _batchable = value;
        setRequiresRedraw();
        return value;
    }
}
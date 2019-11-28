// =================================================================================================
//
//	Starling Framework - Particle System Extension
//	Copyright Gamua GmbH. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

package starling.extensions;

import haxe.xml.Fast;

import openfl.display3D.Context3DBlendFactor;
import openfl.errors.ArgumentError;

import starling.textures.Texture;
import starling.utils.MathUtil;
import starling.utils.Max;

class PDParticleSystem extends ParticleSystem
{
    public var defaultDuration(get, set):Float;
    public var emitterType(get, set):Int;
    public var emitterXVariance(get, set):Float;
    public var emitterYVariance(get, set):Float;
    public var lifespan(get, set):Float;
    public var lifespanVariance(get, set):Float;
    public var startSize(get, set):Float;
    public var startSizeVariance(get, set):Float;
    public var endSize(get, set):Float;
    public var endSizeVariance(get, set):Float;
    public var emitAngle(get, set):Float;
    public var emitAngleVariance(get, set):Float;
    public var startRotation(get, set):Float;
    public var startRotationVariance(get, set):Float;
    public var endRotation(get, set):Float;
    public var endRotationVariance(get, set):Float;
    public var speed(get, set):Float;
    public var speedVariance(get, set):Float;
    public var gravityX(get, set):Float;
    public var gravityY(get, set):Float;
    public var radialAcceleration(get, set):Float;
    public var radialAccelerationVariance(get, set):Float;
    public var tangentialAcceleration(get, set):Float;
    public var tangentialAccelerationVariance(get, set):Float;
    public var maxRadius(get, set):Float;
    public var maxRadiusVariance(get, set):Float;
    public var minRadius(get, set):Float;
    public var minRadiusVariance(get, set):Float;
    public var rotatePerSecond(get, set):Float;
    public var rotatePerSecondVariance(get, set):Float;
    public var startColor(get, set):ColorArgb;
    public var startColorVariance(get, set):ColorArgb;
    public var endColor(get, set):ColorArgb;
    public var endColorVariance(get, set):ColorArgb;
    
    private static inline var EMITTER_TYPE_GRAVITY:Int = 0;
    private static inline var EMITTER_TYPE_RADIAL:Int  = 1;
    
    // emitter configuration                           // .pex element name
    private var _emitterType:Int;                      // emitterType
    private var _emitterXVariance:Float;               // sourcePositionVariance x
    private var _emitterYVariance:Float;               // sourcePositionVariance y
    private var _defaultDuration:Float;                // duration
    
    // particle configuration
    private var _lifespan:Float = 0;                   // particleLifeSpan
    private var _lifespanVariance:Float;               // particleLifeSpanVariance
    private var _startSize:Float;                      // startParticleSize
    private var _startSizeVariance:Float;              // startParticleSizeVariance
    private var _endSize:Float;                        // finishParticleSize
    private var _endSizeVariance:Float;                // finishParticleSizeVariance
    private var _emitAngle:Float;                      // angle
    private var _emitAngleVariance:Float;              // angleVariance
    private var _startRotation:Float;                  // rotationStart
    private var _startRotationVariance:Float;          // rotationStartVariance
    private var _endRotation:Float;                    // rotationEnd
    private var _endRotationVariance:Float;            // rotationEndVariance
    
    // gravity configuration
    private var _speed:Float;                          // speed
    private var _speedVariance:Float;                  // speedVariance
    private var _gravityX:Float;                       // gravity x
    private var _gravityY:Float;                       // gravity y
    private var _radialAcceleration:Float;             // radialAcceleration
    private var _radialAccelerationVariance:Float;     // radialAccelerationVariance
    private var _tangentialAcceleration:Float;         // tangentialAcceleration
    private var _tangentialAccelerationVariance:Float; // tangentialAccelerationVariance
    
    // radial configuration
    private var _maxRadius:Float;                      // maxRadius
    private var _maxRadiusVariance:Float;              // maxRadiusVariance
    private var _minRadius:Float;                      // minRadius
    private var _minRadiusVariance:Float;              // minRadiusVariance
    private var _rotatePerSecond:Float;                // rotatePerSecond
    private var _rotatePerSecondVariance:Float;        // rotatePerSecondVariance
    
    // color configuration
    private var _startColor:ColorArgb;                 // startColor
    private var _startColorVariance:ColorArgb;         // startColorVariance
    private var _endColor:ColorArgb;                   // finishColor
    private var _endColorVariance:ColorArgb;           // finishColorVariance
    
    #if commonjs
    private static function __init__ () {
        
        untyped Object.defineProperties (PDParticleSystem.prototype, {
            "defaultDuration": { get: untyped __js__ ("function () { return this.get_defaultDuration (); }"), set: untyped __js__ ("function (v) { return this.set_defaultDuration (v); }") },
            "emitterType": { get: untyped __js__ ("function () { return this.get_emitterType (); }"), set: untyped __js__ ("function (v) { return this.set_emitterType (v); }") },
            "emitterXVariance": { get: untyped __js__ ("function () { return this.get_emitterXVariance (); }"), set: untyped __js__ ("function (v) { return this.set_emitterXVariance (v); }") },
            "emitterYVariance": { get: untyped __js__ ("function () { return this.get_emitterYVariance (); }"), set: untyped __js__ ("function (v) { return this.set_emitterYVariance (v); }") },
            "lifespan": { get: untyped __js__ ("function () { return this.get_lifespan (); }"), set: untyped __js__ ("function (v) { return this.set_lifespan (v); }") },
            "lifespanVariance": { get: untyped __js__ ("function () { return this.get_lifespanVariance (); }"), set: untyped __js__ ("function (v) { return this.set_lifespanVariance (v); }") },
            "startSize": { get: untyped __js__ ("function () { return this.get_startSize (); }"), set: untyped __js__ ("function (v) { return this.set_startSize (v); }") },
            "startSizeVariance": { get: untyped __js__ ("function () { return this.get_startSizeVariance (); }"), set: untyped __js__ ("function (v) { return this.set_startSizeVariance (v); }") },
            "endSize": { get: untyped __js__ ("function () { return this.get_endSize (); }"), set: untyped __js__ ("function (v) { return this.set_endSize (v); }") },
            "endSizeVariance": { get: untyped __js__ ("function () { return this.get_endSizeVariance (); }"), set: untyped __js__ ("function (v) { return this.set_endSizeVariance (v); }") },
            "emitAngle": { get: untyped __js__ ("function () { return this.get_emitAngle (); }"), set: untyped __js__ ("function (v) { return this.set_emitAngle (v); }") },
            "emitAngleVariance": { get: untyped __js__ ("function () { return this.get_emitAngleVariance (); }"), set: untyped __js__ ("function (v) { return this.set_emitAngleVariance (v); }") },
            "startRotation": { get: untyped __js__ ("function () { return this.get_startRotation (); }"), set: untyped __js__ ("function (v) { return this.set_startRotation (v); }") },
            "startRotationVariance": { get: untyped __js__ ("function () { return this.get_startRotationVariance (); }"), set: untyped __js__ ("function (v) { return this.set_startRotationVariance (v); }") },
            "endRotation": { get: untyped __js__ ("function () { return this.get_endRotation (); }"), set: untyped __js__ ("function (v) { return this.set_endRotation (v); }") },
            "endRotationVariance": { get: untyped __js__ ("function () { return this.get_endRotationVariance (); }"), set: untyped __js__ ("function (v) { return this.set_endRotationVariance (v); }") },
            "speed": { get: untyped __js__ ("function () { return this.get_speed (); }"), set: untyped __js__ ("function (v) { return this.set_speed (v); }") },
            "speedVariance": { get: untyped __js__ ("function () { return this.get_speedVariance (); }"), set: untyped __js__ ("function (v) { return this.set_speedVariance (v); }") },
            "gravityX": { get: untyped __js__ ("function () { return this.get_gravityX (); }"), set: untyped __js__ ("function (v) { return this.set_gravityX (v); }") },
            "gravityY": { get: untyped __js__ ("function () { return this.get_gravityY (); }"), set: untyped __js__ ("function (v) { return this.set_gravityY (v); }") },
            "radialAcceleration": { get: untyped __js__ ("function () { return this.get_radialAcceleration (); }"), set: untyped __js__ ("function (v) { return this.set_radialAcceleration (v); }") },
            "radialAccelerationVariance": { get: untyped __js__ ("function () { return this.get_radialAccelerationVariance (); }"), set: untyped __js__ ("function (v) { return this.set_radialAccelerationVariance (v); }") },
            "tangentialAcceleration": { get: untyped __js__ ("function () { return this.get_tangentialAcceleration (); }"), set: untyped __js__ ("function (v) { return this.set_tangentialAcceleration (v); }") },
            "tangentialAccelerationVariance": { get: untyped __js__ ("function () { return this.get_tangentialAccelerationVariance (); }"), set: untyped __js__ ("function (v) { return this.set_tangentialAccelerationVariance (v); }") },
            "maxRadius": { get: untyped __js__ ("function () { return this.get_maxRadius (); }"), set: untyped __js__ ("function (v) { return this.set_maxRadius (v); }") },
            "maxRadiusVariance": { get: untyped __js__ ("function () { return this.get_maxRadiusVariance (); }"), set: untyped __js__ ("function (v) { return this.set_maxRadiusVariance (v); }") },
            "minRadius": { get: untyped __js__ ("function () { return this.get_minRadius (); }"), set: untyped __js__ ("function (v) { return this.set_minRadius (v); }") },
            "minRadiusVariance": { get: untyped __js__ ("function () { return this.get_minRadiusVariance (); }"), set: untyped __js__ ("function (v) { return this.set_minRadiusVariance (v); }") },
            "rotatePerSecond": { get: untyped __js__ ("function () { return this.get_rotatePerSecond (); }"), set: untyped __js__ ("function (v) { return this.set_rotatePerSecond (v); }") },
            "rotatePerSecondVariance": { get: untyped __js__ ("function () { return this.get_rotatePerSecondVariance (); }"), set: untyped __js__ ("function (v) { return this.set_rotatePerSecondVariance (v); }") },
            "startColor": { get: untyped __js__ ("function () { return this.get_startColor (); }"), set: untyped __js__ ("function (v) { return this.set_startColor (v); }") },
            "startColorVariance": { get: untyped __js__ ("function () { return this.get_startColorVariance (); }"), set: untyped __js__ ("function (v) { return this.set_startColorVariance (v); }") },
            "endColor": { get: untyped __js__ ("function () { return this.get_endColor (); }"), set: untyped __js__ ("function (v) { return this.set_endColor (v); }") },
            "endColorVariance": { get: untyped __js__ ("function () { return this.get_endColorVariance (); }"), set: untyped __js__ ("function (v) { return this.set_endColorVariance (v); }") },
        });
        
    }
    #end
    
    public function new(config:String, texture:Texture)
    {
        super(texture);
        parseConfig(config);
    }
    
    private override function createParticle():Particle
    {
        return new PDParticle();
    }
    
    private override function initParticle(aParticle:Particle):Void
    {
        var particle:PDParticle = cast aParticle;
     
        // for performance reasons, the random variances are calculated inline instead
        // of calling a function
        
        var lifespan:Float = _lifespan + _lifespanVariance * (Math.random() * 2.0 - 1.0);
        var textureWidth:Float = texture != null ? texture.width : 16;
        
        particle.currentTime = 0.0;
        particle.totalTime = lifespan > 0.0 ? lifespan : 0.0;
        
        if (lifespan <= 0.0) return;
        
        var emitterX:Float = this.emitterX;
        var emitterY:Float = this.emitterY;

        particle.x = emitterX + _emitterXVariance * (Math.random() * 2.0 - 1.0);
        particle.y = emitterY + _emitterYVariance * (Math.random() * 2.0 - 1.0);
        particle.startX = emitterX;
        particle.startY = emitterY;
        
        var angle:Float = _emitAngle + _emitAngleVariance * (Math.random() * 2.0 - 1.0);
        var speed:Float = _speed + _speedVariance * (Math.random() * 2.0 - 1.0);
        particle.velocityX = speed * Math.cos(angle);
        particle.velocityY = speed * Math.sin(angle);
        
        var startRadius:Float = _maxRadius + _maxRadiusVariance * (Math.random() * 2.0 - 1.0);
        var endRadius:Float = _minRadius + _minRadiusVariance * (Math.random() * 2.0 - 1.0);
        particle.emitRadius = startRadius;
        particle.emitRadiusDelta = (endRadius - startRadius) / lifespan;
        particle.emitRotation = _emitAngle + _emitAngleVariance * (Math.random() * 2.0 - 1.0);
        particle.emitRotationDelta = _rotatePerSecond + _rotatePerSecondVariance * (Math.random() * 2.0 - 1.0);
        particle.radialAcceleration = _radialAcceleration + _radialAccelerationVariance * (Math.random() * 2.0 - 1.0);
        particle.tangentialAcceleration = _tangentialAcceleration + _tangentialAccelerationVariance * (Math.random() * 2.0 - 1.0);
        
        var startSize:Float = _startSize + _startSizeVariance * (Math.random() * 2.0 - 1.0);
        var endSize:Float = _endSize + _endSizeVariance * (Math.random() * 2.0 - 1.0);
        if (startSize < 0.1) startSize = 0.1;
        if (endSize < 0.1)   endSize = 0.1;
        particle.scale = startSize / textureWidth;
        particle.scaleDelta = ((endSize - startSize) / lifespan) / textureWidth;
        
        // colors
        
        var startColor:ColorArgb = particle.colorArgb;
        var colorDelta:ColorArgb = particle.colorArgbDelta;
        
        startColor.red   = _startColor.red;
        startColor.green = _startColor.green;
        startColor.blue  = _startColor.blue;
        startColor.alpha = _startColor.alpha;
        
        if (_startColorVariance.red != 0)   startColor.red   += _startColorVariance.red   * (Math.random() * 2.0 - 1.0);
        if (_startColorVariance.green != 0) startColor.green += _startColorVariance.green * (Math.random() * 2.0 - 1.0);
        if (_startColorVariance.blue != 0)  startColor.blue  += _startColorVariance.blue  * (Math.random() * 2.0 - 1.0);
        if (_startColorVariance.alpha != 0) startColor.alpha += _startColorVariance.alpha * (Math.random() * 2.0 - 1.0);
        
        var endColorRed:Float   = _endColor.red;
        var endColorGreen:Float = _endColor.green;
        var endColorBlue:Float  = _endColor.blue;
        var endColorAlpha:Float = _endColor.alpha;

        if (_endColorVariance.red != 0)   endColorRed   += _endColorVariance.red   * (Math.random() * 2.0 - 1.0);
        if (_endColorVariance.green != 0) endColorGreen += _endColorVariance.green * (Math.random() * 2.0 - 1.0);
        if (_endColorVariance.blue != 0)  endColorBlue  += _endColorVariance.blue  * (Math.random() * 2.0 - 1.0);
        if (_endColorVariance.alpha != 0) endColorAlpha += _endColorVariance.alpha * (Math.random() * 2.0 - 1.0);
        
        colorDelta.red   = (endColorRed   - startColor.red)   / lifespan;
        colorDelta.green = (endColorGreen - startColor.green) / lifespan;
        colorDelta.blue  = (endColorBlue  - startColor.blue)  / lifespan;
        colorDelta.alpha = (endColorAlpha - startColor.alpha) / lifespan;
        
        // rotation
        
        var startRotation:Float = _startRotation + _startRotationVariance * (Math.random() * 2.0 - 1.0);
        var endRotation:Float   = _endRotation   + _endRotationVariance   * (Math.random() * 2.0 - 1.0);
        
        particle.rotation = startRotation;
        particle.rotationDelta = (endRotation - startRotation) / lifespan;
    }
    
    private override function advanceParticle(aParticle:Particle, passedTime:Float):Void
    {
        var particle:PDParticle = cast aParticle;
        
        var restTime:Float = particle.totalTime - particle.currentTime;
        passedTime = restTime > passedTime ? passedTime : restTime;
        particle.currentTime += passedTime;
        
        if (_emitterType == EMITTER_TYPE_RADIAL)
        {
            particle.emitRotation += particle.emitRotationDelta * passedTime;
            particle.emitRadius   += particle.emitRadiusDelta   * passedTime;
            particle.x = _emitterX - Math.cos(particle.emitRotation) * particle.emitRadius;
            particle.y = _emitterY - Math.sin(particle.emitRotation) * particle.emitRadius;
        }
        else
        {
            var distanceX:Float = particle.x - particle.startX;
            var distanceY:Float = particle.y - particle.startY;
            var distanceScalar:Float = Math.sqrt(distanceX*distanceX + distanceY*distanceY);
            if (distanceScalar < 0.01) distanceScalar = 0.01;
            
            var radialX:Float = distanceX / distanceScalar;
            var radialY:Float = distanceY / distanceScalar;
            var tangentialX:Float = radialX;
            var tangentialY:Float = radialY;
            
            radialX *= particle.radialAcceleration;
            radialY *= particle.radialAcceleration;
            
            var newY:Float = tangentialX;
            tangentialX = -tangentialY * particle.tangentialAcceleration;
            tangentialY = newY * particle.tangentialAcceleration;
            
            particle.velocityX += passedTime * (_gravityX + radialX + tangentialX);
            particle.velocityY += passedTime * (_gravityY + radialY + tangentialY);
            particle.x += particle.velocityX * passedTime;
            particle.y += particle.velocityY * passedTime;
        }
        
        particle.scale += particle.scaleDelta * passedTime;
        particle.rotation += particle.rotationDelta * passedTime;
        
        particle.colorArgb.red   += particle.colorArgbDelta.red   * passedTime;
        particle.colorArgb.green += particle.colorArgbDelta.green * passedTime;
        particle.colorArgb.blue  += particle.colorArgbDelta.blue  * passedTime;
        particle.colorArgb.alpha += particle.colorArgbDelta.alpha * passedTime;
        
        particle.color = particle.colorArgb.toRgb();
        particle.alpha = particle.colorArgb.alpha;
    }
    
    private function updateEmissionRate():Void
    {
        emissionRate = capacity / _lifespan;
    }
    
    private function parseConfig(config:String):Void
    {
        var xml = new haxe.xml.Access(Xml.parse(config).firstElement());
        var config = xml.node;
        _emitterXVariance = Std.parseFloat(config.sourcePositionVariance.att.x);
        _emitterYVariance = Std.parseFloat(config.sourcePositionVariance.att.y);
        _gravityX = Std.parseFloat(config.gravity.att.x);
        _gravityY = Std.parseFloat(config.gravity.att.y);
        _emitterType = getIntValue(config.emitterType);
        _startSize = getFloatValue(config.startParticleSize);
        _startSizeVariance = getFloatValue(config.startParticleSizeVariance);
        _endSize = getFloatValue(config.finishParticleSize);
        _emitAngle = MathUtil.deg2rad(getFloatValue(config.angle));
        _emitAngleVariance = MathUtil.deg2rad(getFloatValue(config.angleVariance));
        _startRotation = MathUtil.deg2rad(getFloatValue(config.rotationStart));
        _startRotationVariance = MathUtil.deg2rad(getFloatValue(config.rotationStartVariance));
        _endRotation = MathUtil.deg2rad(getFloatValue(config.rotationEnd));
        _endRotationVariance = MathUtil.deg2rad(getFloatValue(config.rotationEndVariance));
        _speed = getFloatValue(config.speed);
        _speedVariance = getFloatValue(config.speedVariance);
        _radialAcceleration = getFloatValue(config.radialAcceleration);
        _radialAccelerationVariance = getFloatValue(config.radialAccelVariance);
        _tangentialAcceleration = getFloatValue(config.tangentialAcceleration);
        _tangentialAccelerationVariance = getFloatValue(config.tangentialAccelVariance);
        _maxRadius = getFloatValue(config.maxRadius);
        _maxRadiusVariance = getFloatValue(config.maxRadiusVariance);
        _minRadius = getFloatValue(config.minRadius);
        _rotatePerSecond = MathUtil.deg2rad(getFloatValue(config.rotatePerSecond));
        _rotatePerSecondVariance = MathUtil.deg2rad(getFloatValue(config.rotatePerSecondVariance));
        _startColor = getColor(config.startColor);
        _startColorVariance = getColor(config.startColorVariance);
        _endColor = getColor(config.finishColor);
        _endColorVariance = getColor(config.finishColorVariance);
        _blendFactorSource = getBlendFunc(config.blendFuncSource);
        _blendFactorDestination = getBlendFunc(config.blendFuncDestination);
        defaultDuration = getFloatValue(config.duration);
        capacity = getIntValue(config.maxParticles);
        
        // compatibility with future Particle Designer versions
        // (might fix some of the uppercase/lowercase typos)
        
        if (xml.hasNode.FinishParticleSizeVariance)
            _endSizeVariance = getFloatValue(config.FinishParticleSizeVariance);
        else
            _endSizeVariance = getFloatValue(config.finishParticleSizeVariance);
        
        if (xml.hasNode.particleLifeSpan)
            _lifespan = Math.max(0.01, getFloatValue(config.particleLifeSpan));
        else
            _lifespan = Math.max(0.01, getFloatValue(config.particleLifespan));
        
        if (xml.hasNode.particleLifespanVariance)
            _lifespanVariance = getFloatValue(config.particleLifespanVariance);
        else
            _lifespanVariance = getFloatValue(config.particleLifeSpanVariance);
        
        if (xml.hasNode.minRadiusVariance)
            _minRadiusVariance = getFloatValue(config.minRadiusVariance);
        else
            _minRadiusVariance = 0.0;
        
        updateEmissionRate();
        updateBlendMode();
    }
    
    private function getIntValue(element:haxe.xml.Access):Int
    {
        return Std.parseInt(element.att.value);
    }
    
    private function getFloatValue(element:haxe.xml.Access):Float
    {
        return Std.parseFloat(element.att.value);
    }

    private function getColor(element:haxe.xml.Access):ColorArgb
    {
        var color:ColorArgb = new ColorArgb();
        color.red   = Std.parseFloat(element.att.red);
        color.green = Std.parseFloat(element.att.green);
        color.blue  = Std.parseFloat(element.att.blue);
        color.alpha = Std.parseFloat(element.att.alpha);
        return color;
    }

    private function getBlendFunc(element:haxe.xml.Access):Context3DBlendFactor
    {
        var value:Int = getIntValue(element);
        switch (value)
        {
            case 0:     return Context3DBlendFactor.ZERO;
            case 1:     return Context3DBlendFactor.ONE;
            case 0x300: return Context3DBlendFactor.SOURCE_COLOR;
            case 0x301: return Context3DBlendFactor.ONE_MINUS_SOURCE_COLOR;
            case 0x302: return Context3DBlendFactor.SOURCE_ALPHA;
            case 0x303: return Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA;
            case 0x304: return Context3DBlendFactor.DESTINATION_ALPHA;
            case 0x305: return Context3DBlendFactor.ONE_MINUS_DESTINATION_ALPHA;
            case 0x306: return Context3DBlendFactor.DESTINATION_COLOR;
            case 0x307: return Context3DBlendFactor.ONE_MINUS_DESTINATION_COLOR;
            default:    throw new ArgumentError("unsupported blending function: " + value);
        }
    }
    
    private function get_emitterType():Int { return _emitterType; }
    private function set_emitterType(value:Int):Int { return _emitterType = value; }

    private function get_emitterXVariance():Float { return _emitterXVariance; }
    private function set_emitterXVariance(value:Float):Float { return _emitterXVariance = value; }

    private function get_emitterYVariance():Float { return _emitterYVariance; }
    private function set_emitterYVariance(value:Float):Float { return _emitterYVariance = value; }

    private function get_defaultDuration():Float { return _defaultDuration; }
    private function set_defaultDuration(value:Float):Float
    {
        return _defaultDuration = value < 0 ? Max.MAX_VALUE : value;
    }

    override private function set_capacity(value:Int):Int
    {
        super.capacity = value;
        updateEmissionRate();
        return value;
    }

    private function get_lifespan():Float { return _lifespan; }
    private function set_lifespan(value:Float):Float
    { 
        _lifespan = Math.max(0.01, value);
        updateEmissionRate();
        return value;
    }

    private function get_lifespanVariance():Float { return _lifespanVariance; }
    private function set_lifespanVariance(value:Float):Float { return _lifespanVariance = value; }

    private function get_startSize():Float { return _startSize; }
    private function set_startSize(value:Float):Float { return _startSize = value; }

    private function get_startSizeVariance():Float { return _startSizeVariance; }
    private function set_startSizeVariance(value:Float):Float { return _startSizeVariance = value; }

    private function get_endSize():Float { return _endSize; }
    private function set_endSize(value:Float):Float { return _endSize = value; }

    private function get_endSizeVariance():Float { return _endSizeVariance; }
    private function set_endSizeVariance(value:Float):Float { return _endSizeVariance = value; }

    private function get_emitAngle():Float { return _emitAngle; }
    private function set_emitAngle(value:Float):Float { return _emitAngle = value; }

    private function get_emitAngleVariance():Float { return _emitAngleVariance; }
    private function set_emitAngleVariance(value:Float):Float { return _emitAngleVariance = value; }

    private function get_startRotation():Float { return _startRotation; }
    private function set_startRotation(value:Float):Float { return _startRotation = value; }

    private function get_startRotationVariance():Float { return _startRotationVariance; }
    private function set_startRotationVariance(value:Float):Float { return _startRotationVariance = value; }
    
    private function get_endRotation():Float { return _endRotation; }
    private function set_endRotation(value:Float):Float { return _endRotation = value; }
    
    private function get_endRotationVariance():Float { return _endRotationVariance; }
    private function set_endRotationVariance(value:Float):Float { return _endRotationVariance = value; }
    
    private function get_speed():Float { return _speed; }
    private function set_speed(value:Float):Float { return _speed = value; }

    private function get_speedVariance():Float { return _speedVariance; }
    private function set_speedVariance(value:Float):Float { return _speedVariance = value; }

    private function get_gravityX():Float { return _gravityX; }
    private function set_gravityX(value:Float):Float { return _gravityX = value; }

    private function get_gravityY():Float { return _gravityY; }
    private function set_gravityY(value:Float):Float { return _gravityY = value; }

    private function get_radialAcceleration():Float { return _radialAcceleration; }
    private function set_radialAcceleration(value:Float):Float { return _radialAcceleration = value; }

    private function get_radialAccelerationVariance():Float { return _radialAccelerationVariance; }
    private function set_radialAccelerationVariance(value:Float):Float { return _radialAccelerationVariance = value; }

    private function get_tangentialAcceleration():Float { return _tangentialAcceleration; }
    private function set_tangentialAcceleration(value:Float):Float { return _tangentialAcceleration = value; }

    private function get_tangentialAccelerationVariance():Float { return _tangentialAccelerationVariance; }
    private function set_tangentialAccelerationVariance(value:Float):Float { return _tangentialAccelerationVariance = value; }

    private function get_maxRadius():Float { return _maxRadius; }
    private function set_maxRadius(value:Float):Float { return _maxRadius = value; }

    private function get_maxRadiusVariance():Float { return _maxRadiusVariance; }
    private function set_maxRadiusVariance(value:Float):Float { return _maxRadiusVariance = value; }

    private function get_minRadius():Float { return _minRadius; }
    private function set_minRadius(value:Float):Float { return _minRadius = value; }

    private function get_minRadiusVariance():Float { return _minRadiusVariance; }
    private function set_minRadiusVariance(value:Float):Float { return _minRadiusVariance = value; }

    private function get_rotatePerSecond():Float { return _rotatePerSecond; }
    private function set_rotatePerSecond(value:Float):Float { return _rotatePerSecond = value; }

    private function get_rotatePerSecondVariance():Float { return _rotatePerSecondVariance; }
    private function set_rotatePerSecondVariance(value:Float):Float { return _rotatePerSecondVariance = value; }

    private function get_startColor():ColorArgb { return _startColor; }
    private function set_startColor(value:ColorArgb):ColorArgb { return _startColor = value; }

    private function get_startColorVariance():ColorArgb { return _startColorVariance; }
    private function set_startColorVariance(value:ColorArgb):ColorArgb { return _startColorVariance = value; }

    private function get_endColor():ColorArgb { return _endColor; }
    private function set_endColor(value:ColorArgb):ColorArgb { return _endColor = value; }

    private function get_endColorVariance():ColorArgb { return _endColorVariance; }
    private function set_endColorVariance(value:ColorArgb):ColorArgb { return _endColorVariance = value; }
}
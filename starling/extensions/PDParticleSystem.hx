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

import haxe.xml.Fast;

import flash.display3D.Context3DBlendFactor;
import flash.errors.ArgumentError;

import starling.textures.Texture;
import starling.utils.MathUtil;

class PDParticleSystem extends ParticleSystem
{
    public var emitterType(get, set):Int;
    public var emitterXVariance(get, set):Float;
    public var emitterYVariance(get, set):Float;
    public var maxNumParticles(get, set):Int;
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
    private var mEmitterType:Int;                      // emitterType
    private var mEmitterXVariance:Float;               // sourcePositionVariance x
    private var mEmitterYVariance:Float;               // sourcePositionVariance y
    
    // particle configuration
    private var mMaxNumParticles:Int;                  // maxParticles
    private var mLifespan:Float;                       // particleLifeSpan
    private var mLifespanVariance:Float;               // particleLifeSpanVariance
    private var mStartSize:Float;                      // startParticleSize
    private var mStartSizeVariance:Float;              // startParticleSizeVariance
    private var mEndSize:Float;                        // finishParticleSize
    private var mEndSizeVariance:Float;                // finishParticleSizeVariance
    private var mEmitAngle:Float;                      // angle
    private var mEmitAngleVariance:Float;              // angleVariance
    private var mStartRotation:Float;                  // rotationStart
    private var mStartRotationVariance:Float;          // rotationStartVariance
    private var mEndRotation:Float;                    // rotationEnd
    private var mEndRotationVariance:Float;            // rotationEndVariance
    
    // gravity configuration
    private var mSpeed:Float;                          // speed
    private var mSpeedVariance:Float;                  // speedVariance
    private var mGravityX:Float;                       // gravity x
    private var mGravityY:Float;                       // gravity y
    private var mRadialAcceleration:Float;             // radialAcceleration
    private var mRadialAccelerationVariance:Float;     // radialAccelerationVariance
    private var mTangentialAcceleration:Float;         // tangentialAcceleration
    private var mTangentialAccelerationVariance:Float; // tangentialAccelerationVariance
    
    // radial configuration
    private var mMaxRadius:Float;                      // maxRadius
    private var mMaxRadiusVariance:Float;              // maxRadiusVariance
    private var mMinRadius:Float;                      // minRadius
    private var mMinRadiusVariance:Float;              // minRadiusVariance
    private var mRotatePerSecond:Float;                // rotatePerSecond
    private var mRotatePerSecondVariance:Float;        // rotatePerSecondVariance
    
    // color configuration
    private var mStartColor:ColorArgb;                 // startColor
    private var mStartColorVariance:ColorArgb;         // startColorVariance
    private var mEndColor:ColorArgb;                   // finishColor
    private var mEndColorVariance:ColorArgb;           // finishColorVariance
    
    public function new(config:Xml, texture:Texture)
    {
        parseConfig(config);
        
        var emissionRate:Float = mMaxNumParticles / mLifespan;
        super(texture, emissionRate, mMaxNumParticles, mMaxNumParticles,
              mBlendFactorSource, mBlendFactorDestination);
    }
    
    private override function createParticle():Particle
    {
        return new PDParticle();
    }
    
    private override function initParticle(aParticle:Particle):Void
    {
        var particle:PDParticle = try cast(aParticle, PDParticle) catch(e:Dynamic) null;
     
        // for performance reasons, the random variances are calculated inline instead
        // of calling a function
        
        var lifespan:Float = mLifespan + mLifespanVariance * (Math.random() * 2.0 - 1.0);
        
        particle.currentTime = 0.0;
        particle.totalTime = lifespan > 0.0 ? lifespan : 0.0;
        
        if (lifespan <= 0.0) return;
        
        particle.x = mEmitterX + mEmitterXVariance * (Math.random() * 2.0 - 1.0);
        particle.y = mEmitterY + mEmitterYVariance * (Math.random() * 2.0 - 1.0);
        particle.startX = mEmitterX;
        particle.startY = mEmitterY;
        
        var angle:Float = mEmitAngle + mEmitAngleVariance * (Math.random() * 2.0 - 1.0);
        var speed:Float = mSpeed + mSpeedVariance * (Math.random() * 2.0 - 1.0);
        particle.velocityX = speed * Math.cos(angle);
        particle.velocityY = speed * Math.sin(angle);
        
        var startRadius:Float = mMaxRadius + mMaxRadiusVariance * (Math.random() * 2.0 - 1.0);
        var endRadius:Float = mMinRadius + mMinRadiusVariance * (Math.random() * 2.0 - 1.0);
        particle.emitRadius = startRadius;
        particle.emitRadiusDelta = (endRadius - startRadius) / lifespan;
        particle.emitRotation = mEmitAngle + mEmitAngleVariance * (Math.random() * 2.0 - 1.0);
        particle.emitRotationDelta = mRotatePerSecond + mRotatePerSecondVariance * (Math.random() * 2.0 - 1.0);
        particle.radialAcceleration = mRadialAcceleration + mRadialAccelerationVariance * (Math.random() * 2.0 - 1.0);
        particle.tangentialAcceleration = mTangentialAcceleration + mTangentialAccelerationVariance * (Math.random() * 2.0 - 1.0);
        
        var startSize:Float = mStartSize + mStartSizeVariance * (Math.random() * 2.0 - 1.0);
        var endSize:Float = mEndSize + mEndSizeVariance * (Math.random() * 2.0 - 1.0);
        if (startSize < 0.1) startSize = 0.1;
        if (endSize < 0.1)   endSize = 0.1;
        particle.scale = startSize / texture.width;
        particle.scaleDelta = ((endSize - startSize) / lifespan) / texture.width;
        
        // colors
        
        var startColor:ColorArgb = particle.colorArgb;
        var colorDelta:ColorArgb = particle.colorArgbDelta;
        
        startColor.red   = mStartColor.red;
        startColor.green = mStartColor.green;
        startColor.blue  = mStartColor.blue;
        startColor.alpha = mStartColor.alpha;
        
        if (mStartColorVariance.red != 0)   startColor.red   += mStartColorVariance.red   * (Math.random() * 2.0 - 1.0);
        if (mStartColorVariance.green != 0) startColor.green += mStartColorVariance.green * (Math.random() * 2.0 - 1.0);
        if (mStartColorVariance.blue != 0)  startColor.blue  += mStartColorVariance.blue  * (Math.random() * 2.0 - 1.0);
        if (mStartColorVariance.alpha != 0) startColor.alpha += mStartColorVariance.alpha * (Math.random() * 2.0 - 1.0);
        
        var endColorRed:Float   = mEndColor.red;
        var endColorGreen:Float = mEndColor.green;
        var endColorBlue:Float  = mEndColor.blue;
        var endColorAlpha:Float = mEndColor.alpha;

        if (mEndColorVariance.red != 0)   endColorRed   += mEndColorVariance.red   * (Math.random() * 2.0 - 1.0);
        if (mEndColorVariance.green != 0) endColorGreen += mEndColorVariance.green * (Math.random() * 2.0 - 1.0);
        if (mEndColorVariance.blue != 0)  endColorBlue  += mEndColorVariance.blue  * (Math.random() * 2.0 - 1.0);
        if (mEndColorVariance.alpha != 0) endColorAlpha += mEndColorVariance.alpha * (Math.random() * 2.0 - 1.0);
        
        colorDelta.red   = (endColorRed   - startColor.red)   / lifespan;
        colorDelta.green = (endColorGreen - startColor.green) / lifespan;
        colorDelta.blue  = (endColorBlue  - startColor.blue)  / lifespan;
        colorDelta.alpha = (endColorAlpha - startColor.alpha) / lifespan;
        
        // rotation
        
        var startRotation:Float = mStartRotation + mStartRotationVariance * (Math.random() * 2.0 - 1.0);
        var endRotation:Float   = mEndRotation   + mEndRotationVariance   * (Math.random() * 2.0 - 1.0);
        
        particle.rotation = startRotation;
        particle.rotationDelta = (endRotation - startRotation) / lifespan;
    }
    
    private override function advanceParticle(aParticle:Particle, passedTime:Float):Void
    {
        var particle:PDParticle = try cast(aParticle, PDParticle) catch(e:Dynamic) null;
        
        var restTime:Float = particle.totalTime - particle.currentTime;
        passedTime = restTime > passedTime ? passedTime : restTime;
        particle.currentTime += passedTime;
        
        if (mEmitterType == EMITTER_TYPE_RADIAL)
        {
            particle.emitRotation += particle.emitRotationDelta * passedTime;
            particle.emitRadius   += particle.emitRadiusDelta   * passedTime;
            particle.x = mEmitterX - Math.cos(particle.emitRotation) * particle.emitRadius;
            particle.y = mEmitterY - Math.sin(particle.emitRotation) * particle.emitRadius;
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
            
            particle.velocityX += passedTime * (mGravityX + radialX + tangentialX);
            particle.velocityY += passedTime * (mGravityY + radialY + tangentialY);
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
        emissionRate = mMaxNumParticles / mLifespan;
    }
    
    private function parseConfig(config:Xml):Void
    {
        var xml = new Fast(config);
        var config = xml.node;
        mEmitterXVariance = Std.parseFloat(config.sourcePositionVariance.att.x);
        mEmitterYVariance = Std.parseFloat(config.sourcePositionVariance.att.y);
        mGravityX = Std.parseFloat(config.gravity.att.x);
        mGravityY = Std.parseFloat(config.gravity.att.y);
        mEmitterType = getIntValue(config.emitterType);
        mMaxNumParticles = getIntValue(config.maxParticles);
        mLifespan = Math.max(0.01, getFloatValue(config.particleLifeSpan));
        mLifespanVariance = getFloatValue(config.particleLifespanVariance);
        mStartSize = getFloatValue(config.startParticleSize);
        mStartSizeVariance = getFloatValue(config.startParticleSizeVariance);
        mEndSize = getFloatValue(config.finishParticleSize);
        mEndSizeVariance = getFloatValue(config.FinishParticleSizeVariance);
        mEmitAngle = MathUtil.deg2rad(getFloatValue(config.angle));
        mEmitAngleVariance = MathUtil.deg2rad(getFloatValue(config.angleVariance));
        mStartRotation = MathUtil.deg2rad(getFloatValue(config.rotationStart));
        mStartRotationVariance = MathUtil.deg2rad(getFloatValue(config.rotationStartVariance));
        mEndRotation = MathUtil.deg2rad(getFloatValue(config.rotationEnd));
        mEndRotationVariance = MathUtil.deg2rad(getFloatValue(config.rotationEndVariance));
        mSpeed = getFloatValue(config.speed);
        mSpeedVariance = getFloatValue(config.speedVariance);
        mRadialAcceleration = getFloatValue(config.radialAcceleration);
        mRadialAccelerationVariance = getFloatValue(config.radialAccelVariance);
        mTangentialAcceleration = getFloatValue(config.tangentialAcceleration);
        mTangentialAccelerationVariance = getFloatValue(config.tangentialAccelVariance);
        mMaxRadius = getFloatValue(config.maxRadius);
        mMaxRadiusVariance = getFloatValue(config.maxRadiusVariance);
        mMinRadius = getFloatValue(config.minRadius);
        mMinRadiusVariance = getFloatValue(config.minRadiusVariance);
        mRotatePerSecond = MathUtil.deg2rad(getFloatValue(config.rotatePerSecond));
        mRotatePerSecondVariance = MathUtil.deg2rad(getFloatValue(config.rotatePerSecondVariance));
        mStartColor = getColor(config.startColor);
        mStartColorVariance = getColor(config.startColorVariance);
        mEndColor = getColor(config.finishColor);
        mEndColorVariance = getColor(config.finishColorVariance);
        mBlendFactorSource = getBlendFunc(config.blendFuncSource);
        mBlendFactorDestination = getBlendFunc(config.blendFuncDestination);
        
        // compatibility with future Particle Designer versions
        // (might fix some of the uppercase/lowercase typos)
        
        if (Math.isNaN(mEndSizeVariance))
            mEndSizeVariance = getFloatValue(config.finishParticleSizeVariance);
        if (Math.isNaN(mLifespan))
            mLifespan = Math.max(0.01, getFloatValue(config.particleLifespan));
        if (Math.isNaN(mLifespanVariance))
            mLifespanVariance = getFloatValue(config.particleLifeSpanVariance);
        if (Math.isNaN(mMinRadiusVariance))
            mMinRadiusVariance = 0.0;
    }
    
    private function getIntValue(element:Fast):Int
    {
        return Std.parseInt(element.att.value);
    }
    
    private function getFloatValue(element:Fast):Float
    {
        return Std.parseFloat(element.att.value);
    }

    private function getColor(element:Fast):ColorArgb
    {
        var color:ColorArgb = new ColorArgb();
        color.red   = Std.parseFloat(element.att.red);
        color.green = Std.parseFloat(element.att.green);
        color.blue  = Std.parseFloat(element.att.blue);
        color.alpha = Std.parseFloat(element.att.alpha);
        return color;
    }

    private function getBlendFunc(element:Fast):String
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
    
    private function get_emitterType():Int { return mEmitterType; }
    private function set_emitterType(value:Int):Int { return mEmitterType = value; }

    private function get_emitterXVariance():Float { return mEmitterXVariance; }
    private function set_emitterXVariance(value:Float):Float { return mEmitterXVariance = value; }

    private function get_emitterYVariance():Float { return mEmitterYVariance; }
    private function set_emitterYVariance(value:Float):Float { return mEmitterYVariance = value; }

    private function get_maxNumParticles():Int { return mMaxNumParticles; }
    private function set_maxNumParticles(value:Int):Int
    { 
        maxCapacity = value;
        mMaxNumParticles = maxCapacity; 
        updateEmissionRate(); 
        return value;
    }

    private function get_lifespan():Float { return mLifespan; }
    private function set_lifespan(value:Float):Float
    { 
        mLifespan = Math.max(0.01, value);
        updateEmissionRate();
        return value;
    }

    private function get_lifespanVariance():Float { return mLifespanVariance; }
    private function set_lifespanVariance(value:Float):Float { return mLifespanVariance = value; }

    private function get_startSize():Float { return mStartSize; }
    private function set_startSize(value:Float):Float { return mStartSize = value; }

    private function get_startSizeVariance():Float { return mStartSizeVariance; }
    private function set_startSizeVariance(value:Float):Float { return mStartSizeVariance = value; }

    private function get_endSize():Float { return mEndSize; }
    private function set_endSize(value:Float):Float { return mEndSize = value; }

    private function get_endSizeVariance():Float { return mEndSizeVariance; }
    private function set_endSizeVariance(value:Float):Float { return mEndSizeVariance = value; }

    private function get_emitAngle():Float { return mEmitAngle; }
    private function set_emitAngle(value:Float):Float { return mEmitAngle = value; }

    private function get_emitAngleVariance():Float { return mEmitAngleVariance; }
    private function set_emitAngleVariance(value:Float):Float { return mEmitAngleVariance = value; }

    private function get_startRotation():Float { return mStartRotation; }
    private function set_startRotation(value:Float):Float { return mStartRotation = value; }

    private function get_startRotationVariance():Float { return mStartRotationVariance; }
    private function set_startRotationVariance(value:Float):Float { return mStartRotationVariance = value; }
    
    private function get_endRotation():Float { return mEndRotation; }
    private function set_endRotation(value:Float):Float { return mEndRotation = value; }
    
    private function get_endRotationVariance():Float { return mEndRotationVariance; }
    private function set_endRotationVariance(value:Float):Float { return mEndRotationVariance = value; }
    
    private function get_speed():Float { return mSpeed; }
    private function set_speed(value:Float):Float { return mSpeed = value; }

    private function get_speedVariance():Float { return mSpeedVariance; }
    private function set_speedVariance(value:Float):Float { return mSpeedVariance = value; }

    private function get_gravityX():Float { return mGravityX; }
    private function set_gravityX(value:Float):Float { return mGravityX = value; }

    private function get_gravityY():Float { return mGravityY; }
    private function set_gravityY(value:Float):Float { return mGravityY = value; }

    private function get_radialAcceleration():Float { return mRadialAcceleration; }
    private function set_radialAcceleration(value:Float):Float { return mRadialAcceleration = value; }

    private function get_radialAccelerationVariance():Float { return mRadialAccelerationVariance; }
    private function set_radialAccelerationVariance(value:Float):Float { return mRadialAccelerationVariance = value; }

    private function get_tangentialAcceleration():Float { return mTangentialAcceleration; }
    private function set_tangentialAcceleration(value:Float):Float { return mTangentialAcceleration = value; }

    private function get_tangentialAccelerationVariance():Float { return mTangentialAccelerationVariance; }
    private function set_tangentialAccelerationVariance(value:Float):Float { return mTangentialAccelerationVariance = value; }

    private function get_maxRadius():Float { return mMaxRadius; }
    private function set_maxRadius(value:Float):Float { return mMaxRadius = value; }

    private function get_maxRadiusVariance():Float { return mMaxRadiusVariance; }
    private function set_maxRadiusVariance(value:Float):Float { return mMaxRadiusVariance = value; }

    private function get_minRadius():Float { return mMinRadius; }
    private function set_minRadius(value:Float):Float { return mMinRadius = value; }

    private function get_minRadiusVariance():Float { return mMinRadiusVariance; }
    private function set_minRadiusVariance(value:Float):Float { return mMinRadiusVariance = value; }

    private function get_rotatePerSecond():Float { return mRotatePerSecond; }
    private function set_rotatePerSecond(value:Float):Float { return mRotatePerSecond = value; }

    private function get_rotatePerSecondVariance():Float { return mRotatePerSecondVariance; }
    private function set_rotatePerSecondVariance(value:Float):Float { return mRotatePerSecondVariance = value; }

    private function get_startColor():ColorArgb { return mStartColor; }
    private function set_startColor(value:ColorArgb):ColorArgb { return mStartColor = value; }

    private function get_startColorVariance():ColorArgb { return mStartColorVariance; }
    private function set_startColorVariance(value:ColorArgb):ColorArgb { return mStartColorVariance = value; }

    private function get_endColor():ColorArgb { return mEndColor; }
    private function set_endColor(value:ColorArgb):ColorArgb { return mEndColor = value; }

    private function get_endColorVariance():ColorArgb { return mEndColorVariance; }
    private function set_endColorVariance(value:ColorArgb):ColorArgb { return mEndColorVariance = value; }
}
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

class PDParticle extends Particle
{
    public var colorArgb:ColorArgb;
    public var colorArgbDelta:ColorArgb;
    public var startX:Float;
    public var startY:Float;
    public var velocityX:Float;
    public var velocityY:Float;
    public var radialAcceleration:Float;
    public var tangentialAcceleration:Float;
    public var emitRadius:Float;
    public var emitRadiusDelta:Float;
    public var emitRotation:Float;
    public var emitRotationDelta:Float;
    public var rotationDelta:Float;
    public var scaleDelta:Float;
    
    public function new()
    {
        super();
        colorArgb = new ColorArgb();
        colorArgbDelta = new ColorArgb();
    }
}
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

class Particle
{
    public var x:Float;
    public var y:Float;
    public var scale:Float;
    public var rotation:Float;
    public var color:Int;
    public var alpha:Float;
    public var currentTime:Float;
    public var totalTime:Float;
    
    public function new()
    {
        x = y = rotation = currentTime = 0.0;
        totalTime = alpha = scale = 1.0;
        color = 0xffffff;
    }
}
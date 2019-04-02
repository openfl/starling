package starling.events;

import openfl.Vector;

/** Stores the information about raw touches in a pool of object instances.
 *
 *  <p>This class is purely for internal use of the TouchProcessor.</p>
 */
class TouchData
{
    /** The identifier of a touch. '0' for mouse events, an increasing number for touches. */
    public var id(default, null):Int;
    
    /** The current phase the touch is in. @see TouchPhase */
    public var phase(default, null):String;
    
    /** The x-position of the touch in stage coordinates. */
    public var globalX(default, null):Float;
    
    /** The y-position of the touch in stage coordinates. */
    public var globalY(default, null):Float;
    
    /** A value between 0.0 and 1.0 indicating force of the contact with the device.
     *  If the device does not support detecting the pressure, the value is 1.0. */
    public var pressure(default, null):Float;
    
    /** Width of the contact area.
     *  If the device does not support detecting the pressure, the value is 1.0. */
    public var width(default, null):Float;
    
    /** Height of the contact area.
     *  If the device does not support detecting the pressure, the value is 1.0. */
    public var height(default, null):Float;

    private static var sPool:Vector<TouchData> = new Vector<TouchData>();

    private function new() {}

    private function setTo(touchID:Int, phase:String, globalX:Float, globalY:Float,
                            pressure:Float=1.0, width:Float=1.0, height:Float=1.0):Void
    {
        this.id = touchID; this.phase = phase; this.globalX = globalX; this.globalY = globalY;
        this.pressure = pressure; this.width = width; this.height = height;
    }

    /** Creates a new TouchData instance with the given properties or returns one from
        *  the object pool. */
    public static function fromPool(touchID:Int, phase:String, globalX:Float, globalY:Float,
                                    pressure:Float=1.0, width:Float=1.0, height:Float=1.0):TouchData
    {
        var touchData:TouchData = sPool.length > 0 ? sPool.pop() : new TouchData();
        touchData.setTo(touchID, phase, globalX, globalY, pressure, width, height);
        return touchData;
    }

    /** Moves an instance back into the pool. */
    public static function toPool(rawTouch:TouchData):Void
    {
        sPool[sPool.length] = rawTouch;
    }
}
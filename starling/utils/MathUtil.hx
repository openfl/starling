package starling.utils;

class MathUtil
{

	/** Returns the smallest value in an array. */
	public static function min(values:Array<Float>):Float
	{
		if (values.length == 0)
			return 0.0;
		var min:Float = values[0];
		for (i in 1 ... values.length)
			if (values[i] < min)
				min = values[i];
		return min;
	}

	/** Converts an angle from degrees into radians. */
	public static function deg2rad(deg:Float):Float
	{
		return deg / 180.0 * Math.PI;   
	}
}
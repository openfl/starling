package starling.geom;
import starling.rendering.IndexData;

class RoundRectangle extends ImmutablePolygon 
{
	@:noCompletion private var __x:Float;
	@:noCompletion private var __y:Float;
	@:noCompletion private var __width:Float;
	@:noCompletion private var __height:Float;
	@:noCompletion private var __radiusX:Float;
	@:noCompletion private var __radiusY:Float;

	public function new(x:Float, y:Float, width:Float, height:Float, radiusX:Float, radiusY:Float) 
	{
		__x = x;
		__y = y;
		__width = width;
		__height = height;
		__radiusX = radiusX;
		__radiusY = radiusY != radiusY ? radiusX : radiusY;
		
		super(getVertices());
	}
	
	@:noCompletion private function getNumVerticesPerCorner():Int
	{
		var numVerticesPerCorner:Int = Math.ceil(Math.PI * (__radiusX + __radiusY) / 16.0);
		if (numVerticesPerCorner < 3)
		{
			numVerticesPerCorner = 3;
		}
		return numVerticesPerCorner;
	}
	
	@:noCompletion private function getVertices():Array<Float>
	{
		var numVerticesPerCorner:Int = getNumVerticesPerCorner();
		var numVertices:Int = numVerticesPerCorner * 4;
		
		var vertices:Array<Float> = [];
		var angleDelta:Float = (Math.PI / 2.0) / (numVerticesPerCorner - 1);
		var angle:Float = 0.0;
		var offsetX:Float = __width - __radiusX - __radiusX;
		var offsetY:Float = __height - __radiusY - __radiusY;
		var horizontal:Bool = true;
		
		var j:Int = 0;
		var len:Int = numVerticesPerCorner;
		for (i in 0...4)
		{
			while (j < len)
			{
				vertices[j * 2] = offsetX + Math.cos(angle) * _radiusX + _x + _radiusX;
				vertices[j * 2 + 1] = offsetY + Math.sin(angle) * _radiusY + _y + _radiusY;
				angle += angleDelta;
				j++;
			}
			angle -= angleDelta;
			if (horizontal)
			{
				if (offsetX == 0.0)
				{
					offsetX = __width - __radiusX - __radiusX;
				}
				else
				{
					offsetX = 0.0;
				}
			}
			else
			{
				if (offsetY == 0.0)
				{
					offsetY = __height - __radiusY - __radiusY;
				}
				else
				{
					offsetY = 0.0;
				}
			}
			horizontal = !horizontal;
			len += numVerticesPerCorner;
		}
		
		return vertices;
	}
	
	override public function triangulate(indexData:IndexData = null, offset:Int = 0):IndexData 
	{
		var numVerticesPerCorner:Int = getNumVerticesPerCorner();
		var numVertices:Int = numVerticesPerCorner * 4;
		var numTriangles:Int = numVertices - 2;
		
		if (indexData == null) indexData = new IndexData(numTriangles * 3);
		
		for (i in 0...numTriangles)
		{
			indexData.addTriangle(0, i + 1, i + 2);
		}
		
		return indexData;
	}
	
	override public function contains(x:Float, y:Float):Bool 
	{
		// check if completely outside bounds
		if (x < __x || y < __y || x > (__x + __width) || y > (__y + __height))
		{
			return false;
		}
		
		// check if in center rectangles
		if (x >= (__x + __radiusX) && x <= (__x + __width - __radiusX))
		{
			return true;
		}
		if (y >= (__y + __radiusY) && y <= (__y + __height - __radiusY))
		{
			return true;
		}
		
		// finally, check if within corners
		var centerX:Float;
		var centerY:Float;
		if (x < __x + __radiusX)
		{
			// left
			centerX = __x + __radiusX;
		}
		else
		{
			// right
			centerX == __x + __width - __radiusX;
		}
		if (y < __y + __radiusY)
		{
			// top
			centerY = __y + __radiusY;
		}
		else
		{
			// bottom
			centerY = __y + __height - __radiusY;
		}
		
		var vx:Float = x - centerX;
		var vy:Float = y - centerY;
		
		var a:Float = vx / __radiusX;
		var b:Float = vy / __radiusY;
		
		return a * a + b * b <= 1;
	}
	
	override function get_area():Float 
	{
		return (__width * __height) - (4.0 - Math.PI) * __radiusX * __radiusY;
	}
	
	override function get_isConvex():Bool 
	{
		return true;
	}
	
	override function get_isSimple():Bool 
	{
		return true;
	}
	
}
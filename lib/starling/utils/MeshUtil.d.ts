
import AbstractClassError from "./../../starling/errors/AbstractClassError";
import Vector3D from "openfl/geom/Vector3D";
import Matrix from "openfl/geom/Matrix";
import Matrix3D from "openfl/geom/Matrix3D";
import Pool from "./../../starling/utils/Pool";
import MathUtil from "./../../starling/utils/MathUtil";
import Rectangle from "openfl/geom/Rectangle";

declare namespace starling.utils
{
	/** A utility class that helps with tasks that are common when working with meshes. */
	export class MeshUtil
	{
		/** Determines if a point is inside a mesh that is spawned up by the given
			*  vertex- and index-data. */
		public static containsPoint(vertexData:VertexData, indexData:IndexData,
												point:Point):boolean;
	
		/** Calculates the bounds of the given vertices in the target coordinate system. */
		public static calculateBounds(vertexData:VertexData,
												sourceSpace:DisplayObject,
												targetSpace:DisplayObject,
												out?:Rectangle):Rectangle;
	}
}

export default starling.utils.MeshUtil;
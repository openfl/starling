import Error from "openfl/errors/Error";

declare namespace starling.errors
{
	/** A MissingContextError is thrown when a Context3D object is required but not (yet) 
	 *  available. */
	export class MissingContextError extends Error
	{
		/** Creates a new MissingContextError object. */
		public constructor(message?:string, id?:number);
	}
}

export default starling.errors.MissingContextError;
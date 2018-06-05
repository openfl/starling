import Error from "openfl/errors/Error";

declare namespace starling.errors
{
	/** An AbstractClassError is thrown when you attempt to create an instance of an abstract 
	 *  class. */
	export class AbstractClassError extends Error
	{
		/** Creates a new AbstractClassError object. */
		public constructor(message?:string, id?:number);
	}
}

export default starling.errors.AbstractClassError;
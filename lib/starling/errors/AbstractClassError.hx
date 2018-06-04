// =================================================================================================
//
//	Starling Framework
//	Copyright Gamua GmbH. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

package starling.errors;

import openfl.errors.Error;

/** An AbstractClassError is thrown when you attempt to create an instance of an abstract 
 *  class. */

@:jsRequire("starling/errors/AbstractClassError", "default")

extern class AbstractClassError extends Error
{
    /** Creates a new AbstractClassError object. */
    public function new(message:String="Cannot instantiate abstract class", id:Int=0);
}
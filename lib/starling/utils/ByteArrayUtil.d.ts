// =================================================================================================
//
//	Starling Framework
//	Copyright Gamua GmbH. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

declare namespace starling.utils
{
    export class ByteArrayUtil
    {
        /** @protected */
        // public constructor() { throw new AbstractClassError(); }
    
        /** Figures out if a byte array starts with the UTF bytes of a certain string. If the
         *  array starts with a 'BOM', it is ignored; so are leading zeros and whitespace. */
        public static startsWithString(bytes:ByteArray, string:string):boolean;
    
        /** Compares the range of bytes within two byte arrays. */
        public static compareByteArrays(a:ByteArray, indexA:number,
                                                 b:ByteArray, indexB:number,
                                                 numBytes?:number):boolean;
    }
}

export default starling.utils.ByteArrayUtil;
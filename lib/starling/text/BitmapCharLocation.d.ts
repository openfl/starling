// =================================================================================================
//
//	Starling Framework
//	Copyright Gamua GmbH. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

import Vector from "openfl/Vector";
import BitmapChar from "./BitmapChar";

declare namespace starling.text
{
    /** A helper class referencing a BitmapChar and properties about its location and size.
     *
     *  <p>This class is used and returned by <code>BitmapFont.arrangeChars()</code>.
     *  It's typically only needed for advanced changes to Starling's default text composition
     *  mechanisms.</p>
     *
     *  <p>This class supports object pooling. All instances returned by the methods
     *  <code>instanceFromPool</code> and <code>vectorFromPool</code> are returned to the
     *  respective pool when calling <code>rechargePool</code>.</p>
     */
    export class BitmapCharLocation
    {
        /** The actual bitmap char to be drawn. */
        public char:BitmapChar;
        
        /** The scale with which the char must be placed. */
        public scale:number;
        
        /** The x-coordinate of the char's location. */
        public x:number;
        
        /** The y-coordinate of the char's location. */
        public y:number;
        
        /** The index of this char in the processed String. */
        public index:number;

        /** Create a new instance that references the given char. */
        public constructor(char:BitmapChar);

        // pooling

        /** Returns a "BitmapCharLocation" instance from the pool, initialized with the given char.
         *  All instances will be returned to the pool when calling <code>rechargePool</code>. */
        public static instanceFromPool(char:BitmapChar):BitmapCharLocation;

        /** Returns an empty Vector for "BitmapCharLocation" instances from the pool.
         *  All vectors will be returned to the pool when calling <code>rechargePool</code>. */
        public static vectorFromPool():Vector<BitmapCharLocation>;

        /** Puts all objects that were previously returned by either of the "...fromPool" methods
         *  back into the pool. */
        public static rechargePool():void;
    }
}

export default starling.text.BitmapCharLocation;
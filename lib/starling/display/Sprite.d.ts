import DisplayObjectContainer from "./../../starling/display/DisplayObjectContainer";

declare namespace starling.display
{
    /** A Sprite is the most lightweight, non-abstract container class.
     *  Use it as a simple means of grouping objects together in one coordinate system.
     *
     *  @see DisplayObject
     *  @see DisplayObjectContainer
     */
    export class Sprite extends DisplayObjectContainer
    {
        /** Creates an empty sprite. */
        public constructor();
    }
}

export default starling.display.Sprite;
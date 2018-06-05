import Event from "./../../starling/events/Event";

declare namespace starling.events
{
    /** An EnterFrameEvent is triggered once per frame and is dispatched to all objects in the
     *  display tree.
     *
     *  It contains information about the time that has passed since the last frame. That way, you 
     *  can easily make animations that are independent of the frame rate, taking the passed time
     *  into account.
     */
    export class EnterFrameEvent extends Event
    {
        /** Event type for a display object that is entering a new frame. */
        public static ENTER_FRAME:string;
        
        /** Creates an enter frame event with the passed time. */
        public constructor(type:string, passedTime:number, bubbles?:boolean);
        
        /** The time that has passed since the last frame (in seconds). */
        public readonly passedTime:number;
        protected get_passedTime():number;
    }
}

export default starling.events.EnterFrameEvent;
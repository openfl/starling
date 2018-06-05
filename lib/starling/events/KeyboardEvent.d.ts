import Event from "./../../starling/events/Event";

declare namespace starling.events
{
    /** A KeyboardEvent is dispatched in response to user input through a keyboard.
     * 
     *  <p>This is Starling's version of the Flash KeyboardEvent class. It contains the same 
     *  properties as the Flash equivalent.</p> 
     * 
     *  <p>To be notified of keyboard events, add an event listener to any display object that
     *  is part of your display tree. Starling has no concept of a "Focus" like native Flash.</p>
     *  
     *  @see starling.display.Stage
     */
    export class KeyboardEvent extends Event
    {
        /** Event type for a key that was released. */
        public static KEY_UP:string;
        
        /** Event type for a key that was pressed. */
        public static KEY_DOWN:string;
        
        /** Creates a new KeyboardEvent. */
        public constructor(type:string, charCode?:number, keyCode?:number, 
                            keyLocation?:number, ctrlKey?:boolean, 
                            altKey?:boolean, shiftKey?:boolean);
        
        // prevent default
        
        /** Cancels the keyboard event's default behavior. This will be forwarded to the native
         * flash KeyboardEvent. */
        public preventDefault():void;
        
        /** Checks whether the preventDefault() method has been called on the event. */
        public isDefaultPrevented():boolean;
        
        // properties
        
        /** Contains the character code of the key. */
        public readonly charCode:number;
        protected get_charCode():number;
        
        /** The key code of the key. */
        public readonly keyCode:number;
        protected get_keyCode():number;
        
        /** Indicates the location of the key on the keyboard. This is useful for differentiating 
         * keys that appear more than once on a keyboard. @see Keylocation */ 
        public readonly keyLocation:number;
        protected get_keyLocation():number;
        
        /** Indicates whether the Alt key is active on Windows or Linux; 
         * indicates whether the Option key is active on Mac OS. */
        public readonly altKey:boolean;
        protected get_altKey():boolean;
        
        /** Indicates whether the Ctrl key is active on Windows or Linux; 
         * indicates whether either the Ctrl or the Command key is active on Mac OS. */
        public readonly ctrlKey:boolean;
        protected get_ctrlKey():boolean;
        
        /** Indicates whether the Shift key modifier is active (true) or inactive (false). */
        public readonly shiftKey:boolean;
        protected get_shiftKey():boolean;
    }
}

export default starling.events.KeyboardEvent;
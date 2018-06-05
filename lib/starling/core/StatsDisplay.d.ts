// =================================================================================================
//
//	Starling Framework
//	Copyright Gamua GmbH. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

import Sprite from "./../display/Sprite";

declare namespace starling.core
{
	/** A small, lightweight box that displays the current framerate, memory consumption and
	 *  the number of draw calls per frame. The display is updated automatically once per frame. */
	export class StatsDisplay extends Sprite
	{
		/** Creates a new Statistics Box. */
		public constructor();
		
		/** Updates the displayed values. */
		public update():void;

		/** Call this once in every frame that can skip rendering because nothing changed. */
		public markFrameAsSkipped():void;
		
		/** The number of Stage3D draw calls per second. */
		public drawCount:number;
		protected get_drawCount():number;
		protected set_drawCount(value:number):number;
		
		/** The current frames per second (updated twice per second). */
		public fps:number;
		protected get_fps():number;
		protected set_fps(value:number):number;
		
		/** The currently required system memory in MB. */
		public memory:number;
		protected get_memory():number;
		protected set_memory(value:number):number;
		
		/** The currently used graphics memory in MB. */
		public gpuMemory:number;
		protected get_gpuMemory():number;
		protected set_gpuMemory(value:number):number;
	}
}

export default starling.core.StatsDisplay;
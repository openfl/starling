package;


import openfl.display.Sprite;
import starling.core.Starling;


class Startup extends Sprite {
	
	
	private var starling:Starling;
	
	
	public function new () {
		
		super ();
		
		starling = new Starling (Game, stage);
		starling.start ();
		
	}
	
	
}
import openfl.display.Sprite;
import openfl.display.Stage;
import starling.core.Starling;


class App extends Sprite {
	
	
	private var starling:Starling;
	
	
	public function new () {
		
		super ();
		
		starling = new Starling (Game, stage);
		starling.start ();
		
	}
	
	
	static function main () {
		
		var stage = new Stage (550, 400, 0xFFFFFF, App);
		js.Browser.document.body.appendChild (stage.element);
		
	}
	
	
}


class Game extends starling.display.Sprite {
	
	
	public function new () {
		
		super ();
		
		
		
	}
	
	
}
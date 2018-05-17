package {
	
	
	import openfl.display.Stage;
	
	
	public class Main {
		
		
		public function Main () {
			
			var stage:Stage = new Stage (320, 480, 0xFFFFFF, Demo);
			var content:HTMLDivElement = document.getElementById ("openfl-content") as HTMLDivElement;
			content.appendChild (stage.element);
			
		}
		
		
	}
	
	
}
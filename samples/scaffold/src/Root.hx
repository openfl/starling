package;

import starling.display.Image;
import starling.display.Sprite;
import starling.events.Event;
import starling.utils.AssetManager;

/** The Root class is the topmost display object in your game. It loads all the assets
 *  and displays a progress bar while this is happening. Later, it is responsible for
 *  switching between game and menu. For this, it listens to "START_GAME" and "GAME_OVER"
 *  events fired by the Menu and Game classes. Keep this class rather lightweight: it 
 *  controls the high level behaviour of your game. */
class Root extends Sprite
{
    public static var assets(get, never):AssetManager;

    private static var sAssets:AssetManager;
    
    private var mActiveScene:Sprite;
    
    public function new()
    {
        super();

        addEventListener(Menu.START_GAME, onStartGame);
        addEventListener(Game.GAME_OVER,  onGameOver);
        
        // not more to do here -- Startup will call "start" immediately.
    }
    
    public function start(assets:AssetManager):Void
    {
        // the asset manager is saved as a static variable; this allows us to easily access
        // all the assets from everywhere by simply calling "Root.assets"

        sAssets = assets;
        addChild(new Image(assets.getTexture("background")));
        showScene(Menu);
    }
    
    private function onGameOver(event:Event, score:Int):Void
    {
        trace("Game Over! Score: " + score);
        showScene(Menu);
    }
    
    private function onStartGame(event:Event, gameMode:String):Void
    {
        trace("Game starts! Mode: " + gameMode);
        showScene(Game);
    }
    
    private function showScene(screen:Class<Dynamic>):Void
    {
        if (mActiveScene != null) mActiveScene.removeFromParent(true);
        mActiveScene = Type.createInstance (screen, []);
        addChild(mActiveScene);
    }
    
    private static function get_assets():AssetManager { return sAssets; }
}
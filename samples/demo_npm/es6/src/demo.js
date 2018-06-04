import Bitmap from "openfl/display/Bitmap";
import BitmapData from "openfl/display/BitmapData";
import Sprite from "openfl/display/Sprite";
import OpenFLStage from "openfl/display/Stage";
import Context3DRenderMode from "openfl/display3D/Context3DRenderMode";
import Error from "openfl/errors/Error";
import OpenFLEvent from "openfl/events/Event";
import Rectangle from "openfl/geom/Rectangle";
import Capabilities from "openfl/system/Capabilities";
import System from "openfl/system/System";
import StageScaleMode from "openfl/display/StageScaleMode";
import AssetLibrary from "openfl/utils/AssetLibrary";
import AssetManifest from "openfl/utils/AssetManifest";
import Assets from "openfl/utils/Assets";
import ByteArray from "openfl/utils/ByteArray";
import Vector from "openfl/Vector";

import Starling from "starling/core/Starling";
import Stage from "starling/display/Stage";
import Event from "starling/events/Event";
import BitmapFont from "starling/text/BitmapFont";
import TextField from "starling/text/TextField";
import Texture from "starling/textures/Texture";
import TextureAtlas from "starling/textures/TextureAtlas";
import AssetManager from "starling/utils/AssetManager";
import Max from "starling/utils/Max";
import RectangleUtil from "starling/utils/RectangleUtil";
import StringUtil from "starling/utils/StringUtil";

import ProgressBar from "./utils/progressBar";
import Constants from "./constants";
import Game from "./game";

class Demo extends Sprite
{
    constructor()
    {
        super();
        if (this.stage != null) this.start();
        else this.addEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);
    }

    onAddedToStage = (event) =>
    {
        this.removeEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);
        
        this.stage.scaleMode = StageScaleMode.NO_SCALE;
        
        this.start();
    }

    start()
    {
        // We develop the game in a *fixed* coordinate system of 320x480. The game might
        // then run on a device with a different resolution; for that case, we zoom the
        // viewPort to the optimal size for any display and load the optimal textures.

        Starling.multitouchEnabled = true; // for Multitouch Scene

        this._starling = new Starling(Game, this.stage, null, null, Context3DRenderMode.AUTO, "auto");
        this._starling.stage.stageWidth = Constants.GameWidth;
        this._starling.stage.stageHeight = Constants.GameHeight;
        this._starling.enableErrorChecking = Capabilities.isDebugger;
        this._starling.skipUnchangedFrames = true;
        this._starling.supportBrowserZoom = true;
        this._starling.supportHighResolutions = true;
        this._starling.simulateMultitouch = true;
        this._starling.addEventListener(Event.ROOT_CREATED, () =>
        {
            this.loadAssets(this.startGame);
        });
        
        this.stage.addEventListener(Event.RESIZE, this.onResize, false, Max.INT_MAX_VALUE, true);

        this._starling.start();
        this.initElements();
    }

    loadAssets(onComplete)
    {
        var assets = new AssetManager();

        assets.verbose = Capabilities.isDebugger;

        var manifest = new AssetManifest ();
        manifest.addBitmapData ("assets/textures/1x/atlas.png");
        manifest.addText ("assets/textures/1x/atlas.xml");
        manifest.addBitmapData ("assets/fonts/1x/desyrel.png");
        manifest.addText ("assets/fonts/1x/desyrel.fnt");
        manifest.addBitmapData ("assets/textures/1x/background.jpg");
        manifest.addSound ([ "assets/audio/wing_flap.ogg", "assets/audio/wing_flap.mp3" ]);
        manifest.addBytes ("assets/textures/1x/compressed_texture.atf");
        manifest.addFont ("DejaVu Sans");
        manifest.addFont ("Ubuntu");
        
        AssetLibrary.loadFromManifest (manifest).onComplete (function (library) {
            
            Assets.registerLibrary ("default", library);
            
            var atlasTexture = Texture.fromBitmapData(Assets.getBitmapData("assets/textures/1x/atlas.png"), false);
            var atlasXml = Assets.getText("assets/textures/1x/atlas.xml");
            var desyrelTexture = Texture.fromBitmapData(Assets.getBitmapData("assets/fonts/1x/desyrel.png"), false);
            var desyrelXml = Assets.getText("assets/fonts/1x/desyrel.fnt");
            var bitmapFont = new BitmapFont(desyrelTexture, desyrelXml);
            TextField.registerCompositor(bitmapFont, bitmapFont.name);
            assets.addTexture("atlas", atlasTexture);
            assets.addTextureAtlas("atlas", new TextureAtlas(atlasTexture, atlasXml));
            assets.addTexture("background", Texture.fromBitmapData(Assets.getBitmapData("assets/textures/1x/background.jpg"), false));
            assets.addSound("wing_flap", Assets.getSound("assets/audio/wing_flap.ogg"));
            var compressedTexture = Assets.getBytes("assets/textures/1x/compressed_texture.atf");
            assets.addByteArray("compressed_texture", compressedTexture);
            
            onComplete(assets);
            
        }).onProgress ((bytesLoaded, bytesTotal) => {
            
            if (this._progressBar != null && bytesTotal > 0) {
                
                this._progressBar.ratio = (bytesLoaded / bytesTotal);
                
            }
            
        }).onError ((e) => {
            
            console.error (e);
            
        });
    }

    startGame = (assets) =>
    {
        var game = this._starling.root;
        game.start(assets);
        setTimeout(this.removeElements, 150); // delay to make 100% sure there's no flickering.
    }

    initElements()
    {
        // Add background image.
        BitmapData.loadFromFile("assets/textures/1x/background.jpg").onComplete((bitmapData) => {
            this._background = new Bitmap(bitmapData);
            this._background.smoothing = true;
            this.addChild(this._background);

            // While the assets are loaded, we will display a progress bar.

            this._progressBar = new ProgressBar(175, 20);
            this._progressBar.x = (this._background.width - this._progressBar.width) / 2;
            this._progressBar.y =  this._background.height * 0.7;
            this.addChild(this._progressBar);
        });
    }

    removeElements = () =>
    {
        if (this._background != null)
        {
            this.removeChild(this._background);
            this._background = null;
        }

        if (this._progressBar != null)
        {
            this.removeChild(this._progressBar);
            this._progressBar = null;
        }
    }
    
    onResize = (e) =>
    {
        var viewPort = RectangleUtil.fit(new Rectangle(0, 0, Constants.GameWidth, Constants.GameHeight), new Rectangle(0, 0, this.stage.stageWidth, this.stage.stageHeight));
        try
        {
            this._starling.viewPort = viewPort;
        }
        catch(error) {}
    }
}

var stage = new OpenFLStage (320, 480, 0xFFFFFF, Demo);
var content = document.getElementById ("openfl-content");
content.appendChild (stage.element);
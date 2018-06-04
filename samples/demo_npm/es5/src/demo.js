var Bitmap = require ("openfl/display/Bitmap").default;
var BitmapData = require ("openfl/display/BitmapData").default;
var Sprite = require ("openfl/display/Sprite").default;
var OpenFLStage = require ("openfl/display/Stage").default;
var Context3DRenderMode = require ("openfl/display3D/Context3DRenderMode").default;
var Error = require ("openfl/errors/Error").default;
var OpenFLEvent = require ("openfl/events/Event").default;
var Rectangle = require ("openfl/geom/Rectangle").default;
var Capabilities = require ("openfl/system/Capabilities").default;
var System = require ("openfl/system/System").default;
var StageScaleMode = require ("openfl/display/StageScaleMode").default;
var AssetLibrary = require ("openfl/utils/AssetLibrary").default;
var AssetManifest = require ("openfl/utils/AssetManifest").default;
var Assets = require ("openfl/utils/Assets").default;
var ByteArray = require ("openfl/utils/ByteArray").default;
var Vector = require ("openfl/Vector").default;

var Starling = require ("starling/core/Starling").default;
var Stage = require ("starling/display/Stage").default;
var Event = require ("starling/events/Event").default;
var BitmapFont = require ("starling/text/BitmapFont").default;
var TextField = require ("starling/text/TextField").default;
var Texture = require ("starling/textures/Texture").default;
var TextureAtlas = require ("starling/textures/TextureAtlas").default;
var AssetManager = require ("starling/utils/AssetManager").default;
var Max = require ("starling/utils/Max").default;
var RectangleUtil = require ("starling/utils/RectangleUtil").default;
var StringUtil = require ("starling/utils/StringUtil").default;

var ProgressBar = require ("./utils/progressBar").default;
var Constants = require ("./constants").default;
var Game = require ("./game").default;

var Demo = function()
{
    Sprite.call(this);
    
    this.onAddedToStage = this.onAddedToStage.bind(this);
    this.startGame = this.startGame.bind(this);
    this.removeElements = this.removeElements.bind(this);
    this.onResize = this.onResize.bind(this);
    
    if (this.stage != null) this.start();
    else this.addEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);
}

Demo.prototype = Object.create(Sprite.prototype);
Demo.prototype.constructor = Demo;

Demo.prototype.onAddedToStage = function (event)
{
    this.removeEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);
    
    this.stage.scaleMode = StageScaleMode.NO_SCALE;
    
    this.start();
}

Demo.prototype.start = function()
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
    this._starling.addEventListener(Event.ROOT_CREATED, function ()
    {
        this.loadAssets(this.startGame);
    }.bind (this));
    
    this.stage.addEventListener(Event.RESIZE, this.onResize, false, Max.INT_MAX_VALUE, true);

    this._starling.start();
    this.initElements();
}

Demo.prototype.loadAssets = function(onComplete)
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
        
    }).onProgress (function (bytesLoaded, bytesTotal) {
        
        if (this._progressBar != null && bytesTotal > 0) {
            
            this._progressBar.ratio = (bytesLoaded / bytesTotal);
            
        }
        
    }.bind (this)).onError (function(e) {
        
        console.error (e);
        
    });
}

Demo.prototype.startGame = function(assets)
{
    var game = this._starling.root;
    game.start(assets);
    setTimeout(this.removeElements, 150); // delay to make 100% sure there's no flickering.
}

Demo.prototype.initElements = function()
{
    // Add background image.
    BitmapData.loadFromFile("assets/textures/1x/background.jpg").onComplete(function(bitmapData) {
        this._background = new Bitmap(bitmapData);
        this._background.smoothing = true;
        this.addChild(this._background);

        // While the assets are loaded, we will display a progress bar.

        this._progressBar = new ProgressBar(175, 20);
        this._progressBar.x = (this._background.width - this._progressBar.width) / 2;
        this._progressBar.y =  this._background.height * 0.7;
        this.addChild(this._progressBar);
    }.bind (this));
}

Demo.prototype.removeElements = function()
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

Demo.prototype.onResize = function (e)
{
    var viewPort = RectangleUtil.fit(new Rectangle(0, 0, Constants.GameWidth, Constants.GameHeight), new Rectangle(0, 0, this.stage.stageWidth, this.stage.stageHeight));
    try
    {
        this._starling.viewPort = viewPort;
    }
    catch(error) {}
}

var stage = new OpenFLStage (320, 480, 0xFFFFFF, Demo);
var content = document.getElementById ("openfl-content");
content.appendChild (stage.element);
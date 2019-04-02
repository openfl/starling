module.exports = {
	
	animation: require("./animation"),
	
	BezierEasing: require("./animation/BezierEasing").default,
	DelayedCall: require("./animation/DelayedCall").default,
	IAnimatable: require("./animation/IAnimatable").default,
	Juggler: require("./animation/Juggler").default,
	Transitions: require("./animation/Transitions").default,
	Tween: require("./animation/Tween").default,
	
	
	// TODO: Including here creates circular references
	
	// assets: require("./assets"),
	
	// AssetFactory: require("./assets/AssetFactory").default,
	// AssetFactoryHelper: require("./assets/AssetFactoryHelper").default,
	// AssetManager: require("./assets/AssetManager").default,
	// AssetReference: require("./assets/AssetReference").default,
	// AssetType: require("./assets/AssetType").default,
	// AtfTextureFactory: require("./assets/AtfTextureFactory").default,
	// BitmapTextureFactory: require("./assets/BitmapTextureFactory").default,
	// ByteArrayFactory: require("./assets/ByteArrayFactory").default,
	// DataLoader: require("./assets/DataLoader").default,
	// JsonFactory: require("./assets/JsonFactory").default,
	// SoundFactory: require("./assets/SoundFactory").default,
	// XmlFactory: require("./assets/XmlFactory").default,
	
	
	core: require("./core"),
	
	Starling: require("./core/Starling").default,
	StatsDisplay: require("./core/StatsDisplay").default,
	
	
	display: require("./display"),
	
	BlendMode: require("./display/BlendMode").default,
	Button: require("./display/Button").default,
	ButtonState: require("./display/ButtonState").default,
	Canvas: require("./display/Canvas").default,
	DisplayObject: require("./display/DisplayObject").default,
	DisplayObjectContainer: require("./display/DisplayObjectContainer").default,
	Image: require("./display/Image").default,
	Mesh: require("./display/Mesh").default,
	MeshBatch: require("./display/MeshBatch").default,
	MovieClip: require("./display/MovieClip").default,
	Quad: require("./display/Quad").default,
	Sprite: require("./display/Sprite").default,
	Sprite3D: require("./display/Sprite3D").default,
	Stage: require("./display/Stage").default,
	
	
	errors: require("./errors"),
	
	AbstractClassError: require("./errors/AbstractClassError").default,
	AbstractMethodError: require("./errors/AbstractMethodError").default,
	MissingContextError: require("./errors/MissingContextError").default,
	NotSupportedError: require("./errors/NotSupportedError").default,
	
	
	events: require("./events"),
	
	EnterFrameEvent: require("./events/EnterFrameEvent").default,
	Event: require("./events/Event").default,
	EventDispatcher: require("./events/EventDispatcher").default,
	KeyboardEvent: require("./events/KeyboardEvent").default,
	ResizeEvent: require("./events/ResizeEvent").default,
	Touch: require("./events/Touch").default,
	TouchData: require("./events/TouchData").default,
	TouchEvent: require("./events/TouchEvent").default,
	TouchMarker: require("./events/TouchMarker").default,
	TouchPhase: require("./events/TouchPhase").default,
	TouchProcessor: require("./events/TouchProcessor").default,
	
	
	extensions: require("./extensions"),
	
	ColorArgb: require("./extensions/ColorArgb").default,
	Particle: require("./extensions/Particle").default,
	ParticleSystem: require("./extensions/ParticleSystem").default,
	PDParticle: require("./extensions/PDParticle").default,
	PDParticleSystem: require("./extensions/PDParticleSystem").default,
	
	
	filters: require("./filters"),
	
	BlurFilter: require("./filters/BlurFilter").default,
	ColorMatrixFilter: require("./filters/ColorMatrixFilter").default,
	CompositeFilter: require("./filters/CompositeFilter").default,
	DisplacementMapFilter: require("./filters/DisplacementMapFilter").default,
	DropShadowFilter: require("./filters/DropShadowFilter").default,
	FilterChain: require("./filters/FilterChain").default,
	FilterHelper: require("./filters/FilterHelper").default,
	FragmentFilter: require("./filters/FragmentFilter").default,
	GlowFilter: require("./filters/GlowFilter").default,
	IFilterHelper: require("./filters/IFilterHelper").default,
	
	
	geom: require("./geom"),
	
	Polygon: require("./geom/Polygon").default,
	
	
	rendering: require("./rendering"),
	
	BatchProcessor: require("./rendering/BatchProcessor").default,
	BatchToken: require("./rendering/BatchToken").default,
	Effect: require("./rendering/Effect").default,
	FilterEffect: require("./rendering/FilterEffect").default,
	MeshEffect: require("./rendering/MeshEffect").default,
	Painter: require("./rendering/Painter").default,
	Program: require("./rendering/Program").default,
	RenderState: require("./rendering/RenderState").default,
	VertexData: require("./rendering/VertexData").default,
	VertexDataAttribute: require("./rendering/VertexDataAttribute").default,
	VertexDataFormat: require("./rendering/VertexDataFormat").default,
	
	
	styles: require("./styles"),
	
	DistanceFieldStyle: require("./styles/DistanceFieldStyle").default,
	MeshStyle: require("./styles/MeshStyle").default,
	
	
	text: require("./text"),
	
	BitmapChar: require("./text/BitmapChar").default,
	BitmapCharLocation: require("./text/BitmapCharLocation").default,
	BitmapFont: require("./text/BitmapFont").default,
	BitmapFontType: require("./text/BitmapFontType").default,
	ITextCompositor: require("./text/ITextCompositor").default,
	TextField: require("./text/TextField").default,
	TextFieldAutoSize: require("./text/TextFieldAutoSize").default,
	TextFormat: require("./text/TextFormat").default,
	TextOptions: require("./text/TextOptions").default,
	TrueTypeCompositor: require("./text/TrueTypeCompositor").default,
	
	
	textures: require("./textures"),
	
	AtfData: require("./textures/AtfData").default,
	ConcreteTexture: require("./textures/ConcreteTexture").default,
	RenderTexture: require("./textures/RenderTexture").default,
	SubTexture: require("./textures/SubTexture").default,
	Texture: require("./textures/Texture").default,
	TextureAtlas: require("./textures/TextureAtlas").default,
	TextureOptions: require("./textures/TextureOptions").default,
	TextureSmoothing: require("./textures/TextureSmoothing").default,
	
	
	utils: require("./utils"),
	
	Align: require("./utils/Align").default,
	AssetManager: require("./utils/AssetManager").default,
	Color: require("./utils/Color").default,
	Execute: require("./utils/Execute").default,
	MathUtil: require("./utils/MathUtil").default,
	MatrixUtil: require("./utils/MatrixUtil").default,
	Max: require("./utils/Max").default,
	MeshSubset: require("./utils/MeshSubset").default,
	MeshUtil: require("./utils/MeshUtil").default,
	Padding: require("./utils/Padding").default,
	Pool: require("./utils/Pool").default,
	RectangleUtil: require("./utils/RectangleUtil").default,
	ScaleMode: require("./utils/ScaleMode").default,
	StringUtil: require("./utils/StringUtil").default,
	SystemUtil: require("./utils/SystemUtil").default,
}
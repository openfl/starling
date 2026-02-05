Starling Changelog
==================

2.8.0 (??/??/2026)
------------------

- added `MultiTextureStyle` for batching multiple textures in a single draw call (thanks to johnridges and Fancy2209!)
- added vector drawing APIs to `Canvas`, including `drawGraphicsData`, curves, and path support (thanks to Fancy2209!)
- added Earcut-based triangulation for `Polygon`, including offset support (thanks to Fancy2209!)
- added `Starling.defaultTextureSmoothing` to configure default texture smoothing globally (thanks to Adolio!)
- added new tween hooks: `onRepeatStart`, `onRepeatFinish`, and `repeatReverseDelay` (thanks to Mintonist!)
- added `Event.RENDER_COMPLETE` and adjusted `Event.RENDER` dispatch timing (thanks to Adolio!)
- added `Event.REMOVED_FROM_JUGGLER` and `Juggler.isEmpty`; pooled tweens are released when purging (thanks to Adolio!)
- added support for root JSON arrays in `JsonFactory` (thanks to Adolio!)
- added detection of extension and MIME type for embedded assets in `AssetManager` (thanks to Adolio!)
- added `Polygon` factory method that accepts vectors
- added `Canvas.drawRoundRectangle()` method (thanks to Josh!)
- optimized mipmap generation for `ConcretePotTexture` and fixed mip sizes (thanks to zach-xhx!)
- optimized mask handling: faster reuse of identical masks, plus fixes for hit-test and `maskInverted` redraw issues (thanks to MatseFR!)
- optimized `removeChild` performance (thanks to HaimZik!)
- fixed some state exceptions in `Canvas` (thanks to Josh!)
- fixed bounds computation for `DisplayObjectContainer` with zero-size children (thanks to Adolio!)
- fixed rare `RangeError` in `BatchProcessor`
- fixed `currentTime` in `MovieClip` after reversing frames
- fixed `BitmapFont` glyphs exceeding the top of `TextField` when the line height is larger
- fixed `BlendMode.isRegistered` error when called early (thanks to MatseFR!)
- fixed `numConnections` setter in `AssetManager` and certificate error handling in `DataLoader`
- restored queuing `File` objects with `AssetManager`

2.7.1 (03/28/2025)
------------------

- Added support for HashLink
- Added missing `StringUtil.parseBoolean()`
- Added updated externs to npm package for TypeScript and Royale
- Fixed null exception in `DelayedCall` when arguments are omitted
- Fixed uncaught exceptions when the thrown object doesn't extend `openfl.errors.Error`
- Fixed null exceptions in `BitmapFont` when parsing XML data
- Fixed null exception in `Polygon` when no vertices were passed to constructor
- Fixed `FilterChain` constructor arguments that should default to `null`
- Fixed handling of `null` in `VertexDataFormat.fromString()`
- Fixed null exception in `VertexData` where tinted value should default to `false`
- Fixed null exception in `DisplayObject` where is3D value should default to `false`
- Fixed deprecation warnings for `@:final`
- Fixed usage of `__js__` that should have been `js.Syntax.code` on newer Haxe versions
- Fixed handling of `NaN` values in `Tween`
- Fixed formatting of AssetManager logging
- Fixed mismatched overrides of `addEventListener()` and `removeEventListener()` in `MeshStyle`
- Fixed missing demo project templates that were accidentally removed from Haxelib bundle
- Updated `private` fields to add `@:noCompletion`, similar to OpenFL

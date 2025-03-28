Starling Changelog
==================

2.7.1 (03/28/2026)
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

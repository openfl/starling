[![Simplified BSD License](https://img.shields.io/badge/license-BSD-blue.svg?style=flat)](LICENSE.md) [![NPM Version](https://img.shields.io/npm/v/starling-framework.svg?style=flat)](http://npmjs.com/package/starling-framework) [![Haxelib Version](https://img.shields.io/github/tag/openfl/starling.svg?style=flat&label=haxelib)](http://lib.haxe.org/p/starling) [![Build Status](https://img.shields.io/github/actions/workflow/status/openfl/starling/main.yml?branch=master)](https://github.com/openfl/starling/actions)

Starling Framework
==================

The Cross Platform Game Engine
------------------------------

The Starling Framework allows you to create hardware accelerated apps in Haxe, TypeScript, JavaScript, or ActionScript 3. The main target is the creation of 2D games, but Starling may be used for any graphical application. Thanks to OpenFL, Starling-based applications can be deployed to mobile devices (iOS, Android), the desktop (Windows, macOS, Linux), and to web browsers via either JavaScript or WebAssembly.

While Starling mimics the classic display tree architecture of OpenFL, it provides much better performance than the OpenFL version: all objects are rendered directly by the GPU (using the Stage3D API) with improved batching and support for things like texture atlases. When paired with OpenFL, Starling provides an alternative GPU renderer with helpful features. The complete architecture was designed for working well with the GPU; common game development tasks are built right into its core. Starling hides Stage3D internals from developers who don't need low-level access, but makes it easy to access them for those who need full performance and flexibility.

Starling aims to be as lightweight and easy to use as possible. As an open-source project, much care was taken to make the source code easy to read, understand and extend. With under 15k lines of code, experienced developers can easily grasp it in its entirety, or modify it to their needs.

Getting Started (Haxelib)
-------------------------

First, [install the Haxe toolkit](https://haxe.org/download).

Then, you can easily install Starling by running the following command in a terminal or command prompt:

```sh
haxelib install starling
```

To include Starling in an OpenFL project, add this line to your [_project.xml_](https://lime.openfl.org/docs/project-files/xml-format/) file:

```xml
<haxelib name="starling" />
```

You can also create a new empty project by running the following command:

```sh
openfl create starling:project StarlingProject
```

You can also try the Starling demo project:

```sh
openfl create starling:demo
cd demo
openfl test html5
```

Getting Started (NPM)
---------------------

To use Starling with TypeScript, JavaScript, or AS3 with Apache Royale, you can install the Yeoman generator to create an empty project:

```bash
npm install -g yo starling-framework-generator
mkdir StarlingProject
cd StarlingProject
yo starling-framework
```

You can also try the Starling demo:

```bash
git clone https://github.com/openfl/starling
cd starling/samples/demo_npm/typescript
npm install
npm start -s
```

There are AS3, ES5, ES6, Haxe and TypeScript versions of the demo available.

Note about high-dpi support
---------------------------

Starling supports high-dpi devices such as 4K monitors. To enable high-dpi, add this line to your project file:

```xml
<window allow-high-dpi="true"/>
```

You also need to set a flag in your code to tell Starling to support high resolutions:

```haxe
starling.supportHighResolutions = true;
```

Quick Links (Haxe)
------------------

* [Instruction Manual](https://books.openfl.org/starling-manual/)
* [Starling Support Forum](https://forum.starling-framework.org/t/starling-haxe)
* [OpenFL Support Forum](http://community.openfl.org)

Quick Links (AS3)
-----------------

* [Official Homepage](http://www.starling-framework.org)
* [API Reference](http://doc.starling-framework.org)
* [Support Forum](https://forum.starling-framework.org/)
* [Starling Wiki](http://wiki.starling-framework.org)
  * [Showcase](http://wiki.starling-framework.org/games/start)
  * [Extensions](http://wiki.starling-framework.org/extensions/start)

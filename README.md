[![Simplified BSD License](https://img.shields.io/badge/license-BSD-blue.svg?style=flat)](LICENSE.md) [![Haxelib Version](https://img.shields.io/github/tag/openfl/starling.svg?style=flat&label=haxelib)](http://lib.haxe.org/p/starling) [![Build Status](https://img.shields.io/travis/openfl/starling.svg?style=flat)](https://travis-ci.org/openfl/starling)

Starling
========

Starling is the "Cross-Platform Game Engine", a popular Stage3D framework.


Installation
------------

You can easily install Starling using haxelib:

    haxelib install starling

To add it to an OpenFL project, add this to your project file:

```xml
<haxelib name="starling" />
```

Sample Projects
---------------

To list samples included with Starling, run:

    openfl create starling

To create a copy of one of the samples, and run it, you can do something like:

    openfl create starling:demo
    cd demo
    openfl test html5

There is also a command to create a new empty project:

    openfl create starling:project MyNewProject
    

Other Samples
-------------

- [StarlingDemoHaxe](https://github.com/zacdevon/StarlingDemoHaxe) - A simple demo mobile app built with FlashDevelop, Adobe AIR and Haxe/OpenFL/Starling


Development Builds
------------------

Clone the Starling repository:

    git clone https://github.com/openfl/starling


Tell haxelib where your development copy of Starling is installed:

    haxelib dev starling starling


To return to release builds:

    haxelib dev starling


starling
========

An unofficial port of Starling framework. Currently based on Starling v2.0.1.

[HTML5 version of the demo](http://vroad.github.io/starling-samples)

Install
-------
   haxelib git starling https://github.com/openfl/starling

Dependencies:

    haxelib git openfl https://github.com/openfl/openfl
    haxelib git lime https://github.com/openfl/lime

To use original version of away3d and openfl again, type these commands.

    haxelib dev openfl
    haxelib dev lime

Current Limitations
-------------------

starling-openfl limitations:

* Does not work with openfl-legacy compile option.
* Only works on html5, cpp, unofficial Node.js target, and unofficial C# target.
  * I only tested with Windows and Android devices.
* DisplacementMapFilter don't work correctly. The filter just moves a object a little bit.
  * Noises that are used in DisplacementMapFilter example cannot be generated on OpenFL for now.
* Mini-Bitmap Font is not supported on html5.

OpenFL Limitations(As of 3.6.1):

* You need to set vertices and shader variables after setting a shader program.

Haxe Limitations(As of 3.2.1):

* Rendering lots of objects is slow on flash target. (Probably because ByteArray operations are not optimized by Haxe Compiler)

starling-openfl [![Join the chat at https://gitter.im/vroad/starling-openfl](https://badges.gitter.im/vroad/starling-openfl.svg)](https://gitter.im/vroad/starling-openfl?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)
===============

An unofficial port of Starling framework. Currently based on Starling v2.0.1.

[HTML5 version of the demo](http://vroad.github.io/starling-samples)

Install
-------
   haxelib git starling https://github.com/vroad/starling-openfl

Dependencies:

    haxelib git openfl https://github.com/vroad/openfl
    haxelib git lime https://github.com/vroad/lime

To use original version of away3d and openfl again, type these commands(If you are using openfl 3.6.1 and lime 2.9.1).

    haxelib set openfl 3.6.1
    haxelib set lime 2.9.1

Current Limitations
-------------------

starling-openfl limitations:

* Does not work with openfl-legacy compile option.
* Only works on html5, cpp, and unofficial Node.js target.
  * Except for html5, only windows platform is tested. 
* DisplacementMapFilter don't work correctly. The filter just moves a object a little bit.
  * Noises that are used in DisplacementMapFilter example cannot be generated on OpenFL for now.
* Mini-Bitmap Font is not supported on html5.

OpenFL Limitations(As of 3.6.1):

* You need to set vertices and shader variables after setting a shader program.

Haxe Limitations(As of 3.2.1):

* Rendering lots of objects is slow on flash target. (Probably because ByteArray operations are not optimized by Haxe Compiler)

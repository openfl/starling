starling-openfl
===============

[![Join the chat at https://gitter.im/vroad/starling-openfl](https://badges.gitter.im/vroad/starling-openfl.svg)](https://gitter.im/vroad/starling-openfl?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)
An unofficial port of Starling framework. Currently based on Starling 1.7.

[HTML5 version of the demo](http://vroad.github.io/starling-samples)

[io.js version of the demo for Windows x86](https://www.dropbox.com/s/2rt488tjxqzdqvi/Starling_demo_iojs_20150215.zip?dl=0)

Install
-------
   haxelib git starling https://github.com/vroad/starling-openfl

Dependencies:

    haxelib git openfl https://github.com/vroad/openfl
    haxelib git lime https://github.com/vroad/lime

To use original version of away3d and openfl again, type these commands(If you are using openfl 2.2.4 and lime 2.0.6).

    haxelib set openfl 2.2.4
    haxelib set lime 2.0.6

Current Limitations
-------------------

starling-openfl limitations:

* Does not work with openfl-legacy compile option.
* Only works on html5, cpp, and unofficial Node.js target.
  * Except for html5, only windows platform is tested. 
* DisplacementMapFilter don't work correctly. The filter just moves a object a little bit.
  * Noises that are used in DisplacementMapFilter example cannot be generated on OpenFL for now.
* Mini-Bitmap Font is not supported.

OpenFL Limitations(As of 2.2.4):

* You need to set vertices and shader variables after setting a shader program.
* Filtering, Texture repeat, Mipmapping flags specified in AGAL shader is not used. You need to set these flags manually with Context3D.setSamplerState.

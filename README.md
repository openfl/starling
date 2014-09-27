starling-openfl
===============
An unofficial port of Starling framework.

Install
-------
   haxelib install git https://github.com/vroad/starling-openfl

Dependencies:

    haxelib git away3d https://github.com/vroad/away3d-core-openfl
    haxelib git openfl https://github.com/vroad/openfl

To use original version of away3d and openfl, type these commands(If you are using openfl 2.0.1 and away3d 1.0.1-alpha).
    haxelib set openfl 2.0.1
    haxelib set away3d 1.0.1-alpha

Current Limitations
-------------------
* Only works on html5 and cpp.
* BlurFilter and DisplacementMapFilter don't work correctly.
* You need to set vertices and shader variables after setting a shader program.

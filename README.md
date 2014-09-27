starling-openfl
===============
An unofficial port of Starling framework.

[HTML5 version of the demo](http://vroad.github.io/starling-samples)

Install
-------
   haxelib install git https://github.com/vroad/starling-openfl

Dependencies:

    haxelib git away3d https://github.com/vroad/away3d-core-openfl
    haxelib git openfl https://github.com/vroad/openfl

To use original version of away3d and openfl again, type these commands(If you are using openfl 2.0.1 and away3d 1.0.1-alpha).

    haxelib set openfl 2.0.1
    haxelib set away3d 1.0.1-alpha

Current Limitations
-------------------
* Only works on html5 and cpp.
* DisplacementMapFilter don't work correctly. The filter moves a object a little bit.
  * Noises that are used in DisplacementMapFilter example cannot be generated on html5, because html5 target doesn't support them.
* You need to set vertices and shader variables after setting a shader program.

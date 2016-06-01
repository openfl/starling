package starling.rendering._internal;

#if flash
typedef Shader = flash.utils.ByteArray;
#else
typedef Shader = openfl.gl.GLShader;
#end